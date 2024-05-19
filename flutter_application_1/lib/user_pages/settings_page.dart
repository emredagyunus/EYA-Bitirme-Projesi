import 'package:EYA/themes/theme_provider.dart';
import 'package:EYA/user_pages/mail_changing_page.dart';
import 'package:EYA/user_pages/password_changing_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isNotificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();
    setState(() {
      isNotificationsEnabled = settings.authorizationStatus == AuthorizationStatus.authorized;
    });
  }

  Future<void> _requestNotificationPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    setState(() {
      isNotificationsEnabled = settings.authorizationStatus == AuthorizationStatus.authorized;
    });

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      // Kullanıcı bildirimi reddettiğinde yapılacak işlemler
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bildirim izni reddedildi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ayarlar",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Geniş ekran için düzen
            return _buildWideLayout(context);
          } else {
            // Dar ekran için düzen
            return _buildNarrowLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 500.0, vertical: 50.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _buildSettingItem(
                  context,
                  "Karanlık Mod",
                  CupertinoSwitch(
                    value: Provider.of<ThemeProvider>(context, listen: true).isDarkMode,
                    onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                  ),
                ),
                _buildSettingItem(
                  context,
                  "E-Postanı Değiştir",
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MailChangingPage()),
                      );
                    },
                    child: Text(
                      ">",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ),
                _buildSettingItem(
                  context,
                  "Şifreni Değiştir",
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PasswordChangingPage()),
                      );
                    },
                    child: Text(
                      ">",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ),
                _buildSettingItem(
                  context,
                  "Bildirimleri Aç/Kapat",
                  CupertinoSwitch(
                    value: isNotificationsEnabled,
                    onChanged: (value) {
                      if (value) {
                        _requestNotificationPermission();
                      } else {
                        // Bildirim izinlerini kapatma işlemleri (bu manuel olarak yapılmalıdır)
                        setState(() {
                          isNotificationsEnabled = false;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSettingItem(
            context,
            "Karanlık Mod",
            CupertinoSwitch(
              value: Provider.of<ThemeProvider>(context, listen: true).isDarkMode,
              onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
            ),
          ),
          _buildSettingItem(
            context,
            "E-Postanı Değiştir",
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MailChangingPage()),
                );
              },
              child: Text(
                ">",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ),
          _buildSettingItem(
            context,
            "Şifreni Değiştir",
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordChangingPage()),
                );
              },
              child: Text(
                ">",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ),
          _buildSettingItem(
            context,
            "Bildirimleri Aç/Kapat",
            CupertinoSwitch(
              value: isNotificationsEnabled,
              onChanged: (value) {
                if (value) {
                  _requestNotificationPermission();
                } else {
                  setState(() {
                    isNotificationsEnabled = false;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, String title, Widget trailing) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      padding: const EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: trailing,
          ),
        ],
      ),
    );
  }
}
