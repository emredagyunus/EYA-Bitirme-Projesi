// root_page.dart
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:EYA/user_pages/all_complaint_page.dart';
import 'package:EYA/user_pages/home_page.dart';
import 'package:EYA/user_pages/my_favori_page.dart';
import 'package:EYA/user_pages/myprof%C4%B1le_page.dart';
import 'package:EYA/user_pages/sikayet_1.dart';
import 'package:page_transition/page_transition.dart';
import 'package:unicons/unicons.dart';

class RootPage extends StatefulWidget {
  final int? initialIndex;
  const RootPage({super.key, this.initialIndex});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _currentIndexNotifier.value = widget.initialIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _IndexedStack(
        currentIndex: _currentIndexNotifier.value,
        children: [
          const HomePage(),
          FavoritesPage(),
          AllComplaint(),
          MyProfilePage(),
        ],
      ),
      floatingActionButton: _FloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _AnimatedBottomNavigationBar(
        currentIndexNotifier: _currentIndexNotifier,
        icons: _bottomNavigationBarIcons,
        titles: _bottomNavigationBarTitles,
      ),
    );
  }
}

// _indexed_stack.dart
class _IndexedStack extends StatelessWidget {
  final int currentIndex;
  final List<Widget> children;

  const _IndexedStack({required this.currentIndex, required this.children});

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentIndex,
      children: children,
    );
  }
}

// _floating_action_button.dart
class _FloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: FloatingActionButton(
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
        child: Icon(
          UniconsLine.plus,
          color: Colors.white,
        ),
      ),
    );
  }
}

// _animated_bottom_navigation_bar.dart
class _AnimatedBottomNavigationBar extends StatelessWidget {
  final ValueNotifier<int> currentIndexNotifier;
  final List<IconData> icons;
  final List<String> titles;

  const _AnimatedBottomNavigationBar({
    required this.currentIndexNotifier,
    required this.icons,
    required this.titles,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar(
      splashColor: Colors.deepPurple,
      activeColor: Colors.deepPurple,
      inactiveColor: Colors.black,
      icons: icons,
      activeIndex: currentIndexNotifier.value,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      onTap: (index) {
        currentIndexNotifier.value = index;
      },
    );
  }
}

// constants.dart
const List<IconData> _bottomNavigationBarIcons = [
  UniconsLine.estate,
  UniconsLine.heart_alt,
  UniconsLine.sort_amount_down,
  UniconsLine.user_circle,
];

const List<String> _bottomNavigationBarTitles = [
  'Home',
  'Favorite',
  'Sikayet',
  'Profile',
];