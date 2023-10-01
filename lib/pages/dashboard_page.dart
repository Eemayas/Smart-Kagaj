import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smart_kagaj/commonWidgets/animated_button.dart';
import 'package:smart_kagaj/commonWidgets/documents_card.dart';
import 'package:smart_kagaj/database/firebase.dart';
import 'package:smart_kagaj/pages/nav_drawer.dart';
import '../commonWidgets/greeting_card.dart';
import '../commonWidgets/notice_card.dart';
import '../commonWidgets/smooth_navigation.dart';
import '../constant/colors.dart';
import '../constant/data.dart';
import '../constant/fonts.dart';
import '../database/documents.dart';
import 'documen_list_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  static String userName = FirebaseDB.userName ?? "User";

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  User user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    EasyLoading.show(
      dismissOnTap: true,
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    FirebaseDB.retrievePersonalDetail(userUid: user.uid);
    EasyLoading.dismiss();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundColorAppBar,
          title: Text(
            "Dashboard",
            style: kwhiteTextStyle,
          ),
          actions: [
            IconButton(icon: const Icon(Icons.more_vert), onPressed: () => {}),
          ],
        ),
        drawer: const NavDrawer(),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GreetingUser(userName: DashboardPage.userName),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Notices..",
                style: kwhiteTextStyle.copyWith(fontSize: 20),
              ),
              NoticeCard(
                noticeTitle: noticeList[0]["noticeTitle"],
                noticeURL: noticeList[0]["noticeURL"],
                publishedDate: noticeList[0]["publishedDate"],
                noticeDescription: noticeList[0]["noticeDescription"],
                noticePublishedBy: noticeList[0]["noticePublishedBy"],
                noticeImgURL: noticeList[0]["noticeImgURL"],
                isDashBoard: true,
              ),
              const SizedBox(
                height: 30,
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
                    return const CircularProgressIndicator();
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
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: DocumentDB.documentsNameList.length > 4
                          ? 4
                          : DocumentDB.documentsNameList.length,
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 30),
                    child: RiveAnimatedBtn(
                      label: "View more documents",
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 800),
                            () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.of(context).push(SmoothSlidePageRoute(
                              page: const DocumentListPage()));
                        });
                      },
                      iconData: const Icon(
                        Icons.arrow_right_alt,
                        color: Colors.black,
                      ),
                    )),
              ),
            ]),
          )),
        ));
  }
}
