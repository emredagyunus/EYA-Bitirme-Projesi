import 'package:EYA/user_pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:EYA/firebase_options.dart';
import 'package:EYA/user_pages/onboarding_screen.dart';
import 'package:EYA/user_pages/root_page.dart';
import 'package:EYA/themes/theme_provider.dart';
import 'package:provider/provider.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if (snapshot.hasData) {
           if(MediaQuery.of(context).size.width > 600){
             return HomePage();
           }else{
             return RootPage();
           }
          }
          else {
            return OnboardingScreen();
          }
        },
      ),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}




