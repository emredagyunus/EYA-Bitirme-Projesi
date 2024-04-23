import 'package:flutter/material.dart';
import 'package:flutter_application_1/companents/my_button.dart';
import 'package:flutter_application_1/companents/my_textfield.dart';

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
      appBar: AppBar(
        title: Text(
          'Sıkça Sorulan Sorular',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // SingleChildScrollView kullanarak ekranı kaydırılabilir yapın
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
              height: MediaQuery.of(context).size.height - kToolbarHeight - 50, // Ekran yüksekliğini alarak içeriği klavye boyutuna göre ayarlayın
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
                  controller: TextEditingController(),
                  hintText: 'adiniz',
                  obscureText: false,
                  icon: Icon(Icons.person),
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: TextEditingController(),
                  hintText: 'soyad',
                  obscureText: false,
                  icon: Icon(Icons.person),
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: TextEditingController(),
                  hintText: 'Email',
                  obscureText: false,
                  icon: Icon(Icons.person),
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: TextEditingController(),
                  hintText: 'Sorunuz..',
                  obscureText: false,
                  maxLines: 4,
                  icon: Icon(Icons.person),
                ),
                SizedBox(height: 50),
                MyButton(text: "Gonder")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
