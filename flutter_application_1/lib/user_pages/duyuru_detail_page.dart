import 'package:EYA/companents/customAppBar.dart';
import 'package:EYA/companents/my_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:EYA/models/duyuru.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DuyuruDetailPage extends StatefulWidget {
  final Duyuru duyuru;

  DuyuruDetailPage({required this.duyuru});

  @override
  _DuyuruDetailPageState createState() => _DuyuruDetailPageState();
}

class _DuyuruDetailPageState extends State<DuyuruDetailPage> {
  List<VideoPlayerController?> _videoControllers = [];
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }



  Future<void> checkIfFavorite() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String userId = user!.uid;
      DocumentSnapshot favoriteDoc = await FirebaseFirestore.instance
          .collection('favoritesDuyuru')
          .doc(userId)
          .collection('duyuru')
          .doc(widget.duyuru.id)
          .get();

      if (favoriteDoc.exists) {
        setState(() {
          isFavorite = true;
        });
      }
    } catch (e) {
      print('Favori kontrolü yapılırken hata oluştu: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      drawer: MediaQuery.of(context).size.width > 600 ? MyDrawer() : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.3,
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                initialPage: 0,
                enableInfiniteScroll: false,
                reverse: false,
                autoPlay: false,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              items: _buildCarouselItems(),
            ),
            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.duyuru.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'Tarih: ${widget.duyuru.timestamp.toDate().day}/${widget.duyuru.timestamp.toDate().month}/${widget.duyuru.timestamp.toDate().year}',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  widget.duyuru.description,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 16),

            
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCarouselItems() {
    List<Widget> items = [];

    if (widget.duyuru.imageURLs.isNotEmpty) {
      items.addAll(widget.duyuru.imageURLs.map((imageUrls) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            imageUrls,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.cover,
          ),
        );
      }));
    }

    if (_videoControllers.isNotEmpty) {
      items.addAll(_videoControllers.map((controller) {
        if (controller!.value.isInitialized) {
          return GestureDetector(
            onTap: () {
              if (controller.value.isPlaying) {
                controller.pause();
              } else {
                controller.play();
              }
            },
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          );
        } else {
          return Container();
        }
      }));
    }

    return items;
  }
}
