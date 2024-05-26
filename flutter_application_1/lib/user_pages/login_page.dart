import 'package:EYA/admin_pages/admin_home_page.dart';
import 'package:EYA/companents/my_button.dart';
import 'package:EYA/companents/my_textfield.dart';
import 'package:EYA/services/auth/auth_services.dart';
import 'package:EYA/user_pages/forgot_password_page.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  void login() async {
    final _authService = AuthService();

    // Bilgilerin eksiksiz doldurulup doldurulmadığını kontrol et
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Lütfen gerekli tüm bilgileri gir!"),
          ),
        );
      }
      return;
    }

    try {
      if (emailController.text == 'eya@admin.com' &&
          passwordController.text == 'admin12345') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminHomePage(),
          ),
        );
      } else {
        await _authService.signInWithEmailPassword(
          emailController.text,
          passwordController.text,
        );
      }
    } catch (e) {
      String errorMessage =
          "Geçersiz bir e-posta veya şifre girdin, lütfen kontrol et!";
      if (e.hashCode == 'invalid-email') {
        errorMessage = "Geçersiz e-posta adresi. Lütfen kontrol edin.";
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            errorMessage,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void forgetPw() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ForgotPassword();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidthMultiplier = screenWidth * (screenWidth > 600 ? 0.25 : 0.7);

    final isWideScreen = screenWidth > 1024;
    final isTablet = screenWidth > 600 && screenWidth <= 1024;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // logo
                  Image(
                    image: const AssetImage("lib/images/eya/logo.png"),
                    width: imageWidthMultiplier,
                    height: imageWidthMultiplier,
                  ),

                  const SizedBox(height: 25),

                  Text(
                    "Hoş Geldiniz...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: isWideScreen ? 400 : (isTablet ? 350 : null),
                    child: MyTextField(
                      controller: emailController,
                      maxLines: 1,
                      hintText: "E-Posta",
                      obscureText: false,
                      icon: const Icon(
                        UniconsLine.envelope,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: isWideScreen ? 400 : (isTablet ? 350 : null),
                    child: MyTextField(
                      controller: passwordController,
                      maxLines: 1,
                      hintText: "Şifre",
                      obscureText: _obscureText,
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
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: isWideScreen ? 400 : (isTablet ? 350 : null),
                    child: MyButton(
                      onTap: login,
                      text: 'Giriş Yap',
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: isWideScreen ? 200 : (isTablet ? 200 : null),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: forgetPw,
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

void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
