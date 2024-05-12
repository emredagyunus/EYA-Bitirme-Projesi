import 'package:EYA/companents/customAppBar.dart';
import 'package:EYA/companents/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:EYA/companents/my_button.dart';
import 'package:EYA/companents/number_circle_widget.dart';
import 'package:EYA/user_pages/root_page.dart';

class ComplaintProcessedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      drawer: MediaQuery.of(context).size.width > 600 ? MyDrawer() : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            NumberCircleContainer(
              backgroundColor5: Colors.deepPurple,
              lineColor5: Colors.white,
            ),
            Image.asset('lib/images/eya/logo.png'),
            SizedBox(height: 20),
            Text(
              'Şikayetin İşleme Alındı!',
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
