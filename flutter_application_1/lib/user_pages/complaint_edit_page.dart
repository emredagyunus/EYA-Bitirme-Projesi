import 'package:EYA/companents/customAppBar.dart';
import 'package:EYA/companents/my_button.dart';
import 'package:EYA/companents/my_textfield.dart';
import 'package:EYA/user_pages/sikayet_5.dart';
import 'package:flutter/material.dart';
import 'package:EYA/models/complaint.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unicons/unicons.dart';

class ComplaintEditPage extends StatefulWidget {
  final ComplaintModel complaint;

  const ComplaintEditPage({Key? key, required this.complaint})
      : super(key: key);

  @override
  _ComplaintEditPageState createState() => _ComplaintEditPageState();
}

class _ComplaintEditPageState extends State<ComplaintEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _ilController;
  late TextEditingController _ilceController;
  late TextEditingController _mahalleController;
  late TextEditingController _sokakController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.complaint.title);
    _descriptionController =
        TextEditingController(text: widget.complaint.description);
    _ilController = TextEditingController(text: widget.complaint.il);
    _ilceController = TextEditingController(text: widget.complaint.ilce);
    _mahalleController = TextEditingController(text: widget.complaint.mahalle);
    _sokakController = TextEditingController(text: widget.complaint.sokak);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ilController.dispose();
    _ilceController.dispose();
    _mahalleController.dispose();
    _sokakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width >= 1200 ? 500 : 16,
          vertical: MediaQuery.of(context).size.width >= 1200 ? 50 : 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              MyTextField(
                controller: _titleController,
                maxLines: 1,
                hintText: 'Şikayet Başlığı',
                obscureText: false,
                icon: Icon(UniconsLine.subject),
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: _descriptionController,
                maxLines: 4,
                hintText: 'Şikayet Detayı',
                obscureText: false,
                icon: Icon(UniconsLine.bars),
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: _ilController,
                maxLines: 1,
                hintText: 'İl',
                obscureText: false,
                icon: Icon(UniconsLine.location_point),
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: _ilceController,
                maxLines: 1,
                hintText: 'İlçe',
                obscureText: false,
                icon: Icon(UniconsLine.location_point),
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: _mahalleController,
                maxLines: 1,
                hintText: 'Mahalle',
                obscureText: false,
                icon: Icon(UniconsLine.location_point),
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: _sokakController,
                maxLines: 1,
                hintText: 'Sokak',
                obscureText: false,
                icon: Icon(UniconsLine.location_point),
              ),
              const SizedBox(height: 30),
              MyButton(
                onTap: () {
                  _updateComplaint();
                },
                text:'Güncelle',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateComplaint() async {
    try {
      await FirebaseFirestore.instance
          .collection('sikayet')
          .doc(widget.complaint.id)
          .update({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'il': _ilController.text,
        'ilce': _ilceController.text,
        'mahalle': _mahalleController.text,
        'sokak': _sokakController.text,
        'isVisible':false,
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ComplaintProcessedPage(),
          ));
    } catch (e) {
      print('Hata oluştu: $e');
     }
  }
}
