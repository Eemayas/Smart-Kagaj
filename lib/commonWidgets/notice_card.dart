import 'package:flutter/material.dart';
import 'package:smart_kagaj/commonWidgets/animated_button.dart';

import '../constant/colors.dart';
import '../constant/fonts.dart';
import '../pages/notice_page.dart';
import 'smooth_navigation.dart';

class NoticeCard extends StatelessWidget {
  final String noticeTitle;
  final String noticeDescription;
  final String noticeImgURL;
  final String noticePublishedBy;
  final String noticeURL;
  final bool isDashBoard;
  final String publishedDate;
  const NoticeCard({
    super.key,
    required this.noticeTitle,
    required this.noticeDescription,
    required this.noticeImgURL,
    required this.noticePublishedBy,
    required this.noticeURL,
    required this.publishedDate,
    this.isDashBoard = false,
  });

  @override
  Widget build(BuildContext context) {
    Color boxShadowColor = kBoxShadowGreen;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: 200,
        decoration: BoxDecoration(
          color: const Color(0xff191928),
          border: Border.all(color: Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(
              color: boxShadowColor,
              offset: const Offset(6, 6),
              blurRadius: 3,
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(
                            noticeImgURL), // Replace with your image URL
                        fit: BoxFit.cover, // You can adjust the fit as needed
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(noticeTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: kwhiteTextStyle.copyWith(
                                fontSize: 15, fontWeight: FontWeight.w300)),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Published By-$noticePublishedBy",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: kwhiteTextStyle.copyWith(
                                fontSize: 10, fontWeight: FontWeight.w300)),
                        Text("Published At-$publishedDate",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: kwhitesubTextStyle.copyWith(
                                fontSize: 10, fontWeight: FontWeight.w300)),
                        const SizedBox(
                          height: 5,
                        ),
                        Text("Description:",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: kwhitesubTextStyle.copyWith(
                                fontSize: 10, fontWeight: FontWeight.w300)),
                        Text(noticeDescription,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: kwhitesubTextStyle.copyWith(
                                fontSize: 10, fontWeight: FontWeight.w300)),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  const Divider(
                    thickness: 2,
                    color: Color.fromARGB(255, 135, 135, 135),
                  ),
                  RiveAnimatedBtn(
                    label: "Read More",
                    onTap: () {
                      Navigator.of(context).push(SmoothSlidePageRoute(
                          page: NoticePage(
                        noticeDescription: noticeDescription,
                        noticeImgURL: noticeImgURL,
                        noticePublishedBy: noticePublishedBy,
                        noticeTitle: noticeTitle,
                        noticeURL: noticeURL,
                        publishedDate: publishedDate,
                      )));
                    },
                    iconData:
                        const Icon(Icons.arrow_right_alt, color: Colors.black),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
