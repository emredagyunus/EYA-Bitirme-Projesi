import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/duyuru.dart';

class DuyuruDetailPage extends StatelessWidget {
  final Duyuru duyuru;

  const DuyuruDetailPage({Key? key, required this.duyuru}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Duyuru Detayı',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (duyuru.imageUrls.isNotEmpty)
              Image.network(
                duyuru.imageUrls.first,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            if (duyuru.imageUrls.isEmpty)
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
                  duyuru.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${duyuru.timestamp.toDate().day}/${duyuru.timestamp.toDate().month}/${duyuru.timestamp.toDate().year}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              duyuru.description,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
