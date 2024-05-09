import 'package:flutter/material.dart';
import 'package:EYA/admin_pages/admin_blog_page.dart';
import 'package:EYA/admin_pages/admin_duyuru_page.dart';
import 'package:EYA/admin_pages/admin_home_page.dart';
import 'package:EYA/admin_pages/admin_kurum_ekle.dart';
import 'package:EYA/admin_pages/admin_message_page.dart';
import 'package:EYA/companents/my_drawer_tile.dart';
import 'package:EYA/user_pages/settings_page.dart';
import 'package:EYA/services/auth/auth_gate.dart';
import 'package:EYA/services/auth/auth_services.dart';
import 'package:unicons/unicons.dart';

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
            text: "Ana Sayfa",
            icon: UniconsLine.home_alt,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminHomePage(),
              ),
            ),
          ),
          MyDrawerTile(
              text: "Blog Yönet",
              icon: UniconsLine.blogger_alt,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminBlogPage(),
                    ));
              }),
          MyDrawerTile(
              text: "Duyuru Yönet",
              icon: UniconsLine.megaphone,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminDuyuruPage(),
                    ));
              }),
          MyDrawerTile(
              text: "Kurum Ekle",
              icon: UniconsLine.university,
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

               MyDrawerTile(
              text: "Mesajlar",
              icon: UniconsLine.chat,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  FirebaseDataPage(),
                  ),
                );
              }),

          //settings list tile
          MyDrawerTile(
              text: "Ayarlar",
              icon: UniconsLine.setting,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  SettingsPage(),
                  ),
                );
              }),

          const Spacer(),
          //logout list tile
          MyDrawerTile(
              text: "Çıkış Yap",
              icon: UniconsLine.sign_out_alt,
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
