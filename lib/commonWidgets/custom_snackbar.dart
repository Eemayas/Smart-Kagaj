import 'package:flutter/material.dart';
import 'package:smart_kagaj/constant/colors.dart';
import 'package:smart_kagaj/constant/fonts.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnackbar({
  required BuildContext context,
  icons = Icons.error,
  iconsColor = Colors.red,
  text,
  backgroundColor = kBackgroundColorCard,
}) {
  // Get the screen width once and store it in a variable
  // double screenWidth = MediaQuery.of(context).size.width;
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      backgroundColor: kBackgroundColorCard,
      content: Row(
        children: [
          Icon(icons, color: iconsColor),
          const SizedBox(width: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.67,
            child: Text(
              text,
              softWrap: true,
              style: kwhiteTextStyle,
            ),
          ),
        ],
      ),
    ),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnackbarPart2({
  width,
  required BuildContext context,
  icons = Icons.error,
  iconsColor = Colors.red,
  text,
  backgroundColor = kBackgroundColorCard,
}) {
  // Get the screen width once and store it in a variable
  // double screenWidth = MediaQuery.of(context).size.width;

  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      backgroundColor: kBackgroundColorCard,
      content: Row(
        children: [
          Icon(icons, color: iconsColor),
          const SizedBox(width: 10),
          SizedBox(
            width: width * 0.67,
            child: Text(
              text,
              softWrap: true,
              style: kwhiteTextStyle,
            ),
          ),
        ],
      ),
    ),
  );
}



// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';

// import '../constant.dart';

// ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnackbar({
//   required BuildContext context,
//   icons = Icons.error,
//   iconsColor = Colors.red,
//   text,
//   backgroundColor = kBackgroundColorCard,
// }) {
//   return ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//         showCloseIcon: true,
//         backgroundColor: kBackgroundColorCard,
//         content: Row(
//           children: [
//             Icon(icons, color: iconsColor),
//             SizedBox(
//               width: 10,
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.67,
//               child: Text(
//                 text,
//                 softWrap: true,
//                 style: kwhiteTextStyle,
//               ),
//             ),
//           ],
//         )),
//   );
// }
