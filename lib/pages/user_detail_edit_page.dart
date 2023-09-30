// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import 'package:smart_kagaj/commonWidgets/animated_button.dart';

import '../commonWidgets/custom_snackbar.dart';
import '../commonWidgets/date_Input_field.dart';
import '../commonWidgets/input_filed.dart';
import '../commonWidgets/onboarding_background.dart';
import '../commonWidgets/uploadImageToFirebase.dart';
import '../constant/fonts.dart';
import '../database/firebase.dart';

class UserDetailEditPage extends StatefulWidget {
  const UserDetailEditPage({super.key});
  static String id = "user_detail_";

  @override
  State<UserDetailEditPage> createState() => _UserDetailEntryPageState();
}

class _UserDetailEntryPageState extends State<UserDetailEditPage> {
  final userNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final dateController = TextEditingController();
  User user = FirebaseAuth.instance.currentUser!;

  File? _selectedImage;
  Uint8List? _image;
  String? imageUrl = "";
  Future<void> _addUserData() async {
    FirebaseDB.userName = userNameController.text;
    FirebaseDB.phoneNumber = phoneNumberController.text;
    FirebaseDB.dateOfBirth = dateController.text;
    FirebaseDB.printall();
    Navigator.of(context).pop("Changed");
  }

  Future<void> _uploadImageThenDataUpload() async {
    EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    print("imageUrl3\n+$imageUrl");
    try {
      print("imageUrl4\n+$imageUrl");
      String userId = user.uid;
      if (imageUrl == "") {
        print("try3");
        imageUrl = await uploadImageToFirebase(_image!, userId, "ProfileImage");
      }
      print(imageUrl);
      if (imageUrl != null) {
        FirebaseDB.userName = userNameController.text;
        FirebaseDB.phoneNumber = phoneNumberController.text;
        FirebaseDB.dateOfBirth = dateController.text;
        FirebaseDB.profileImageURL = imageUrl;
        FirebaseDB.printall();
        if (await FirebaseDB.uploadPersonalDetail(
            context: context, userUid: user.uid)) {
          Navigator.pop(context);
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

  // Future<void> _uploadImageThenDataUpload() async {
  //   EasyLoading.show(
  //     status: 'Processing...',
  //     maskType: EasyLoadingMaskType.black,
  //   );
  //   try {
  //     String userId = user.uid;
  //     if (imageUrl == "") {
  //       imageUrl = await uploadImageToFirebase(_image!, userId, "ProfileImage");
  //       print(imageUrl);
  //       if (imageUrl != null) {
  //         FirebaseDB.userName = userNameController.text;
  //         FirebaseDB.phoneNumber = phoneNumberController.text;
  //         FirebaseDB.dateOfBirth = dateController.text;
  //         FirebaseDB.profileImageURL = imageUrl;
  //         FirebaseDB.printall();
  //         Navigator.of(context).pop("Changed");
  //       } else {
  //         print("Error: Image URL is null");
  //         customSnackbar(context: context, text: "Error: Image URL is null");
  //       }
  //     } else {
  //       FirebaseDB.userName = userNameController.text;
  //       FirebaseDB.phoneNumber = phoneNumberController.text;
  //       FirebaseDB.dateOfBirth = dateController.text;
  //       FirebaseDB.profileImageURL = imageUrl;
  //       FirebaseDB.printall();
  //       Navigator.of(context).pop("Changed");
  //     }
  //   } catch (e) {
  //     print("ERROR UPLOADING PROFILE IMAGE : $e");
  //     customSnackbar(
  //         context: context, text: "ERROR UPLOADING PROFILE IMAGE : $e");
  //   }
  //   EasyLoading.dismiss();
  // }

  @override
  void initState() {
    super.initState();
    userNameController.text = FirebaseDB.userName as String;
    phoneNumberController.text = FirebaseDB.phoneNumber as String;
    dateController.text = FirebaseDB.dateOfBirth as String;
    imageUrl = FirebaseDB.profileImageURL;
    userNameController.addListener(() => setState(() {}));
    phoneNumberController.addListener(() => setState(() {}));
    dateController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    userNameController.dispose();
    phoneNumberController.dispose();
    dateController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    print("imageUrl+$imageUrl");
    imageUrl = "";
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
      imageUrl == "";
      print("imageUrl2+$imageUrl");
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

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
                                child: SizedBox(
                                    height: 200, child: ImagesTryCatch()),
                              ),
                              ElevatedButton(
                                onPressed: _pickImage,
                                child: Text(
                                  'Change Image',
                                  style: kwhiteTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InputField(
                          isrequired: true,
                          hintText: "",
                          controllerss: userNameController,
                          keyboardType: TextInputType.text,
                          labelText: "Name",
                          textCapitalization: TextCapitalization.words,
                          prefixIcon: Icons.person_2,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InputField(
                          isrequired: true,
                          controllerss: phoneNumberController,
                          keyboardType: TextInputType.number,
                          labelText: "Phone Number",
                          prefixIcon: Icons.money,
                          hintText: "9800000000",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DateInputField(
                          dateinput: dateController.text.isEmpty
                              ? DateTime.now()
                              : DateTime(
                                  int.parse(dateController.text
                                      .split('-')[0]), // Year
                                  int.parse(dateController.text
                                      .split('-')[1]), // Month
                                  int.parse(
                                      dateController.text.split('-')[2]), // Day
                                ),
                          controllerss: dateController,
                          keyboardType: TextInputType.datetime,
                          labelText: "Date of Birth",
                          prefixIcon: Icons.date_range_outlined,
                          hintText: "YYYY-MM-DD",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RiveAnimatedBtn(
                          label: "Update",
                          iconData: Icon(
                            Icons.edit_document,
                            color: Colors.black,
                          ),
                          onTap: () {
                            Future.delayed(const Duration(milliseconds: 800),
                                () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (userNameController.text.isEmpty) {
                                customSnackbar(
                                  context: context,
                                  text: 'Please Enter your name',
                                );
                              } else if (phoneNumberController.text.isEmpty) {
                                customSnackbar(
                                  context: context,
                                  text: 'Please Enter your phone number',
                                );
                              } else if (dateController.text.isEmpty) {
                                customSnackbar(
                                  context: context,
                                  text: 'Please Enter your date of birth',
                                );
                              } else {
                                _uploadImageThenDataUpload();
                                // _addUserData();
                              }
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImagesTryCatch extends StatelessWidget {
  const ImagesTryCatch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(
                  FirebaseDB.profileImageURL!), // Replace with your image URL
              fit: BoxFit.cover, // You can adjust the fit as needed
            ),
          ));
    } catch (error) {
      print(error);
      return ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Lottie.asset("assets/Lottie/ProfileAnimation.json"),
      );
    }
    // return  ClipRRect(
    //     borderRadius:
    //         BorderRadius.circular(100),
    //     child: CachedNetworkImage(
    //       imageUrl:
    //           FirebaseDB.profileImageURL!,
    //     )
    //     // _selectedImage != null
    //     //     ? Container(
    //     //         decoration:
    //     //             buildGradientBorder(),
    //     //         child: CircleAvatar(
    //     //           radius:
    //     //               100, // Adjust the size as needed
    //     //           backgroundImage: FileImage(
    //     //               _selectedImage!),
    //     //         ),
    //     //       )
    //     //     :
    //     // Lottie.asset(
    //     //     "assets/Lottie/ProfileAnimation.json"),
    //     );
  }
}
