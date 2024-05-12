import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:EYA/admin_pages/admin_home_page.dart';
import 'package:EYA/companents/my_button.dart';
import 'package:EYA/companents/my_textfield.dart';
import 'package:EYA/user_pages/forgot_password_page.dart';
import 'package:EYA/services/auth/auth_services.dart';
import 'package:unicons/unicons.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;
  // login method
  void login() async {
    //get instance of auth services
    final _authService = AuthService();
    //try sign in
    try {
      if (emailController.text == 'eya@admin.com' &&
          passwordController.text == 'admin12345') {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminHomePage(),
            ));
      } else {
        await _authService.signInWithEmailPassword(
          emailController.text,
          passwordController.text,
        );
        if(kIsWeb){

        }else{
          String? deviceToken = await FirebaseMessaging.instance.getToken();

        if (deviceToken != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth
                  .instance.currentUser!.uid) 
              .update({'deviceToken': deviceToken});
        }
        }
      }
    }

    // display any errors
    catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  //forget password
  void forgetPw() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text("User tapped forgot password."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logo
                  Image(
                    image: const AssetImage("lib/images/eya/logo.png"),
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.7,
                  ),

                  const SizedBox(height: 25),

                  //message, app slogan
                  Text(
                    "Hoş Geldiniz...",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),
                  //email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: "E-Posta",
                    obscureText: false,
                    icon: const Icon(
                      UniconsLine.envelope,
                    ),
                    maxLines: 1,
                  ),

                  const SizedBox(height: 10),
                  //password textfield
                  MyTextField(
                      controller: passwordController,
                      hintText: "Şifre",
                      obscureText: _obscureText,
                      maxLines: 1,
                      icon: const Icon(
                        UniconsLine.lock_alt,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText
                            ? UniconsLine.eye
                            : UniconsLine.eye_slash),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )),

                  const SizedBox(height: 10),
                  //sign in button
                  MyButton(
                    onTap: login,
                    text: 'Giriş Yap',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ForgotPassword();
                                },
                              ),
                            );
                          },
                          child: Text(
                            'Şifremi Unuttum',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Üye değil misin?",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Hemen kaydol!",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
