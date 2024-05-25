import 'package:flutter/material.dart';
import 'package:EYA/models/complaint.dart';
import 'package:EYA/user_pages/complaint_detail_page.dart';
import 'package:EYA/user_pages/complaint_edit_page.dart'; // Eklediğimiz sayfa

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyComplaint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Şikayetlerim',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;
          final bool isWideScreen = screenWidth > 1250;
          final bool isTablet = screenWidth > 600 && screenWidth <= 1250;

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('sikayet')
                .where('userID', isEqualTo: currentUserUid)
                .where('isVisible', isEqualTo: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Bir hata oluştu.'),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('Hiçbir şikayet bulunamadı!'),
                );
              }

              List<ComplaintModel> complaints = snapshot.data!.docs
                  .map((doc) => ComplaintModel.fromFirestore(doc))
                  .toList();

              return GridView.builder(
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWideScreen ? 6 : isTablet ? 4 : 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 9,
                  childAspectRatio: isWideScreen ? 0.75 : isTablet ? 0.55 : 0.75,
                ),
                itemCount: complaints.length,
                itemBuilder: (context, index) {
                  ComplaintModel complaint = complaints[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComplaintDetailPage(
                            complaint: complaint,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(1),
                      child: Hero(
                        tag: complaint.id,
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
                                    : isTablet
                                        ? 4 / 3
                                        : 7 / 2.9,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: complaint.imageURLs.isNotEmpty
                                      ? Image.network(
                                          complaint.imageURLs[0],
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
                                      complaint.title.trim(),
                                      style: TextStyle(
                                        fontSize: isWideScreen ? 13 : 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      complaint.description.length > 50
                                          ? '${complaint.description.substring(0, 50).trim()}...'
                                          : complaint.description.trim(),
                                      style: TextStyle(
                                        fontSize: isWideScreen ? 13 : 14,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ComplaintEditPage(
                                              complaint: complaint,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(

                                        'Düzenle',
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: isWideScreen ? 13 : 14,
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
          );
        },
      ),
    );
  }
}
