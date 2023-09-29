import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadImageToFirebase(
    Uint8List imageBytes, String userId, String childName) async {
  String imageUrl = "";
  try {
    // Reference storageRef =
    //     FirebaseStorage.instance.ref().child('images/$childName').child(userId);
    Reference storageRef =
        FirebaseStorage.instance.ref().child(childName).child(userId);
    UploadTask uploadTask = storageRef.putData(imageBytes);
    TaskSnapshot snapshot = await uploadTask;

    imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  } catch (e) {
    print("Error uploading image to storage : $e ");
  }
  return imageUrl;
}
