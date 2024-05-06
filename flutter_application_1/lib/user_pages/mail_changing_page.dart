import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:EYA/companents/my_textfield.dart';
import 'package:unicons/unicons.dart';

class MailChangingPage extends StatefulWidget {
  @override
  _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<MailChangingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late User? user;
  TextEditingController newEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  bool _obscureText = true;

  Future<void> changeEmail() async {
    if (user != null) {
      // Bilgilerin eksiksiz doldurulup doldurulmadığını kontrol et
      if (newEmailController.text.isEmpty || passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lütfen gerekli tüm bilgileri gir!"),
          ),
        );
        return; // Bilgiler eksik olduğu için fonksiyonu sonlandır
      }

      // E-posta adresinin geçerli olup olmadığını kontrol et
      if (!isValidEmail(newEmailController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lütfen geçerli bir e-posta adresi gir!"),
          ),
        );
        return; // Geçerli bir e-posta adresi girilmediği için fonksiyonu sonlandır
      }

      // Yeni e-posta adresi mevcut e-posta adresiyle aynıysa işlem yapma
      if (newEmailController.text == user!.email) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Yeni e-posta adresi, var olan e-posta adresi ile aynı olamaz!"),
          ),
        );
        return; // Yeni e-posta mevcut e-posta ile aynı olduğu için fonksiyonu sonlandır
      }

      try {
        AuthCredential credential = EmailAuthProvider.credential(
            email: user!.email!, password: passwordController.text.trim());
        await user!.reauthenticateWithCredential(credential);
        await user!.verifyBeforeUpdateEmail(newEmailController.text.trim());

        // E-posta adresi değişikliği başarılı oldu, Firestore belgesini güncelle
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user!.uid);
        await userDoc.update({
          'email': newEmailController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('E-posta adresin başarıyla güncellendi!'),
          ),
        );
        Navigator.pop(context);
        // ignore: unused_catch_clause
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Geçersiz şifre! Lütfen doğru şifreyi gir!';

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
          'E-Postanı Değiştir',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(UniconsLine.save),
            onPressed: () {
              changeEmail();
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
                  'E-Posta',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    user?.email ?? '',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Yeni E-Posta',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                MyTextField(
                  controller: newEmailController,
                  hintText: 'Yeni E-Posta',
                  obscureText: false,
                  icon: Icon(UniconsLine.envelope),
                  maxLines: 1,
                ),
              ],
            ),
            const SizedBox(height: 25),
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
                    controller: passwordController,
                    hintText: "Şifre",
                    obscureText: _obscureText,
                    maxLines: 1,
                    icon: const Icon(UniconsLine.lock_alt),
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
              ],
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: const Text(
                "Var olan e-posta adresinden farklı\nbir e-posta adresi girerek yeni\ne-posta adresini kaydet.",
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

// E-posta adresinin geçerli formatta olup olmadığını kontrol eden regex deseni
  bool isValidEmail(String email) {
    RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
}
