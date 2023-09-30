import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_kagaj/pages/entry_point.dart';
import 'package:smart_kagaj/pages/login_signup_page.dart';

import 'custom_snackbar.dart';

class CheckSignInOutPage extends StatelessWidget {
  static String id = "Check Page";
  const CheckSignInOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              customSnackbar(context: context, text: "Something went wrong");
            }
            if (snapshot.hasData) {
              return const EntryPoint();
            } else {
              return const LogInSignUp();
            }
          }),
    );
  }
}
