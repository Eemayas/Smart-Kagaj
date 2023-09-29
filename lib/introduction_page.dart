import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';
import 'package:flutter/material.dart';
import 'package:smart_kagaj/commonWidgets/animated_button.dart';
import 'package:smart_kagaj/constant/fonts.dart';

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
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.2,
            right: -100,
            top: -10,
            child: Image.asset(
              "assets/Backgrounds/Spline.png",
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: const SizedBox(),
            ),
          ),
          const RiveAnimation.asset(
            "assets/RiveAssets/shapes.riv",
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: const SizedBox(),
            ),
          ),
          SafeArea(
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
                          Text("Welcome \nTo",
                              style: kwhiteTextStyle.copyWith(
                                  fontSize: 20, fontWeight: FontWeight.w800)),
                          Text(
                            "eGovernance",
                            style: kwhiteboldTextStyle.copyWith(fontSize: 35),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width *
                                    0.6, // Set your desired maximum width here
                              ),
                              child: Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vel egestas dolor, nec dignissim metus. Donec augue elit, rhoncus ac sodales id, porttitor vitae est. Donec laoreet rutrum libero sed pharetra.",
                                // textAlign: TextAlign.justify,
                                style: kwhiteTextStyle.copyWith(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              )),
                          SizedBox(
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
                        print("Pressed");
                      });
                    },
                    iconData: const Icon(
                      CupertinoIcons.arrow_right,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
