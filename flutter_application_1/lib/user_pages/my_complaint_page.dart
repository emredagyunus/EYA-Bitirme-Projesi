import 'package:EYA/companents/customAppBar.dart';
import 'package:EYA/companents/my_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EYA/models/complaint.dart';
import 'package:EYA/user_pages/complaint_detail_page.dart';

class MyComplaint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: customAppBar(context),
      drawer: MediaQuery.of(context).size.width > 600 ? MyDrawer() : null,
      body: StreamBuilder(
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
              child: Text('Hiç şikayet bulunamadı.'),
            );
          }

          List<ComplaintModel> complaints = snapshot.data!.docs.map((doc) {
            return ComplaintModel.fromFirestore(doc);
          }).toList();

          return ListView.builder(
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
                  margin: EdgeInsets.all(12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: complaint.imageURLs.isNotEmpty
                          ? Image.network(
                              complaint.imageURLs[0],
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.2,
                              fit: BoxFit.cover,
                            )
                          : Image.asset("lib/images/eya/logo.png"),
                    ),
                    title: Text(
                      complaint.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      complaint.description.length > 50
                          ? '${complaint.description.substring(0, 62)}...'
                          : complaint.description,
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
