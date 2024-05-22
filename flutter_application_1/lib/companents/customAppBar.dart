import 'package:EYA/main.dart';
import 'package:EYA/user_pages/all_complaint_page.dart';
import 'package:EYA/user_pages/my_favori_page.dart';
import 'package:EYA/user_pages/myprof%C4%B1le_page.dart';
import 'package:EYA/user_pages/sikayet_1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

PreferredSizeWidget customAppBar(BuildContext context) {
  return AppBar(
    title: Text(
      'E Y A',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    backgroundColor: Colors.deepPurple,
    iconTheme: IconThemeData(color: Colors.white),
    centerTitle: true,
    actions: [
      if (MediaQuery.of(context).size.width > 600)
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.home, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Anasayfa',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesPage()),
                );
              },
              child: Row(
                children: [
                  Icon(UniconsLine.heart_alt, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Favoriler',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllComplaint()),
                );
              },
              child: Row(
                children: [
                  Icon(UniconsLine.sort_amount_down, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Tum sikayetler',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error');
                }
                var userData = snapshot.data!.data() as Map<String, dynamic>;
                var fullName = "${userData['name']} ${userData['surname']}";

                return TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyProfilePage()),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(UniconsLine.user_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        fullName,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SikayetIlkPage()),
                );
              },
              child: Row(
                children: [
                  Icon(UniconsLine.plus, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Sikayet yaz',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
    ],
  );
}
