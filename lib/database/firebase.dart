// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../commonWidgets/custom_snackbar.dart';

class FirebaseDB {
  static String? userName;
  static String? phoneNumber;
  static String? dateOfBirth;
  static String? profileImageURL;
  static String? citizenshipNumber;
  static String? citizenshipImageURL;
  static String? citizenshipIssuedDate;

  static void printall() {
    print(
        "userName:$userName\nphoneNumber:$phoneNumber\ndateOfBirth:$dateOfBirth}\nprofileImageURL:$profileImageURL\ncitizenshipNumber:$citizenshipNumber\ncitizenshipImageUR:$citizenshipImageURL\ncitizenshipIssuedDate:$citizenshipIssuedDate");
  }

  static Future<bool> uploadPersonalDetail(
      {required BuildContext context, required userUid}) async {
    try {
      await FirebaseFirestore.instance
          .collection("Personal_Detail")
          .doc(userUid)
          .set({
        'Username': userName,
        'PhoneNumber': phoneNumber,
        "Date of Birth": dateOfBirth,
        "Profile Image URL": profileImageURL,
        "Citizenship Number": citizenshipNumber,
        "Citizenhip ImageURL": citizenshipImageURL,
        "Citizenhip Issued Date": citizenshipIssuedDate,
      });
      print("User Details added to Firebase");
      customSnackbar(
        context: context,
        icons: Icons.done_all,
        iconsColor: Colors.green,
        text: "User Details added to Firebase",
      );
      return true;
    } catch (e) {
      print("Error Adding user Details to Firebase : $e");
      customSnackbar(
        context: context,
        text: "Error Adding user Details to Firebase : $e",
      );
      return false;
    }
  }

  static Future<Map<String, dynamic>?> retrievePersonalDetail(
      {required String userUid}) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("Personal_Detail")
          .doc(userUid)
          .get();

      if (snapshot.exists) {
        // Convert the snapshot data to a Map and return it
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        print(data);
        userName = data['Username'];
        phoneNumber = data['PhoneNumber'];
        dateOfBirth = data["Date of Birth"];
        profileImageURL = data["Profile Image URL"];
        citizenshipNumber = data["Citizenship Number"];
        citizenshipImageURL = data["Citizenhip ImageURL"];
        citizenshipIssuedDate = data["Citizenhip Issued Date"];
        printall();
        return data;
      } else {
        // Document does not exist
        return null;
      }
    } catch (e) {
      print("Error retrieving user details from Firebase: $e");
      return null;
    }
  }
}
