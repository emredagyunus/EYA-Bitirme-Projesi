// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/sikayet_3.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_application_1/companents/my_button.dart';
import 'package:flutter_application_1/companents/number_circle_widget.dart';

class ImageAdd extends StatefulWidget {
  final void Function()? onTap;
  final String title;
  final String description;
  final String userID;

  ImageAdd({
    Key? key,
    this.onTap,
    required this.title,
    required this.description,
    required this.userID,
  }) : super(key: key);

  @override
  State<ImageAdd> createState() => _ImageAddState();
}

class _ImageAddState extends State<ImageAdd> {
  List<File?> images = [];
  List<File?> videos = [];
  final picker = ImagePicker();

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
    List<String> imageURLs = [];
    List<String> videoURLs = [];

    // Resimleri yükle
    for (int i = 0; i < images.length; i++) {
      final File? file = images[i];
      final String fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + i.toString();

      final firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('sikayet/$fileName');
      await storageRef.putFile(file!);

      final String downloadURL = await storageRef.getDownloadURL();
      imageURLs.add(downloadURL);
    }

    // Videoları yükle
    for (int i = 0; i < videos.length; i++) {
      final File? file = videos[i];
      final String fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + i.toString();

      final firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('sikayet/videos/$fileName');
      await storageRef.putFile(file!);

      final String downloadURL = await storageRef.getDownloadURL();
      videoURLs.add(downloadURL);
    }

    // Firebase'e yüklenen resim ve video URL'lerini MyLocationPage'e aktar
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyLocationPage(
          title: widget.title,
          description: widget.description,
          userID: widget.userID,
          imageURLs: imageURLs,
          videoURLs: videoURLs,
        ),
      ),
    );
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
                  Text('Şikayeti iptal etmek istediğinizden emin misiniz?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Hayır seçeneği için pop(false)
                  },
                  child: Text('Hayır'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Evet seçeneği için pop(true)
                  },
                  child: Text('Evet'),
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Engelsiz Yaşam'),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
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
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Center(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Image.file(
                      images[index]!,
                      fit: BoxFit.cover,
                    );
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
              text: 'Kaydet',
              onTap: _uploadFiles,
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
