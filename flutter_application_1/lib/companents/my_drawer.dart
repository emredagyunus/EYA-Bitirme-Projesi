import 'package:flutter/material.dart';
import 'package:EYA/companents/my_drawer_tile.dart';
import 'package:EYA/user_pages/aboutus_page.dart';
import 'package:EYA/user_pages/blog_page.dart';
import 'package:EYA/user_pages/donation_page.dart';
import 'package:EYA/user_pages/duyuru_page.dart';
import 'package:EYA/user_pages/iletisim_page.dart';
import 'package:EYA/user_pages/my_complaint_page.dart';
import 'package:EYA/user_pages/root_page.dart';
import 'package:EYA/user_pages/settings_page.dart';
import 'package:EYA/user_pages/sss_page.dart';
import 'package:EYA/services/auth/auth_gate.dart';
import 'package:EYA/services/auth/auth_services.dart';
import 'package:unicons/unicons.dart';

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
            text: "Ana Sayfa",
            icon: UniconsLine.home_alt,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RootPage(
                    initialIndex: 0,
                  ),
                )),
          ),
          MyDrawerTile(
              text: "Hakkımızda",
              icon: UniconsLine.info_circle,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutUsPage(),
                    ));
              }),
          MyDrawerTile(
              text: "Blog",
              icon: UniconsLine.blogger_alt,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlogPage(),
                    ));
              }),
          MyDrawerTile(
              text: "Duyuru",
              icon: UniconsLine.megaphone,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DuyuruPage(),
                    ));
              }),
          MyDrawerTile(
              text: "Şikayetlerim",
              icon: UniconsLine.bookmark,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyComplaint(),
                    ));
              }),
          MyDrawerTile(
              text: "Bağış Kanalları",
              icon: UniconsLine.gift,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DonationPage(),
                    ));
              }),
          MyDrawerTile(
              text: "İletişim",
              icon: UniconsLine.envelope_send,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => iletisimPage(),
                    ));
              }),
          MyDrawerTile(
              text: "Sıkça Sorulan Sorular",
              icon: UniconsLine.comment_question,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FAQPage(),
                    ));
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
                    builder: (context) => const SettingsPage(),
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
