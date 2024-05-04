import 'package:flutter/material.dart';
import 'package:EYA_KURUM/companents/my_button.dart';
import 'package:EYA_KURUM/companents/number_circle_widget.dart';
import 'package:EYA_KURUM/kurum_page/kurum_home_page.dart';

class KurumOnayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Şikayet İşleme Alındı',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NumberCircleContainer(
              backgroundColor2: Colors.deepPurple,
              lineColor2: Colors.white,
            ),
            Image.asset('lib/images/eya/logo.png'),
            SizedBox(height: 20),
            Text(
              'Cevabiniz yayinlanmistir',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Eya',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            MyButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KurumHomePage(),
                  ),
                );
              },
              text: "Anasayfa",
            ),
          ],
        ),
      ),
    );
  }
}
