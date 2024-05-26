import 'package:EYA/companents/customAppBar.dart';
import 'package:EYA/companents/my_drawer.dart';
import 'package:EYA/main.dart';
import 'package:flutter/foundation.dart';
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
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 1200 ? 500.0 : 0,
          vertical: MediaQuery.of(context).size.width > 1200 ? 5.0 : 0,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NumberCircleContainer(
                backgroundColor5: Colors.deepPurple,
                lineColor5: Colors.white,
              ),
              SizedBox(height: 20),  
              Padding(
                padding: const EdgeInsets.only(top:1.0), 
                child: Image.asset('lib/images/eya/parmak.png', height: 150),  
              ),
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
              SizedBox(height: 300),
              MyButton(
                onTap: () {
                  if(kIsWeb){
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyApp(),
                      ),
                      (route) => route.isFirst,
                    );
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RootPage(
                          initialIndex: 0,
                        ),
                        
                      ),
                      (route) => route.isFirst,
                    );
                  }
                },
                text: "Anasayfa",
              ),
              SizedBox(height: 25),  
            ],
          ),
        ),
      ),
    );
  }
}
