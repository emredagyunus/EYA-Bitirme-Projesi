import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unicons/unicons.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User? user;

  TextEditingController adController = TextEditingController();
  TextEditingController soyadController = TextEditingController();
  TextEditingController telefonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(user!.uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          adController.text = userData['name'];
          soyadController.text = userData['surname'];
          telefonController.text = userData['phone'];
        });
      }
    }
  }

  Future<void> _updateUserData() async {
    try {
      // Telefon numarasının doğrulaması
      if (telefonController.text.length != 11) {
        // Telefon numarasının 11 karakter olmadığını belirten bir uyarı mesajı
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Telefon numarası 11 karakter olmalıdır.'),
          ),
        );
        return; // Güncellemeyi durdur
      }

      if (user != null) {
        await _firestore.collection('users').doc(user!.uid).update({
          'name': adController.text,
          'surname': soyadController.text,
          'phone': telefonController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil bilgileri başarıyla güncellendi.'),
          ),
        );
        Navigator.pop(context);
      }
    } catch (error) {
      // Hataları yönetme
      print("Kullanıcı verilerini güncelleme hatası: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil bilgilerini güncellerken hata oluştu.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profilini Düzenle',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(UniconsLine.save),
            onPressed: () {
              _updateUserData();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 25),
            _buildSectionTitle('Ad'),
            _buildTextField(adController, UniconsLine.user),
            const SizedBox(height: 25),
            _buildSectionTitle('Soyad'),
            _buildTextField(soyadController, UniconsLine.user),
            const SizedBox(height: 25),
            _buildSectionTitle('Telefon'),
            _buildTextField(telefonController, UniconsLine.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 5),
              color: Colors.black26,
              spreadRadius: 2,
              blurRadius: 10),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: icon == CupertinoIcons.phone
            ? TextInputType.phone // Telefon numarası için özel bir giriş türü
            : TextInputType.text,
        maxLength: icon == CupertinoIcons.phone
            ? 11
            : null, // Telefon numarası için maksimum uzunluk
        decoration: InputDecoration(
          //hintText: controller.text.isEmpty ? 'Değer gir' : controller.text,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
