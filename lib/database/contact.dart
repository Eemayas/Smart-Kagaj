// ignore_for_file: use_build_context_synchronously, avoid_print, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_kagaj/utils/constants.dart';

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
  static List? Signers;
  static List? contractsHashess;
  static List ContractDetail = [
    {
      "date": ContractDB.date,
      "contractName": ContractDB.contractName,
      "contractDescription": ContractDB.contractDescription,
      "contractContent": ContractDB.contractContent,
      "contractTermsAndCondition": ContractDB.contractTermsAndCondition,
      "contractTotalSigners": ContractDB.contractTotalSigners,
      "contractAuthName": ContractDB.contractAuthName,
      "contractAuthHash": ContractDB.contractAuthHash,
      "contractAddress": ContractAddress,
      "Signers": Signers
    }
  ];
  static void printall() {
    print(
        "dateController:$date\ncontractNameController:$contractName\ncontractDescriptionController:$contractDescription}\ncontractContentController:$contractContent\ncontractTermsAndConditionController:$contractTermsAndCondition\ncontractTotalSignersController:$contractTotalSigners\ncontractAuthNameController:$contractAuthName \n contractAuthHashController: $contractAuthHash");
  }

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> addcontractToListInFirestore(
      {required Map<String, dynamic> contractData,
      contractAddress,
      required BuildContext context}) async {
    try {
      await FirebaseFirestore.instance
          .collection("Contract_List")
          .doc(contractAddress)
          .set(contractData);
      print("Contact Details added to Firebase");
      customSnackbar(
        context: context,
        icons: Icons.done_all,
        iconsColor: Colors.green,
        text: "Contract Details added to Firebase",
      );
      return true;
    } catch (e) {
      print("Error Adding Contract Details to Firebase : $e");
      customSnackbar(
        context: context,
        text: "Error Adding Contract Details to Firebase : $e",
      );
      return false;
    }
  }

  static Future<bool> addContractHashToFirestore({
    required String contractHash,
    required BuildContext context,
  }) async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection("Contract_hash").doc();

      await docRef.set({'contractHash': contractHash});

      print("Contract Hash added to Firebase with document ID: ${docRef.id}");
      customSnackbar(
        context: context,
        icons: Icons.done_all,
        iconsColor: Colors.green,
        text: "Contract Hash added to Firebase",
      );
      return true;
    } catch (e) {
      print("Error Adding Contract Hash to Firebase: $e");
      customSnackbar(
        context: context,
        text: "Error Adding Contract Hash to Firebase: $e",
      );
      return false;
    }
  }

  static Future<bool> editContractInFirestore({
    required Map<String, dynamic> updatedContractData,
    required String contractAddress,
    required BuildContext context,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("Contract_List")
          .doc(contractAddress)
          .update(updatedContractData);
      print("Contract Details updated in Firebase");
      customSnackbar(
        context: context,
        icons: Icons.done_all,
        iconsColor: Colors.green,
        text: "Contract Details updated in Firebase",
      );
      return true;
    } catch (e) {
      print("Error updating Contract Details in Firebase : $e");
      customSnackbar(
        context: context,
        text: "Error updating Contract Details in Firebase : $e",
      );
      return false;
    }
  }

  static Future<bool> deleteContractInFirestore({
    required String contractAddress,
    required BuildContext context,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("Contract_List")
          .doc(contractAddress)
          .delete();
      print("Contract Details deleted from Firebase");
      customSnackbar(
        context: context,
        icons: Icons.done_all,
        iconsColor: Colors.red,
        text: "Contract Details deleted from Firebase",
      );
      return true;
    } catch (e) {
      print("Error deleting Contract Details from Firebase : $e");
      customSnackbar(
        context: context,
        text: "Error deleting Contract Details from Firebase : $e",
      );
      return false;
    }
  }

  static Future<bool> deleteContractHashFromFirestore(
      String documentId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection("Contract_hash")
          .doc(documentId)
          .delete();

      print("Contract Hash deleted from Firebase: $documentId");
      customSnackbar(
        context: context,
        icons: Icons.done_all,
        iconsColor: Colors.green,
        text: "Contract Hash deleted from Firebase",
      );
      return true;
    } catch (e) {
      print("Error Deleting Contract Hash from Firebase: $e");
      customSnackbar(
        context: context,
        text: "Error Deleting Contract Hash from Firebase: $e",
      );
      return false;
    }
  }

  static Future<Map<String, dynamic>?> fetchContractFromFirestore({
    required BuildContext context,
    required String contractAddress,
  }) async {
    try {
      final DocumentSnapshot contractSnapshot = await FirebaseFirestore.instance
          .collection("Contract_List")
          .doc(contractAddress)
          .get();

      if (contractSnapshot.exists) {
        Map<String, dynamic> data =
            contractSnapshot.data() as Map<String, dynamic>;

        date = data["date"];
        contractName = data["contractName"];
        contractDescription = data["contractDescription"];
        contractContent = data["contractContent"];
        contractTermsAndCondition = data["contractTermsAndCondition"];
        contractTotalSigners = data["contractTotalSigners"];
        contractAuthName = data["contractAuthName"];
        contractAuthHash = data["contractAuthHash"];
        Signers = data["Signers"];
        printall();
        return contractSnapshot.data() as Map<String, dynamic>?;
      } else {
        customSnackbar(
          context: context,
          text: "Error fetching Contract Details from Firebase",
        );
        return null;
      }
    } catch (e) {
      customSnackbar(
        context: context,
        text: "Error fetching Contract Details from Firebase: $e",
      );
      print("Error fetching Contract Details from Firebase: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllContractHashes() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("Contract_hash").get();

      List<Map<String, dynamic>> contractHashes = [];

      querySnapshot.docs.forEach((doc) {
        // Convert each document to a Map and add it to the list
        contractHashes.add(doc.data() as Map<String, dynamic>);
      });
      contractsHashess = contractsHashess;
      return contractHashes;
    } catch (e) {
      print("Error fetching Contract Hashes from Firebase: $e");
      return [];
    }
  }
}
