// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:smart_kagaj/database/contract.dart';
import 'package:smart_kagaj/pages/dashboard_page.dart';
import '../commonWidgets/animated_button.dart';
import '../commonWidgets/contact_card.dart';
import '../commonWidgets/greeting_card.dart';
import '../constant/colors.dart';
import '../constant/fonts.dart';
// import 'package:flutter/material.dart';

class ContractListPage extends StatefulWidget {
  const ContractListPage({super.key});
  static String id = 'DocumentListPage_id';

  @override
  State<ContractListPage> createState() => _ContractListPageState();
}

class _ContractListPageState extends State<ContractListPage> {
  User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundColorAppBar,
          title: Text(
            "Contracts",
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
          label: 'Add Contract',
          onTap: () async {
            final result = await showCreateDialog(context: context, user: user);
            if (result != null) {
              ContractDB.contractsNameList.add(result);
              setState(() {});
              // Now, you can trigger a UI update here if needed.
              // You may not need to do anything here if the UI automatically reflects the changes.
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
                "Contracts",
                style: kwhiteTextStyle.copyWith(fontSize: 20),
              ),
              FutureBuilder<List<String>>(
                future: ContractDB.fetchContractListFromFirestore(
                    userUid: user.uid),
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
                    // final contractsNames = snapshot.data ?? [];
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 0.99,
                      ),
                      itemCount: ContractDB.contractsNameList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return ContractCards(
                          onDelete: () async {
                            if (await ContractDB.deleteContractFromFirestore(
                                userUid: user.uid,
                                dataToDelete:
                                    ContractDB.contractsNameList[i])) {
                              setState(() {});
                            }
                          },
                          onEdit: () async {
                            final result = await showCreateDialog(
                                context: context,
                                user: user,
                                text: ContractDB.contractsNameList[i]);
                            if (result != null) {
                              ContractDB.contractsNameList.add(result);
                              setState(() {});
                              // Now, you can trigger a UI update here if needed.
                              // You may not need to do anything here if the UI automatically reflects the changes.
                            }
                          },
                          documentName: ContractDB.contractsNameList[i],
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
        title: Text('Create Contract'),
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
                if (await ContractDB.addContractToListInFirestore(
                    userUid: user.uid,
                    context: context,
                    newContract: contractNameController.text)) {
                  ContractDB.newContractName = contractNameController.text;
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
