import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EYA_KURUM/companents/my_button.dart';
import 'package:EYA_KURUM/companents/my_textfield.dart';
import 'package:EYA_KURUM/kurum_page/kurum_onay_page.dart';

class KurumCevapPage extends StatefulWidget {
  final String complaintId;

  KurumCevapPage({required this.complaintId});

  @override
  _KurumCevapPageState createState() => _KurumCevapPageState();
}

class _KurumCevapPageState extends State<KurumCevapPage> {
  final TextEditingController _cevapController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String title = '';
  String description = '';
  List<String> cevaplar = [];

  @override
  void initState() {
    super.initState();
    fetchComplaintDetails();
  }

  void fetchComplaintDetails() async {
    try {
      DocumentSnapshot complaintDoc =
          await _firestore.collection('sikayet').doc(widget.complaintId).get();

      if (complaintDoc.exists) {
        setState(() {
          title = complaintDoc['title'];
          description = complaintDoc['description'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Şikayet bulunamadı.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    }
  }

void _sendCevap(String cevap) async {
  try {
    DateTime now = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(now);

    // Get the userId from the 'sikayet' document
    var sikayetDoc = await _firestore.collection('sikayet').doc(widget.complaintId).get();
    if (!sikayetDoc.exists || !sikayetDoc.data()!.containsKey('userID')) {
      throw Exception('Kullanıcı ID bulunamadı.');
    }
    String userId = sikayetDoc.data()!['userID'];

    // Add answer to 'sikayet' collection
    var docRef = await _firestore
        .collection('sikayet')
        .doc(widget.complaintId)
        .collection('cevaplar')
        .add({
      'cevap': cevap,
      'timestampkurum': timestamp,
      'sikayetId': widget.complaintId,
      'cevapID': '',
    });
    String docId = docRef.id;
    await _firestore
        .collection('sikayet')
        .doc(widget.complaintId)
        .collection('cevaplar')
        .doc(docId)
        .update({
      'cevapID': docId,
    });
    await _firestore.collection('sikayet').doc(widget.complaintId).update({
      'cevap': cevap,
    });


    var favoritesDocSnapshot = await _firestore.collection('favorites').doc(userId).get();
    if (favoritesDocSnapshot.exists) {
      var favoriteDocRef = _firestore
          .collection('favorites')
          .doc(userId)
          .collection('complaints')
          .doc(widget.complaintId);

      var favoriteDoc = await favoriteDocRef.get();
      if (!favoriteDoc.exists) {
        await favoriteDocRef.set({'sikayetId': widget.complaintId});
      }

      var favoriteAnswerRef = await favoriteDocRef.collection('cevaplar').add({
        'cevap': cevap,
        'timestampkurum': timestamp,
        'sikayetId': widget.complaintId,
        'cevapID': '',
      });

      String favoriteDocId = favoriteAnswerRef.id;
      await favoriteDocRef.collection('cevaplar').doc(favoriteDocId).update({
        'cevapID': favoriteDocId,
      });
      await favoriteDocRef.update({
        'cevap': cevap,
      });
    }

    setState(() {
      cevaplar.add(cevap);
    });

    _cevapController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cevap başarıyla kaydedildi.')),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KurumOnayPage(),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cevap gönderirken bir hata oluştu: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kurum Cevap',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title.isNotEmpty ? title : 'Yükleniyor...',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                description.isNotEmpty ? description : 'Yükleniyor...',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: cevaplar.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Cevap ${index + 1}: ${cevaplar[index]}'),
                  );
                },
              ),
              SizedBox(height: 20),
              MyTextField(
                controller: _cevapController,
                maxLines: 10,
                hintText: 'Cevabiniz...',
                obscureText: false,
                icon: Icon(Icons.question_answer),
              ),
              SizedBox(height: 20),
              MyButton(
                onTap: () {
                  String cevap = _cevapController.text.trim();
                  if (cevap.isNotEmpty) {
                    _sendCevap(cevap);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lütfen bir cevap girin.')),
                    );
                  }
                },
                text: 'Gönder',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cevapController.dispose();
    super.dispose();
  }
}
