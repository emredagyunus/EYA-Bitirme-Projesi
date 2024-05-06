import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:EYA/user_pages/sikayet_3.dart';
import 'package:EYA/companents/my_button.dart';
import 'package:EYA/companents/number_circle_widget.dart';
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
  List<Uint8List?> images = [];
  List<Uint8List?> videos = [];
  bool _uploading = false;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        images.add(result!.files.first.bytes);
      });
    }
  }

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      setState(() {
        videos.add(result!.files.first.bytes);
      });
    }
  }

  Future<void> _uploadFiles() async {
    setState(() {
      _uploading = true;
    });
    List<String> imageURLs = [];
    List<String> videoURLs = [];

    for (int i = 0; i < images.length; i++) {
      final Uint8List? file = images[i];
      final String uuid = Uuid().v4();
      final String fileName = 'image_$uuid.png';

      final firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('sikayet/$fileName');

      await storageRef.putData(
        file!,
        firebase_storage.SettableMetadata(contentType: 'image/png'),
      );

      final String downloadURL = await storageRef.getDownloadURL();
      imageURLs.add(downloadURL);
    }

    for (int i = 0; i < videos.length; i++) {
      final Uint8List? file = videos[i];
      final String uuid = Uuid().v4();
      final String fileName = 'video_$uuid.mp4';

      final firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('sikayet/videos/$fileName');

      await storageRef.putData(
        file!,
        firebase_storage.SettableMetadata(contentType: 'video/mp4'),
      );

      final String downloadURL = await storageRef.getDownloadURL();
      videoURLs.add(downloadURL);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Engelsiz Yaşam', style: TextStyle(color: Colors.white)),
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
                  if (index < images.length) {
                    return Stack(
                      children: [
                        Image.memory(
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
                      ],
                    );
                  } else {
                    final videoIndex = index - images.length;
                    final videoFile = videos[videoIndex]!;
                    final videoController =
                        VideoPlayerController.file(File.fromRawPath(videoFile));
                    return Stack(
                      children: [
                        FutureBuilder(
                          future: videoController.initialize(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    videoController.play();
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
                onTap: _pickImage,
              ),
              MyButton(
                text: 'Video Ekle',
                onTap: _pickVideo,
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          MyButton(
            text: 'Kaydet',
            onTap: _uploadFiles,
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
