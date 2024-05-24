// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:EYA/companents/customAppBar.dart';
import 'package:EYA/companents/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:EYA/user_pages/sikayet_3.dart';
import 'package:EYA/companents/my_button.dart';
import 'package:EYA/companents/number_circle_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class ImageAdd extends StatefulWidget {
  final void Function()? onTap;
  final String title;
  final String description;
  final String userID;
  final String userName;
  final String userSurname;

  ImageAdd({
    Key? key,
    this.onTap,
    required this.title,
    required this.description,
    required this.userID,
    required this.userName,
    required this.userSurname,
  }) : super(key: key);

  @override
  State<ImageAdd> createState() => _ImageAddState();
}

class _ImageAddState extends State<ImageAdd> {
  List<File?> images = [];
  List<File?> videos = [];
  final picker = ImagePicker();
  late VideoPlayerController _controller;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(''));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await picker.pickImage(source: source);
    setState(() {
      if (pickedImage != null) {
        images.add(File(pickedImage.path));
      }
    });
  }

  Future<void> _pickVideo(ImageSource source) async {
    final pickedVideo = await picker.pickVideo(source: source);
    setState(() {
      if (pickedVideo != null) {
        videos.add(File(pickedVideo.path));
      }
    });
  }

 Future<void> _uploadFiles() async {
  setState(() {
    _uploading = true;
  });
  List<String> imageURLs = [];
  List<String> videoURLs = [];

  for (int i = 0; i < images.length; i++) {
    final File? file = images[i];
    final String uuid = Uuid().v4();
    final String fileName = 'image_$uuid.png';

    final firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('sikayet/$fileName');


    await storageRef.putFile(
      file!,
      firebase_storage.SettableMetadata(contentType: 'image/png'),
    );

    final String downloadURL = await storageRef.getDownloadURL();
    imageURLs.add(downloadURL);
  }

  for (int i = 0; i < videos.length; i++) {
    final File? file = videos[i];
    final String uuid = Uuid().v4();
    final String fileName = 'video_$uuid.mp4'; 

    final firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('sikayet/videos/$fileName');

    await storageRef.putFile(
      file!,
      firebase_storage.SettableMetadata(contentType: 'video/mp4'),
    );

    final String downloadURL = await storageRef.getDownloadURL();
    videoURLs.add(downloadURL);
  }

  if (videos.isNotEmpty) {
    _controller = VideoPlayerController.file(videos[0]!);
    await _initializeVideoPlayer();
  } else {
    _controller = VideoPlayerController.file(File(''));
  }
  setState(() {
    _uploading = false;
  });
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MyLocationPage(
        title: widget.title,
        description: widget.description,
        userID: widget.userID,
        imageURLs: imageURLs,
        videoURLs: videoURLs,
        userName: widget.userName,
        userSurname: widget.userSurname,
      ),
    ),
  );
}

  Future<void> _initializeVideoPlayer() async {
    try {
      await _controller.initialize();
      setState(() {});
    } catch (e) {
      print('Video Player Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Emin misiniz?'),
              content:
                  Text('Önceki sayfaya dönmek istediğinizden emin misiniz?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Evet'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Hayır'),
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        appBar:  customAppBar(context),
        drawer: MediaQuery.of(context).size.width > 600 ? MyDrawer() : null,
        body: Column(
          children: [
            NumberCircleContainer(
              backgroundColor2: Colors.deepPurple,
              lineColor2: Colors.white,
            ),
            const SizedBox(height: 16.0),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Resim veya Video Ekle',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: images.length + videos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (index < images.length) {
                      return Stack(
                        children: [
                          Image.file(
                            images[index]!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  images.removeAt(index);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                  Icons.close,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                          if (_uploading)
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      );
                    } else {
                      final videoIndex = index - images.length;
                      final videoFile = videos[videoIndex]!;
                      final videoController =
                          VideoPlayerController.file(videoFile);
                      return Stack(
                        children: [
                          FutureBuilder(
                            future: videoController.initialize(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                     videoController.play();
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      videoController.play();
                                    });
                                  },
                                  child: AspectRatio(
                                    aspectRatio: 1.0,
                                    child: VideoPlayer(videoController),
                                  ),
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  videos.removeAt(videoIndex);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                  Icons.close,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                          if (_uploading)
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyButton(
                  text: 'Resim Ekle',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
                MyButton(
                  text: 'Video Ekle',
                  onTap: () => _pickVideo(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            MyButton(
              text: 'Devam Et',
              onTap: _uploadFiles,
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
