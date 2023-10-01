import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_kagaj/constant/colors.dart';
import 'package:smart_kagaj/constant/fonts.dart';

class QRGeneratorPage extends StatelessWidget {
  const QRGeneratorPage({super.key, required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColorAppBar,
        title: Text(
          "QR Generator",
          style: kwhiteTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.24,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Lottie.asset("assets/Lottie/QR_animation.json"),
                )),
            Text(
              "Scan The QR code given  below to share this document",
              textAlign: TextAlign.center,
              style: kwhiteboldTextStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            QrImageView(backgroundColor: Colors.white, data: imageUrl),
          ],
        ),
      ),
    );
  }
}
