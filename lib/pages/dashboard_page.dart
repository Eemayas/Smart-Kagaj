import 'package:flutter/material.dart';
import 'package:smart_kagaj/commonWidgets/animated_button.dart';
import 'package:smart_kagaj/commonWidgets/documents_card.dart';
import '../commonWidgets/greeting_card.dart';
import '../commonWidgets/notice_card.dart';
import '../constant/colors.dart';
import '../constant/data.dart';
import '../constant/fonts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  static String userName = "Prashants";

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
              DocumentsCards(
                onDelete: () {},
                onEdit: () {},
                documentName: "Citizenship",
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
                          // Navigator.of(context).push(
                          //     SmoothSlidePageRoute(page: DocumentListPage()));
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
