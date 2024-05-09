import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:EYA/user_pages/all_complaint_page.dart';
import 'package:EYA/user_pages/home_page.dart';
import 'package:EYA/user_pages/my_favori_page.dart';
import 'package:EYA/user_pages/myprof%C4%B1le_page.dart';
import 'package:EYA/user_pages/sikayet_1.dart';
import 'package:page_transition/page_transition.dart';
import 'package:unicons/unicons.dart';

class RootPage extends StatefulWidget {
  final int? initialIndex;
  const RootPage({Key? key, this.initialIndex}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _bottomNavIndex = widget.initialIndex ?? 0;
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
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false, // Set hasScrollBody to false
            child: Column(
              children: [
                Expanded(
                  child: IndexedStack(
                    index: _bottomNavIndex,
                    children: _widgetOptions(),
                  ),
                ),
                if (isMobile)
                  AnimatedBottomNavigationBar(
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
                    },
                  ),
                // Footer expanded to fill remaining space
                Container(
                  color: Colors.deepPurple.shade300,
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Text(
                    'footer alani doldurulucak',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked, // Change FloatingActionButton location to endDocked
      floatingActionButton: MediaQuery.of(context).viewInsets.bottom > 0
          ? SizedBox.shrink()
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: SikayetIlkPage(),
                    type: PageTransitionType.bottomToTop,
                  ),
                );
              },
              backgroundColor: Colors.deepPurple,
              child: Icon(UniconsLine.plus, color: Colors.white),
            ),
      bottomNavigationBar: isMobile ? null : SizedBox(height: 50), // Hide bottom navigation bar on web
    );
  }
}
