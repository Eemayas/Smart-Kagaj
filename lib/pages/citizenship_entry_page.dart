// ignore_for_file: prefer_const_constructors, must_be_immutable, avoid_print, use_build_context_synchronously
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import '../commonWidgets/animated_button.dart';
import '../commonWidgets/custom_snackbar.dart';
import '../commonWidgets/date_Input_field.dart';
import '../commonWidgets/input_filed.dart';
import '../commonWidgets/onboarding_background.dart';
import '../commonWidgets/smooth_navigation.dart';
import '../commonWidgets/uploadImageToFirebase.dart';
import '../constant/colors.dart';
import '../constant/fonts.dart';
import '../database/firebase.dart';
import 'setup_MPIN_pages.dart';

class CitizenshipEntryPage extends StatefulWidget {
  const CitizenshipEntryPage({super.key});
  static String id = "CitizenshipEntryPage";
  @override
  State<CitizenshipEntryPage> createState() => _CitizenshipEntryPageState();
}

class _CitizenshipEntryPageState extends State<CitizenshipEntryPage> {
  final citizenshipNumberController = TextEditingController();
  final dateController = TextEditingController();

  User user = FirebaseAuth.instance.currentUser!;
  late RiveAnimationController _btnAnimationController;
  String? imageUrl;
  File? _selectedImage;
  File? image;
  Uint8List? _image;
  Future<void> _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        _selectedImage = imageTemp;
      });
      if (_selectedImage != null) {
        Uint8List imageBytes = await _selectedImage!.readAsBytes();
        _image = imageBytes;
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void updateImageUrl(String url) {
    setState(() {
      imageUrl = url;
    });
  }

  @override
  void dispose() {
    _btnAnimationController.dispose();
    citizenshipNumberController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> _uploadImageThenDataUpload() async {
    EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      String userId = user.uid;
      String? imageUrl =
          await uploadImageToFirebase(_image!, userId, "Citizenship");
      print(imageUrl);
      if (imageUrl != null) {
        FirebaseDB.citizenshipImageURL = imageUrl;
        FirebaseDB.citizenshipNumber = citizenshipNumberController.text;
        FirebaseDB.citizenshipIssuedDate = dateController.text;
        FirebaseDB.printall();
        if (await FirebaseDB.uploadPersonalDetail(
            context: context, userUid: user.uid)) {
          Navigator.of(context).push(SmoothSlidePageRoute(page: SetupMPIN()));
        }
      } else {
        print("Error: Image URL is null");
        customSnackbar(context: context, text: "Error: Image URL is null");
      }
    } catch (e) {
      print("ERROR UPLOADING PROFILE IMAGE : $e");
      customSnackbar(
          context: context, text: "ERROR UPLOADING PROFILE IMAGE : $e");
    }
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    citizenshipNumberController.addListener(() => setState(() {}));
    // dateController.addListener(() => setState(() {}));
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {FocusScope.of(context).requestFocus(FocusNode())},
        child: OnbodingScreenBackground(
          inputWidgets: SingleChildScrollView(
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: _pickImage,
                              child: _selectedImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          16), // Adjust the corner radius as needed
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        decoration: buildGradientBorder(),
                                        child: Image.file(
                                          _selectedImage!,
                                          fit: BoxFit.cover,
                                          // width: double.infinity, // Match image width
                                          // height: double.infinity, // Match image height
                                        ),
                                      ),
                                    )
                                  // Image.file(
                                  //     _selectedImage!,
                                  //     // height: 200,
                                  //   )
                                  : SizedBox(
                                      height: 200,
                                      child: Lottie.asset(
                                          "assets/Lottie/CitizenshipAnimation.json")),
                            ),
                            ElevatedButton(
                              onPressed: _pickImage,
                              child: Text(
                                'Select Document',
                                style: kwhiteTextStyle,
                              ),
                            ),
                          ],
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        InputField(
                            isrequired: true,
                            hintText: "",
                            controllerss: citizenshipNumberController,
                            keyboardType: TextInputType.text,
                            labelText: "Citizenship Number",
                            textCapitalization: TextCapitalization.words,
                            prefixIcon: Icons.person_2),
                        SizedBox(
                          height: 20,
                        ),
                        DateInputField(
                          dateinput: DateTime.now(),
                          controllerss: dateController,
                          keyboardType: TextInputType.datetime,
                          labelText: "Issued Date",
                          prefixIcon: Icons.date_range_outlined,
                          hintText: "YYYY-MM-DD",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RiveAnimatedBtn(
                          label: "Proceed",
                          iconData: Icon(
                            Icons.login_sharp,
                            color: Colors.black,
                          ),
                          onTap: () {
                            Future.delayed(const Duration(milliseconds: 800),
                                () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (citizenshipNumberController.text.isEmpty) {
                                customSnackbar(
                                  context: context,
                                  text: 'Plese Enter your Citizenship Number',
                                );
                              } else if (dateController.text.isEmpty) {
                                customSnackbar(
                                  context: context,
                                  text: 'Plese Enter your Issued Date',
                                );
                              } else if (_selectedImage == null) {
                                customSnackbar(
                                    context: context,
                                    text:
                                        'No Citizenship image is Selected. Please select');
                              } else {
                                _uploadImageThenDataUpload();
                              }
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )),
          ),
        ));
  }
}
