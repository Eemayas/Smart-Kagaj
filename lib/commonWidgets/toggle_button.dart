// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:smart_kagaj/constant/fonts.dart';

class ToggleButton extends StatefulWidget {
  final double width;
  final double height;

  final String leftDescription;
  final String rightDescription;

  final Color toggleColor;
  final Color toggleBackgroundColor;
  final Color toggleBorderColor;

  final Color inactiveTextColor;
  final Color activeTextColor;

  final double _leftToggleAlign = -1;
  final double _rightToggleAlign = 1;

  final VoidCallback onLeftToggleActive;
  final VoidCallback onRightToggleActive;

  const ToggleButton(
      {Key? key,
      required this.width,
      required this.height,
      required this.toggleBackgroundColor,
      required this.toggleBorderColor,
      required this.toggleColor,
      required this.activeTextColor,
      required this.inactiveTextColor,
      required this.leftDescription,
      required this.rightDescription,
      required this.onLeftToggleActive,
      required this.onRightToggleActive})
      : super(key: key);

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  double _toggleXAlign = -1;

  late Color _leftDescriptionColor;
  late Color _rightDescriptionColor;
  bool isLeftActive = true;

  @override
  void initState() {
    super.initState();

    // _leftDescriptionColor = widget.activeTextColor;
    // _rightDescriptionColor = widget.inactiveTextColor;
  }

  @override
  Widget build(BuildContext context) {
    _leftDescriptionColor =
        isLeftActive ? widget.activeTextColor : widget.inactiveTextColor;
    _rightDescriptionColor =
        !isLeftActive ? widget.activeTextColor : widget.inactiveTextColor;
    double toggleAxis =
        isLeftActive ? widget._rightToggleAlign : widget._leftToggleAlign;
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.toggleBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
        border: Border.all(color: widget.toggleBorderColor),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(_toggleXAlign, 0),
            duration: Duration(milliseconds: 300),
            child: Container(
              width: widget.width * 0.5,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.toggleColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(
                () {
                  _toggleXAlign = toggleAxis;

                  isLeftActive = !isLeftActive;

                  // _toggleXAlign = widget._rightToggleAlign;
                  // _leftDescriptionColor = widget.inactiveTextColor;
                  // _rightDescriptionColor = widget.activeTextColor;
                },
              );

              isLeftActive
                  ? widget.onLeftToggleActive()
                  : widget.onRightToggleActive();
            },
            child: Align(
              alignment: Alignment(-1, 0),
              child: Container(
                width: widget.width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  widget.leftDescription,
                  style: kwhiteTextStyle.copyWith(
                      color: _leftDescriptionColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(
                () {
                  _toggleXAlign = toggleAxis;

                  isLeftActive = !isLeftActive;

                  // _toggleXAlign = widget._leftToggleAlign;

                  // _leftDescriptionColor = widget.activeTextColor;
                  // _rightDescriptionColor = widget.inactiveTextColor;
                },
              );
              isLeftActive
                  ? widget.onLeftToggleActive()
                  : widget.onRightToggleActive();

              // widget.onLeftToggleActive();
            },
            child: Align(
              alignment: Alignment(1, 0),
              child: Container(
                width: widget.width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  widget.rightDescription,
                  style: kwhiteTextStyle.copyWith(
                      color: _rightDescriptionColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
