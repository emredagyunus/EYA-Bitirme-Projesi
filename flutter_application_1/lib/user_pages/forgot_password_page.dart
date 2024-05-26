import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:EYA/companents/my_button.dart';
import 'package:EYA/companents/my_textfield.dart';
import 'package:EYA/services/auth/login_or_register.dart';
import 'package:page_transition/page_transition.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  Future<void> passwordReset() async {
    // Bilgilerin eksiksiz doldurulup doldurulmadığını kontrol et
    if (emailController.text.isEmpty) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Lütfen gerekli bilgiyi gir!"),
          ),
        );
      }
      return;
    }

    // E-posta adresinin geçerli olup olmadığını kontrol et
    if (!isValidEmail(emailController.text)) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Lütfen geçerli bir e-posta adresi gir!"),
          ),
        );
      }
      return; // Geçerli bir e-posta adresi girilmediği için fonksiyonu sonlandır
    }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return LoginOrRegister();
        },
      ));
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1024;
    final isTablet = screenWidth > 600 && screenWidth <= 1024;

    double horizontalPadding = 20;
    double verticalPadding = 20;
    double imageWidth = 100; // Default image width for mobile

    if (isTablet) {
      horizontalPadding = 50;
      verticalPadding = 50;
      imageWidth = 150; // Image width for tablet
    } else if (isWideScreen) {
      horizontalPadding = 400;
      verticalPadding = 0;
      imageWidth = 300; // Image width for web/desktop
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: horizontalPadding),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "lib/images/eya/logo.png",
                  width: imageWidth,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: const Text(
                  'Şifremi\nUnuttum',
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: const Text(
                  "Şifreni değiştirmek için\nhesabınla ilişkilendirilmiş\ne-posta adresini gir.",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              MyTextField(
                controller: emailController,
                obscureText: false,
                hintText: 'E-Posta',
                icon: Icon(UniconsLine.envelope),
                maxLines: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                onTap: passwordReset,
                text: "Devam Et",
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: const LoginOrRegister(),
                          type: PageTransitionType.bottomToTop));
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'Hesabın var mı? ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'Giriş yap!',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// E-posta adresinin geçerli formatta olup olmadığını kontrol eden regex deseni
  bool isValidEmail(String email) {
    RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
}

void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
