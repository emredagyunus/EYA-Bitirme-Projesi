import 'package:cloud_firestore/cloud_firestore.dart';

class Iletisim {
  final String name;
  final String phone;
  final String mail;
  final String description;
  final Timestamp timestamp;

  Iletisim({
    required this.name,
    required this.phone,
    required this.description,
    required this.mail,
    required this.timestamp,
  });

  factory Iletisim.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    Timestamp timestamp = data['timestamp'] ?? Timestamp.now();

    return Iletisim(
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      description: data['description'] ?? '',
      mail: data['mail'] ?? '',
      timestamp: timestamp,
    );
  }
}
