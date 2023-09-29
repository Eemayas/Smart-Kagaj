import 'package:flutter/material.dart';

class CustomProgressButton extends StatelessWidget {
  final Widget label;
  final double height;
  final double maxWidth;
  final Icon icons;
  final Function()? onTap;
  const CustomProgressButton({
    super.key,
    required this.label,
    this.height = 40.00,
    this.maxWidth = 200.00,
    required this.icons,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxWidth: maxWidth // Set your desired maximum width here
          ),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Adjust the radius as needed
            ),
            backgroundColor: Colors.blueAccent,
          ),
          onPressed: onTap,
          child: Row(
            children: [
              icons,
              const SizedBox(
                width: 5,
              ),
              label,
            ],
          )),
    );
  }
}
