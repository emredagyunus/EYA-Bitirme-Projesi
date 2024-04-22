import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/companents/my_button.dart';
import 'package:flutter_application_1/companents/my_textfield.dart';
import 'package:flutter_application_1/companents/number_circle_widget.dart';
import 'package:flutter_application_1/pages/sikayet_2.dart';

class SikayetIlkPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> addSikayetToFirestore(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? userID = user?.uid;

    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hata'),
            content: Text('Başlık veya açıklama boş olamaz.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Uyarıyı kapat
                },
                child: Text('Tamam'),
              ),
            ],
          );
        },
      );
    } else {
      // ImageAdd sayfasına verileri göndermeden geçiş yapın
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImageAdd(
            title: titleController.text,
            description: descriptionController.text,
            userID: userID!,
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
              title: Text('Emin misiniz?'),
              content:
                  Text('Şikayeti iptal etmek istediğinizden emin misiniz?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Hayır seçeneği için pop(false)
                  },
                  child: Text('Hayır'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Evet seçeneği için pop(true)
                  },
                  child: Text('Evet'),
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Şikayet Oluşturma Sayfası'),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
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
                hintText: 'Şikayet Başlığı',
                obscureText: false,
                icon: Icon(Icons.title),
              ),
              SizedBox(height: 10.0),
              Text(
                'Şikayetiniz',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              MyTextField(
                controller: descriptionController,
                hintText: 'Şikayetinizin detaylarını buraya yazınız...',
                obscureText: false,
                icon: Icon(Icons.read_more),
                maxLines: 10,
              ),
              SizedBox(
                height: 50,
              ),
              MyButton(
                onTap: () {
                  addSikayetToFirestore(context);
                },
                text: "devam et",
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
