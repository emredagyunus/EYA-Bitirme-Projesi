import 'package:flutter/material.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool isEditMode = false;

  String ad = 'John';
  String soyad = 'Doe';
  String telefon = '555-5555';
  String mail = 'john.doe@example.com';
  String sifre = '12345';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Düzenle'),
        actions: [
          IconButton(
            icon: Icon(isEditMode ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildField('Ad', ad),
            buildField('Soyad', soyad),
            buildField('Telefon Numarası', telefon),
            buildField('E-Mail', mail),
            buildField('Şifre', sifre),
          ],
        ),
      ),
    );
  }

  Widget buildField(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.0),
          isEditMode
              ? TextFormField(
                  initialValue: value,
                  onChanged: (newValue) {
                    setState(() {
                      if (label == 'Ad') {
                        ad = newValue;
                      } else if (label == 'Soyad') {
                        soyad = newValue;
                      } else if (label == 'Telefon Numarası') {
                        telefon = newValue;
                      } else if (label == 'E-Mail') {
                        mail = newValue;
                      } else if (label == 'Şifre') {
                        sifre = newValue;
                      }
                    });
                  },
                )
              : Text(value),
        ],
      ),
    );
  }
}
