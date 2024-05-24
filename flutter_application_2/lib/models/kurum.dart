import 'package:cloud_firestore/cloud_firestore.dart';

class Kurum {
  final String id;
  final String name;
  final String userID;
  final String title;
  final Timestamp timestamp;
  final String description;
  final String il;
  final String ilce;
  final String mahalle;
  final String sokak;
  late bool isVisible;

  Kurum({
    required this.id,
    required this.name,
    required this.userID,
    required this.title,
    required this.timestamp,
    required this.description,
    required this.il,
    required this.ilce,
    required this.mahalle,
    required this.sokak,
    required this.isVisible,
  });

  factory Kurum.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Veri alınamadı veya boş.');
    }

  
    Timestamp timestamp = data['timestamp'] ?? Timestamp.now();

    return Kurum(
      id: doc.id,
      userID: data['userID'] ?? '',
      name: data['name'] ?? '',
      title: data['title'] ?? '',
      timestamp: timestamp,
      description: data['description'] ?? '',
      il: data['il'] ?? '',
      ilce: data['ilce'] ?? '',
      mahalle: data['mahalle'] ?? '',
      sokak: data['sokak'] ?? '',
      isVisible: data['isVisible'],
    );
  }
}
