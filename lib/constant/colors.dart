import 'package:flutter/material.dart';

const Color kBackgroundColor = Color(0xff1E1E1E);
const Color kBackgroundColorAppBar = Color.fromARGB(255, 43, 41, 50);
const Color kBackgroundColorCard = Color(0xff191928);

const Color kBoxShadowGreen = Color(0x7F008000);
const Color kBoxShadowRed = Color(0x7FFF0000);

BoxDecoration buildGradientBorder() {
  return BoxDecoration(
    // shape: BoxShape.circle,
    border: Border.all(
      width: 3, // Adjust the border width as needed
      color: Colors.transparent, // Set border color to transparent
    ),
    gradient: const LinearGradient(
      colors: [Colors.blue, Colors.green], // Customize gradient colors
      begin: Alignment.topLeft, // Customize gradient begin position
      end: Alignment.bottomRight, // Customize gradient end position
    ),
  );
}
