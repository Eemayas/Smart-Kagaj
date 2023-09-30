// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:smart_kagaj/pages/dashboard_page.dart';
import '../commonWidgets/animated_button.dart';
import '../commonWidgets/documents_card.dart';
import '../commonWidgets/greeting_card.dart';
import '../constant/colors.dart';
import '../constant/fonts.dart';
import '../database/documents.dart';

class DocumentListPage extends StatefulWidget {
  const DocumentListPage({super.key});
  static String id = 'DocumentListPage_id';

  @override
  State<DocumentListPage> createState() => _DocumentListPageState();
}

class _DocumentListPageState extends State<DocumentListPage> {
  User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    DocumentDB.clear();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundColorAppBar,
          title: Text(
            "Documents",
            style: kwhiteTextStyle,
          ),
          actions: [
            IconButton(icon: Icon(Icons.more_vert), onPressed: () => {}),
          ],
        ),
        floatingActionButton: RiveAnimatedBtn(
          iconData: Icon(
            Icons.create_new_folder,
            color: Colors.black,
          ),
          label: 'Add Document',
          onTap: () async {
            final result = await showCreateDialog(context: context, user: user);
            if (result != null) {
              DocumentDB.documentsNameList.add(result);
              setState(() {});
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GreetingUser(userName: DashboardPage.userName),
              SizedBox(
                height: 20,
              ),
              Text(
                "Documents",
                style: kwhiteTextStyle.copyWith(fontSize: 20),
              ),
              FutureBuilder<List<String>>(
                future: DocumentDB.fetchDocumentListFromFirestore(
                    userUid:
                        user.uid), // Replace with your data fetching function
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    EasyLoading.show(
                      dismissOnTap: true,
                      status: 'Processing...',
                      maskType: EasyLoadingMaskType.black,
                    );
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Handle any errors that occur during data fetching.
                    return Text('Error: ${snapshot.error}');
                  } else {
                    EasyLoading.dismiss();

                    // Data has been successfully fetched, you can build your GridView.
                    print(snapshot);
                    // final documentNames = snapshot.data ?? [];
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: DocumentDB.documentsNameList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return DocumentsCards(
                          onDelete: () async {
                            if (await DocumentDB.deleteDocumentFromFirestore(
                                userUid: user.uid,
                                dataToDelete:
                                    DocumentDB.documentsNameList[i])) {
                              setState(() {});
                            }
                          },
                          onEdit: () async {
                            final result = await showCreateDialog(
                                context: context,
                                user: user,
                                text: DocumentDB.documentsNameList[i]);
                            if (result != null) {
                              DocumentDB.documentsNameList.add(result);
                              setState(() {});
                              // Now, you can trigger a UI update here if needed.
                              // You may not need to do anything here if the UI automatically reflects the changes.
                            }
                          },
                          documentName: DocumentDB.documentsNameList[i],
                        );
                      },
                    );
                  }
                },
              ),
              SizedBox(
                height: 100,
              )
            ]),
          )),
        ));
  }
}

Future<String?> showCreateDialog(
    {required BuildContext context, required user, text = ""}) async {
  final contractNameController = TextEditingController();
  contractNameController.text = text;
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Create Folder'),
        content: TextField(
          controller: contractNameController,
          decoration: InputDecoration(
            hintText: 'Enter something',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(text == "" ? 'Create' : "Edit"),
            onPressed: () async {
              if (contractNameController.text.isNotEmpty) {
                if (text == "" &&
                    await DocumentDB.addDocumentToListInFirestore(
                        userUid: user.uid,
                        context: context,
                        newDocument: contractNameController.text)) {
                  DocumentDB.newDocumentName = contractNameController.text;
                  Navigator.of(context).pop(contractNameController.text);
                }
                if (text != "" &&
                    await DocumentDB.editDocumentInFirestore(
                        userUid: user.uid,
                        context: context,
                        oldDocument: text,
                        newDocument: contractNameController.text)) {
                  DocumentDB.newDocumentName = contractNameController.text;
                  Navigator.of(context).pop(contractNameController.text);
                }
              }
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
        ],
      );
    },
  );
}
