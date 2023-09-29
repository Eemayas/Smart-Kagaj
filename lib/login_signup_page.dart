import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_kagaj/commonWidgets/animated_button.dart';
import 'package:smart_kagaj/commonWidgets/custom_snackbar.dart';
import 'package:smart_kagaj/commonWidgets/onboarding_background.dart';
import 'package:smart_kagaj/commonWidgets/smooth_navigation.dart';
import 'package:smart_kagaj/commonWidgets/toggle_button.dart';
import 'package:smart_kagaj/constant/colors.dart';
import 'package:smart_kagaj/constant/fonts.dart';
import 'package:smart_kagaj/user_detail_entry_page.dart';

import 'commonWidgets/input_filed.dart';
import 'package:lottie/lottie.dart';

class LogInSignUp extends StatefulWidget {
  const LogInSignUp({Key? key}) : super(key: key);
  static String id = 'LogInSignUp_id';

  @override
  State<LogInSignUp> createState() => _LogInSignUpState();
}

class _LogInSignUpState extends State<LogInSignUp> {
  bool isLogIn = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  _forgotPassword() {}

  _navigateToTermsAndConditions() {}

  _logIn() async {}

  _signUp() {
    Navigator.of(context)
        .push(SmoothSlidePageRoute(page: const UserDetailEntryPage()));
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
    confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        print(
            "${emailController.text}  ${passwordController.text} ${confirmPasswordController.text} "),
        FocusScope.of(context).requestFocus(FocusNode())
      },
      child: OnbordingBackgroung(
        inputWidgets: SingleChildScrollView(
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.24,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Lottie.asset("assets/Lottie/login.json"),
                      )),
                  Text(
                    isLogIn ? "Log In" : "Sign In",
                    style: kwhiteboldTextStyle.copyWith(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'By signing in you are agreeing our ',
                            style: kwhiteTextStyle,
                          ),
                          TextSpan(
                              text: 'Term and privacy policy',
                              style: kwhiteboldTextStyle.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _navigateToTermsAndConditions),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ToggleButton(
                    width: 300.0,
                    height: 50.0,
                    toggleBackgroundColor: kBackgroundColorCard,
                    toggleBorderColor: (Colors.grey[350])!,
                    toggleColor: (Colors.indigo[900])!,
                    activeTextColor: Colors.white,
                    inactiveTextColor: Colors.white60,
                    leftDescription: 'Log In',
                    rightDescription: 'Sign Up',
                    onLeftToggleActive: () {
                      setState(() {
                        isLogIn = !isLogIn;
                      });
                    },
                    onRightToggleActive: () {
                      setState(() {
                        isLogIn = !isLogIn;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputField(
                      isrequired: true,
                      hintText: "",
                      controllerss: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      labelText: "Email",
                      prefixIcon: Icons.email_outlined),
                  const SizedBox(
                    height: 20,
                  ),
                  InputField(
                    isPassword: true,
                    isrequired: true,
                    controllerss: passwordController,
                    keyboardType: TextInputType.text,
                    labelText: "Password",
                    prefixIcon: Icons.password,
                    hintText: "*****",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: !isLogIn,
                    child: InputField(
                      isPassword: true,
                      isrequired: true,
                      controllerss: confirmPasswordController,
                      keyboardType: TextInputType.text,
                      labelText: "Confirm Password",
                      prefixIcon: Icons.password,
                      hintText: "*****",
                    ),
                  ),
                  Visibility(
                      visible: !isLogIn,
                      child: const SizedBox(
                        height: 20,
                      )),
                  Visibility(
                    visible: isLogIn,
                    child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: _forgotPassword,
                          child: Text(
                            "Forgot Password?",
                            style: kwhiteboldTextStyle.copyWith(
                              // color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RiveAnimatedBtn(
                    label: isLogIn ? "Log In" : "Sign In",
                    onTap: () {
                      Future.delayed(const Duration(milliseconds: 800), () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (emailController.text.isEmpty) {
                          customSnackbar(
                            context: context,
                            icons: Icons.error,
                            iconsColor: Colors.red,
                            text: 'Plese Fill the Email',
                          );
                        } else if (passwordController.text.isEmpty) {
                          customSnackbar(
                            context: context,
                            icons: Icons.error,
                            iconsColor: Colors.red,
                            text: 'Plese input Password',
                          );
                        } else if (!isLogIn &&
                            confirmPasswordController.text.isEmpty) {
                          customSnackbar(
                            context: context,
                            icons: Icons.error,
                            iconsColor: Colors.red,
                            text: 'Plese input Confirm Password',
                          );
                        } else if (!isLogIn &&
                            (confirmPasswordController.text !=
                                passwordController.text)) {
                          customSnackbar(
                              context: context,
                              icons: Icons.error,
                              iconsColor: Colors.red,
                              text:
                                  'Password and Confirm Password Doesnot Match');
                        } else {
                          isLogIn ? _logIn() : _signUp();
                        }
                      });
                    },
                    iconData: const Icon(
                      Icons.login_sharp,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
