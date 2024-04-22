import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/companents/my_drawer.dart';
import 'package:flutter_application_1/models/complaint.dart';
import 'package:flutter_application_1/pages/complaint_detay.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late User user;
  late CollectionReference favoritesRef;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    favoritesRef = FirebaseFirestore.instance
        .collection('favorites')
        .doc(user.uid)
        .collection('complaints');
  }

  Future<void> removeFromFavorites(String complaintId) async {
    try {
      await favoritesRef.doc(complaintId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Şikayet favorilerden kaldırıldı.'),
        ),
      );
    } catch (e) {
      print('Favoriden kaldırma işlemi başarısız oldu: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Şikayet favorilerden kaldırılırken bir hata oluştu.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favoriler',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: favoritesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Veriler alınırken bir hata oluştu.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Henüz favori şikayet yok.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot complaintDoc = snapshot.data!.docs[index];
              Map<String, dynamic> complaintData =
                  complaintDoc.data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComplaintDetailPage(
                        complaint: ComplaintModel(
                          id: complaintData['id'],
                          userID: complaintData['userId'],
                          imageURLs:
                              List<String>.from(complaintData['imageURLs']),
                          videoURLs:
                              List<String>.from(complaintData['videoURLs']),
                          title: complaintData['title'],
                          timestamp: complaintData['timestamp'],
                          description: complaintData['description'],
                          il: complaintData['il'],
                          ilce: complaintData['ilce'],
                          mahalle: complaintData['mahalle'],
                          sokak: complaintData['sokak'],
                        ),
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: complaintData['imageURLs'].isNotEmpty
                          ? Image.network(
                              complaintData['imageURLs'][0],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                          : Image.asset("lib/images/eya/logo.png"),
                    ),
                    title: Text(complaintData['title']),
                    subtitle: Text(
                      complaintData['description'].length > 50
                          ? '${complaintData['description'].substring(0, 50)}...'
                          : complaintData['description'],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        removeFromFavorites(complaintData['id']);
                      },
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
