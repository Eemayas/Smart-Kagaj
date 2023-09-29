// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../pages/user_detail_entry_page.dart';

class DocumentDB {
  static List documentsNameList = [];
  static String? newDocumentName;
  static List<Map<String, dynamic>> documentList = [
    {
      "icons": Image.asset(
        "assets/icons/document.png",
        color: Colors.green,
      ),
      "documentName": "Citizenship",
      "nextPage": const UserDetailEntryPage()
    },
    {
      "icons": Image.asset(
        "assets/icons/document.png",
        color: Colors.green,
      ),
      "documentName": "Citizenship",
      "nextPage": const UserDetailEntryPage()
    },
    {
      "icons": Image.asset(
        "assets/icons/document.png",
        color: Colors.green,
      ),
      "documentName": "Citizenship",
      "nextPage": const UserDetailEntryPage()
    },
    {
      "icons": Image.asset(
        "assets/icons/document.png",
        color: Colors.green,
      ),
      "documentName": "Citizenship",
      "nextPage": const UserDetailEntryPage()
    },
    {
      "icons": Image.asset(
        "assets/icons/document.png",
        color: Colors.green,
      ),
      "documentName": "Citizenship",
      "nextPage": const UserDetailEntryPage()
    },
    {
      "icons": Image.asset(
        "assets/icons/document.png",
        color: Colors.green,
      ),
      "documentName": "Citizenship",
      "nextPage": const UserDetailEntryPage()
    },
    {
      "icons": Image.asset(
        "assets/icons/document.png",
        color: Colors.green,
      ),
      "documentName": "Citizenship",
      "nextPage": const UserDetailEntryPage()
    },
  ];
  static void clear() {
    documentsNameList = [];
  }

  static Future<bool> addDocumentToListInFirestore(
      {required String newDocument,
      required userUid,
      required BuildContext context}) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance
          .collection('Documents_list')
          .doc(userUid)
          .collection(userUid);

      // Fetch the current list from Firestore
      final documentSnapshot =
          await collectionReference.doc('myDocument').get();
      final List<dynamic> currentList =
          documentSnapshot.data()?['documentsNameList'] ?? [];

      // Append the new data
      currentList.add(newDocument);
      documentsNameList = currentList;
      // Update the list in Firestore
      await collectionReference.doc('myDocument').update({
        'documentsNameList': currentList,
      });
      return true;
    } catch (e) {
      print('Error adding data to Firestore list: $e');
      return false;
    }
  }

  static Future<List<String>> fetchDocumentListFromFirestore(
      {required userUid}) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance
          .collection('Documents_list')
          .doc(userUid)
          .collection(userUid);

      // Fetch the current list from Firestore
      final documentSnapshot =
          await collectionReference.doc('myDocument').get();

      if (documentSnapshot.exists) {
        final List<String> listDocument =
            documentSnapshot.data()?['documentsNameList'].cast<String>() ?? [];

        documentsNameList = listDocument;
        print(listDocument);
        print(documentsNameList);
        return listDocument;
      } else {
        print("Document does not exist.");
        initializeDataInFirestore(userUid: userUid);
        return [];
      }
    } catch (e) {
      print('Error fetching data from Firestore: $e');
      return [];
    }
  }

  static Future<bool> deleteDocumentFromFirestore(
      {required userUid, required String dataToDelete}) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance
          .collection('Documents_list')
          .doc(userUid)
          .collection(userUid);

      // Fetch the current list from Firestore
      final documentSnapshot =
          await collectionReference.doc('myDocument').get();
      final List<dynamic> currentList =
          documentSnapshot.data()?['documentsNameList'] ?? [];

      // Remove the data to delete from the list
      currentList.remove(dataToDelete);
      documentsNameList = currentList;
      // Update the list in Firestore
      await collectionReference.doc('myDocument').update({
        'documentsNameList': currentList,
      });
      return true;
    } catch (e) {
      print('Error deleting data from Firestore list: $e');
      return false;
    }
  }

  static Future<void> editDocumentInFirestore({
    required String userUid,
    required String newDocument,
    required String oldDocument,
  }) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance
          .collection('Documents_list')
          .doc(userUid)
          .collection(userUid);

      // Fetch the current list from Firestore
      final documentSnapshot =
          await collectionReference.doc('myDocument').get();
      final List<dynamic> currentList =
          documentSnapshot.data()?['documentsNameList'] ?? [];

      // Find the index of the old data to edit
      final int index = currentList.indexOf(oldDocument);

      if (index != -1) {
        // Update the data at the specified index
        currentList[index] = newDocument;

        // Update the list in Firestore
        await collectionReference.doc('myDocument').update({
          'documentsNameList': currentList,
        });
      } else {
        print("Document not found in the list.");
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
          .collection('Documents_list')
          .doc(userUid)
          .collection(userUid);

      // Set the initial data in Firestore
      await collectionReference.doc('myDocument').set({
        'documentsNameList': [],
      });
    } catch (e) {
      print('Error initializing data in Firestore: $e');
    }
  }
}
