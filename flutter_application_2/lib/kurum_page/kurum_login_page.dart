import 'package:flutter/material.dart';
import 'package:EYA_KURUM/companents/my_button.dart';
import 'package:EYA_KURUM/companents/my_textfield.dart';
import 'package:EYA_KURUM/kurum_page/kurum_home_page.dart';
import 'package:EYA_KURUM/services/auth/auth_services.dart';

class KurumLoginPage extends StatefulWidget {
  final void Function()? onTap;

  const KurumLoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<KurumLoginPage> createState() => _KurumLoginPageState();
}

class _KurumLoginPageState extends State<KurumLoginPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // login method
  void login() async {
    //get instance of auth services
    final _authService = AuthService();

    //try sign in
    try {
      await _authService.signInWithEmailPasswordKurum(
        nameController.text,
        passwordController.text,
      );
      Navigator.push(context, MaterialPageRoute(builder:(context) => KurumHomePage(),));
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: LayoutBuilder(
          builder: (context, constraints) {
             double screenWidth = constraints.maxWidth;
            double horizontalPadding;
            double verticalPadding = 0.0;  
            if (screenWidth >= 1024) {
               horizontalPadding = 300.0;
            } else {
               horizontalPadding = 20.0;
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: const AssetImage("lib/images/eya/logo.png"),
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.width * 0.25,
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
                      MyTextField(
                        controller: nameController,
                        maxLines: 1,
                        hintText: "Kurum Adı",
                        obscureText: false,
                        icon: const Icon(Icons.mail),
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: passwordController,
                        maxLines: 1,
                        hintText: "Şifre",
                        obscureText: true,
                        icon: const Icon(Icons.password),
                      ),
                      const SizedBox(height: 10),
                      MyButton(
                        onTap: login,
                        text: 'Giriş Yap',
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}