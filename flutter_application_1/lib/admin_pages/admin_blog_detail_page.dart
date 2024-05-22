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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (blog.imageURLs.isNotEmpty)
                Image.network(
                  blog.imageURLs.first,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              if (blog.imageURLs.isEmpty)
                Image.asset(
                  'lib/images/eya/logo.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    blog.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
