import 'package:flutter/material.dart';
import 'package:flutter_application_1/companents/my_button.dart';
import 'package:flutter_application_1/companents/my_image_box.dart';
import 'package:flutter_application_1/companents/my_textfield.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unicons/unicons.dart';

class iletisimPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'İletişim',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const MyImageBox(),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MyTextField(
                    controller: TextEditingController(),
                    obscureText: false,
                    hintText: 'Ad Soyad',
                    icon: Icon(UniconsLine.user),
                    maxLines: 1,
                  ),
                ),
                Expanded(
                  child: MyTextField(
                    controller: TextEditingController(),
                    obscureText: false,
                    hintText: 'Telefon',
                    icon: Icon(UniconsLine.phone),
                    textAlign: TextAlign.center,
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
                    controller: TextEditingController(),
                    obscureText: false,
                    hintText: 'E-Posta',
                    icon: Icon(UniconsLine.envelope),
                    textAlign: TextAlign.center,
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
                    controller: TextEditingController(),
                    obscureText: false,
                    hintText: 'Mesaj',
                    icon: Icon(UniconsLine.bars),
                    textAlign: TextAlign.center,
                    maxLines: 5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            MyButton(
              text: "Gönder",
              onTap: () {},
            ),
            SizedBox(height: 16),
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(41.1102, 29.0370),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('Konumum'),
                    position: LatLng(41.1102, 29.0370),
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
    );
  }
}
