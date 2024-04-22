import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintModel {
  final String id;
  final String userID; // Eklenen alan: Kullanıcı ID'si
  final List<String> imageURLs;
  final List<String> videoURLs; 
  final String title;
  final Timestamp timestamp;
  final String description;
  final String il;
  final String ilce;
  final String mahalle;
  final String sokak;

  ComplaintModel({
    required this.id,
    required this.userID, // Eklenen alan: Kullanıcı ID'si
    required this.imageURLs,
    required this.videoURLs,
    required this.title,
    required this.timestamp,
    required this.description,
    required this.il,
    required this.ilce,
    required this.mahalle,
    required this.sokak,
  });

  factory ComplaintModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Veri alınamadı veya boş.');
    }

    List<String> imageURLs = [];
    if (data['imageURLs'] != null) {
      imageURLs = List<String>.from(data['imageURLs']! as List<dynamic>);
    }

    List<String> videoURLs = [];
    if (data['videoURLs'] != null) {
      videoURLs = List<String>.from(data['videoURLs']! as List<dynamic>);
    }
    Timestamp timestamp = data['timestamp'] ?? Timestamp.now();

    return ComplaintModel(
      id: doc.id,
      userID: data['userID'] ?? '', // Eklenen alan: Kullanıcı ID'si
      imageURLs: imageURLs,
      videoURLs: videoURLs,
      title: data['title'] ?? '', // Varsayılan olarak boş string
      timestamp: timestamp,
      description: data['description'] ?? '', // Varsayılan olarak boş string
      il: data['il'] ?? '', // Varsayılan olarak boş string
      ilce: data['ilce'] ?? '', // Varsayılan olarak boş string
      mahalle: data['mahalle'] ?? '', // Varsayılan olarak boş string
      sokak: data['sokak'] ?? '', // Varsayılan olarak boş string
    );
  }
}

