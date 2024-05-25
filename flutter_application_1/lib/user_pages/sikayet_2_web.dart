import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:EYA/companents/customAppBar.dart';
import 'package:EYA/companents/my_drawer.dart';
import 'package:flutter/foundation.dart';
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
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        images.add(result!.files.first.bytes);
      });
    }
  }

  Future<void> _pickVideo() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);

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
          userName: widget.userName,
          userSurname: widget.userSurname,
          imageURLs: imageURLs,
          videoURLs: videoURLs,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     bool isLargeScreen = MediaQuery.of(context).size.width > 1200;

     double horizontalPadding = isLargeScreen ? 500.0 : 0.0;
    double verticalPadding = isLargeScreen ? 5.0 : 0.0;

    return Scaffold(
      appBar: customAppBar(context),
      drawer: isLargeScreen ? MyDrawer() : null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        child: Column(
          children: [
            NumberCircleContainer(
              backgroundColor2: Colors.deepPurple,
              lineColor2: Colors.white,
            ),
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                padding: EdgeInsets.all(8.0),
                crossAxisCount: 3,
                children: List.generate(images.length + videos.length, (index) {
                  if (index < images.length) {
                    return _buildImageBox(index);
                  } else {
                    int videoIndex = index - images.length;
                    return _buildVideoBox(videoIndex);
                  }
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyButton(
                  onTap: _pickImage,
                  text: 'Resim Ekle',
                ),
                MyButton(
                  onTap: _pickVideo,
                  text: 'Video Ekle',
                ),
              ],
            ),
            const SizedBox(height: 10),
            MyButton(
              onTap: _uploadFiles,
              text: 'Kaydet',
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildImageBox(int index) {
    return Stack(
      children: [
        Image.memory(
          images[index]!,
          fit: BoxFit.cover,
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
  }

  Widget _buildVideoBox(int index) {
    return Stack(
      children: [
        VideoPlayerWidget(
          videoBytes: videos[index]!,
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              setState(() {
                videos.removeAt(index);
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
}

class VideoPlayerWidget extends StatefulWidget {
  final Uint8List videoBytes;

  const VideoPlayerWidget({Key? key, required this.videoBytes})
      : super(key: key);
@override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _controller = VideoPlayerController.network(
        Uri.parse('data:video/mp4;base64,' +
                base64Encode(widget.videoBytes).replaceAll('\n', ''))
            .toString(),
      );
    } else {
      final Directory appDocDir = Directory.systemTemp;
      final String appDocPath = appDocDir.path;
      final File videoFile = File('$appDocPath/temp_video.mp4');
      videoFile.writeAsBytesSync(widget.videoBytes);
      _controller = VideoPlayerController.file(videoFile);
    }

    _controller.initialize().then((_) {
      setState(() {});
    });

    _controller.addListener(() {
      if (_controller.value.isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPaused =
        !_controller.value.isPlaying && _controller.value.isInitialized;
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        GestureDetector(
          onTap: () {
            if (_isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
            setState(() {
              _isPlaying = !_isPlaying;
            });
          },
          child: Visibility(
            visible: isPaused,
            child: Center(
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                size: 50,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
