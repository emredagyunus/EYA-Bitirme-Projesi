import 'package:EYA/companents/customAppBar.dart';
import 'package:EYA/companents/my_drawer.dart';
import 'package:EYA/user_pages/sikayet_2_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:EYA/companents/my_button.dart';
import 'package:EYA/companents/my_textfield.dart';
import 'package:EYA/companents/number_circle_widget.dart';
import 'package:EYA/user_pages/sikayet_2.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SikayetIlkPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> addSikayetToFirestore(BuildContext context) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    String? userID = user?.uid;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(userID).get();
    String name = documentSnapshot.get('name');
    String surname = documentSnapshot.get('surname');

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
      if (kIsWeb) {
        // Web platformundaysa
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ImageAddWeb(
              title: titleController.text,
              description: descriptionController.text,
              userID: userID!,
              userName: name,
              userSurname: surname,
            ),
          ),
        );
      } else {
        // Mobil platformdaysa
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ImageAdd(
              title: titleController.text,
              description: descriptionController.text,
              userID: userID!,
              userName: name,
              userSurname: surname,
            ),
          ),
        );
      }
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
        appBar: customAppBar(context),
        drawer: MediaQuery.of(context).size.width > 600 ? MyDrawer() : null,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 600 ? 500 : 0,
            vertical: 5,
          ), // Küçük ekranlarda padding yok, büyük ekranlarda 500 birimlik yatay padding
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
                maxLines: 1,
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
