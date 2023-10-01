// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smart_kagaj/pages/qr_generator.dart';

import '../Provider/provider.dart';
import '../commonWidgets/animated_button.dart';
import '../commonWidgets/custom_button.dart';
import '../commonWidgets/custom_snackbar.dart';
import '../commonWidgets/smooth_navigation.dart';
import '../commonWidgets/uploadImageToFirebase.dart';
import '../constant/colors.dart';
import '../constant/fonts.dart';
import '../database/documentImages.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({super.key, required this.documentName});
  static String id = 'DocumentPage_id';
  final String documentName;

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  User user = FirebaseAuth.instance.currentUser!;
  // List imgURLList = [
  //   'https://assets-api.kathmandupost.com/thumb.php?src=https://assets-cdn.kathmandupost.com/uploads/source/news/2023/third-party/WhatsAppImage20230920at60220PM-1695216938.jpg&w=900&height=601',
  //   'https://assets-api.kathmandupost.com/thumb.php?src=https://assets-cdn.kathmandupost.com/uploads/source/news/2023/third-party/WhatsAppImage20230920at60220PM-1695216938.jpg&w=900&height=601',
  //   'https://assets-api.kathmandupost.com/thumb.php?src=https://assets-cdn.kathmandupost.com/uploads/source/news/2023/third-party/WhatsAppImage20230920at60220PM-1695216938.jpg&w=900&height=601',
  //   'https://assets-api.kathmandupost.com/thumb.php?src=https://assets-cdn.kathmandupost.com/uploads/source/news/2023/third-party/WhatsAppImage20230920at60220PM-1695216938.jpg&w=900&height=601'
  // ];

  File? _selectedImage;
  Uint8List? _image;
  Future<bool> _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return false;
      final imageTemp = File(image.path);
      setState(() {
        _selectedImage = imageTemp;
        DocumentImageListDB.newDocumentImageName = imageTemp;
      });

      if (_selectedImage != null) {
        Uint8List imageBytes = await _selectedImage!.readAsBytes();
        _image = imageBytes;
        return await _uploadImage() ? true : false;
        // return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Failed to pick image: $e');
      return false;
    }
  }

  Future<bool> _uploadImage() async {
    try {
      String userId = user.uid;
      String? imageUrl = await uploadImageToFirebase(_image!, userId,
          "Documents/${widget.documentName}_${DocumentImageListDB.documentImagesNameList.length}");
      print(imageUrl);
      if (imageUrl != null) {
        DocumentImageListDB.newDocumentImageUrl = imageUrl;
        DocumentImageListDB.addDocumentImageToListInFirestore(
            documentName: widget.documentName,
            newDocumentImageUrl: imageUrl,
            userUid: user.uid,
            context: context);
        return true;
      } else {
        print("Error: Image URL is null");
        customSnackbar(context: context, text: "Error: Image URL is null");
        return false;
      }
    } catch (e) {
      print("ERROR UPLOADING DOCUMENT : $e");
      customSnackbar(
          context: context, text: "ERROR UPLOADING PROFILE IMAGE : $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<ChangedMsg>().result == "changed") {
      setState(() {});
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColorAppBar,
        title: Text(
          widget.documentName,
          style: kwhiteTextStyle,
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () => {}),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            FutureBuilder<List<String>>(
              future: DocumentImageListDB.fetchDocumentImageListFromFirestore(
                  documentName: widget.documentName,
                  userUid:
                      user.uid), // Replace with your data fetching function
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  EasyLoading.show(
                    dismissOnTap: true,
                    status: 'Processing...',
                    maskType: EasyLoadingMaskType.black,
                  );
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  EasyLoading.dismiss();
                  print(snapshot);
                  final documentNames = snapshot.data ?? [];
                  print(documentNames);
                  print(DocumentImageListDB.documentImagesNameList);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: documentNames.length,
                    // DocumentImageListDB.documentImagesNameList.length,
                    itemBuilder: (BuildContext context, int i) {
                      return ImageViewer(
                          // key: DocumentImageListDB.documentImagesNameList[i],
                          onDelete: () async {
                            if (await DocumentImageListDB
                                .deleteDocumentImageFromFirestore(
                                    documentName: widget.documentName,
                                    userUid: user.uid,
                                    dataToDelete: DocumentImageListDB
                                        .documentImagesNameList[i])) {
                              setState(() {});
                            }
                          },
                          user: user,
                          imgURL: documentNames[i]
                          // DocumentImageListDB.documentImagesNameList[i]
                          );
                    },
                  );
                }
              },
            ),
            RiveAnimatedBtn(
              label: "Add More Document",
              onTap: () async {
                EasyLoading.show(
                  status: 'Processing...',
                  maskType: EasyLoadingMaskType.black,
                );
                if (await _pickImage()) {
                  setState(() {});
                }
                EasyLoading.dismiss();
              },
              iconData: const Icon(
                Icons.note_add_outlined,
                color: Colors.black,
              ),
            ),
          ]),
        )),
      ),
    );
  }
}

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    super.key,
    required this.imgURL,
    required this.user,
    required this.onDelete,
  });
  final Function onDelete;
  final User user;
  final String imgURL;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 15),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0, // Border width
                      ),
                    ),
                    child: Container()),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(imgURL), // Replace with your image URL
                    fit: BoxFit.cover, // You can adjust the fit as needed
                  ),
                ),
                // child: CachedNetworkImage(
                //   imageUrl: imgURL,
                //   placeholder: (context, url) => CircularProgressIndicator(),
                //   errorWidget: (context, url, error) => Icon(Icons.error),
                // ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              children: [
                CustomProgressButton(
                  label: Text(
                    "Delete",
                    style: kwhiteTextStyle,
                  ),
                  icons: const Icon(Icons.delete_forever),
                  onTap: () {
                    onDelete();
                  },
                ),
                CustomProgressButton(
                  label: Text(
                    "Share",
                    style: kwhiteTextStyle,
                  ),
                  icons: const Icon(Icons.share),
                  onTap: () {
                    Navigator.of(context).push(SmoothSlidePageRoute(
                        page: QRGeneratorPage(
                      imageUrl: imgURL,
                    )));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// void _showCreateDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       // Return an AlertDialog with a TextField and a Create button
//       return AlertDialog(
//         title: const Text('Create Something'),
//         content: const TextField(
//           decoration: InputDecoration(
//             hintText: 'Enter something',
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('Create'),
//             onPressed: () {
//               // Handle the "Create" button press here
//               Navigator.of(context).pop(); // Close the dialog
//             },
//           ),
//           TextButton(
//             child: const Text('Cancel'),
//             onPressed: () {
//               Navigator.of(context).pop(); // Close the dialog
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
