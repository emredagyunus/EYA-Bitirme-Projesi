import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintModel {
  final String id;
  final List<String> imageURL;
  final String title;
  final Timestamp timestamp;
  final String description;
  final String il;
  final String ilce;
  final String mahalle;
  final String sokak;

  ComplaintModel({
    required this.id,
    required this.imageURL,
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

  return ComplaintModel(
    id: doc.id,
    imageURL: imageURLs,
    title: data['title'],
    timestamp: data['timestamp'],
    description: data['description'],
    il: data['il'],
    ilce: data['ilce'],
    mahalle: data['mahalle'],
    sokak: data['sokak'],
  );
}
}
