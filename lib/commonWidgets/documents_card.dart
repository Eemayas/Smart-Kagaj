import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../constant/fonts.dart';
import '../pages/document_page.dart';
import 'smooth_navigation.dart';

class DocumentsCards extends StatelessWidget {
  final String documentName;

  final Color color;
  final Function onDelete;
  final Function onEdit;
  final Color borderColor;
  final Color boxShadowColor;
  final Color iconBgColor;

  static const Color _iconBgColor = Color.fromARGB(113, 3, 95, 80);
  static const Color _borderColor = Colors.transparent;

  const DocumentsCards({
    super.key,
    required this.documentName,
    this.color = kBackgroundColorCard,
    // this.icons=_icons,
    this.borderColor = _borderColor,
    this.boxShadowColor = kBoxShadowGreen,
    this.iconBgColor = _iconBgColor,
    required this.onDelete,
    required this.onEdit,
    // required this.nextPage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(SmoothSlidePageRoute(
          page: DocumentPage(
        documentName: documentName,
      ))),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: borderColor,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: boxShadowColor,
                offset: const Offset(6, 6),
                blurRadius: 3,
              ),
            ],
            borderRadius: BorderRadius.circular(30),
          ),
          width: MediaQuery.of(context).size.width * 0.4,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/icons/document.png",
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(documentName,
                    maxLines: 2,
                    style: kwhitesubTextStyle.copyWith(
                        fontSize: 15, fontWeight: FontWeight.w300)),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          onDelete();
                        },
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.redAccent,
                        )),
                    IconButton(
                        onPressed: () {
                          onEdit();
                        },
                        icon: const Icon(
                          Icons.edit_document,
                          color: Colors.green,
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
