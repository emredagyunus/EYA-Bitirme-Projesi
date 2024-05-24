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

          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenSize.width > 1250 ? 6 : screenSize.width > 600 ? 4 : 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 9,
              childAspectRatio: screenSize.width > 1250 ? 0.75 : screenSize.width > 600 ? 0.8 : 0.75,
            ),
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
                child: Card(
                  margin: EdgeInsets.all(1),
                  child: Hero(
                    tag: currentDuyuru.id,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: screenSize.width > 1250 ? 4 / 3 : screenSize.width > 600 ? 4 / 3 : 7 / 2.9,
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: currentDuyuru.imageURLs.isNotEmpty
                                  ? Image.network(
                                      currentDuyuru.imageURLs[0],
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      "lib/images/eya/logo.png",
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentDuyuru.title.length > 50 ? '${currentDuyuru.title.substring(0, 50)}...' : currentDuyuru.title,
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
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DuyuruDetailPage(
                                          duyuru: currentDuyuru,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Detay',
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: screenSize.width > 1250 ? 13 : 14,
                                    ),
                                  ),
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
          );
        },
      ),
    );
  }
}
