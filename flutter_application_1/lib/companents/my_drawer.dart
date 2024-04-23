import 'package:flutter/material.dart';
import 'package:flutter_application_1/companents/my_drawer_tile.dart';
import 'package:flutter_application_1/pages/aboutus.dart';
import 'package:flutter_application_1/pages/iletisim_page.dart';
import 'package:flutter_application_1/pages/my_complaint_page.dart';
import 'package:flutter_application_1/pages/settings_page.dart';
import 'package:flutter_application_1/pages/sss_page.dart';
import 'package:flutter_application_1/services/auth/auth_gate.dart';
import 'package:flutter_application_1/services/auth/auth_services.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    final authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),

          //home list tile
          MyDrawerTile(
            text: "ANASAYFA",
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),
          MyDrawerTile(
              text: "HAKKIMIZDA",
              icon: Icons.person,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutUsPage(),
                    ));
              }),
          MyDrawerTile(text: "BLOG", icon: Icons.person, onTap: () {}),
          MyDrawerTile(text: "DUYURU", icon: Icons.person, onTap: () {}),
          MyDrawerTile(
              text: "ŞİKAYETLERİM",
              icon: Icons.person,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyComplaint(),
                    ));
              }),
          MyDrawerTile(
              text: "BAĞIŞ KAMPANYALARI",
              icon: Icons.person,
              onTap: () {
                
              }),
          MyDrawerTile(
              text: "İLETİŞİM",
              icon: Icons.person,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => iletisimPage(),
                    ));
              }),
          MyDrawerTile(text: "SSS", icon: Icons.person, onTap: () {Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FAQPage(),
                    ));}),

          //settings list tile
          MyDrawerTile(
              text: "AYARLAR",
              icon: Icons.settings,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              }),

          const Spacer(),
          //logout list tile
          MyDrawerTile(
              text: "ÇIKIŞ YAP",
              icon: Icons.logout,
              onTap: () {
                logout();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthGate(),
                    ));
              }),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
