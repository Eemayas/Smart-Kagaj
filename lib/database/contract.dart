// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContractDB {
  static List contractsNameList = [];
  static String? newContractName;

  static Future<bool> addContractToListInFirestore(
      {required String newContract,
      required userUid,
      required BuildContext context}) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance
          .collection('Contracts_list')
          .doc(userUid)
          .collection(userUid);

      // Fetch the current list from Firestore
      final documentSnapshot =
          await collectionReference.doc('myContract').get();
      final List<dynamic> currentList =
          documentSnapshot.data()?['contractsNameList'] ?? [];
      // Append the new data
      currentList.add(newContract);
      contractsNameList = currentList;
      // Update the list in Firestore
      await collectionReference.doc('myContract').update({
        'contractsNameList': currentList,
      });
      return true;
    } catch (e) {
      print('Error adding data to Firestore list: $e');
      return false;
    }
  }

  static Future<List<String>> fetchContractListFromFirestore(
      {required userUid}) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance
          .collection('Contracts_list')
          .doc(userUid)
          .collection(userUid);

      // Fetch the current list from Firestore
      final documentSnapshot =
          await collectionReference.doc('myContract').get();

      if (documentSnapshot.exists) {
        final List<String> listContract =
            documentSnapshot.data()?['contractsNameList'].cast<String>() ?? [];

        contractsNameList = listContract;
        print(listContract);
        print(contractsNameList);
        return listContract;
      } else {
        print("Contract does not exist.");
        initializeDataInFirestore(userUid: userUid);
        return [];
      }
    } catch (e) {
      print('Error fetching data from Firestore: $e');
      return [];
    }
  }

  static Future<bool> deleteContractFromFirestore(
      {required userUid, required String dataToDelete}) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance
          .collection('Contracts_list')
          .doc(userUid)
          .collection(userUid);

      // Fetch the current list from Firestore
      final documentSnapshot =
          await collectionReference.doc('myContract').get();
      final List<dynamic> currentList =
          documentSnapshot.data()?['contractsNameList'] ?? [];

      // Remove the data to delete from the list
      currentList.remove(dataToDelete);
      contractsNameList = currentList;
      // Update the list in Firestore
      await collectionReference.doc('myContract').update({
        'contractsNameList': currentList,
      });
      return true;
    } catch (e) {
      print('Error deleting data from Firestore list: $e');
      return false;
    }
  }

  static Future<void> editContractInFirestore({
    required String userUid,
    required String newContract,
    required String oldContract,
  }) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance
          .collection('Contracts_list')
          .doc(userUid)
          .collection(userUid);

      // Fetch the current list from Firestore
      final documentSnapshot =
          await collectionReference.doc('myContract').get();
      final List<dynamic> currentList =
          documentSnapshot.data()?['contractsNameList'] ?? [];

      // Find the index of the old data to edit
      final int index = currentList.indexOf(oldContract);

      if (index != -1) {
        // Update the data at the specified index
        currentList[index] = newContract;

        // Update the list in Firestore
        await collectionReference.doc('myContract').update({
          'contractsNameList': currentList,
        });
      } else {
        print("Contract not found in the list.");
      }
    } catch (e) {
      print('Error editing data in Firestore list: $e');
    }
  }

  static Future<void> initializeDataInFirestore({
    required String userUid,
  }) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance
          .collection('Contracts_list')
          .doc(userUid)
          .collection(userUid);

      // Set the initial data in Firestore
      await collectionReference.doc('myContract').set({
        'contractsNameList': [],
      });
    } catch (e) {
      print('Error initializing data in Firestore: $e');
    }
  }
}
