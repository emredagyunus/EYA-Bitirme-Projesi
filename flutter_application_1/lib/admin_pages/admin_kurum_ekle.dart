import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_pages/admin_home_page.dart';
import 'package:flutter_application_1/companents/my_button.dart';
import 'package:flutter_application_1/companents/my_textfield.dart';
import 'package:flutter_application_1/services/auth/auth_services.dart';
import 'package:unicons/unicons.dart';

class AdminKurumKayit extends StatefulWidget {
  final void Function()? onTap;

  const AdminKurumKayit({super.key, required this.onTap});

  @override
  State<AdminKurumKayit> createState() => _AdminKurumKayitState();
}

class _AdminKurumKayitState extends State<AdminKurumKayit> {
  final TextEditingController kurumNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ilController = TextEditingController();
  final TextEditingController ilceController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  //register method
  void register() async {
    final _authService = AuthService();

    //check password -> creat user
    if (passwordController.text == confirmPasswordController.text) {
      // try creating user
      try {
        await _authService.signUpWithEmailPasswordKurum(
            emailController.text,
            passwordController.text,
            ilController.text,
            ilceController.text,
            kurumNameController.text);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminHomePage(),
            ));
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kurum Ekle',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
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

                MyTextField(
                  controller: kurumNameController,
                  hintText: "Kurum Adı",
                  obscureText: false,
                  icon: Icon(UniconsLine.university),
                  maxLines: 1,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: ilController,
                  hintText: "İl",
                  obscureText: false,
                  icon: Icon(UniconsLine.location_point),
                  maxLines: 1,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: ilceController,
                  hintText: "İlçe",
                  obscureText: false,
                  icon: Icon(UniconsLine.location_point),
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

                const SizedBox(height: 20),
                //sign up button
                MyButton(
                  onTap: register,
                  text: "Ekle",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
