import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationPage extends StatelessWidget {
  DonationPage({Key? key});

  final List<Map<String, String>> campaignData = [
    {
      "image": "lib/images/eya/yesilay.jpg",
      "title": "Yeşilay Bağış Kampanyası",
      "description":
          "Bağımlılıkla mücadele ederek sağlıklı bir toplum için destek verebilirsiniz",
      "url": "https://www.yesilay.org.tr/",
    },
    {
      "image": "lib/images/eya/tegv.jpg",
      "title": "Tegv Bağış Kampanyası",
      "description":
          "Çocukların hayatını değiştiren eğitim projelerine katkıda bulunun",
      "url": "https://www.tegv.org/",
    },
    {
      "image": "lib/images/eya/yesilay.jpg",
      "title": "Yeşilay Bağış Kampanyası",
      "description":
          "Bağımlılıkla mücadele ederek sağlıklı bir toplum için destek verebilirsiniz",
      "url": "https://www.yesilay.org.tr/",
    },
    {
      "image": "lib/images/eya/tegv.jpg",
      "title": "Tegv Bağış Kampanyası",
      "description":
          "Çocukların hayatını değiştiren eğitim projelerine katkıda bulunun",
      "url": "https://www.tegv.org/",
    },
    {
      "image": "lib/images/eya/yesilay.jpg",
      "title": "Yeşilay Bağış Kampanyası",
      "description":
          "Bağımlılıkla mücadele ederek sağlıklı bir toplum için destek verebilirsiniz",
      "url": "https://www.yesilay.org.tr/",
    },
    {
      "image": "lib/images/eya/tegv.jpg",
      "title": "Tegv Bağış Kampanyası",
      "description":
          "Çocukların hayatını değiştiren eğitim projelerine katkıda bulunun",
      "url": "https://www.tegv.org/",
    },
    {
      "image": "lib/images/eya/yesilay.jpg",
      "title": "Yeşilay Bağış Kampanyası",
      "description":
          "Bağımlılıkla mücadele ederek sağlıklı bir toplum için destek verebilirsiniz",
      "url": "https://www.yesilay.org.tr/",
    },
    {
      "image": "lib/images/eya/tegv.jpg",
      "title": "Tegv Bağış Kampanyası",
      "description":
          "Çocukların hayatını değiştiren eğitim projelerine katkıda bulunun",
      "url": "https://www.tegv.org/",
    },
     {
      "image": "lib/images/eya/yesilay.jpg",
      "title": "Yeşilay Bağış Kampanyası",
      "description":
          "Bağımlılıkla mücadele ederek sağlıklı bir toplum için destek verebilirsiniz",
      "url": "https://www.yesilay.org.tr/",
    },
    {
      "image": "lib/images/eya/tegv.jpg",
      "title": "Tegv Bağış Kampanyası",
      "description":
          "Çocukların hayatını değiştiren eğitim projelerine katkıda bulunun",
      "url": "https://www.tegv.org/",
    },

    // Diğer kampanya verileri...
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;
    final crossAxisCount = isMobile ? 2 : 5; 

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 254),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, 
            crossAxisSpacing: 15,
            mainAxisSpacing: 25,
            childAspectRatio: 1.5 / 2.5, 
          ),
          itemCount: campaignData.length,
          itemBuilder: (context, int i) {
            final campaign = campaignData[i];
            return GestureDetector(
              onTap: () {
                _launchURL(campaign["url"]!);
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.deepPurple), 
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 0, 0, 0),
                        blurRadius: 5,
                        offset: Offset(3, 3),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Image.asset(
                          campaign["image"]!,
                          height: isMobile ? 100.0 : 150.0, 
                          width: 280,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 17),
                      Text(
                        campaign["title"]!,
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15), 
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          campaign["description"]!,
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10), 
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            _launchURL(campaign["url"]!);
                          },
                          child: Text("Bağış Yap", style: TextStyle(color: Colors.white)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
                          ),
                        ),
                      ),
                    ],
                  ),
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
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
