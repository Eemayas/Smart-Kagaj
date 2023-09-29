import 'package:flutter/material.dart';

import '../../constant/fonts.dart';

class PinEntryField extends StatefulWidget {
  final List<TextEditingController> pinControllers;

  const PinEntryField({super.key, required this.pinControllers});
  @override
  _PinEntryFieldState createState() => _PinEntryFieldState();
}

class _PinEntryFieldState extends State<PinEntryField> {
  late List<FocusNode> _pinFocusNodes;

  @override
  void initState() {
    super.initState();
    _pinFocusNodes = List.generate(4, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var i = 0; i < 4; i++) {
      _pinFocusNodes[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          width: 50.0, // Adjust the width of each box
          height: 50.0, // Adjust the height of each box
          margin: const EdgeInsets.all(10.0), // Adjust the spacing between boxes
          decoration: BoxDecoration(
            // color: Color(0xFFf5f5f8),
            border: Border.all(
              color: Colors.greenAccent,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
            // boxShadow: BoxShadow(color: Colors.greenAccent,)
          ),
          child: TextField(
            readOnly: true,
            controller: widget.pinControllers[index],
            focusNode: _pinFocusNodes[index],
            keyboardType: TextInputType.none,
            maxLength: 1,
            textAlign: TextAlign.center,
            style: kwhiteboldTextStyle.copyWith(
              fontSize: 20,
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 3) {
                FocusScope.of(context).nextFocus();
              }
            },
            decoration: const InputDecoration(
              counterText: '', // Hide the character count
              border: InputBorder.none, // Hide the default border
              focusedBorder: InputBorder.none, // Hide the focused border
            ),
          ),
        );
      }),
    );
  }
}
