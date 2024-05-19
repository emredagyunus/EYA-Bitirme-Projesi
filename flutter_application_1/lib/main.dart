import 'package:EYA/user_pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:EYA/firebase_options.dart';
import 'package:EYA/user_pages/onboarding_screen.dart';
import 'package:EYA/user_pages/root_page.dart';
import 'package:EYA/user_pages/login_page.dart'; 
import 'package:EYA/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

   await _initializeFirebaseMessaging();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _initializeFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // iOS için izin iste
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  // Android için izin iste (Android'de varsayılan olarak izin verilmiştir)
  if (defaultTargetPlatform == TargetPlatform.android) {
    messaging.subscribeToTopic('all');  // Örnek: Herkese bildirim gönderme
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); 
          }
          if (snapshot.hasData) {
            if (MediaQuery.of(context).size.width > 600) {
              return HomePage();
            } else {
              return RootPage();
            }
          }
          if (kIsWeb) {
            return LoginPage(onTap: () {  },);
          }
          return OnboardingScreen(); 
        },
      ),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
