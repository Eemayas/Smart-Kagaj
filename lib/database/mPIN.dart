// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../commonWidgets/custom_snackbar.dart';

class MPIN {
  static String? mPIN;
  static String? mConfirmPIN;
  static String? retrievePIN;

  static bool checkPIN() {
    if (mConfirmPIN == mPIN) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> uploadMPIN(
      {required BuildContext context, required userUid}) async {
    if (checkPIN()) {
      try {
        await FirebaseFirestore.instance.collection("MPIN").doc(userUid).set({
          'MPIN': mPIN,
        });
        print("MPIN added");
        customSnackbar(
          context: context,
          icons: Icons.done_all,
          iconsColor: Colors.green,
          text: "PIN is Sucessfully Setup",
        );
        return true;
      } catch (e) {
        print("Error Setting up Mpin : $e");
        customSnackbar(
          context: context,
          text: "Error Setting up Mpin : $e",
        );
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool> retrieveMPIN({required String userUid}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection("MPIN")
              .doc(userUid)
              .get();

      if (documentSnapshot.exists) {
        // Document exists, you can access the 'MPIN' field
        retrievePIN = documentSnapshot.data()?['MPIN'];
        print("MPIN: $retrievePIN");
        return true;
      } else {
        // Document does not exist
        print("Document does not exist.");
        return false;
      }
    } catch (error) {
      print("Error retrieving MPIN: $error");
      return false;
    }
  }
}
