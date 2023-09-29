import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_kagaj/commonWidgets/animated_button.dart';
import 'package:smart_kagaj/commonWidgets/custom_snackbar.dart';
import 'package:smart_kagaj/commonWidgets/input_filed.dart';
import 'package:smart_kagaj/commonWidgets/onboarding_background.dart';
import 'package:image_picker/image_picker.dart';
import 'commonWidgets/date_Input_field.dart';
import 'constant/colors.dart';
import 'constant/fonts.dart';

class UserDetailEntryPage extends StatefulWidget {
  const UserDetailEntryPage({super.key});
  static String id = "user_detail_entry";

  @override
  State<UserDetailEntryPage> createState() => _UserDetailEntryPageState();
}

class _UserDetailEntryPageState extends State<UserDetailEntryPage> {
  final userNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final dateController = TextEditingController();
  File? _selectedImage;
  Uint8List? _image;
  _addUserData() async {}

  Future<void> _uploadImageThenDataUpload() async {}

  @override
  void initState() {
    super.initState();
    userNameController.addListener(() => setState(() {}));
    phoneNumberController.addListener(() => setState(() {}));
    // dateController.addListener(() => setState(() {}));
  }

  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusScope.of(context).requestFocus(FocusNode())},
      child: OnbordingBackgroung(
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
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: _selectedImage != null
                                        ? Container(
                                            decoration: buildGradientBorder(),
                                            child: CircleAvatar(
                                              radius:
                                                  100, // Adjust the size as needed
                                              backgroundImage:
                                                  FileImage(_selectedImage!),
                                            ),
                                          )
                                        : Lottie.asset(
                                            "assets/Lottie/ProfileAnimation.json"),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _pickImage,
                                child: Text(
                                  'Select Image',
                                  style: kwhiteTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
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
                        const SizedBox(
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
                        const SizedBox(
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
                        const SizedBox(
                          height: 20,
                        ),
                        RiveAnimatedBtn(
                          label: "Proceed",
                          iconData: const Icon(
                            Icons.login_sharp,
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
                              } else if (_image == null) {
                                customSnackbar(
                                    context: context,
                                    text:
                                        'No Profile Picture is Selected. Please select');
                              } else {
                                // _uploadImage();
                                _uploadImageThenDataUpload();
                                // _addUserData();
                              }
                            });
                          },
                        ),
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
