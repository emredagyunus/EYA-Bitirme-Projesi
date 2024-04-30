import 'package:flutter/material.dart';

class MailChangingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mail degistirme',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}