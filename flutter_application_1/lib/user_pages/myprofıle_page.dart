import 'package:EYA/companents/customAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:EYA/companents/my_drawer.dart';
import 'package:EYA/user_pages/profile_edit_page.dart';
import 'package:unicons/unicons.dart';

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
        if (mounted) {
          setState(() {
            ad = userData['name'];
            soyad = userData['surname'];
            telefon = userData['phone'];
            mail = user!.email!;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      drawer: MyDrawer(),
      appBar: customAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            width: isWideScreen ? 500 : double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: isWideScreen ? 50.0 : 20.0,
                vertical: isWideScreen ? 50.0 : 20.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.deepPurple),
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(
                    UniconsLine.user_circle,
                    color: Colors.deepPurple,
                    size: 75,
                  ),
                ),
                const SizedBox(height: 20),
                itemProfile('Ad', ad, UniconsLine.user),
                const SizedBox(height: 10),
                itemProfile('Soyad', soyad, UniconsLine.user),
                const SizedBox(height: 10),
                itemProfile('Telefon', telefon, UniconsLine.phone),
                const SizedBox(height: 10),
                itemProfile('E-Posta', mail, UniconsLine.envelope),
                const SizedBox(height: 20),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                UniconsLine.pen,
                                color: Colors.deepPurple,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Profilini Düzenle',
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
