import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EYA/companents/admin_drawer.dart';
import 'package:EYA/models/complaint.dart';
import 'package:EYA/user_pages/complaint_detail_page.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Şikayetler',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Onaylanmamış Şikayetler'),
              Tab(text: 'Onaylanmış Şikayetler'),
            ],
          ),
        ),
        drawer: MyAdminDrawer(),
        body: TabBarView(
          children: [
            buildComplaintList(context, isVisible: false),
            buildComplaintList(context, isVisible: true),
          ],
        ),
      ),
    );
  }

  Widget buildComplaintList(BuildContext context, {required bool isVisible}) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('sikayet')
          .where('isVisible', isEqualTo: isVisible)
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
            child: Text(isVisible
                ? 'Onaylanmış şikayet bulunamadı.'
                : 'Onaylanmamış şikayet bulunamadı.'),
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
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: complaint.imageURLs.isNotEmpty
                        ? Image.network(
                            complaint.imageURLs[0],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Image.asset("lib/images/eya/logo.png"),
                  ),
                  title: Text(complaint.title),
                  subtitle: Text(
                    complaint.description.length > 50
                        ? '${complaint.description.substring(0, 62)}...'
                        : complaint.description,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: complaint.isVisible,
                        activeColor: Colors.deepPurple,
                        onChanged: (newValue) {
                          FirebaseFirestore.instance
                              .collection('sikayet')
                              .doc(complaint.id)
                              .update({'isVisible': newValue});
                          FirebaseFirestore.instance
                              .collection('favorites')
                              .doc(complaint.userID)
                              .collection("complaints")
                              .doc(complaint.id)
                              .update({'isVisible': newValue});
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Şikayeti Sil'),
                                content: Text(
                                    'Şikayeti silmek istediğinize emin misiniz?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Hayır'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('sikayet')
                                          .doc(complaint.id)
                                          .delete();
                                      FirebaseFirestore.instance
                                          .collection('favorites')
                                          .doc(complaint.userID)
                                          .collection("complaints")
                                          .doc(complaint.id)
                                          .delete();
                                      Navigator.pop(context);
                                    },
                                    child: Text('Evet'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
