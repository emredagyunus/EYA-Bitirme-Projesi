import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:EYA/companents/my_drawer.dart';
import 'package:EYA/user_pages/profile_edit_page.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User? user;

  String ad = '';
  String soyad = '';
  String telefon = '';
  String mail = '';
  String sifre = '';

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(user!.uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          ad = userData['name'];
          soyad = userData['surname'];
          telefon = userData['phone'];
          mail = user!.email!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text(
          'Profil',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            CircleAvatar(
              radius: 50,
              child: Icon(CupertinoIcons.person_fill,
                  color: Colors.white, size: 75),
            ),
            const SizedBox(height: 20),
            itemProfile('İsim', ad, CupertinoIcons.person),
            const SizedBox(height: 10),
            itemProfile('Soyisim', soyad, CupertinoIcons.person),
            const SizedBox(height: 10),
            itemProfile('Telefon numarası', telefon, CupertinoIcons.phone),
            const SizedBox(height: 10),
            itemProfile('E-mail', mail, CupertinoIcons.mail),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return EditProfilePage();
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.deepPurple,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.pen,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                color: Colors.deepPurple,
                spreadRadius: 2,
                blurRadius: 10)
          ]),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        tileColor: Colors.white,
      ),
    );
  }
}
