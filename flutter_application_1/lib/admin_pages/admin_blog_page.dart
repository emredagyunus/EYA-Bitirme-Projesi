import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:EYA/admin_pages/admin_blog_add.dart';
import 'package:EYA/admin_pages/admin_blog_detail_page.dart';
import 'package:EYA/companents/admin_drawer.dart';
import 'package:EYA/models/Blog.dart';

class AdminBlogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Blog Yönet',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          bottom: TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Gösterilen Bloglar'),
              Tab(text: 'Gizlenen Bloglar'),
            ],
          ),
        ),
        drawer: MyAdminDrawer(),
        body: TabBarView(
          children: [
            _buildBlogList(context, isVisible: true),
            _buildBlogList(context, isVisible: false),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BlogAdd()),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.deepPurple,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildBlogList(BuildContext context, {required bool isVisible}) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('blog')
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
            var blog = Blog.fromFirestore(doc);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlogDetailPage(blog: blog),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(blog.title),
                  subtitle: Text(blog.description.substring(0, 50).trim()),
                  leading: blog.imageURLs.isNotEmpty
                      ? Image.network(
                          blog.imageURLs.first,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        )
                      : Image.asset(
                          'lib/images/eya/logo.png',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        activeColor: Colors.deepPurple,
                        value: blog.isVisible,
                        onChanged: (newValue) {
                          FirebaseFirestore.instance
                              .collection('blog')
                              .doc(blog.id)
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
                                  'Bu blog yazısını silmek istediğinize emin misiniz?'),
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
                                        .collection('blog')
                                        .doc(blog.id)
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
