// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DocumentImageListDB {
  static List documentImagesNameList = [];
  static File? newDocumentImageName;
  static String? newDocumentImageUrl;

  static Future<bool> addDocumentImageToListInFirestore(
      {required String newDocumentImageUrl,
      required String documentName,
      required userUid,
      required BuildContext context}) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance
          .collection('DocumentImages_list')
          .doc(userUid)
          .collection(documentName);

      // Fetch the current list from Firestore
      final DocumentImageSnapshot =
          await collectionReference.doc('myDocumentImage').get();
      final List<dynamic> currentList =
          DocumentImageSnapshot.data()?['DocumentImagesNameList'] ?? [];

      // Append the new data
      currentList.add(newDocumentImageUrl);
      documentImagesNameList = currentList;
      // Update the list in Firestore
      await collectionReference.doc('myDocumentImage').update({
        'DocumentImagesNameList': currentList,
      });
      return true;
    } catch (e) {
      print('Error adding data to Firestore list: $e');
      return false;
    }
  }

  static Future<List<String>> fetchDocumentImageListFromFirestore({
    required userUid,
    required String documentName,
  }) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance
          .collection('DocumentImages_list')
          .doc(userUid)
          .collection(documentName);

      // Fetch the current list from Firestore
      final DocumentImageSnapshot =
          await collectionReference.doc('myDocumentImage').get();

      if (DocumentImageSnapshot.exists) {
        final List<String> listDocumentImage =
            DocumentImageSnapshot.data()?['DocumentImagesNameList']
                    .cast<String>() ??
                [];

        documentImagesNameList = listDocumentImage;
        print(listDocumentImage);
        print(documentImagesNameList);
        return listDocumentImage;
      } else {
        print("DocumentImage does not exist.");
        initializeDataInFirestore(userUid: userUid, documentName: documentName);
        return [];
      }
    } catch (e) {
      print('Error fetching data from Firestore: $e');
      return [];
    }
  }

  static Future<bool> deleteDocumentImageFromFirestore({
    required userUid,
    required String dataToDelete,
    required String documentName,
  }) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance
          .collection('DocumentImages_list')
          .doc(userUid)
          .collection(documentName);

      // Fetch the current list from Firestore
      final DocumentImageSnapshot =
          await collectionReference.doc('myDocumentImage').get();
      final List<dynamic> currentList =
          DocumentImageSnapshot.data()?['DocumentImagesNameList'] ?? [];

      // Remove the data to delete from the list
      currentList.remove(dataToDelete);
      documentImagesNameList = currentList;
      // Update the list in Firestore
      await collectionReference.doc('myDocumentImage').update({
        'DocumentImagesNameList': currentList,
      });
      return true;
    } catch (e) {
      print('Error deleting data from Firestore list: $e');
      return false;
    }
  }

  static Future<void> editDocumentImageInFirestore({
    required String userUid,
    required String documentName,
    required String newDocumentImage,
    required String oldDocumentImage,
  }) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance
          .collection('DocumentImages_list')
          .doc(userUid)
          .collection(documentName);

      // Fetch the current list from Firestore
      final DocumentImageSnapshot =
          await collectionReference.doc('myDocumentImage').get();
      final List<dynamic> currentList =
          DocumentImageSnapshot.data()?['DocumentImagesNameList'] ?? [];

      // Find the index of the old data to edit
      final int index = currentList.indexOf(oldDocumentImage);

      if (index != -1) {
        // Update the data at the specified index
        currentList[index] = newDocumentImage;

        // Update the list in Firestore
        await collectionReference.doc('myDocumentImage').update({
          'DocumentImagesNameList': currentList,
        });
      } else {
        print("DocumentImage not found in the list.");
      }
    } catch (e) {
      print('Error editing data in Firestore list: $e');
    }
  }

  static Future<void> initializeDataInFirestore({
    required String documentName,
    required String userUid,
  }) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance
          .collection('DocumentImages_list')
          .doc(userUid)
          .collection(documentName);

      // Set the initial data in Firestore
      await collectionReference.doc('myDocumentImage').set({
        'DocumentImagesNameList': [],
      });
    } catch (e) {
      print('Error initializing data in Firestore: $e');
    }
  }
}
