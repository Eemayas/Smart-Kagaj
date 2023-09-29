import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constant/fonts.dart';

class GreetingUser extends StatelessWidget {
  const GreetingUser({
    super.key,
    required this.userName,
  });

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi,$userName",
                style: kwhiteboldTextStyle.copyWith(fontSize: 28),
              ),
              Text(
                "Welcome to the Smart Kagaj",
                style: kwhiteTextStyle.copyWith(),
              ),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          height: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Lottie.asset("assets/Lottie/ProfileAnimation.json"),
          ),
        ),
      ],
    );
  }
}
