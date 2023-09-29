// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../commonWidgets/greeting_card.dart';
import '../commonWidgets/notice_card.dart';

import '../constant/data.dart';
import '../constant/fonts.dart';
import 'dashboard_page.dart';

class NoticeListPage extends StatelessWidget {
  const NoticeListPage({super.key});
  static String userName = "Prashant";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      GreetingUser(userName: DashboardPage.userName),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Notices..",
                        style: kwhiteTextStyle.copyWith(fontSize: 25),
                      ),
                      for (int i = 0; i < noticeList.length; i++)
                        NoticeCard(
                          noticeTitle: noticeList[i]["noticeTitle"],
                          noticeURL: noticeList[i]["noticeURL"],
                          publishedDate: noticeList[i]["publishedDate"],
                          noticeDescription: noticeList[i]["noticeDescription"],
                          noticePublishedBy: noticeList[i]["noticePublishedBy"],
                          noticeImgURL: noticeList[i]["noticeImgURL"],
                        ),
                      SizedBox(
                        height: 20,
                      ),
                    ]),
              )),
            ],
          ),
        ));
  }
}
