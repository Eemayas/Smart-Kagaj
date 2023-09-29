import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class OnbordingBackgroung extends StatelessWidget {
  const OnbordingBackgroung({super.key, required this.inputWidgets});
  static String id = 'OnbordingBackgroung_id';
  final Widget inputWidgets;
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
          inputWidgets,
        ],
      ),
    );
  }
}
