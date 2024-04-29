import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class DonationPage extends StatelessWidget {
  DonationPage({super.key});

  final List<Map<String, String>> campaignData = [
    {
      "image": "lib/images/eya/kizilay.jpg",
      "title": "Kızılay Bağış Kampanyası",
      "description":
          " Çocuklarımıza en hızlı şekilde bağış yaparak onların hayatına dokunmak için bağış yapabilirsiniz.",
      "url": "https://www.kizilay.org.tr/",
    },
    {
      "image": "lib/images/eya/te.jpg",
      "title": "Türk Eğitim Vakfı Bağış Kampanyası",
      "description":
          "Eğitimde fırsat eşitliğini sağlamak için destek olabilirsiniz.",
      "url": "https://tev.org.tr/",
    },
    {
      "image": "lib/images/eya/yesilay.jpg",
      "title": "Yeşilay Bağış Kampanyası ",
      "description":
          "Bağımlılıkla mücadele ederek sağlıklı bir toplum için destek verebilirsiniz",
      "url": "https://www.yesilay.org.tr/",
    },
    {
      "image": "lib/images/eya/tegv.jpg",
      "title": "Tegv Bağış Kampanyası",
      "description":
          "Çocukların hayatını değiştiren eğitim projelerine katkıda bulunabilirsiniz",
      "url": "https://www.tegv.org/",
    },
    {
      "image": "lib/images/eya/haytap.jpg",
      "title": "Haytap Bağış Kampanyası",
      "description":
          "Sokak hayvanlarının yaşam koşullarını iyileştirmek için onlara destek olabilirsiniz",
      "url": "https://www.haytap.org/",
    },
    {
      "image": "lib/images/eya/tocev.jpg",
      "title": "Tocev Bağış Kampanyası ",
      "description":
          "Çozukların eğitimine destek olmak için bağış yapabilirsiniz",
      "url": "https://www.tocev.org.tr/",
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
        title: Row(
          children: [
            Image.asset(
              'lib/images/eya/logo.png',
              scale: 15,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Bağış Kampanyaları',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Colors.white,
              ),
            )
          ],
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
