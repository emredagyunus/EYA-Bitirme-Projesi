// ignore_for_file: deprecated_member_use

import 'package:EYA/companents/customAppBar.dart';
import 'package:EYA/companents/my_drawer.dart';
import 'package:EYA/models/complaint.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
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
  bool isLocationPanelOpen = false;
  bool isDescriptionExpanded = false;
  bool isAnswerPanelOpen = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoControllers();
    checkIfFavorite();
  }

  void _initializeVideoControllers() {
    widget.complaint.videoURLs.forEach((videoUrl) {
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
            .collection('sikayet')
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
          'isVisible': widget.complaint.isVisible,
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

  void toggleLocationPanel() {
    setState(() {
      isLocationPanelOpen = !isLocationPanelOpen;
    });
  }

  void toggleDescriptionPanel() {
    setState(() {
      isDescriptionExpanded = !isDescriptionExpanded;
    });
  }

  void toggleAnswerPanel() {
    setState(() {
      isAnswerPanelOpen = !isAnswerPanelOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      drawer: MediaQuery.of(context).size.width > 600 ? MyDrawer() : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 1366) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 400, vertical: 0),
              child: _buildComplaintDetails(),
            );
          } else {
            return SingleChildScrollView(
              padding: EdgeInsets.all(30.0),
              child: _buildComplaintDetails(),
            );
          }
        },
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

  Widget _buildComplaintDetails() {
    return Column(
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
        SizedBox(height: 20), // Bu satır boşluk ekler
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding:
                  EdgeInsets.all(8), // Kutucuk içindeki boşluğu ayarlamak için
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 5),
                      color: Colors.black26,
                      spreadRadius: 2,
                      blurRadius: 10),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                    8), // Kutucuk köşelerini yuvarlamak için
                /*border: Border.all(
                    color: Colors.black),*/ // Kutucuk kenarlığını ve rengini ayarlamak için
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Şikayetçi: ",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .black, // "Şikayetçi:" kısmının rengi burada ayarlanır
                      ),
                    ),
                    TextSpan(
                      text: widget.complaint.userName +
                          " " +
                          widget.complaint.userSurname,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors
                            .black, // İsim ve soyisim kısmının rengi burada ayarlanır
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.all(
                  8.0), // Kutucuk içindeki boşluğu ayarlamak için
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 5),
                      color: Colors.black26,
                      spreadRadius: 2,
                      blurRadius: 10),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                    8.0), // Kutucuk köşelerini yuvarlamak için
                /*border: Border.all(
                    color: Colors.black),*/ // Kutucuk kenarlığını ve rengini ayarlamak için
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Tarih: ',
                      style: TextStyle(
                        fontSize: 15,
                        //fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .black, // "Tarih:" kısmının rengi burada ayarlanır
                      ),
                    ),
                    TextSpan(
                      text:
                          '${widget.complaint.timestamp.toDate().day}/${widget.complaint.timestamp.toDate().month}/${widget.complaint.timestamp.toDate().year}',
                      style: TextStyle(
                        fontSize: 15,
                        //fontStyle: FontStyle.italic,
                        //fontWeight: FontWeight.bold,
                        color: Colors
                            .black, // Tarih kısmının rengi burada ayarlanır
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 5),
            Expanded(
              child: Text(
                widget.complaint.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        InkWell(
          onTap: toggleDescriptionPanel,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.complaint.description,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(
                  8.0), // Kutucuk içindeki boşluğu ayarlamak için
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5),
                    color: Colors.black26,
                    spreadRadius: 2,
                    blurRadius: 10,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                    8.0), // Kutucuk köşelerini yuvarlamak için
                /*border: Border.all(
          color: Colors.black),*/ // Kutucuk kenarlığını ve rengini ayarlamak için
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'İlgili Kurum: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '${widget.complaint.kurum}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      //overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: toggleLocationPanel,
              icon: Icon(
                isLocationPanelOpen
                    ? UniconsLine.angle_up
                    : UniconsLine.angle_down,
                size: 20,
              ),
              label: Text(
                'Konum Bilgileri',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
        if (isLocationPanelOpen) ...[
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'İl:',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${widget.complaint.il}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'İlçe:',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${widget.complaint.ilce}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Mahalle:',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${widget.complaint.mahalle}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Sokak:',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${widget.complaint.sokak}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],

        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            InkWell(
              onTap: toggleAnswerPanel,
              child: Row(
                children: [
                  Icon(
                    UniconsLine.university,
                    color: Colors.black,
                    size: 20.0,
                  ),
                  Text(
                    ' Kurumun Yanıtı ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Icon(
                    isAnswerPanelOpen
                        ? UniconsLine.angle_up
                        : UniconsLine.angle_down,
                    color: Colors.black,
                    size: 20.0,
                  ),
                ],
              ),
            ),
            if (isAnswerPanelOpen) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('sikayet')
                      .doc(widget.complaint.id)
                      .collection('cevaplar')
                      .orderBy('timestampkurum', descending: false)
                      .snapshots(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                            Row(
                              children: [
                                Text(
                                  'Tarih: ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .black, // Başlık metnini kalın yapar
                                  ),
                                ),
                                Text(
                                  '$formattedDate',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Kurum: ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight
                                        .bold, // Başlık metnini kalın yapar
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '${widget.complaint.kurum}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Yanıt: ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight
                                        .bold, // Başlık metnini kalın yapar
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '${data['cevap']}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 25),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
            SizedBox(height: 50),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildCarouselItems() {
    List<Widget> items = [];

    // Video controllers varsa, videoları ekler
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
    // Fotoğraflar varsa, fotoğrafları ekler
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
    } else {
      items.add(
        Image.asset(
          "lib/images/eya/logo.png",
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.3,
          fit: BoxFit.cover,
        ),
      );
    }

    return items;
  }
}
