import 'package:EYA/admin_pages/admin_duyuru_detail_page.dart';
import 'package:EYA/models/duyuru.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DuyuruPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Duyuru',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('duyuru')
            .where('isVisible', isEqualTo: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Bir hata oluştu.'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Hiç Duyuru Yok,'),
            );
          }

          List<Duyuru> duyuru = snapshot.data!.docs.map((doc) {
            return Duyuru.fromFirestore(doc);
          }).toList();

          return ListView.builder(
            itemCount: duyuru.length,
            itemBuilder: (context, index) {
              Duyuru currentDuyuru = duyuru[index];
              String limitedDescription = currentDuyuru.description.length > 50
                  ? '${currentDuyuru.description.substring(0, 50)}...'
                  : currentDuyuru.description;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DuyuruDetailPage(
                        duyuru: currentDuyuru,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: screenSize.width > 600 // Ekran genişliği 600'den büyükse
                      ? EdgeInsets.symmetric(horizontal: 500, vertical: 5)
                      : EdgeInsets.symmetric(vertical: 5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.deepPurple), // Kenarlık rengi deeppurple olarak ayarlandı
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: currentDuyuru.imageURLs.isNotEmpty
                            ? Image.network(
                                currentDuyuru.imageURLs[0],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Image.asset("lib/images/eya/logo.png"),
                      ),
                      title: Text(currentDuyuru.title),
                      subtitle: Text(limitedDescription),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
