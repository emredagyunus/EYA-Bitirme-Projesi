import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:EYA_KURUM/models/complaint.dart';
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

      DocumentSnapshot favoriteDoc = await favoriteRef.get();

      if (favoriteDoc.exists) {
        await favoriteRef.delete();
        setState(() {
          isFavorite = false;
          widget.complaint.favoritesCount -= 1;
        });

        await FirebaseFirestore.instance
            .collection('complaints')
            .doc(widget.complaint.id)
            .update({'favoritesCount': FieldValue.increment(-1)});
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
          'favoritesCount': FieldValue.increment(1),
        });
        setState(() {
          isFavorite = true;
          widget.complaint.favoritesCount += 1;
        });
        await FirebaseFirestore.instance
            .collection('sikayet')
            .doc(widget.complaint.id)
            .update({'favoritesCount': FieldValue.increment(1)});
      }
    } catch (e) {
      print('Favorilere eklerken hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
     double screenWidth = MediaQuery.of(context).size.width;
    EdgeInsets padding;

    if (screenWidth > 1024) {
       padding = EdgeInsets.symmetric(horizontal: 300, vertical: 5);
    } else {
       padding = EdgeInsets.all(16.0);
    }

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
        padding: padding,
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
            const SizedBox(height: 25),
            Column(
              children: [
                Container(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "ilgili kurum:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${widget.complaint.kurum}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  'Cevap:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('sikayet')
                        .doc(widget.complaint.id)
                        .collection('cevaplar')
                        .orderBy('timestampkurum', descending: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              'Bir hata oluştu: ${snapshot.error.toString()}'),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final List<DocumentSnapshot> documents =
                          snapshot.data!.docs;

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          final DocumentSnapshot document = documents[index];
                          final data = document.data() as Map<String, dynamic>;

                          DateTime timestamp =
                              (data['timestampkurum'] as Timestamp).toDate();

                          String formattedDate =
                              '${timestamp.day}/${timestamp.month}/${timestamp.year}';

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tarih: $formattedDate',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Kurum: ${widget.complaint.kurum}',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(
                                'Cevap: ${data['cevap']}',
                              ),
                              SizedBox(height: 25),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ],
        ),
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
    if (widget.complaint.imageURLs.isNotEmpty) {
      items.addAll(
        widget.complaint.imageURLs.map((imageUrl) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.cover,
            ),
          );
        }
        ),
      );
    } else {
      items.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            "lib/images/eya/logo.png",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.cover,
          ),
        ),
      );
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