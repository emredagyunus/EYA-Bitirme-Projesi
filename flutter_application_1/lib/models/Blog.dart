import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  final String id;
  final String title;
  final String description;
  final List<String> imageUrls;
  final Timestamp timestamp;
  late bool isVisible;

  Blog({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.isVisible,
    required this.timestamp,
  });

  factory Blog.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
    return Blog(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      isVisible: data['isVisible'],
      timestamp: timestamp,
    );
  }
}
