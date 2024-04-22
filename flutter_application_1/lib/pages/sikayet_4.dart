import 'package:flutter/material.dart';
import 'package:flutter_application_1/companents/my_button.dart';
import 'package:flutter_application_1/companents/number_circle_widget.dart';
import 'package:flutter_application_1/pages/root_page.dart';

class ComplaintProcessedPage extends StatelessWidget {
  @override
 Widget build(BuildContext context) {
    /* Timer(Duration(seconds: 10), () {
      Navigator.push(context, MaterialPageRoute(builder:(context) => RootPage(),)); // // Sayfayı kapat
    });*/

    return Scaffold(
      appBar: AppBar(
        title: Text('Şikayet İşleme Alındı'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        automaticallyImplyLeading: false, // Geri dönme butonunu kaldırır
      ),
      body: Column(
        children: [
           NumberCircleContainer(
              backgroundColor4: Colors.deepPurple,
              lineColor4: Colors.white,
            ),
          Image.asset('lib/images/eya/logo.png'), // Logo buraya eklenecek
          SizedBox(height: 20),
          Text(
            'Şikayetiniz İşleme Alınmıştır',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Onaylandıktan sonra yayınlanacaktır.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 30),
          MyButton(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder:(context) => RootPage(),)); // Anasayfaya git
            },
            text:"Anasayfa", // Buton metni
          ),
        ],
      ),
    );
  }
}
