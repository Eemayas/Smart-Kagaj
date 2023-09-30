// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDB {
  static List adminNameList = [];
  // static String? newContractName;

  static Future<bool> addAdminToListInFirestore(
      {required String newAdminUser, required BuildContext context}) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance.collection('Admin_list');

      // Fetch the current list from Firestore
      final documentSnapshot = await collectionReference.doc('AdminList').get();
      final List<dynamic> currentList =
          documentSnapshot.data()?['adminNameList'] ?? [];
      // Append the new data
      currentList.add(newAdminUser);
      adminNameList = currentList;
      // Update the list in Firestore
      await collectionReference.doc('AdminList').update({
        'adminNameList': currentList,
      });
      return true;
    } catch (e) {
      print('Error adding data to Firestore list: $e');
      return false;
    }
  }

  static Future<List<String>> fetchAdminListFromFirestore() async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance.collection('Admin_list');

      // Fetch the current list from Firestore
      final documentSnapshot = await collectionReference.doc('AdminList').get();

      if (documentSnapshot.exists) {
        final List<String> listContract =
            documentSnapshot.data()?['adminNameList'].cast<String>() ?? [];

        adminNameList = listContract;
        print(listContract);
        print(adminNameList);
        return listContract;
      } else {
        print("Admin does not exist.");
        initializeDataInFirestore();
        return [];
      }
    } catch (e) {
      print('Error fetching data from Firestore: $e');
      return [];
    }
  }

  static Future<bool> deleteContractFromFirestore(
      {required String dataToDelete}) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance.collection('Admin_list');

      // Fetch the current list from Firestore
      final documentSnapshot = await collectionReference.doc('AdminList').get();
      final List<dynamic> currentList =
          documentSnapshot.data()?['adminNameList'] ?? [];

      // Remove the data to delete from the list
      currentList.remove(dataToDelete);
      adminNameList = currentList;
      // Update the list in Firestore
      await collectionReference.doc('AdminList').update({
        'adminNameList': currentList,
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
      final collectionReference = firestoreInstance.collection('Admin_list');

      // Fetch the current list from Firestore
      final documentSnapshot = await collectionReference.doc('AdminList').get();
      final List<dynamic> currentList =
          documentSnapshot.data()?['adminNameList'] ?? [];

      // Find the index of the old data to edit
      final int index = currentList.indexOf(oldContract);

      if (index != -1) {
        // Update the data at the specified index
        currentList[index] = newContract;

        // Update the list in Firestore
        await collectionReference.doc('AdminList').update({
          'adminNameList': currentList,
        });
      } else {
        print("Contract not found in the list.");
      }
    } catch (e) {
      print('Error editing data in Firestore list: $e');
    }
  }

  static Future<void> initializeDataInFirestore() async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance.collection('Admin_list');

      // Set the initial data in Firestore
      await collectionReference.doc('AdminList').set({
        'adminNameList': [],
      });
    } catch (e) {
      print('Error initializing data in Firestore: $e');
    }
  }
}
