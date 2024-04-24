import 'package:cloud_firestore/cloud_firestore.dart';

class Duyuru {
  final String id;
  final String title;
  final String description;
  final List<String> imageURLs;
  final Timestamp timestamp;
  late bool isVisible;

  Duyuru({
    required this.id,
    required this.title,
    required this.description,
    required this.imageURLs,
    required this.isVisible,
    required this.timestamp,
  });

  factory Duyuru.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
    List<String> imageURLs = [];
    if (data['imageURLs'] != null) {
      imageURLs = List<String>.from(data['imageURLs']! as List<dynamic>);
    }
    return Duyuru(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageURLs: List<String>.from(data['imageURLs'] ?? []),
      isVisible: data['isVisible'],
      timestamp: timestamp,
    );
  }
}
