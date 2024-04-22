import 'package:flutter/material.dart';
import 'package:flutter_application_1/companents/my_button.dart';
import 'package:flutter_application_1/companents/my_image_box.dart';
import 'package:flutter_application_1/companents/my_textfield.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Google Maps paketini ekliyoruz

class iletisimPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iletisim'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const MyImageox(),
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
                    icon: Icon(Icons.text_decrease),
                  ),
                ),
                Expanded(
                  child: MyTextField(
                    controller: TextEditingController(),
                    obscureText: false,
                    hintText: 'Telefon Numarasi',
                    icon: Icon(Icons.text_decrease),
                    textAlign: TextAlign.center,
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
                    hintText: 'Mail Adresiniz..',
                    icon: Icon(Icons.text_decrease),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            MyButton(
              text: "Gonder",
              onTap: () {},
            ),
            SizedBox(height: 16),
            Expanded(
  // Google Maps widgeti burada başlıyor
  child: GoogleMap(
    initialCameraPosition: CameraPosition(
      target: LatLng(41.1102, 29.0370), // Ayazağa Mahallesi, Hadım Koruyolu Cd. No:19, Sarıyer / İstanbul koordinatları
      zoom: 15, // Yakınlaştırma seviyesi
    ),
    markers: {
      Marker(
        markerId: MarkerId('Konumum'),
        position: LatLng(41.1102, 29.0370), // Ayazağa Mahallesi, Hadım Koruyolu Cd. No:19, Sarıyer / İstanbul koordinatları
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), // Kırmızı işaretçi
        infoWindow: InfoWindow(
          title: 'Ayazağa, Hadım Koruyolu Cd. No:19, 34398 Sarıyer/İstanbul',
          snippet: 'İşte burası!',
        ),
      ),
    },
    onMapCreated: (GoogleMapController controller) {
      // Harita oluşturulduğunda yapılacak işlemler (opsiyonel)
    },
  ),
),

          ],
        ),
      ),
    );
  }
}
