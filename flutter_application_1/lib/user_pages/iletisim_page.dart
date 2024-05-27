import 'package:EYA/companents/customAppBar.dart';
import 'package:EYA/companents/my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:EYA/companents/my_button.dart';
import 'package:EYA/companents/my_image_box.dart';
import 'package:EYA/companents/my_textfield.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unicons/unicons.dart';

class iletisimPage extends StatefulWidget {
  @override
  State<iletisimPage> createState() => _iletisimPageState();
}

class _iletisimPageState extends State<iletisimPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> saveForm() async {
    // Bilgilerin eksiksiz doldurulup doldurulmadığını kontrol et
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        mailController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Lütfen gerekli tüm bilgileri gir!"),
          ),
        );
      }
      return;
    }

    // Telefon numarasının geçerli olup olmadığını kontrol et
    if (!isValidPhoneNumber(phoneController.text)) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Lütfen geçerli bir telefon numarası gir!"),
          ),
        );
      }
      return;
    }

    // E-posta adresinin geçerli olup olmadığını kontrol et
    if (!isValidEmail(mailController.text)) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Lütfen geçerli bir e-posta adresi gir!"),
          ),
        );
      }
      return; // Geçerli bir e-posta adresi girilmediği için fonksiyonu sonlandır
    }

    try {
      await FirebaseFirestore.instance.collection('iletisim').add({
        'name': nameController.text,
        'phone': phoneController.text,
        'mail': mailController.text,
        'description': descriptionController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Mesaj başarıyla gönderildi!'),
      ));
      nameController.clear();
      phoneController.clear();
      mailController.clear();
      descriptionController.clear();
    } catch (e) {
      print('Hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Mesaj gönderilirken bir hata oluştu!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: customAppBar(context),
      drawer: isWideScreen ? MyDrawer() : null,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: isWideScreen ? 1000 : double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: isWideScreen ? 50.0 : 0,
                vertical: isWideScreen ? 50.0 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'İletişim',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MyTextField(
                        controller: nameController,
                        obscureText: false,
                        hintText: 'Ad Soyad',
                        icon: Icon(UniconsLine.user),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: MyTextField(
                        controller: phoneController,
                        obscureText: false,
                        hintText: 'Telefon',
                        icon: Icon(UniconsLine.phone),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MyTextField(
                        controller: mailController,
                        obscureText: false,
                        hintText: 'E-Posta',
                        icon: Icon(UniconsLine.envelope),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MyTextField(
                        controller: descriptionController,
                        obscureText: false,
                        hintText: 'Mesaj',
                        icon: Icon(UniconsLine.bars),
                        maxLines: 5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                MyButton(
                  text: "Gönder",
                  onTap: saveForm,
                ),
                SizedBox(height: 15),
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(41.11739921218435, 29.00383209842172),
                      zoom: 17,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('Konumum'),
                        position: LatLng(41.11739921218435, 29.00383209842172),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed),
                        infoWindow: InfoWindow(
                          title:
                              'Ayazağa, Hadım Koruyolu Cd. No:19, 34398 Sarıyer/İstanbul',
                          snippet: 'İşte burası!',
                        ),
                      ),
                    },
                    onMapCreated: (GoogleMapController controller) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Telefon numarasının geçerli formatta olup olmadığını kontrol eden regex deseni
  bool isValidPhoneNumber(String phoneNumber) {
    RegExp regex = RegExp(r'^0\d{10}$');
    return regex.hasMatch(phoneNumber);
  }

  // E-posta adresinin geçerli formatta olup olmadığını kontrol eden regex deseni
  bool isValidEmail(String email) {
    RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
}
