import 'package:flutter/material.dart';
import 'package:smart_kagaj/constant/colors.dart';
import 'constant/fonts.dart';
import 'pages/dashboard_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
builder: EasyLoading.init(),
        title: 'Smart Kagaj',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const DashboardPage());
  }
}


void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.squareCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..textStyle = kwhiteTextStyle
    ..customAnimation = CustomAnimation();
}

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}