import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_kagaj/constant/colors.dart';
import 'package:provider/provider.dart';
import 'package:smart_kagaj/pages/create_contract_page.dart';
import 'package:smart_kagaj/pages/entry_point.dart';
import 'Provider/provider.dart';
import 'constant/fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'pages/contracts_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //Provider Initialization
  runApp(MultiProvider(
    //List of Provider used in the app
    providers: [ChangeNotifierProvider(create: (_) => ChangedMsg())],
    child: const MyApp(),
  ));
  // runApp(const MyApp());
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
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: kBackgroundColor,
          textTheme: TextTheme(
            labelLarge: kbuttontextTextStyle,
            bodyLarge: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        home: const EntryPoint());
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
