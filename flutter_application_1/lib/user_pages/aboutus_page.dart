import 'package:flutter/material.dart';
import 'package:EYA/companents/my_image_box.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hakkımızda',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MyImageBox(),
              /*SizedBox(height: 20),
              Text(
                'Hakkımızda',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),*/
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Engelsiz Yaşam (EYA), güçlü bir topluluk platformudur. Burada, engelli bireylerin günlük yaşamlarında karşılaştığı zorlukları paylaşabilecekleri ve çözüme kavuşturulmasına yardımcı olacakları bir alan bulabilirsin. EYA, sadece engelli bireyler için değil, aynı zamanda onların yakınları ve toplumun her kesimi için açık bir paylaşım alanıdır.\n\nHesap oluşturarak, tanık olduğun şikayetleri kolayca paylaşabilirsin. Bu paylaşımları çeşitli biçimlerde yapabilir, ilgili kuruluşları etiketleyebilir ve sorunların hızlı bir şekilde çözüme kavuşturulmasını sağlayabilirsin. Ayrıca, platformdaki duyuruları takip ederek etkinlikler, seminerler ve bağış kampanyaları gibi faydalı içeriklere de göz atabilirsin.\n\nEngelsiz bir yaşam için hep birlikte adım atmaya ne dersin? Bize katıl ve birlikte daha kapsayıcı bir dünya inşa edelim!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    //fontStyle: FontStyle.italic,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
