import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';
import 'package:flutter/material.dart';
import 'package:smart_kagaj/commonWidgets/animated_button.dart';
import 'package:smart_kagaj/commonWidgets/onboarding_background.dart';
import 'package:smart_kagaj/commonWidgets/smooth_navigation.dart';
import 'package:smart_kagaj/constant/data.dart';
import 'package:smart_kagaj/constant/fonts.dart';
import 'login_signup_page.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);
  static String id = 'IntroductionPage_id';

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  late RiveAnimationController _btnAnimationController;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }

  @override
  void dispose() {
    _btnAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnbodingScreenBackground(
      inputWidgets: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome To",
                          style: kwhiteTextStyle.copyWith(
                              fontSize: 20, fontWeight: FontWeight.w800)),
                      Text(
                        "Smart Kagaj",
                        style: kwhiteboldTextStyle.copyWith(fontSize: 35),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width *
                                0.7, // Set your desired maximum width here
                          ),
                          child: Text(
                            introductionDescription, // textAlign: TextAlign.justify,
                            style: kwhiteTextStyle.copyWith(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Join Us For Free",
                        style: kwhiteTextStyle.copyWith(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(flex: 2),
              RiveAnimatedBtn(
                label: "Get Started",
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 800), () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Navigator.of(context)
                        .push(SmoothSlidePageRoute(page: const LogInSignUp()));
                  });
                },
                iconData: const Icon(
                  CupertinoIcons.arrow_right,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
