import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import '../constant/colors.dart';
import '../constant/fonts.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  static String id = "TermsAndConditionsScreen";

  const TermsAndConditionsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColorAppBar,
        title: Text(
          'Terms & Conditions',
          style: kwhiteboldTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mainText('Smart Kagaj Terms and Conditions'),
              const SizedBox(height: 16.0),
              longText(
                '''
Welcome to SmartKagaj, the innovative mobile application transforming contract signing through blockchain and smart contracts. Before using our services, please read the following terms and conditions carefully.''',
              ),
              const SizedBox(height: 16.0),
              // // Link to third-party Terms and Conditions
              // GestureDetector(
              //   onTap: () {
              //     _launchURL(Uri(
              //         scheme: 'https',
              //         host: 'policies.google.com',
              //         path: '/terms'));
              //   },
              //   child: linkText(
              //     'Link to Terms and Conditions of third-party service providers used by the app',
              //   ),
              // ),
              // const SizedBox(height: 16.0),
              bulletPointsText(" 1. Acceptance of Terms"),
              longText(
                '''By accessing or using SmartKagaj, you agree to abide by these terms and conditions. If you do not agree, please refrain from using our application.''',
              ),

              const SizedBox(height: 16.0),

              bulletPointsText("2. User Eligibility"),
              longText(
                '''You must be at least 18 years old or the legal age in your jurisdiction to use SmartKagaj. By using the app, you affirm that you meet these eligibility requirements.''',
              ),

              const SizedBox(height: 16.0),

              bulletPointsText("3. Account Registration"),
              longText(
                '''To access certain features of SmartKagaj, you may need to register an account. You are responsible for maintaining the confidentiality of your account information and are liable for all activities that occur under your account.''',
              ),

              const SizedBox(height: 16.0),

              bulletPointsText("4. Use of SmartKagaj"),
              longText(
                '''a. SmartKagaj grants you a non-exclusive, non-transferable, revocable license to use the application for its intended purpose.

b. You agree not to engage in any unauthorized use, reproduction, distribution, or modification of SmartKagaj.''',
              ),

              const SizedBox(height: 16.0),

              bulletPointsText("5. Digital Contract Execution"),
              longText(
                '''a. SmartKagaj facilitates the digitalization of contract signing through blockchain and smart contracts. Users acknowledge that digital signatures executed through SmartKagaj hold legal validity, and users are responsible for understanding and complying with relevant laws and regulations.

b. SmartKagaj is not responsible for the content of contracts created or signed using the application. Users are encouraged to seek legal advice if needed.''',
              ),

              const SizedBox(height: 16.0),

              bulletPointsText("6. Privacy and Security"),
              longText(
                '''a. SmartKagaj takes privacy and security seriously. User data is handled in accordance with our Privacy Policy, available on the app.

b. Users are responsible for maintaining the security of their accounts, including passwords and access credentials.''',
              ),

              const SizedBox(height: 16.0),

              bulletPointsText("7. Limitation of Liability"),
              longText(
                '''SmartKagaj is provided "as is," and we make no warranties or representations regarding the accuracy, completeness, or suitability for a particular purpose. We are not liable for any damages arising from the use of SmartKagaj.''',
              ),

              const SizedBox(height: 16.0),

              bulletPointsText("8. Modifications to Terms and App"),
              longText(
                '''SmartKagaj reserves the right to modify these terms and conditions at any time. Users will be notified of significant changes. SmartKagaj also reserves the right to modify or discontinue the application with or without notice.''',
              ),

              const SizedBox(height: 16.0),

              bulletPointsText("9. Governing Law"),
              longText(
                '''These terms and conditions are governed by and construed in accordance with the laws of [Jurisdiction]. Any disputes arising from the use of SmartKagaj shall be resolved in the courts of [Jurisdiction].''',
              ),

              const SizedBox(height: 16.0),
              longText(
                '''By using SmartKagaj, you agree to these terms and conditions. If you have any questions, please contact us at smartcontract@gmail.com. Thank you for choosing SmartKagaj.''',
              ),

              const SizedBox(height: 16.0),

              const SizedBox(height: 16.0),
              // Add more content as needed
            ],
          ),
        ),
      ),
    );
  }

  Text mainText(String text) {
    return Text(text,
        style: kwhiteTextStyle.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          decoration: TextDecoration.underline,
        ));
  }

  Text bulletPointsText(String text) {
    return Text(text,
        style: kwhiteTextStyle.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 17,
          // decoration: TextDecoration.underline,
        ));
  }

  Text longText(String text) {
    return Text(
      text,
      style: kwhiteTextStyle,
    );
  }

  Text linkText(String text) {
    return Text(
      text,
      style: kwhiteTextStyle.copyWith(
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
    );
  }

  // Function to open URLs in the default browser
  _launchURL(Uri uri) async {
    if (await launchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }
}
