import 'package:EYA/companents/customAppBar.dart';
import 'package:EYA/companents/my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:EYA/companents/my_button.dart';
import 'package:EYA/companents/my_textfield.dart';
import 'package:unicons/unicons.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      drawer: MediaQuery.of(context).size.width > 600 ? MyDrawer() : null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'SSS'),
                Tab(text: 'Mesaj Formu'),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height - kToolbarHeight - 50, 
              child: TabBarView(
                controller: _tabController,
                children: [
                  FAQSection(),
                  FeedbackForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 30),
        ExpansionTile(
          title: Text('Sorulacak Soru 1'),
          children: <Widget>[
            ListTile(
              title: Text('Cevabı 1'),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('Sorulacak Soru 2'),
          children: <Widget>[
            ListTile(
              title: Text('Cevabı 2'),
            ),
          ],
        ),
      ],
    );
  }
}


class FeedbackForm extends StatelessWidget {

  Future<void> saveForm() async {
    try {
      await FirebaseFirestore.instance.collection('sssForm').add({
        'name': nameController.text,
        'phone': surnameController.text,
        'mail': emailController.text,
        'description': descriptionController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      nameController.clear();
      surnameController.clear();
      emailController.clear();
      descriptionController.clear();
    } catch (e) {
      print('Hata: $e');
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Mesaj Formu',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                MyTextField(
                  controller: nameController,
                  hintText: 'Ad',
                  obscureText: false,
                  icon: Icon(UniconsLine.user),
                  maxLines: 1,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: surnameController,
                  hintText: 'Soyad',
                  obscureText: false,
                  icon: Icon(UniconsLine.user),
                  maxLines: 1,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: emailController,
                  hintText: 'E-Posta',
                  obscureText: false,
                  icon: Icon(UniconsLine.envelope),
                  maxLines: 1,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: descriptionController,
                  hintText: 'Mesaj',
                  obscureText: false,
                  maxLines: 4,
                  icon: Icon(UniconsLine.bars),
                ),
                SizedBox(height: 50),
                MyButton(text: "Gönder",onTap: (){},)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
