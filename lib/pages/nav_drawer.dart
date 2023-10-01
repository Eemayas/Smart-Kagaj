// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_kagaj/commonWidgets/custom_snackbar.dart';
import 'package:smart_kagaj/constant/colors.dart';
import 'package:smart_kagaj/database/admin.dart';
import 'package:smart_kagaj/pages/admin_controller_page.dart';
import 'package:smart_kagaj/pages/entry_point.dart';
import 'package:smart_kagaj/pages/login_signup_page.dart';

import '../commonWidgets/smooth_navigation.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  User user = FirebaseAuth.instance.currentUser!;
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kBackgroundColor,
      // since there are few items, Column is enough and ListView isn't required
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // identifier for the logged in ID
          children: [
            GestureDetector(
                onTap: () {
                  // show user account
                },
                child: SizedBox(
                  height: 100,
                  width: double.maxFinite,
                  child: DrawerHeader(
                    padding: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(user.email ?? "xyz@gmail.com")],
                    ),
                  ),
                )),
            Expanded(
              // make the main items fill the whole available space
              flex: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          SmoothSlidePageRoute(page: const EntryPoint()));
                    },
                  ),
                  Visibility(
                      visible: AdminDB.checkemail(),
                      child: ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text('Admin'),
                        onTap: () {
                          Navigator.of(context).push(SmoothSlidePageRoute(
                              page: const AdminControllerPage()));
                        },
                      )),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        // ignore: use_build_context_synchronously
                        customSnackbar(
                          context: context,
                          icons: Icons.done_all,
                          iconsColor: Colors.green,
                          text: "User signed out",
                        );
                        Navigator.of(context).pushAndRemoveUntil(
                          SmoothSlidePageRoute(page: LogInSignUp()),
                          (route) => false,
                        );
                        print('User signed out');
                      } catch (e) {
                        print('Error signing out: $e');
                      }
                    },
                  ),
                  Visibility(
                      visible: AdminDB.checkemail(),
                      child: ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text('Create Contract'),
                        onTap: () {
                          SystemNavigator.pop();
                        },
                      )),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Quit'),
                    onTap: () {
                      SystemNavigator.pop();
                    },
                  )
                ],
              ),
            ),
            // ListTile(
            //   leading: const Icon(Icons.settings),
            //   title: const Text('Settings'),
            //   onTap: () {
            //     Navigator.pushNamed(context, "/settings");
            //   },
            // ),
          ]),
    );
  }
}
