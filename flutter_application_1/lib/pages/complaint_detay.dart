import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_application_1/models/complaint.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintDetailPage extends StatefulWidget {
  final ComplaintModel complaint;

  ComplaintDetailPage({required this.complaint});

  @override
  _ComplaintDetailPageState createState() => _ComplaintDetailPageState();
}

class _ComplaintDetailPageState extends State<ComplaintDetailPage> {
  List<VideoPlayerController?> _videoControllers = [];
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoControllers();
    checkIfFavorite();
  }

  void _initializeVideoControllers() {
    widget.complaint.videoURLs.forEach((videoUrl) {
      // ignore: deprecated_member_use
      final controller = VideoPlayerController.network(videoUrl);
      controller.initialize().then((_) {
        if (mounted) {
          setState(() {
            _videoControllers.add(controller);
            controller.play();
          });
        }
      });
    });
  }

  Future<void> checkIfFavorite() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String userId = user!.uid;
      DocumentSnapshot favoriteDoc = await FirebaseFirestore.instance
          .collection('favorites')
          .doc(userId)
          .collection('complaints')
          .doc(widget.complaint.id)
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

  Future<void> addToFavorites() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    DocumentReference favoriteRef = FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
        .collection('complaints')
        .doc(widget.complaint.id);

    if (isFavorite) {
      await favoriteRef.delete();
      setState(() {
        isFavorite = false;
        widget.complaint.favoritesCount -= 1; // Favorilere eklenme sayısını azalt
      });
    } else {
      await favoriteRef.set({
        'id': widget.complaint.id,
        'userId': widget.complaint.userID,
        'imageURLs': widget.complaint.imageURLs,
        'videoURLs': widget.complaint.videoURLs,
        'title': widget.complaint.title,
        'timestamp': widget.complaint.timestamp,
        'description': widget.complaint.description,
        'il': widget.complaint.il,
        'ilce': widget.complaint.ilce,
        'mahalle': widget.complaint.mahalle,
        'sokak': widget.complaint.sokak,
        'favoritesCount': widget.complaint.favoritesCount + 1, 
      });
      setState(() {
        isFavorite = true;
        widget.complaint.favoritesCount += 1; 
      });
    }
  } catch (e) {
    print('Favorilere eklerken hata oluştu: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Şikayet Detayı',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slider
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
                    widget.complaint.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'Tarih: ${widget.complaint.timestamp.toDate().day}/${widget.complaint.timestamp.toDate().month}/${widget.complaint.timestamp.toDate().year}',
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
                Text(
                  'Şikayet Açıklaması:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  widget.complaint.description,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 16),

            Text(
              'Konum Bilgileri:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'İl:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${widget.complaint.il}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'İlçe:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${widget.complaint.ilce}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Mahalle:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${widget.complaint.mahalle}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Sokak:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${widget.complaint.sokak}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addToFavorites();
        },
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.black : Colors.white,
        ),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  List<Widget> _buildCarouselItems() {
    List<Widget> items = [];

    if (widget.complaint.imageURLs.isNotEmpty) {
      items.addAll(widget.complaint.imageURLs.map((imageUrl) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            imageUrl,
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
