// ignore_for_file: prefer_const_constructors, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:smart_kagaj/model/menu.dart';
import 'package:smart_kagaj/pages/contracts_list_page.dart';
import 'package:smart_kagaj/pages/user_detail_show_page.dart';
import '../commonWidgets/btm_nav_item.dart';
import '../constant/colors.dart';
import '../utils/rive_utils.dart';
import 'dashboard_page.dart';
import 'notice_list_page.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});
  static String id = "entrypoint";

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  Menu selectedBottonNav = bottomNavItems.first;
  int selectedIndex = 0;
  void updateSelectedBtmNav(Menu menu) {
    if (selectedBottonNav != menu) {
      setState(() {
        selectedBottonNav = menu;
      });
    }
  }

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(
        () {
          setState(() {});
        },
      );
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Widget> _pages = [
    DashboardPage(),
    ContractListPage(),
    NoticeListPage(),
    UserDetailShowPage(),
    DashboardPage(),
    NoticeListPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      body: _pages[selectedIndex],
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, 100 * animation.value),
        child: SafeArea(
          child: Container(
            padding:
                const EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 12),
            margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: kBackgroundColorAppBar.withOpacity(0.9),
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: kBackgroundColorAppBar.withOpacity(0.3),
                  offset: const Offset(0, 20),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                  bottomNavItems.length,
                  (index) {
                    Menu navBar = bottomNavItems[index];
                    return BtmNavItem(
                      navBar: navBar,
                      press: () {
                        selectedIndex = index;
                        RiveUtils.chnageSMIBoolState(navBar.rive.status!);
                        updateSelectedBtmNav(navBar);
                      },
                      riveOnInit: (artboard) {
                        navBar.rive.status = RiveUtils.getRiveInput(artboard,
                            stateMachineName: navBar.rive.stateMachineName);
                      },
                      selectedNav: selectedBottonNav,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
