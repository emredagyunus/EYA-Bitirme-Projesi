import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/complaint.dart';

class ComplaintDetailPage extends StatelessWidget {
  final ComplaintModel complaint; // complaint alanı eklendi

  ComplaintDetailPage({required this.complaint}); // yapılandırıcı metod güncellendi

  @override
  Widget build(BuildContext context) {
    // complaint alanından tüm verilere erişim sağlayabilirsiniz
    return Scaffold(
      appBar: AppBar(
        title: Text('Şikayet Detayı'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Görsel
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                complaint.imageURL[0], 
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            // Başlık
            Text(
              complaint.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Zaman Damgası
            Text(
              'Tarih: ${complaint.timestamp.toDate().day}/${complaint.timestamp.toDate().month}/${complaint.timestamp.toDate().year}',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16),
            // Açıklama
            Text(
              'Şikayet Açıklaması:\n${complaint.description}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            // Konum Bilgileri
            Text(
              'Konum Bilgileri:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'İl: ${complaint.il}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'İlçe: ${complaint.ilce}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Mahalle: ${complaint.mahalle}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Sokak: ${complaint.sokak}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
