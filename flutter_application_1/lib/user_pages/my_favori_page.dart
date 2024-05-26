import 'package:EYA/companents/customAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EYA/companents/my_drawer.dart';
import 'package:EYA/models/complaint.dart';
import 'package:EYA/user_pages/complaint_detail_page.dart';

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
      appBar: customAppBar(context),
      drawer: MyDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: favoritesRef.where('isVisible', isEqualTo: true).snapshots(),
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
              child: Text('Henüz favori şikayetin yok!'),
            );
          }

          final bool isWideScreen = MediaQuery.of(context).size.width > 1250;
          final bool tablet = MediaQuery.of(context).size.width > 600;

          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: isWideScreen
                ? SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  )
                : tablet
                    ? SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.8,
                      )
                    : SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 9,
                        childAspectRatio: 0.75,
                      ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot complaintDoc = snapshot.data!.docs[index];
              Map<String, dynamic> complaintData =
                  complaintDoc.data() as Map<String, dynamic>;
              List<ComplaintModel> complaints = snapshot.data!.docs.map((doc) {
                return ComplaintModel.fromFirestore(doc);
              }).toList();
               ComplaintModel complaint = complaints[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComplaintDetailPage(
                        complaint: complaint
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Card(
                      margin: EdgeInsets.all(1),
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
                              aspectRatio: isWideScreen
                                  ? 4 / 3
                                  : tablet
                                      ? 4 / 3
                                      : 7 / 2.9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: complaintData['imageURLs'].isNotEmpty
                                    ? Image.network(
                                        complaintData['imageURLs'][0],
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset("lib/images/eya/logo.png"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    complaintData['title'].trim(),
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    complaintData['description'].length > 50
                                        ? '${complaintData['description'].substring(0, 50).trim()}...'
                                        : complaintData['description'].trim(),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      right: 15,
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          removeFromFavorites(complaintData['id']);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
