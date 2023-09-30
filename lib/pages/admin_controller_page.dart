import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_kagaj/commonWidgets/custom_button.dart';
import 'package:smart_kagaj/constant/fonts.dart';
import 'package:smart_kagaj/database/admin.dart';
import 'package:smart_kagaj/model/menu.dart';
import '../commonWidgets/custom_snackbar.dart';
import '../commonWidgets/input_filed.dart';

class AdminControllerPage extends StatefulWidget {
  static String id = "Forgot Password";
  const AdminControllerPage({super.key});

  @override
  State<AdminControllerPage> createState() => _AdminControllerPageState();
}

class _AdminControllerPageState extends State<AdminControllerPage> {
  final emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    emailController.addListener(() => setState(() {}));
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        print("${emailController.text} "),
        FocusScope.of(context).requestFocus(FocusNode())
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.24,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Lottie.asset("assets/Lottie/Admin.json"),
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Enter the Email manage the Admin Previllage",
                    style: kwhiteTextStyle.copyWith(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputField(
                      isrequired: true,
                      hintText: "",
                      controllerss: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      labelText: "Email",
                      prefixIcon: Icons.email_outlined),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomProgressButton(
                    height: 200,
                    label: SizedBox(
                      width: 100,
                      child: Text(
                        "Add Email to Admin Category",
                        style: kwhiteTextStyle,
                      ),
                    ),
                    icons: const Icon(Icons.add),
                    onTap: () => {
                      FocusScope.of(context).requestFocus(FocusNode()),
                      if (emailController.text.isEmpty)
                        {
                          customSnackbar(
                            context: context,
                            icons: Icons.error,
                            iconsColor: Colors.red,
                            text: 'Plese Fill the Email',
                          )
                        }
                      else
                        {
                          AdminDB.addAdminToListInFirestore(
                              newAdminUser: emailController.text,
                              context: context),
                          customSnackbar(
                            context: context,
                            icons: Icons.done,
                            iconsColor: Colors.green,
                            text: 'Email is Sucessfully added',
                          )
                        },
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomProgressButton(
                    height: 200,
                    label: SizedBox(
                        width: 100,
                        child: Text(
                          "Remove Email from Admin Category",
                          style: kwhiteTextStyle,
                        )),
                    icons: const Icon(Icons.delete_forever),
                    onTap: () => {
                      FocusScope.of(context).requestFocus(FocusNode()),
                      if (emailController.text.isEmpty)
                        {
                          customSnackbar(
                            context: context,
                            icons: Icons.error,
                            iconsColor: Colors.red,
                            text: 'Plese Fill the Email',
                          )
                        }
                      else
                        {
                          AdminDB.deleteContractFromFirestore(
                            dataToDelete: emailController.text,
                          ),
                          customSnackbar(
                            context: context,
                            icons: Icons.delete,
                            iconsColor: Colors.red,
                            text: 'Email is Deleted',
                          )
                        },
                    },
                  )
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
