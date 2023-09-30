// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, unnecessary_null_comparison, unused_element

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../commonWidgets/animated_button.dart';
import '../commonWidgets/custom_button.dart';
import '../constant/fonts.dart';
import '../database/documentImages.dart';

class ContractPage extends StatefulWidget {
  const ContractPage({super.key, required this.documentName});
  static String id = 'DocumentPage_id';
  final String documentName;

  @override
  State<ContractPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<ContractPage> {
  User user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: () async {},
          icon: Icon(Icons.file_copy_outlined),
        ),
      ]),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(20.0),
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
                  return CircularProgressIndicator();
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
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 0.85,
                    ),
                    itemCount:
                        DocumentImageListDB.documentImagesNameList.length,
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
                          imgURL:
                              DocumentImageListDB.documentImagesNameList[i]);
                    },
                  );
                }
              },
            ),
            RiveAnimatedBtn(
              label: "Sign Contract",
              onTap: () async {
                EasyLoading.show(
                  status: 'Processing...',
                  maskType: EasyLoadingMaskType.black,
                );
                // if (await _pickImage()) {
                //   setState(() {});
                // }
                EasyLoading.dismiss();
              },
              iconData: Icon(
                Icons.note_add_outlined,
                color: Colors.black,
              ),
            ),
            RiveAnimatedBtn(
              label: "Edit Contracts",
              onTap: () async {
                EasyLoading.show(
                  status: 'Processing...',
                  maskType: EasyLoadingMaskType.black,
                );
                // if (await _pickImage()) {
                //   setState(() {});
                // }
                EasyLoading.dismiss();
              },
              iconData: Icon(
                Icons.note_add_outlined,
                color: Colors.black,
              ),
            ),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(100),
            //   child: DocumentImageListDB.newDocumentImageName != null
            //       ? Container(
            //           decoration: buildGradientBorder(),
            //           child: CircleAvatar(
            //             radius: 100, // Adjust the size as needed
            //             backgroundImage: FileImage(
            //                 DocumentImageListDB.newDocumentImageName!),
            //           ),
            //         )
            //       : Container(),
            // ),
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
            child: CustomProgressButton(
              label: Text(
                "Delete",
                style: kwhiteTextStyle,
              ),
              icons: Icon(Icons.delete_forever),
              onTap: () {
                onDelete();
              },
            ),
          )
        ],
      ),
    );
  }
}

void _showCreateDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Return an AlertDialog with a TextField and a Create button
      return AlertDialog(
        title: Text('Create Something'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter something',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Create'),
            onPressed: () {
              // Handle the "Create" button press here
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
