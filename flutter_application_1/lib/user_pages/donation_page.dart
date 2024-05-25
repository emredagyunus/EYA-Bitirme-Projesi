import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
              'Bağış Kanalları',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          padding: EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenSize.width > 1250
                ? 6
                : screenSize.width > 600
                    ? 4
                    : 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 9,
            childAspectRatio: screenSize.width > 1250
                ? 0.75
                : screenSize.width > 600
                    ? 0.55
                    : 0.65,
          ),
          itemCount: campaignData.length,
          itemBuilder: (context, index) {
            final campaign = campaignData[index];
            final description = campaign["description"]!;
            final limitedDescription = description.length > 50
                ? '${description.substring(0, 50)}...'
                : description;

            return GestureDetector(
              onTap: () {
                _launchURL(campaign["url"]!);
              },
              child: Card(
                margin: EdgeInsets.all(1),
                child: Hero(
                  tag: campaign["title"]!,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.deepPurple,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: screenSize.width > 1250
                              ? 4 / 3
                              : screenSize.width > 600
                                  ? 4 / 3
                                  : 7 / 2.9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.asset(
                              campaign["image"]!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                campaign["title"]!.length > 50
                                    ? '${campaign["title"]!.substring(0, 50)}...'
                                    : campaign["title"]!,
                                style: TextStyle(
                                  fontSize: screenSize.width > 1250 ? 13 : 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                limitedDescription,
                                style: TextStyle(
                                  fontSize: screenSize.width > 1250 ? 13 : 14,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _launchURL(campaign["url"]!);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    child: Text(
                                      'Bağış Yap',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            screenSize.width > 1250 ? 13 : 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
