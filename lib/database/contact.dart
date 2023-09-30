// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../commonWidgets/custom_snackbar.dart';

class ContractDB {
  static String? date;
  static String? contractName;
  static String? contractDescription;
  static String? contractContent;
  static String? contractTermsAndCondition;
  static String? contractTotalSigners;
  static String? contractAuthName;
  static String? contractAuthHash;
  static List ContractList = [];
  static void printall() {
    print(
        "dateController:$date\ncontractNameController:$contractName\ncontractDescriptionController:$contractDescription}\ncontractContentController:$contractContent\ncontractTermsAndConditionController:$contractTermsAndCondition\ncontractTotalSignersController:$contractTotalSigners\ncontractAuthNameController:$contractAuthName \n contractAuthHashController: $contractAuthHash");
  }

  // static Future<bool> addDocumentImageToListInFirestore(
  //     { required Map contractDeatils,
  //     required BuildContext context}) async {
  //   try {
  //     final firestoreInstance = FirebaseFirestore.instance;
  //     final collectionReference = firestoreInstance
  //         .collection('Contract_list')
  //     // Fetch the current list from Firestore
  //     final DocumentImageSnapshot =
  //         await collectionReference.doc('myContracts').get();
  //     final List<dynamic> currentList =
  //         DocumentImageSnapshot.data()?['Contact_List'] ?? [];
  //     // Append the new data
  //     currentList.add(newDocumentImageUrl);
  //     documentImagesNameList = currentList;
  //     // Update the list in Firestore
  //     await collectionReference.doc('myDocumentImage').update({
  //       'DocumentImagesNameList': currentList,
  //     });
  //     context.read<ChangedMsg>().changed();
  //     return true;
  //   } catch (e) {
  //     print('Error adding data to Firestore list: $e');
  //     return false;
  //   }
  // }

  // static Future<bool> uploadContractDetails(
  //     {required BuildContext context, required userUid}) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection("Contracts_Lists")
  //         .doc(userUid)
  //         .set({
  //       'Username': userName,
  //       'PhoneNumber': phoneNumber,
  //       "Date of Birth": dateOfBirth,
  //       "Profile Image URL": profileImageURL,
  //       "Citizenship Number": citizenshipNumber,
  //       "Citizenhip ImageURL": citizenshipImageURL,
  //       "Citizenhip Issued Date": citizenshipIssuedDate,
  //     });
  //     print("User Details added to Firebase");
  //     customSnackbar(
  //       context: context,
  //       icons: Icons.done_all,
  //       iconsColor: Colors.green,
  //       text: "User Details added to Firebase",
  //     );
  //     return true;
  //   } catch (e) {
  //     print("Error Adding user Details to Firebase : $e");
  //     customSnackbar(
  //       context: context,
  //       text: "Error Adding user Details to Firebase : $e",
  //     );
  //     return false;
  //   }
  // }

  // static Future<Map<String, dynamic>?> retrievePersonalDetail(
  //     {required String userUid}) async {
  //   try {
  //     DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //         .collection("Personal_Detail")
  //         .doc(userUid)
  //         .get();
  //     if (snapshot.exists) {
  //       // Convert the snapshot data to a Map and return it
  //       Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //       print(data);
  //       userName = data['Username'];
  //       phoneNumber = data['PhoneNumber'];
  //       dateOfBirth = data["Date of Birth"];
  //       profileImageURL = data["Profile Image URL"];
  //       citizenshipNumber = data["Citizenship Number"];
  //       citizenshipImageURL = data["Citizenhip ImageURL"];
  //       citizenshipIssuedDate = data["Citizenhip Issued Date"];
  //       printall();
  //       return data;
  //     } else {
  //       // Document does not exist
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error retrieving user details from Firebase: $e");
  //     return null;
  //   }
  // }
}

// import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a contract to Firestore
  static Future<void> addContract(Map<String, dynamic> contractData) async {
    await _firestore.collection('contracts').add(contractData);
  }

  // Fetch all contracts from Firestore
  static Stream<QuerySnapshot> getContracts() {
    print(_firestore.collection('contracts').snapshots());
    return _firestore.collection('contracts').snapshots();
  }

  // Update a contract in Firestore
  static Future<void> updateContract(
      String contractId, Map<String, dynamic> updatedData) async {
    await _firestore
        .collection('contracts')
        .doc(contractId)
        .update(updatedData);
  }

  // Delete a contract from Firestore
  static Future<void> deleteContract(String contractId) async {
    await _firestore.collection('contracts').doc(contractId).delete();
  }
}
