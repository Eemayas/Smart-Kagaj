// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_kagaj/commonWidgets/animated_button.dart';
import 'package:smart_kagaj/database/contact.dart';
import 'package:smart_kagaj/database/firebase.dart';
import 'package:smart_kagaj/pages/terms_condition_page.dart';
import 'package:smart_kagaj/services/functions.dart';
import 'package:smart_kagaj/utils/constants.dart';
import 'package:web3dart/web3dart.dart';
import '../commonWidgets/custom_snackbar.dart';
import '../commonWidgets/date_Input_field.dart';
import '../commonWidgets/input_filed.dart';
import '../commonWidgets/onboarding_background.dart';

String calculateMD5(String input) {
  var bytes = utf8.encode(input); // Encode the input string as bytes
  var md5Hash = md5.convert(bytes); // Calculate the MD5 hash
  return md5Hash.toString(); // Convert the hash to a string
}

class CreateContractPage extends StatefulWidget {
  const CreateContractPage({super.key});
  static String id = "user_detail_entry";

  @override
  State<CreateContractPage> createState() => _CreateContractPageState();
}

class _CreateContractPageState extends State<CreateContractPage> {
  Client? httpClient;
  Web3Client? ethClient;
  final dateController = TextEditingController();
  final contractNameController = TextEditingController();
  final contractDescriptionController = TextEditingController();
  final contractContentController = TextEditingController();
  final contractTermsAndConditionController = TextEditingController();
  final contractTotalSignersController = TextEditingController();
  final contractAuthNameController = TextEditingController();
  final contractAuthHashController = TextEditingController();
  User user = FirebaseAuth.instance.currentUser!;

  Future<void> _createContract() async {
    EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    ContractDB.date = dateController.text;
    ContractDB.contractName = contractNameController.text;
    ContractDB.contractDescription = contractDescriptionController.text;
    ContractDB.contractContent = "Contract";
    ContractDB.contractTermsAndCondition =
        contractTermsAndConditionController.text;
    ContractDB.contractTotalSigners = '0';
    ContractDB.contractAuthName = contractAuthNameController.text;
    ContractDB.contractAuthHash =
        calculateMD5("$FirebaseDB.userName$FirebaseDB.citizenshipNumber");
    ContractDB.printall();
    createContract(
        ContractAddress,
        DateTime.now().millisecondsSinceEpoch,
        ContractDB.contractName!,
        ContractDB.contractDescription!,
        ContractDB.contractContent!,
        ContractDB.contractTermsAndCondition!,
        int.parse(ContractDB.contractTotalSigners!),
        ContractDB.contractAuthName!,
        ContractDB.contractAuthHash!,
        ethClient!);
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);

    super.initState();
    contractNameController.addListener(() => setState(() {}));
    contractDescriptionController.addListener(() => setState(() {}));
    contractContentController.addListener(() => setState(() {}));
    contractTermsAndConditionController.addListener(() => setState(() {}));
    contractTotalSignersController.addListener(() => setState(() {}));
    contractAuthNameController.addListener(() => setState(() {}));
    contractAuthHashController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusScope.of(context).requestFocus(FocusNode())},
      child: OnbodingScreenBackground(
        inputWidgets: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.24,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Lottie.asset(
                                  "assets/Lottie/createContract.json"),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        DateInputField(
                          dateinput: dateController.text.isEmpty
                              ? DateTime.now()
                              : DateTime(
                                  int.parse(dateController.text
                                      .split('-')[0]), // Year
                                  int.parse(dateController.text
                                      .split('-')[1]), // Month
                                  int.parse(
                                      dateController.text.split('-')[2]), // Day
                                ),
                          controllerss: dateController,
                          keyboardType: TextInputType.datetime,
                          labelText: "Date of Contract Creation",
                          prefixIcon: Icons.date_range_outlined,
                          hintText: "YYYY-MM-DD",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputField(
                          isrequired: true,
                          hintText: "",
                          controllerss: contractNameController,
                          keyboardType: TextInputType.text,
                          labelText: "Name of ContractEm",
                          textCapitalization: TextCapitalization.words,
                          prefixIcon: Icons.person_2,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputField(
                          isrequired: true,
                          controllerss: contractDescriptionController,
                          keyboardType: TextInputType.number,
                          labelText: "Contract Description",
                          prefixIcon: Icons.money,
                          hintText:
                              "This deed of agreement is executed on...... between... (Company Name) .....„..",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // InputField(
                        //   isrequired: true,
                        //   controllerss: contractContentController,
                        //   keyboardType: TextInputType.number,
                        //   labelText: "Contract Description",
                        //   prefixIcon: Icons.money,
                        //   hintText:
                        //       "This deed of agreement is executed on...... between... (Company Name) .....„..",
                        // ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        InputField(
                          isrequired: true,
                          controllerss: contractTermsAndConditionController,
                          keyboardType: TextInputType.number,
                          labelText: "Terms and Conditions",
                          prefixIcon: Icons.money,
                          hintText:
                              "The second patty acc.ted to work in the posiion cf the managanatt ofthe first party Mid accepted to tuvd«go 3 nonths probatrorwy pencd After successfully pafonning the probation penod- the contract will be extended for TWO YEARS renewablc includine the previ«ls three months prcbationæ•y period",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputField(
                          isrequired: true,
                          controllerss: contractAuthNameController,
                          keyboardType: TextInputType.number,
                          labelText: "Auth Name",
                          prefixIcon: Icons.money,
                          hintText: "Prashant, Shyam",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RiveAnimatedBtn(
                          label: "Proceed",
                          onTap: () {
                            Future.delayed(const Duration(milliseconds: 800),
                                () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (contractNameController.text.isEmpty) {
                                customSnackbar(
                                  context: context,
                                  text: 'Please Enter contract name',
                                );
                              } else if (contractDescriptionController
                                  .text.isEmpty) {
                                customSnackbar(
                                  context: context,
                                  text:
                                      'Please Enter contract Description number',
                                );
                              } else if (dateController.text.isEmpty) {
                                customSnackbar(
                                  context: context,
                                  text:
                                      'Please Enter your date Contract Created',
                                );
                              } else if (contractTermsAndConditionController
                                  .text.isEmpty) {
                                customSnackbar(
                                  context: context,
                                  text:
                                      'Please Enter your terms and conditions',
                                );
                              } else if (contractAuthNameController
                                  .text.isEmpty) {
                                customSnackbar(
                                  context: context,
                                  text: 'Please Enter Auth Name',
                                );
                              } else {
                                _createContract();
                              }
                            });
                          },
                          iconData: const Icon(
                            Icons.login_sharp,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
