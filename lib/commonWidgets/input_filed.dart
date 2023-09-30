// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_kagaj/constant/colors.dart';

import '../constant/fonts.dart';

class InputField extends StatefulWidget {
  const InputField(
      {super.key,
      required this.controllerss,
      required this.keyboardType,
      required this.labelText,
      required this.prefixIcon,
      required this.hintText,
      this.isEnable = true,
      this.textCapitalization = TextCapitalization.sentences,
      this.isUserDetail = false,
      this.isrequired = false,
      this.isPassword = false});
  final String hintText;
  final TextCapitalization textCapitalization;
  final TextEditingController controllerss;
  final TextInputType keyboardType;
  final String labelText;
  final IconData prefixIcon;
  final bool isrequired;
  final bool isPassword;
  final bool isEnable;
  final bool isUserDetail;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: widget.textCapitalization,
      enabled: widget.isEnable,
      controller: widget.controllerss,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
        // }
      },
      obscureText: widget.isPassword && !passwordVisible,
      cursorColor: Colors.white,
      style: kwhiteTextStyle,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              )
            : widget.isUserDetail
                ? Container(width: 0)
                : widget.controllerss.text.isEmpty
                    ? Container(width: 0)
                    : widget.isEnable
                        ? IconButton(
                            color: Colors.red,
                            icon: Icon(Icons.close),
                            onPressed: () => widget.controllerss.clear())
                        : Container(width: 0),
        labelStyle: kwhiteTextStyle,
        filled: true,
        hintStyle: kwhiteTextStyle,
        fillColor: kBackgroundColorCard,
        labelText: widget.labelText,
        prefixIcon: Icon(widget.prefixIcon),
        prefixIconColor: Colors.white,
        hintText: widget.hintText,
        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
