import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class DonationPage extends StatelessWidget {
  DonationPage({super.key});

  final List<Map<String, String>> campaignData = [
    {
      "image": "lib/images/eya/kizilay.jpg",
      "title": "Türk Kızılay",
      "description":
          "Ülkemizde ve dünyada ihtiyaç sahiplerine yönelik insani yardım faaliyetlerine destek olabilirsin! Bağış sayfasına gitmek için tıkla!",
      "url": "https://bagis.kizilay.org.tr/tr",
    },
    {
      "image": "lib/images/eya/te.jpg",
      "title": "Türk Eğitim Vakfı",
      "description":
          "Ülkemizin başarılı gençleri okumak istiyor, okutmak ister misin? Bağış sayfasına gitmek için tıkla!",
      "url": "https://www.tev.org.tr/bagis/tr",
    },
    {
      "image": "lib/images/eya/yesilay.jpg",
      "title": "Yeşilay",
      "description":
          "İyi ve sağlıklı yaşam farkındalığı kazandırarak geleceğimizi bağımlılıklardan korumak amacıyla sen de destek olabilirsin! Bağış sayfasına gitmek için tıkla!",
      "url": "https://www.yesilay.org.tr/tr/bagis-yap",
    },
    {
      "image": "lib/images/eya/tegv.jpg",
      "title": "Türkiye Eğitim Gönüllüleri Vakfı",
      "description":
          "Bağış Yap; Bir Çocuk Değişsin, Türkiye Gelişsin! Bağış sayfasına gitmek için tıkla!",
      "url": "https://tegv.org/bagis-yap",
    },
    {
      "image": "lib/images/eya/haytap.jpg",
      "title": "HAYTAP",
      "description":
          "Türkiye'nin hayvan hakları konusunda kurulmuş ilk federasyonu olan HAYTAP'a yapacağınız bağışlar, ülkenin dört bir yanındaki muhtaç hayvanlara yardım olarak ulaşacaktır. Bağış sayfasına gitmek için tıkla!",
      "url": "https://fonzip.com/haytap/bagis",
    },
    {
      "image": "lib/images/eya/tocev.jpg",
      "title": "TOÇEV",
      "description":
          "Daha çok çocuğumuzun bugünü güzel yaşaması ve güzel bir gelecek düşlemesi için destekte bulunarak, daha umutlu bir yarın hayalimize sen de ortak olabilirsin! Bağış sayfasına gitmek için tıkla!",
      "url": "https://www.tocev.org.tr/bagis/",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 254),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          'Bağış Kanalları',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 9 / 16,
          ),
          itemCount: campaignData.length,
          itemBuilder: (context, int i) {
            final campaign = campaignData[i];
            return GestureDetector(
              onTap: () {
                _launchURL(campaign["url"]!);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 187, 175, 189),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 253, 240, 240),
                      blurRadius: 5,
                      offset: Offset(3, 3),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Image.asset(
                      campaign["image"]!, 
                      height: 100, 
                      width: double.infinity, 
                      fit: BoxFit.cover, 
                    ),
                    const SizedBox(height: 8),
                    Text(
                      textAlign: TextAlign.center,
                      campaign["title"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        campaign["description"]!,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void _launchURL(String url) async {
  // ignore: deprecated_member_use
  if (await canLaunch(url)) {
    // ignore: deprecated_member_use
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
