import 'dart:io';
import 'package:EYA/companents/my_button.dart';
import 'package:EYA/companents/number_circle_widget.dart';
import 'package:EYA/user_pages/sikayet_3.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class ImageAddWeb extends StatefulWidget {
  final void Function()? onTap;
  final String title;
  final String description;
  final String userID;
  final String userName;
  final String userSurname;

  ImageAddWeb({
    Key? key,
    this.onTap,
    required this.title,
    required this.description,
    required this.userID,
    required this.userName,
    required this.userSurname,
  }) : super(key: key);

  @override
  State<ImageAddWeb> createState() => _ImageAddWebState();
}

class _ImageAddWebState extends State<ImageAddWeb> {
  List<File?> images = [];
  List<File?> videos = [];
  bool _uploading = false;
  late VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();
    if (videos.isNotEmpty) {
      final videoFile = videos[0];
      if (videoFile != null) {
        videoController = VideoPlayerController.file(videoFile);
        videoController.initialize().then((_) {
          setState(() {});
        });
      }
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        images.add(File(result.files.first.path!));
      });
    }
  }

  Future<void> _pickVideo() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        final file = File(result.files.first.path!);
        if (file != null) {
          videos.add(file);
        }
      });
    }
  }

  Future<void> _uploadFiles() async {
    setState(() {
      _uploading = true;
    });

    try {
      final List<String> imageURLs = await _uploadImages();
      final List<String> videoURLs = await _uploadVideos();

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
          ),),
      );
    } catch (e, stackTrace) {
      print('Error uploading files: $e');
      print('Stack trace: $stackTrace');
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  Future<List<String>> _uploadImages() async {
    final List<String> imageURLs = [];

    for (int i = 0; i < images.length; i++) {
      final File? file = images[i];
      if (file == null) continue;

      final String uuid = Uuid().v4();
      final String fileName = 'image_$uuid.png';

      final firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('sikayet/$fileName');

      await storageRef.putFile(file).whenComplete(() {
        setState(() {});
      });

      final String downloadURL = await storageRef.getDownloadURL();
      imageURLs.add(downloadURL);
    }

    return imageURLs;
  }

  Future<List<String>> _uploadVideos() async {
    final List<String> videoURLs = [];

    for (int i = 0; i < videos.length; i++) {
      try {
        final File? file = videos[i];
        if (file == null) continue;

        final String uuid = Uuid().v4();
        final String fileName = 'video_$uuid.mp4';

        final firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('sikayet/videos/$fileName');

        await storageRef.putFile(file).whenComplete(() {
          setState(() {});
        });

        final String downloadURL = await storageRef.getDownloadURL();
        videoURLs.add(downloadURL);
      } catch (e, stackTrace) {
        print('Error uploading video at index $i: $e');
        print('Stack trace: $stackTrace');
      }
    }

    return videoURLs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resim veya Video', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
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
                  if (index < images.length + videos.length) {
                    Widget itemWidget;
                    double aspectRatio = 1.0;

                    if (index < images.length) {
                      itemWidget = Image.file(
                        images[index]!,
                        fit: BoxFit.cover,
                      );
                    } else {
                      final videoIndex = index - images.length;
                      final videoFile = videos[videoIndex]!;
                      final videoController = VideoPlayerController.file(videoFile);

                      itemWidget = FutureBuilder(
                        future: videoController.initialize(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            videoController.play();
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  videoController.value.isPlaying
                                      ? videoController.pause()
                                      : videoController.play();
                                });
                              },
                              child: AspectRatio(
                                aspectRatio: videoController.value.aspectRatio,
                                child: VideoPlayer(videoController),
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      );

                      aspectRatio = videoController.value.aspectRatio;
                    }

                    return Stack(
                      children: [
                        itemWidget,
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (index < images.length) {
                                  images.removeAt(index);
                                } else {
                                  final videoIndex = index - images.length;
                                  videos.removeAt(videoIndex);
                                }
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
                    return SizedBox.shrink();
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
                onTap: () => _pickImage(),
              ),
              MyButton(
                text: 'Video Ekle',
                onTap: () => _pickVideo(),
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
    );
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }
}