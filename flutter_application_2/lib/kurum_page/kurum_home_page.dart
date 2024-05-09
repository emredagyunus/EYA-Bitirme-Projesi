import 'package:EYA_KURUM/services/auth/auth_gate.dart';
import 'package:EYA_KURUM/services/auth/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EYA_KURUM/kurum_page/complaint_detail_page.dart';
import 'package:EYA_KURUM/kurum_page/kurum_cevap_page.dart';
import 'package:EYA_KURUM/models/complaint.dart';

// ignore: must_be_immutable
class KurumHomePage extends StatelessWidget {
  late  String kurumId;

    void logout() {
    final authService = AuthService();
    authService.signOut();
  }

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
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: (){
              logout();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthGate(),
                    ));
            }
          ),
        ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Onaylanmamış Şikayetler'),
              Tab(text: 'Onaylanmış Şikayetler'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildComplaintList(context, isVisible: true, isResolved: false),
            buildComplaintList(context, isVisible: true, isResolved: true),
          ],
        ),
      ),
    );
  }

  Widget buildComplaintList(BuildContext context,
      {required bool isVisible, required bool isResolved}) {
    User? user = FirebaseAuth.instance.currentUser;
    String? userID = user?.uid;
    kurumId = userID!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('sikayet')
          .where('kurumId', isEqualTo: kurumId)
          .where('isVisible', isEqualTo: isVisible)
          .where('cozuldumu', isEqualTo: isResolved)
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
            child: Text(isResolved
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
                    complaint.description.length > 10
                        ? '${complaint.description.substring(0, 10)}...'
                        : complaint.description,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Cozuldu mu?"),
                      Switch(
                        value: complaint.cozuldumu,
                        activeColor: Colors.deepPurple,
                        onChanged: (newValue) {
                          FirebaseFirestore.instance
                              .collection('sikayet')
                              .doc(complaint.id)
                              .update({'cozuldumu': newValue});
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KurumCevapPage(
                                complaintId: complaint.id,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.add),
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
