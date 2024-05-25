import 'package:EYA/services/auth/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:EYA/companents/my_button.dart';
import 'package:EYA/companents/my_textfield.dart';
import 'package:EYA/services/auth/auth_services.dart';
import 'package:unicons/unicons.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  //register method
  void register() async {
    final _authService = AuthService();

    // Bilgilerin eksiksiz doldurulup doldurulmadığını kontrol et
    if (nameController.text.isEmpty ||
        surnameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
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

    // Telefon numarasının geçerli olup olmadığını kontrol et
    if (!isValidPhoneNumber(phoneController.text)) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Lütfen geçerli bir telefon numarası gir!"),
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

    //check password -> create user
    if (passwordController.text == confirmPasswordController.text) {
      // try creating user
      try {
        await _authService.signUpWithEmailPassword(
            emailController.text,
            passwordController.text,
            nameController.text,
            surnameController.text,
            phoneController.text);

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginOrRegister()),
          );
        }
      } catch (e) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(e.toString()),
            ),
          );
        }
      }
    }
    //if password don't match -> show error
    else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text("Şifreler eşleşmiyor, tekrar dene!"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1200;
    final isTablet = screenWidth > 600 && screenWidth <= 1024;

    double horizontalPadding = 20;
    double verticalPadding = 0;
     double logoTopPadding = 0;
    double logoBottomPadding = 0;
    double fieldSpacing = 5;

    if (isTablet || isWideScreen) {
      horizontalPadding = 350;
      verticalPadding = 0;
      logoTopPadding = 0;  
      logoBottomPadding = 0;  
      fieldSpacing = 5;  
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Padding(
           padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 1200 ? 500 : 0,
            vertical: 5,
          ), 
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // logo
                  Padding(
                    padding: EdgeInsets.only(top: logoTopPadding, bottom: logoBottomPadding),
                    child: Image(
                      image: const AssetImage("lib/images/eya/logo.png"),
                       
                    ),
                  ),

                  // message, app slogan
                  Text(
                    "Kaydol",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                  SizedBox(height: fieldSpacing * 2.5),
                  MyTextField(
                    controller: nameController,
                    hintText: "Ad",
                    obscureText: false,
                    icon: Icon(UniconsLine.user),
                    maxLines: 1,
                  ),
                  SizedBox(height: fieldSpacing),
                  MyTextField(
                    controller: surnameController,
                    hintText: "Soyad",
                    obscureText: false,
                    icon: Icon(UniconsLine.user),
                    maxLines: 1,
                  ),
                  SizedBox(height: fieldSpacing),
                  MyTextField(
                    controller: phoneController,
                    hintText: "Telefon (05xx xxx xx xx)",
                    obscureText: false,
                    icon: Icon(UniconsLine.phone),
                    maxLines: 1,
                    inputType: TextInputType.number,
                  ),
                  SizedBox(height: fieldSpacing),
                  // email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: "E-Posta",
                    obscureText: false,
                    icon: Icon(UniconsLine.envelope),
                    maxLines: 1,
                  ),

                  SizedBox(height: fieldSpacing),
                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: "Şifre",
                    obscureText: false,
                    icon: Icon(UniconsLine.lock_alt),
                    maxLines: 1,
                  ),

                  SizedBox(height: fieldSpacing),

                  // confirm password textfield
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Şifreyi Onayla",
                    obscureText: false,
                    icon: Icon(UniconsLine.lock_alt),
                    maxLines: 1,
                  ),

                  SizedBox(height: fieldSpacing),
                  // sign up button
                  MyButton(
                    onTap: register,
                    text: "Kaydol",
                  ),

                  SizedBox(height: fieldSpacing * 2.5),
                  // already have an account? login here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Zaten bir hesabın var mı?",
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Hemen giriş yap!",
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

  // Telefon numarasının geçerli formatta olup olmadığını kontrol eden regex deseni
  bool isValidPhoneNumber(String phoneNumber) {
    RegExp regex = RegExp(r'^0\d{10}$');
    return regex.hasMatch(phoneNumber);
  }

  // E-posta adresinin geçerli formatta olup olmadığını kontrol eden regex deseni
  bool isValidEmail(String email) {
    RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
}