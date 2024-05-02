import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/companents/my_textfield.dart';
import 'package:unicons/unicons.dart';

class PasswordChangingPage extends StatefulWidget {
  @override
  _PasswordChangingPageState createState() => _PasswordChangingPageState();
}

class _PasswordChangingPageState extends State<PasswordChangingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late User? user;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  bool _obscureOldText = true;
  bool _obscureNewText = true;
  bool _obscureConfirmText = true;

  Future<void> changePassword() async {
    if (user != null) {
      // Bilgilerin eksiksiz doldurulup doldurulmadığını kontrol et
      if (oldPasswordController.text.isEmpty ||
          newPasswordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lütfen gerekli tüm bilgileri gir!"),
          ),
        );
        return; // Bilgiler eksik olduğu için fonksiyonu sonlandır
      }

      // Yeni şifrenin onay şifresiyle eşleşip eşleşmediğini kontrol et
      if (newPasswordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Şifreler eşleşmiyor, tekrar dene!!"),
          ),
        );
        return; // Şifreler eşleşmediği için fonksiyonu sonlandır
      }

      // Yeni şifre mevcut şifreyle aynıysa işlem yapma
      if (oldPasswordController.text == newPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Yeni şifre, var olan şifre ile aynı olamaz!"),
          ),
        );
        return; // Yeni şifre mevcut şifreyle aynı olduğu için fonksiyonu sonlandır
      }

      try {
        AuthCredential credential = EmailAuthProvider.credential(
            email: user!.email!, password: oldPasswordController.text.trim());
        await user!.reauthenticateWithCredential(credential);
        await user!.updatePassword(newPasswordController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Şifren başarıyla güncellendi!'),
          ),
        );
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        String errorMessage =
            'Geçersiz şifre! Lütfen var olan şifreyi doğru gir!';

        print(errorMessage);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Şifreni Değiştir',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(UniconsLine.save),
            onPressed: () {
              changePassword();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Şifre',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                MyTextField(
                  controller: oldPasswordController,
                  hintText: 'Şifre',
                  obscureText: _obscureOldText,
                  maxLines: 1,
                  icon: Icon(UniconsLine.lock_alt),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureOldText
                        ? UniconsLine.eye
                        : UniconsLine.eye_slash),
                    onPressed: () {
                      setState(() {
                        _obscureOldText = !_obscureOldText;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Yeni Şifre',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                MyTextField(
                  controller: newPasswordController,
                  hintText: 'Yeni Şifre',
                  obscureText: _obscureNewText,
                  maxLines: 1,
                  icon: Icon(UniconsLine.lock_alt),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNewText
                        ? UniconsLine.eye
                        : UniconsLine.eye_slash),
                    onPressed: () {
                      setState(() {
                        _obscureNewText = !_obscureNewText;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Yeni Şifreyi Onayla',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Yeni Şifreyi Onayla',
                  obscureText: _obscureConfirmText,
                  maxLines: 1,
                  icon: Icon(UniconsLine.lock_alt),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmText
                        ? UniconsLine.eye
                        : UniconsLine.eye_slash),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmText = !_obscureConfirmText;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: const Text(
                "Var olan şifrenden farklı\nbir şifre girerek yeni\nşifreni kaydet.",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
