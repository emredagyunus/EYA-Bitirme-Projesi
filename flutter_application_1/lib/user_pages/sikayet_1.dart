import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/companents/my_button.dart';
import 'package:flutter_application_1/companents/my_textfield.dart';
import 'package:flutter_application_1/companents/number_circle_widget.dart';
import 'package:flutter_application_1/user_pages/sikayet_2.dart';
import 'package:unicons/unicons.dart';

class SikayetIlkPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> addSikayetToFirestore(BuildContext context) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    String? userID = user?.uid;

    Future<String> getName() async {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(userID).get();

      String veri = documentSnapshot.get('name');

      return veri;
    }

    
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Hata',
              textAlign: TextAlign.center,
            ),
            content: Text('Şikayet başlığı veya detayı boş olamaz!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Tamam'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImageAdd(
            title: titleController.text,
            description: descriptionController.text,
            userID: userID!,
            userName: getName().toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Emin misiniz?',
                textAlign: TextAlign.center,
              ),
              content: Text(
                  'Şikayet oluşturmayı iptal etmek istediğinizden emin misiniz?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Evet'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Hayır'),
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Şikayet Oluştur',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumberCircleContainer(
                backgroundColor1: Colors.deepPurple,
                lineColor1: Colors.white,
              ),
              SizedBox(height: 20.0),
              Text(
                'Şikayet Başlığı',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              MyTextField(
                controller: titleController,
                hintText: 'Başlık',
                obscureText: false,
                icon: Icon(UniconsLine.subject),
              ),
              SizedBox(height: 10.0),
              Text(
                'Şikayet Detayı',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              MyTextField(
                controller: descriptionController,
                hintText: 'Detay',
                obscureText: false,
                icon: Icon(UniconsLine.bars),
                maxLines: 10,
              ),
              SizedBox(
                height: 50,
              ),
              MyButton(
                onTap: () {
                  addSikayetToFirestore(context);
                },
                text: "Devam Et",
              ),
              SizedBox(
                height: 130,
              )
            ],
          ),
        ),
      ),
    );
  }
}
