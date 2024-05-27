import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sıkça Sorulan Sorular',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FAQSection(),
      ),
    );
  }
}

class FAQSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.width > 600;
    return Center(
      child: Container(
        width: isWideScreen ? 800 : double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: isWideScreen ? 16.0 : 0,
            vertical: isWideScreen ? 50.0 : 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 30),
            ExpansionTile(
              title: Text(
                'EYA platformuna nasıl üye olabilirim?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                      'EYA platformuna üye olmak için giriş ekranında bulunan "Hemen kaydol" yazısına tıklayarak gerekli bilgileri doldurman yeterlidir. E-posta adresini doğruladıktan sonra platforma giriş yapabilirsin.'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'EYA platformunda hangi tür içeriklere ulaşabilirim?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                      'EYA platformunda engelli bireylerin karşılaştığı günlük zorluklar, bu zorlukların çözüm önerileri, ilgili kuruluşlara yönelik şikayetler ve bu konularda deneyim ve bilgi paylaşımlarını yapabilirsin. Ayrıca blog yazıları, duyurular, etkinlikler, seminerler ve bağış kampanyalarına da ulaşabilirsin.'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Şikayetlerimi ilgili kurum ve kuruluşlara nasıl iletebilirim?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                      'Paylaşımlarında ilgili kurum veya kuruluşu seçerek şikayetini doğrudan bu kurum veya kuruluşa iletebilirsin. Bu sayede sorunların daha hızlı bir şekilde çözüme kavuşacaktır.'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'EYA platformunda şikayetler yayınlanmadan önce moderasyon onayından geçiyor mu?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                      'Evet, kullanıcılar tarafından oluşturulan tüm şikayetler topluluk kurallarına uyum sağlayabilmeleri adına moderasyon onayından geçiyor.'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'EYA platformunda etkinlik ve duyuruları nasıl takip edebilirim?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                      'Platformda yer alan "Duyuru" bölümünden etkinlikler, seminerler vb. aktiviteler hakkında bilgi edinebilirsin.'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'EYA platformunda gizlilik ve güvenlik nasıl sağlanıyor?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                      'EYA platformu, kullanıcıların gizliliğini ve güvenliğini ön planda tutar. Kişisel bilgilerin, platformun gizlilik politikası ve kullanım şartları çerçevesinde korunur. Herhangi bir güvenlik sorunu yaşaman durumunda destek ekibimize "İletişim" bölümünden ulaşabilirsin.'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Platforma katkıda bulunmak için neler yapabilirim?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                      'EYA platformuna katkıda bulunmak için çeşitli yollar mevcuttur. Şikayetlerini paylaşabilir, etkinliklere katılabilir, bağış kampanyalarına destek verebilir ve diğer kullanıcıların sorunlarına çözüm bulmalarına yardımcı olabilirsin.'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'EYA platformunda moderasyon nasıl sağlanıyor?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                      'EYA platformunda topluluk kurallarına uyulması konusunda titizlikle çalışan bir moderasyon ekibimiz bulunmaktadır. Uygunsuz içerikler ve davranışlar bildirildiğinde hızla incelenir ve gerekli önlemler alınır. Kullanıcılarımızın güvenli ve saygılı bir ortamda etkileşimde bulunmalarını sağlamak en önemli önceliğimizdir.'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'EYA platformuna hangi kanallar üzerinden erişebilirim?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                      'EYA platformuna Android, iOS, Web üzerinden erişebilir ve tüm özelliklerden kolayca faydalanabilirsin. Engelsiz Yaşam Platformu\'nda sen de yerini al ve daha kapsayıcı bir dünya için adım at!'),
                ),
              ],
            ),
            // Daha fazla soru-cevap ekleyebilirsiniz.
          ],
        ),
      ),
    );
  }
}
