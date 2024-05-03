import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/companents/constants.dart';
import 'package:flutter_application_1/user_pages/all_complaint_page.dart';
import 'package:flutter_application_1/user_pages/home_page.dart';
import 'package:flutter_application_1/user_pages/my_favori_page.dart';
import 'package:flutter_application_1/user_pages/myprof%C4%B1le_page.dart';
import 'package:flutter_application_1/user_pages/sikayet_1.dart';
import 'package:page_transition/page_transition.dart';
import 'package:unicons/unicons.dart';

class RootPage extends StatefulWidget {
  final int? initialIndex;
  const RootPage({super.key, this.initialIndex});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _bottomNavIndex = widget.initialIndex?? 0;
  }

  //List of the pages
  List<Widget> _widgetOptions() {
    return [
      const HomePage(),
      FavoritesPage(),
      AllComplaint(),
      MyProfilePage(),
    ];
  }

  //List of the pages icons
  List<IconData> iconList = [
    UniconsLine.estate,
    UniconsLine.heart_alt,
    UniconsLine.sort_amount_down,
    UniconsLine.user_circle,
  ];

  //List of the pages titles
  List<String> titleList = [
    'Home',
    'Favorite',
    'Sikayet',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _bottomNavIndex,
        children: _widgetOptions(),
      ),
      floatingActionButton: SizedBox(
        width: 40,
        height: 40,
         child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  child: SikayetIlkPage(),
                  type: PageTransitionType.bottomToTop));
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(UniconsLine.plus, color: Colors.white,),
      ), ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
          splashColor: Colors.deepPurple,
          activeColor: Colors.deepPurple,
          inactiveColor: Colors.black,
          icons: iconList,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          onTap: (index) {
            setState(() {
              _bottomNavIndex = index;
            });
          }),
    );
  }
}
