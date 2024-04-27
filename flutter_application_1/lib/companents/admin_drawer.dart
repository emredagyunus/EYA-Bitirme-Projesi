import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_pages/admin_blog_page.dart';
import 'package:flutter_application_1/admin_pages/admin_duyuru_page.dart';
import 'package:flutter_application_1/admin_pages/admin_home_page.dart';
import 'package:flutter_application_1/admin_pages/admin_kurum_ekle.dart';
import 'package:flutter_application_1/companents/my_drawer_tile.dart';
import 'package:flutter_application_1/user_pages/settings_page.dart';
import 'package:flutter_application_1/services/auth/auth_gate.dart';
import 'package:flutter_application_1/services/auth/auth_services.dart';

class MyAdminDrawer extends StatelessWidget {
  const MyAdminDrawer({super.key});

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
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminHomePage(),
              ),
            ),
          ),
          MyDrawerTile(
              text: "Admin Blog",
              icon: Icons.add,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminBlogPage(),
                    ));
              }),
          MyDrawerTile(
              text: "Admin Duyuru",
              icon: Icons.add,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminDuyuruPage(),
                    ));
              }),
          MyDrawerTile(
              text: "Kurum Ekle",
              icon: Icons.add,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminKurumKayit(
                      onTap: null,
                    ),
                  ),
                );
              }),

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
