import 'package:flutter/material.dart';

class PasswordChangingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sifre degistirme',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}