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
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Lütfen gerekli tüm bilgileri gir!"),
        ),
      );
      return; // Bilgiler eksik olduğu için fonksiyonu sonlandır
    }

    // Telefon numarasının geçerli olup olmadığını kontrol et
    if (!isValidPhoneNumber(phoneController.text)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Lütfen geçerli bir telefon numarası gir!"),
        ),
      );
      return; // Geçerli bir telefon numarası girilmediği için fonksiyonu sonlandır
    }

    // E-posta adresinin geçerli olup olmadığını kontrol et
    if (!isValidEmail(emailController.text)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Lütfen geçerli bir e-posta adresi gir!"),
        ),
      );
      return; // Geçerli bir e-posta adresi girilmediği için fonksiyonu sonlandır
    }

    //check password -> creat user
    if (passwordController.text == confirmPasswordController.text) {
      // try creating user
      try {
        await _authService.signUpWithEmailPassword(
            emailController.text,
            passwordController.text,
            nameController.text,
            surnameController.text,
            phoneController.text);
      }

      //display any errors
      catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
    //if password don't match -> show error
    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Şifreler eşleşmiyor, tekrar dene!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
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

                  //message, app slogan
                  Text(
                    "Kaydol",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                  const SizedBox(height: 25),
                  MyTextField(
                    controller: nameController,
                    hintText: "Ad",
                    obscureText: false,
                    icon: Icon(UniconsLine.user),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: surnameController,
                    hintText: "Soyad",
                    obscureText: false,
                    icon: Icon(UniconsLine.user),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: phoneController,
                    hintText: "Telefon",
                    obscureText: false,
                    icon: Icon(UniconsLine.phone),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 10),
                  //email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: "E-Posta",
                    obscureText: false,
                    icon: Icon(UniconsLine.envelope),
                    maxLines: 1,
                  ),

                  const SizedBox(height: 10),
                  //password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: "Şifre",
                    obscureText: false,
                    icon: Icon(UniconsLine.lock_alt),
                    maxLines: 1,
                  ),

                  const SizedBox(height: 10),

                  //confirm password textfield
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Şifreyi Onayla",
                    obscureText: false,
                    icon: Icon(UniconsLine.lock_alt),
                    maxLines: 1,
                  ),

                  const SizedBox(height: 10),
                  //sign up button
                  MyButton(
                    onTap: register,
                    text: "Kaydol",
                  ),

                  const SizedBox(height: 25),
                  // already have an account? login here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Zaten bir hesabın var mı?",
                        style: TextStyle(
                            color:
                                Colors.black),
                      ),
                      const SizedBox(width: 4),
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
