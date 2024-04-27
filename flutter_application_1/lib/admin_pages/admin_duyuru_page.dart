import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_pages/admin_duyuru_add.dart';
import 'package:flutter_application_1/admin_pages/admin_duyuru_detail_page.dart';
import 'package:flutter_application_1/models/duyuru.dart';

class AdminDuyuruPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Admin Duyuru Sayfası',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: false,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Gösterilen Duyuru'),
              Tab(text: 'Gizlenen Duyuru'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDuyuruList(context, isVisible: true),
            _buildDuyuruList(context, isVisible: false),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DuyuruAdd()),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.deepPurple,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildDuyuruList(BuildContext context, {required bool isVisible}) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('duyuru')
          .where('isVisible', isEqualTo: isVisible)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            child: Text(isVisible
                ? 'Gösterilecek veri bulunamadı.'
                : 'Gizlenmiş veri bulunamadı.'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            var duyuru = Duyuru.fromFirestore(doc);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DuyuruDetailPage(duyuru: duyuru),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(duyuru.title),
                  subtitle: Text(duyuru.description),
                  leading: duyuru.imageURLs.isNotEmpty
                      ? Image.network(
                          duyuru.imageURLs.first,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        )
                      : Image.asset(
                          'lib/images/eya/logo.png',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 200,
                        ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        activeColor: Colors.deepPurple,
                        value: duyuru.isVisible,
                        onChanged: (newValue) {
                          FirebaseFirestore.instance
                              .collection('duyuru')
                              .doc(duyuru.id)
                              .update({'isVisible': newValue});
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Emin misiniz?'),
                              content: Text(
                                  'Bu duyuruyu silmek istediğinize emin misiniz?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Hayır'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('duyuru')
                                        .doc(duyuru.id)
                                        .delete();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Evet'),
                                ),
                              ],
                            ),
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
