// ignore_for_file: deprecated_member_use

import 'package:EYA/companents/customAppBar.dart';
import 'package:EYA/companents/my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:EYA/companents/my_button.dart';
import 'package:EYA/companents/number_circle_widget.dart';
import 'package:EYA/user_pages/sikayet_5.dart';
import 'package:unicons/unicons.dart';

class KurumEkle extends StatefulWidget {
  final void Function()? onTap;
  final String title;
  final String description;
  final String userID;
  final String userName;
  final String il;
  final String ilce;
  final String mahalle;
  final String sokak;
  final List<String> imageURLs;
  final List<String> videoURLs;
  final String userSurname;

  KurumEkle({
    required this.title,
    required this.description,
    required this.userID,
    required this.userName,
    required this.imageURLs,
    required this.videoURLs,
    required this.il,
    required this.ilce,
    required this.mahalle,
    required this.sokak,
    this.onTap, 
    required this.userSurname,
  });

  @override
  _KurumEkleState createState() => _KurumEkleState();
}

class _KurumEkleState extends State<KurumEkle> {
  List<String> _allNames = [];
  List<String> _filteredNames = [];
  TextEditingController _kurumController = TextEditingController();
  bool _isListVisible = false;

  void _saveToFirebase() async {
    try {
      String kurumId = await _getKurumDosyaId(_kurumController.text);

      var docRef = await FirebaseFirestore.instance.collection('sikayet').add({
        'title': widget.title,
        'description': widget.description,
        'userID': widget.userID,
        'imageURLs': widget.imageURLs,
        'videoURLs': widget.videoURLs,
        'il': widget.il,
        'ilce': widget.ilce,
        'mahalle': widget.mahalle,
        'sokak': widget.sokak,
        'timestamp': FieldValue.serverTimestamp(),
        'favoritesCount': 0,
        'isVisible': false,
        'kurum': _kurumController.text,
        'kurumId': kurumId,
        'islemDurumu': false,
        'cozuldumu': false,
        'cevap': '',
        'userName': widget.userName,
        'userSurname': widget.userSurname,
      });

      // ignore: unused_local_variable
      String docId = docRef.id;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ComplaintProcessedPage(),
        ),
      );
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  Future<String> _getKurumDosyaId(String kurumAdi) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('kurum')
              .where('name', isEqualTo: kurumAdi)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        return '';
      }
    } catch (e) {
      print('Hata oluştu: $e');
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNames();
  }

  Future<void> _loadNames() async {
    List<String> names = await getNameList();
    setState(() {
      _allNames = names;
      _filteredNames = names;
    });
  }

  void _onNameTapped(String name) async {
    try {
      String userID = await _getKurumDosyaId(name);

      setState(() {
        _kurumController.text = name;
        _isListVisible = false;
      });

      print('Seçilen kurumun dosya ID\'si: $userID');
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  void _onTextFieldTapped() {
    setState(() {
      _isListVisible = true;
    });
  }

  void _onTextChanged(String text) {
    setState(() {
      if (text.isEmpty) {
        _filteredNames = _allNames;
      } else {
        List<String> matchingNames = [];
        for (String name in _allNames) {
          String lowercaseName = name.toLowerCase();
          bool isMatch = true;
          int index = 0;
          for (int i = 0; i < text.length; i++) {
            if (index >= lowercaseName.length ||
                lowercaseName[index] != text[i].toLowerCase()) {
              isMatch = false;
              break;
            }
            index++;
          }
          if (isMatch) {
            matchingNames.add(name);
          }
        }
        _filteredNames = matchingNames;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textFieldWidth;
    double listViewWidth;

    if (screenWidth <= 600) {
      // Mobile
      textFieldWidth = screenWidth * 0.9;
      listViewWidth = screenWidth * 0.9;
    } else if (screenWidth <= 1200) {
      // Tablet
      textFieldWidth = screenWidth * 0.7;
      listViewWidth = screenWidth * 0.7;
    } else {
      // Monitor
      textFieldWidth = screenWidth * 0.5;
      listViewWidth = screenWidth * 0.5;
    }

    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Emin misiniz?', textAlign: TextAlign.center,),
              content: Text(
                  'Önceki sayfaya dönmek istediğinizden emin misiniz?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Evet'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Hayır'),
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        appBar: customAppBar(context),
        drawer: MediaQuery.of(context).size.width > 600 ? MyDrawer() : null,
        body: Column(
          children: [
            NumberCircleContainer(
              backgroundColor4: Colors.deepPurple,
              lineColor4: Colors.white,
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: _onTextFieldTapped,
                child: Center(
                  child: AbsorbPointer(
                    absorbing: false,
                    child: Container(
                      width: textFieldWidth,
                      child: TextField(
                        controller: _kurumController,
                        onTap: _onTextFieldTapped,
                        onChanged: _onTextChanged,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.secondary,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 12.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.tertiary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                          labelText: "Kurum Seç",
                          prefixIcon: Icon(UniconsLine.university),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            
            Expanded(
              child: _isListVisible
                  ? SingleChildScrollView(
                      child: Center(
                        child: Container(
                          width: listViewWidth,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredNames.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_filteredNames[index]),
                                onTap: () =>
                                    _onNameTapped(_filteredNames[index]),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
            
            MyButton(
              onTap: _saveToFirebase,
              text: "Gönder",
              width: MediaQuery.of(context).size.width <= 600 ? screenWidth * 0.9 : screenWidth * 0.6,
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

Future<List<String>> getNameList() async {
  List<String> names = [];

  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('kurum').get();

  querySnapshot.docs.forEach((doc) {
    names.add(doc['name']);
  });

  return names;
}
