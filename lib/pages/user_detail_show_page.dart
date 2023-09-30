// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import 'package:smart_kagaj/commonWidgets/animated_button.dart';

import '../commonWidgets/date_Input_field.dart';
import '../commonWidgets/input_filed.dart';
import '../commonWidgets/onboarding_background.dart';
import '../commonWidgets/smooth_navigation.dart';
import '../database/firebase.dart';
import 'user_detail_edit_page.dart';

class UserDetailShowPage extends StatefulWidget {
  const UserDetailShowPage({super.key});
  static String id = "user_detail_";

  @override
  State<UserDetailShowPage> createState() => _UserDetailEntryPageState();
}

class _UserDetailEntryPageState extends State<UserDetailShowPage> {
  final userNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final dateController = TextEditingController();
  User user = FirebaseAuth.instance.currentUser!;
  late RiveAnimationController _btnAnimationController;
  @override
  void initState() {
    super.initState();
    FirebaseDB.retrievePersonalDetail(
      userUid: user.uid,
    );
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
  }

  @override
  void dispose() {
    _btnAnimationController.dispose();
    super.dispose();
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
              child: FutureBuilder<Map<String, dynamic>?>(
                future: FirebaseDB.retrievePersonalDetail(
                    userUid:
                        user.uid), // Replace with your data fetching function
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    EasyLoading.show(
                      dismissOnTap: true,
                      status: 'Processing...',
                      maskType: EasyLoadingMaskType.black,
                    );
                    return Form(
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
                                      // onTap: _pickImage,
                                      child: SizedBox(
                                        height: 200,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Lottie.asset(
                                              "assets/Lottie/ProfileAnimation.json"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InputField(
                                isEnable: false,
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
                                isEnable: false,
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
                                dateinput: DateTime.now(),
                                isEnable: false,
                                controllerss: dateController,
                                keyboardType: TextInputType.datetime,
                                labelText: "Date of Birth",
                                prefixIcon: Icons.date_range_outlined,
                                hintText: "YYYY-MM-DD",
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    userNameController.text = FirebaseDB.userName! as String;
                    phoneNumberController.text =
                        FirebaseDB.phoneNumber as String;
                    dateController.text = FirebaseDB.dateOfBirth as String;
                    EasyLoading.dismiss();
                    return Form(
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
                                      // onTap: _pickImage,
                                      child: SizedBox(
                                        height: 200,
                                        child: ImagesTryCatch(),
                                      ),
                                    ),
                                    // ElevatedButton(
                                    //   onPressed: _pickImage,
                                    //   child: Text(
                                    //     'Change Image',
                                    //     style: kwhiteTextStyle,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InputField(
                                isEnable: false,
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
                                isEnable: false,
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
                                        int.parse(dateController.text
                                            .split('-')[2]), // Day
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
                                label: "Edit",
                                iconData: Icon(
                                  Icons.edit_document,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  _btnAnimationController.isActive = true;
                                  Future.delayed(
                                      const Duration(milliseconds: 800),
                                      () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    Navigator.of(context).push(
                                        SmoothSlidePageRoute(
                                            page: UserDetailEditPage()));
                                    if (await FirebaseDB.uploadPersonalDetail(
                                        context: context, userUid: user.uid)) {
                                      setState(() {});
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
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
  }
}
