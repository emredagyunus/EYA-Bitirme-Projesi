import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EYA/admin_pages/admin_duyuru_detail_page.dart';
import 'package:EYA/models/duyuru.dart';

class DuyuruPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              Duyuru currentduyuru = duyuru[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DuyuruDetailPage(
                        duyuru: currentduyuru,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: currentduyuru.imageURLs.isNotEmpty
                          ? Image.network(
                              currentduyuru.imageURLs[0],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                          : Image.asset("lib/images/eya/logo.png"),
                    ),
                    title: Text(currentduyuru.title),
                    subtitle: Text(
                      currentduyuru.description.length > 50
                          ? '${currentduyuru.description.substring(0, 62)}...'
                          : currentduyuru.description,
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
