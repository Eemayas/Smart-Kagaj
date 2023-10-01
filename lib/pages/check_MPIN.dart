// ignore_for_file: unused_import, unnecessary_import, prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:rive/rive.dart';
import 'package:smart_kagaj/commonWidgets/hashgenerator.dart';
import 'package:smart_kagaj/database/contact.dart';
import 'package:smart_kagaj/database/firebase.dart';
import '../commonWidgets/PinEntry/numPad.dart';
import '../commonWidgets/PinEntry/pinEntryField.dart';
import '../commonWidgets/animated_button.dart';
import '../commonWidgets/custom_snackbar.dart';
import '../commonWidgets/onboarding_background.dart';
import '../commonWidgets/smooth_navigation.dart';
import '../constant/fonts.dart';
import '../database/mPIN.dart';

class CheckMPIN extends StatefulWidget {
  const CheckMPIN(
      {this.contractAddress = "Ads",
      this.isContract = false,
      super.key,
      required this.nextPage});
  final Widget nextPage;
  final bool isContract;
  final String contractAddress;
  @override
  State<CheckMPIN> createState() => _CheckMPINState();
}

class _CheckMPINState extends State<CheckMPIN> {
  User user = FirebaseAuth.instance.currentUser!;
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
            "Enter Your Pin",
            style: kwhiteboldTextStyle.copyWith(fontSize: 20),
          ),
          PinEntryField(
            pinControllers: _pinControllers,
          ),
          NumPad(pinControllers: _pinControllers),
          SizedBox(height: 10),
          RiveAnimatedBtn(
              label: "Confirm PIN",
              iconData: Icon(
                Icons.arrow_right_alt,
                color: Colors.black,
              ),
              onTap: () {
                if (_pinControllers[0].text != "" &&
                    _pinControllers[1].text != "" &&
                    _pinControllers[2].text != "" &&
                    _pinControllers[3].text != "") {
                  Future.delayed(const Duration(milliseconds: 800), () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    EasyLoading.show(
                      status: 'Processing...',
                      maskType: EasyLoadingMaskType.black,
                    );
                    bool isSucess = await MPIN.retrieveMPIN(userUid: user.uid);
                    if (isSucess) {
                      String inputedPIN = _pinControllers[0].text +
                          _pinControllers[1].text +
                          _pinControllers[2].text +
                          _pinControllers[3].text;
                      if (inputedPIN == MPIN.retrievePIN) {
                        EasyLoading.showSuccess('PIN is valid');
                        if (widget.isContract) {
                          if (ContractDB.Signers?[0]["hash"] == null) {
                            ContractDB.editContractInFirestore(
                                context: context,
                                contractAddress: widget.contractAddress,
                                updatedContractData: {
                                  "date": ContractDB.date,
                                  "contractName": ContractDB.contractName,
                                  "contractDescription":
                                      ContractDB.contractDescription,
                                  "contractContent": ContractDB.contractContent,
                                  "contractTermsAndCondition":
                                      ContractDB.contractTermsAndCondition,
                                  "contractTotalSigners":
                                      ContractDB.contractTotalSigners,
                                  "contractAuthName":
                                      ContractDB.contractAuthName,
                                  "contractAuthHash":
                                      ContractDB.contractAuthHash,
                                  "contractAddress": widget.contractAddress,
                                  "Signers": [
                                    {
                                      "date": DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now())
                                          .toString(),
                                      "name": FirebaseDB.userName,
                                      "hash": calculateMD5(
                                          "$FirebaseDB.userName$FirebaseDB.citizenshipNumber"),
                                    },
                                    {"date": Null, "name": Null, "hash": Null},
                                  ]
                                });
                            customSnackbar(
                              context: context,
                              text: "Contract is sucessfully signed",
                              icons: Icons.done,
                              iconsColor: Colors.green,
                            );
                          } else {
                            ContractDB.editContractInFirestore(
                                context: context,
                                contractAddress: widget.contractAddress,
                                updatedContractData: {
                                  "date": ContractDB.date,
                                  "contractName": ContractDB.contractName,
                                  "contractDescription":
                                      ContractDB.contractDescription,
                                  "contractContent": ContractDB.contractContent,
                                  "contractTermsAndCondition":
                                      ContractDB.contractTermsAndCondition,
                                  "contractTotalSigners":
                                      ContractDB.contractTotalSigners,
                                  "contractAuthName":
                                      ContractDB.contractAuthName,
                                  "contractAuthHash":
                                      ContractDB.contractAuthHash,
                                  "contractAddress": widget.contractAddress,
                                  "Signers": [
                                    {
                                      "date": ContractDB.Signers?[0]["date"],
                                      "name": ContractDB.Signers?[0]["name"],
                                      "hash": ContractDB.Signers?[0]["hash"],
                                    },
                                    {
                                      "date": DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now())
                                          .toString(),
                                      "name": FirebaseDB.userName,
                                      "hash": calculateMD5(
                                          "$FirebaseDB.userName$FirebaseDB.citizenshipNumber"),
                                    },
                                  ]
                                });
                            customSnackbar(
                              context: context,
                              text: "Contract is sucessfully signed",
                              icons: Icons.done,
                              iconsColor: Colors.green,
                            );
                          }
                        }
                        Navigator.of(context).pushReplacement(
                            SmoothSlidePageRoute(page: widget.nextPage));
                      } else {
                        customSnackbar(
                            context: context,
                            text: "Entered PIN is not correct");
                      }
                    }

                    //
                    EasyLoading.dismiss();
                  });
                } else {
                  customSnackbar(
                      context: context, text: "Please entry your pin");
                  EasyLoading.dismiss();
                }
              }),
        ],
      ),
    ));
  }
}
