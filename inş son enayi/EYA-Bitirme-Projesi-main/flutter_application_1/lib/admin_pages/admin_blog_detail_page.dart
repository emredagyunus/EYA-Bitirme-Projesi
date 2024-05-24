import 'package:flutter/material.dart';
import 'package:EYA/models/Blog.dart';

class BlogDetailPage extends StatelessWidget {
  final Blog blog;

  const BlogDetailPage({Key? key, required this.blog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Blog Detay',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              if (blog.imageURLs.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.network(
                    blog.imageURLs.first,
                    fit: BoxFit.cover,
                    width: 300,
                    height: 150,
                  ),
                ),
              if (blog.imageURLs.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'lib/images/eya/blog.png',
                    fit: BoxFit.cover,
                    width: 500,
                    height: 300,
                  ),
                ),
              Container(
                color: Colors.grey[200],  
                margin: EdgeInsets.all(16.0),  
                padding: EdgeInsets.all(16.0),  
                width: MediaQuery.of(context).size.width *
                    (MediaQuery.of(context).size.width > 600 ? 0.5 : 0.9),  
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          blog.title,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${blog.timestamp.toDate().day}/${blog.timestamp.toDate().month}/${blog.timestamp.toDate().year}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      blog.description,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
