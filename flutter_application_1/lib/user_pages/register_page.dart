import 'package:flutter/material.dart';
import 'package:flutter_application_1/companents/my_button.dart';
import 'package:flutter_application_1/companents/my_textfield.dart';
import 'package:flutter_application_1/services/auth/auth_services.dart';

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
          title: Text("Password dont match!"),
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
                    "Kayıt Ol",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                  const SizedBox(height: 25),
                  MyTextField(
                    controller: nameController,
                    hintText: "İsim",
                    obscureText: false,
                    icon: Icon(Icons.book),
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: surnameController,
                    hintText: "Soyisim",
                    obscureText: false,
                    icon: Icon(Icons.book),
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: phoneController,
                    hintText: "Telefon",
                    obscureText: false,
                    icon: Icon(Icons.phone),
                  ),
                  const SizedBox(height: 10),
                  //email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                    icon: Icon(Icons.mail),
                  ),

                  const SizedBox(height: 10),
                  //password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: "Şifre",
                    obscureText: false,
                    icon: Icon(Icons.password),
                  ),

                  const SizedBox(height: 10),

                  //confirm password textfield
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Şifre tekrar",
                    obscureText: false,
                    icon: Icon(Icons.password),
                  ),

                  const SizedBox(height: 10),
                  //sign up button
                  MyButton(
                    onTap: register,
                    text: "Kayıt Ol",
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
                                Theme.of(context).colorScheme.inversePrimary),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Hemen giriş yap...",
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
