import 'package:EYA/user_pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:EYA/user_pages/root_page.dart';
import 'package:EYA/services/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if(snapshot.hasData){
           if(MediaQuery.of(context).size.width > 600){
             return HomePage();
           }else{
             return RootPage();
           }
          }

          //user is NOT logged in
          else{
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}