import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintModel {
  final String id;
  final String userID;
  final String userName;
  final String userSurname;
  final List<String> imageURLs;
  final List<String> videoURLs;
  final String title;
  final Timestamp timestamp;
  final String description;
  final String il;
  final String ilce;
  final String mahalle;
  final String sokak;
  late int favoritesCount;
  late bool isVisible;
  late bool islemDurumu;
  late bool cozuldumu;
  final String kurum;
  final String cevap;

  ComplaintModel({
    required this.id,
    required this.userID,
    required this.userName,
    required this.userSurname,
    required this.imageURLs,
    required this.videoURLs,
    required this.title,
    required this.timestamp,
    required this.description,
    required this.il,
    required this.ilce,
    required this.mahalle,
    required this.sokak,
    required this.favoritesCount,
    required this.kurum,
    required this.isVisible,
    required this.islemDurumu,
    required this.cozuldumu,
    required this.cevap,
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
      userID: data['userID'] ?? '',
      userName: data['userName'] ?? '',
      userSurname: data['userSurname'] ?? '',
      imageURLs: imageURLs,
      videoURLs: videoURLs,
      title: data['title'] ?? '',
      timestamp: timestamp,
      description: data['description'] ?? '',
      il: data['il'] ?? '',
      ilce: data['ilce'] ?? '',
      mahalle: data['mahalle'] ?? '',
      sokak: data['sokak'] ?? '',
      favoritesCount: data['favoritesCount'] ?? 0,
      isVisible: data['isVisible'] ?? false,
      islemDurumu: data['islemDurumu'] ?? false,
      cozuldumu: data['cozuldumu'] ?? false,
      kurum: data['kurum'] ?? '',
      cevap: data['cevap'] ?? '',
    );
  }
}
