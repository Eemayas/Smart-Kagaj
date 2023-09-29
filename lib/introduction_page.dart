import 'package:flutter/material.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);
  static String id = 'IntroductionPage_id';

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
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
        ],
      ),
    );
  }
}
