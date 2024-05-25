import 'package:EYA/admin_pages/admin_blog_detail_page.dart';
import 'package:EYA/models/Blog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isWideScreen = screenSize.width > 1250;
    final bool isTablet = screenSize.width > 600 && screenSize.width <= 1250;

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
              child: Text('Hiçbir blog yazısı bulunamadı!'),
            );
          }

          List<Blog> blog = snapshot.data!.docs.map((doc) {
            return Blog.fromFirestore(doc);
          }).toList();

          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isWideScreen ? 6 : isTablet ? 4 : 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 9,
              childAspectRatio: isWideScreen ? 0.75 : isTablet ? 0.8 : 0.75,
            ),
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
                  margin: EdgeInsets.all(1),
                  child: Hero(
                    tag: currentBlog.id,
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
                              child: currentBlog.imageURLs.isNotEmpty
                                  ? Image.network(
                                      currentBlog.imageURLs[0],
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
                                  currentBlog.title.length>50
                                  ? '${currentBlog.description.substring(0, 50).trim()}...'
                                      : currentBlog.description.trim(),
                                  style: TextStyle(
                                    fontSize: isWideScreen ? 13 : 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  currentBlog.description.length > 50
                                      ? '${currentBlog.description.substring(0, 50).trim()}...'
                                      : currentBlog.description.trim(),
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
                                            BlogDetailPage(
                                          blog: currentBlog,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Detay',
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
      ),
    );
  }
}
