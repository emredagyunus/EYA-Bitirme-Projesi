import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EYA/admin_pages/admin_blog_detail_page.dart';
import 'package:EYA/models/Blog.dart';

class BlogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Blog',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('blog')
            .where('isVisible', isEqualTo: true)
            .orderBy('timestamp', descending: true)
            .limit(5)
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
              child: Text('Hiç Blog Yazisi bulunamadi.'),
            );
          }

          List<Blog> blog = snapshot.data!.docs.map((doc) {
            return Blog.fromFirestore(doc);
          }).toList();

          return ListView.builder(
            itemCount: blog.length,
            itemBuilder: (context, index) {
              Blog currentBlog = blog[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlogDetailPage(
                        blog: currentBlog,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: currentBlog.imageURLs.isNotEmpty
                          ? Image.network(
                              currentBlog.imageURLs[0],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                          : Image.asset("lib/images/eya/logo.png"),
                    ),
                    title: Text(currentBlog.title),
                    subtitle: Text(
                      currentBlog.description.length > 50
                          ? '${currentBlog.description.substring(0, 62)}...'
                          : currentBlog.description,
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
