import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../commonWidgets/animated_button.dart';
import '../constant/colors.dart';
import '../constant/fonts.dart';

class NoticePage extends StatefulWidget {
  final String noticeTitle;
  final String noticeImgURL;
  final String noticeURL;
  final String noticeDescription;
  final String noticePublishedBy;
  final String publishedDate;
  const NoticePage(
      {super.key,
      required this.noticeTitle,
      required this.noticeImgURL,
      required this.noticeURL,
      required this.noticeDescription,
      required this.noticePublishedBy,
      required this.publishedDate});
  static String id = 'NoticePage_id';

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  late RiveAnimationController _btnAnimationController;
  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }

  @override
  void dispose() {
    _btnAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundColorAppBar,
          title: Text(
            "Notices",
            style: kwhiteTextStyle,
          ),
          actions: [
            IconButton(icon: const Icon(Icons.more_vert), onPressed: () => {}),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, bottom: 100, left: 20.0, right: 20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "---${widget.noticeTitle}",
                        style: kwhiteTextStyle.copyWith(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 15),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
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
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(widget
                                    .noticeImgURL), // Replace with your image URL
                                fit: BoxFit
                                    .cover, // You can adjust the fit as needed
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(widget.noticeDescription,
                          style: kwhiteTextStyle.copyWith(
                              fontSize: 15, fontWeight: FontWeight.w300)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Published By-$widget.noticePublishedBy",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: kwhitesubTextStyle.copyWith(
                              fontSize: 10, fontWeight: FontWeight.w300)),
                      Text("Published At-$widget.publishedDate",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: kwhitesubTextStyle.copyWith(
                              fontSize: 10, fontWeight: FontWeight.w300)),
                    ]),
              )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: AnimatedBtn(
                    label: "Read it on Web",
                    icon: const Icon(
                      Icons.web_rounded,
                      color: Colors.black,
                    ),
                    btnAnimationController: _btnAnimationController,
                    press: () {
                      _btnAnimationController.isActive = true;
                      Future.delayed(const Duration(milliseconds: 800),
                          () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        // const url = noticeURL;
                        final Uri url = Uri.parse(widget.noticeURL);
                        if (!await launchUrl(url)) {
                          throw Exception('Could not launch $url');
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

//  String noticeTitle =
//         "Republic attained but yet to be understood: President Paudel";
//     String noticeImgURL =
//         'https://assets-api.kathmandupost.com/thumb.php?src=https://assets-cdn.kathmandupost.com/uploads/source/news/2023/third-party/WhatsAppImage20230920at60220PM-1695216938.jpg&w=900&height=601';
//     String noticeURL =
//         'https://kathmandupost.com/national/2023/09/20/republic-attained-but-yet-to-be-understood-president-paudel';
//     String noticeDescription =
//         '''President Ramchandra Paudel on Wednesday addressed a special ceremony held at Sheetal Niwas on the occasion of Constitution Day.

// During the ceremony, Paudel expressed his heartfelt tribute towards martyrs who sacrificed their lives for the establishment of a democratic republic and acknowledged the contribution of senior leaders of democratic movements.

// The President stated that while changes had been brought to the system, the condition of the country, society and the general public had yet to be transformed.

// “Undoubtedly, we have restructured the state administratively and the state power too has reached to the access of the people at the most grassroots level. But, the character of the State is yet to be reformed and restructured.”

// Paudel also expressed that although republic had been attained, he felt as though its true meaning was yet to be understood and internalised.

// Republic does not simply mean the change of guards in the governance structure, the President said. “It still remains for us to properly understand that the republic is the system that not only ensures people’s direct participation in the political process, that leads them to state power, but also expects people to transform their conduct in accordance with the spirit of the system.”

// The President opined that while Nepal, as a nation, had abundant opportunities before itself, their realisation would only be possible if relentless work was put into bringing drastic and righteous changes in the conduct and character in accordance with the democratic culture.

// There is no alternative to moving ahead, protecting the constitution and safeguarding political achievements, he added.

// Paudel also stressed the need to improve the mode of governance and enhance international engagements— bilateral and multilateral— in order to strengthen the national economy.

// “As the country faces headwinds at the moment, we are required to enhance our international engagements as well, through balanced and effective foreign policy. Such endeavours are imperative also for strengthening the national economy as we need to generate income and employment opportunities for our young human resources.”

// https://kathmandupost.com/national/2023/09/20/republic-attained-but-yet-to-be-understood-president-paudel''';

//     String noticePublishedBy = "kathmandupost";
//     String publishedDate = "2023-20-9";
