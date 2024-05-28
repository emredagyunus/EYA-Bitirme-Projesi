import 'package:flutter/material.dart';
import 'package:EYA/models/duyuru.dart';

class DuyuruDetailPage extends StatelessWidget {
  final Duyuru duyuru;

  const DuyuruDetailPage({Key? key, required this.duyuru}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Duyuru Detay',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              if (duyuru.imageURLs.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.network(
                    duyuru.imageURLs.first,
                    fit: BoxFit.cover,
                    width: 300,
                    height: 150,
                  ),
                ),
              if (duyuru.imageURLs.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'lib/images/eya/duyuru.jpg',
                    fit: BoxFit.cover,
                    width: 500,
                    height: 300,
                  ),
                ),
              Container(
                color: Colors.grey[200],
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(26.0),
                width: MediaQuery.of(context).size.width *
                    (MediaQuery.of(context).size.width > 600 ? 0.5 : 0.9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            duyuru.title,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${duyuru.timestamp.toDate().day}/${duyuru.timestamp.toDate().month}/${duyuru.timestamp.toDate().year}',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.end,
                          ),
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
            ],
          ),
        ),
      ),
    );
  }
}
