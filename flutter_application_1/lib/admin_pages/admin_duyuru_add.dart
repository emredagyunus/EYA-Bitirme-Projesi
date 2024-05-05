import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:EYA/admin_pages/admin_duyuru_page.dart';
import 'package:EYA/companents/my_button.dart';
import 'package:EYA/companents/my_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:unicons/unicons.dart';

class DuyuruAdd extends StatefulWidget {
  @override
  _DuyuruAddState createState() => _DuyuruAddState();
}

class _DuyuruAddState extends State<DuyuruAdd> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<File> _imageFiles = [];

  Future<void> _saveForm() async {
    try {
      List<String> imageUrls = [];
      for (File imageFile in _imageFiles) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference reference =
            FirebaseStorage.instance.ref().child('images/$fileName');
        UploadTask uploadTask = reference.putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
        String imageUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      await FirebaseFirestore.instance.collection('duyuru').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'imageUrls': imageUrls,
        'isVisible': false,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Form başarıyla kaydedildi.'),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminDuyuruPage()),
      );
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _imageFiles.clear();
      });
    } catch (e) {
      print('Hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Form kaydedilirken bir hata oluştu.'),
      ));
    }
  }

  Future<void> _getImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    // ignore: unnecessary_null_comparison
    if (pickedFiles != null) {
      List<File> pickedImages = [];
      for (var pickedFile in pickedFiles) {
        pickedImages.add(File(pickedFile.path));
      }
      setState(() {
        _imageFiles.addAll(pickedImages);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Duyuru Ekle',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _imageFiles.isNotEmpty
                  ? Container(
                      height: 200,
                      child: CarouselSlider.builder(
                        itemCount: _imageFiles.length,
                        itemBuilder: (context, index, _) {
                          return Image.file(
                            _imageFiles[index],
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                          );
                        },
                        options: CarouselOptions(
                          aspectRatio: 4 / 3,
                          viewportFraction: 1.0,
                          autoPlay: false,
                          enableInfiniteScroll: false,
                        ),
                      ),
                    )
                  : Image.asset('lib/images/eya/logo.png', fit: BoxFit.cover),
              SizedBox(height: 10),
              MyButton(
                onTap: _getImages,
                text: "Resim Seç",
              ),
              SizedBox(height: 20),
              MyTextField(
                controller: _titleController,
                hintText: 'Duyuru Başlığı',
                obscureText: false,
                icon: Icon(UniconsLine.subject),
                maxLines: 1,
              ),
              SizedBox(height: 10),
              MyTextField(
                controller: _descriptionController,
                hintText: 'Duyuru Metni',
                obscureText: false,
                icon: Icon(UniconsLine.bars),
                maxLines: 1,
              ),
              SizedBox(height: 20),
              MyButton(
                onTap: _saveForm,
                text: "Kaydet",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
