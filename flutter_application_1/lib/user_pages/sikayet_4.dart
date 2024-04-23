import 'package:flutter/material.dart';
import 'package:flutter_application_1/companents/my_button.dart';
import 'package:flutter_application_1/companents/number_circle_widget.dart';
import 'package:flutter_application_1/user_pages/root_page.dart';

class ComplaintProcessedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /* Timer(Duration(seconds: 10), () {
      Navigator.push(context, MaterialPageRoute(builder:(context) => RootPage(),)); // // Sayfayı kapat
    });*/

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
      body: Column(
        children: [
          NumberCircleContainer(
            backgroundColor4: Colors.deepPurple,
            lineColor4: Colors.white,
          ),
          Image.asset('lib/images/eya/logo.png'),
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RootPage(),
                  ));
            },
            text: "Anasayfa",
          ),
        ],
      ),
    );
  }
}
