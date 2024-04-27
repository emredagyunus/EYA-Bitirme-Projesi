import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_pages/admin_home_page.dart';
import 'package:flutter_application_1/companents/my_button.dart';
import 'package:flutter_application_1/companents/my_textfield.dart';
import 'package:flutter_application_1/services/auth/auth_services.dart';

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
          'Kurum ekle',
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
                  hintText: "Kurum Ismi",
                  obscureText: false,
                  icon: Icon(Icons.book),
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: ilController,
                  hintText: "il",
                  obscureText: false,
                  icon: Icon(Icons.book),
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: ilceController,
                  hintText: "ilce",
                  obscureText: false,
                  icon: Icon(Icons.add),
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

                const SizedBox(height: 20),
                //sign up button
                MyButton(
                  onTap: register,
                  text: "Kurum Ekle",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
