// ignore_for_file: unused_import, unnecessary_import, prefer_const_constructors, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:rive/rive.dart';
import 'package:smart_kagaj/commonWidgets/onboarding_background.dart';

import '../commonWidgets/PinEntry/numPad.dart';
import '../commonWidgets/PinEntry/pinEntryField.dart';
import '../constant/fonts.dart';

class SetupMPIN extends StatefulWidget {
  const SetupMPIN({super.key});

  @override
  State<SetupMPIN> createState() => _SetupMPINState();
}

class _SetupMPINState extends State<SetupMPIN> {
  late List<TextEditingController> _pinControllers;

  @override
  void initState() {
    super.initState();
    _pinControllers = List.generate(4, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var i = 0; i < 4; i++) {
      _pinControllers[i].dispose();
    }
    super.dispose();
  }

  bool isMPIN = true;
  @override
  Widget build(BuildContext context) {
    return OnbodingScreenBackground(
        inputWidgets: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Lottie.asset("assets/Lottie/Mpin.json"))),
          SizedBox(height: 10),
          Text(
            isMPIN ? "Enter Your PIN" : "Confirm Your PIN",
            style: kwhiteboldTextStyle.copyWith(fontSize: 20),
          ),
          PinEntryField(
            pinControllers: _pinControllers,
          ),
          NumPad(pinControllers: _pinControllers),
          SizedBox(height: 10),
          // AnimatedBtn(
          //     label: isMPIN ? "Proceed" : "Confirm PIN",
          //     icon: Icon(
          //       Icons.arrow_right_alt,
          //       color: Colors.black,
          //     ),
          //     btnAnimationController: _btnAnimationController,
          //     press: () {
          //       if (_pinControllers[0].text != "" &&
          //           _pinControllers[1].text != "" &&
          //           _pinControllers[2].text != "" &&
          //           _pinControllers[3].text != "") {
          //         _btnAnimationController.isActive = true;
          //         Future.delayed(const Duration(milliseconds: 800), () async {
          //           FocusScope.of(context).requestFocus(FocusNode());
          //           EasyLoading.show(
          //             status: 'Processing...',
          //             maskType: EasyLoadingMaskType.black,
          //           );
          //           if (isMPIN) {
          //             MPIN.mPIN = _pinControllers[0].text +
          //                 _pinControllers[1].text +
          //                 _pinControllers[2].text +
          //                 _pinControllers[3].text;
          //             print(MPIN.mPIN);
          //             setState(() {
          //               isMPIN = false;
          //               _pinControllers[0].text = "";
          //               _pinControllers[1].text = "";
          //               _pinControllers[2].text = "";
          //               _pinControllers[3].text = "";
          //             });
          //           } else {
          //             MPIN.mConfirmPIN = _pinControllers[0].text +
          //                 _pinControllers[1].text +
          //                 _pinControllers[2].text +
          //                 _pinControllers[3].text;
          //             print(MPIN.mPIN);
          //             if (await MPIN.uploadMPIN(
          //                     context: context, userUid: user.uid) &&
          //                 MPIN.checkPIN()) {
          //               Navigator.of(context)
          //                   .push(SmoothSlidePageRoute(page: EntryPoint()));
          //             } else {
          //               customSnackbar(
          //                   context: context, text: "PIN doesnot match");
          //             }
          //           }
          //           EasyLoading.dismiss();
          //         });
          //       } else {
          //         customSnackbar(
          //             context: context, text: "Please entry your pin");
          //         EasyLoading.dismiss();
          //       }
          //     }),
        ],
      ),
    ));
  }
}
