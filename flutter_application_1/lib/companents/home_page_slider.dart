import 'dart:ui';
import 'package:EYA/models/complaint.dart';
import 'package:EYA/user_pages/complaint_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('sikayet')
          .where('isVisible', isEqualTo: true)
          .orderBy(FieldPath.documentId)
          .limit(20)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Veri alınamadı veya bir hata oluştu.'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Hiç şikayet bulunamadı.'));
        }

        List<ComplaintModel> complaints = snapshot.data!.docs
            .map((doc) => ComplaintModel.fromFirestore(doc))
            .toList();

        return ScrollConfiguration(
          behavior: MyCustomScrollBehavior(),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
              ),
              itemCount: complaints.length,
              itemBuilder: (context, index) {
                ComplaintModel complaint = complaints[index];
                ImageProvider image;
                if (complaint.imageURLs.isNotEmpty &&
                    complaint.imageURLs[0].isNotEmpty) {
                  image = NetworkImage(complaint.imageURLs[0]);
                } else {
                  image = AssetImage('lib/images/eya/logo.png');
                }
                return HomePageSlider(
                  key: ValueKey(complaint.id),
                  image: image,
                  title: complaint.title,
                  description: complaint.description.length > 50
                      ? '${complaint.description.substring(0, 62)}...'
                      : complaint.description, complaint: complaint,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class HomePageSlider extends StatelessWidget {
  final Key key;
  final ImageProvider image;
  final String title;
  final String description;
   final ComplaintModel complaint;

  const HomePageSlider({
    required this.key,
    required this.image,
    required this.title,
    required this.description,
     required this.complaint,
  }) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ComplaintDetailPage(complaint: complaint,)),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: image,
              fit: BoxFit.cover,
            ),
            border: Border.all(color: Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: Colors.black.withOpacity(0.6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      description,
                      style: TextStyle(color: Colors.white, fontSize: 14),
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