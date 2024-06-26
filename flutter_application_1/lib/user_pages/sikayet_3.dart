// ignore_for_file: deprecated_member_use
import 'package:EYA/companents/customAppBar.dart';
import 'package:EYA/companents/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:EYA/companents/my_button.dart';
import 'package:EYA/companents/my_textfield.dart';
import 'package:EYA/companents/number_circle_widget.dart';
import 'package:EYA/user_pages/sikayet_4.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unicons/unicons.dart';

class MyLocationPage extends StatefulWidget {
  final String title;
  final String description;
  final String userID;
  final String userName;
  final List<String> imageURLs;
  final List<String> videoURLs;
  final String userSurname;

  MyLocationPage({
    required this.title,
    required this.description,
    required this.userID,
    required this.userName,
    required this.imageURLs,
    required this.videoURLs,
    required this.userSurname,
  });

  @override
  _MyLocationPageState createState() => _MyLocationPageState();
}

class _MyLocationPageState extends State<MyLocationPage> {
  GoogleMapController? mapController;
  Position? _currentPosition;
  String _address = '';
  TextEditingController _ilController = TextEditingController();
  TextEditingController _ilceController = TextEditingController();
  TextEditingController _mahalleController = TextEditingController();
  TextEditingController _sokakController = TextEditingController();

  void submitComplaints() async {
    String il = _ilController.text.trim();
    String ilce = _ilceController.text.trim();
    String mahalle = _mahalleController.text.trim();
    String sokak = _sokakController.text.trim();

    if (il.isNotEmpty &&
        ilce.isNotEmpty &&
        mahalle.isNotEmpty &&
        sokak.isNotEmpty) {
      try {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KurumEkle(
              title: widget.title,
              description: widget.description,
              userID: widget.userID,
              userName: widget.userName,
              imageURLs: widget.imageURLs,
              videoURLs: widget.videoURLs,
              il: il,
              ilce: ilce,
              mahalle: mahalle,
              sokak: sokak,
              userSurname: widget.userSurname,
            ),
          ),
        );
      } catch (e) {
        print('Hata: $e');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Hata'),
              content: Text('.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Tamam'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Uyarı',
              textAlign: TextAlign.center,
            ),
            content: Text('Lütfen tüm şikayet kutularını doldur!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Tamam'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocationPermission();
  }

  void _getLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Uyarı'),
            content: Text('Konum izni verilmedi. Ayarlara gitmek ister misiniz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('İptal'),
              ),
              TextButton(
                onPressed: () => Geolocator.openAppSettings(),
                child: Text('Ayarları Aç'),
              ),
            ],
          );
        },
      );
      return;
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _getCurrentLocation();
    }
  }

  void _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
      _getAddressFromLatLng();
      _onFindLocation();
    } catch (e) {
      print(e);
    }
  }

  void _getAddressFromLatLng() async {
    try {
      if (_currentPosition == null) {
        _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      }

      if (_currentPosition != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        Placemark place = placemarks[0];
        setState(() {
          _address = "${place.administrativeArea}, ${place.subAdministrativeArea}, ${place.subLocality}, ${place.thoroughfare}";
        });

        _ilController.text = _address.split(", ").length > 0 ? _address.split(", ")[0] : "";
        _ilceController.text = _address.split(", ").length > 1 ? _address.split(", ")[1] : "";
        _mahalleController.text = _address.split(", ").length > 2 ? _address.split(", ")[2] : "";
        _sokakController.text = _address.split(", ").length > 3 ? _address.split(", ")[3] : "";
      }
    } catch (e) {
      print(e);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    _onFindLocation();
  }

  // ignore: unused_element
  void _onFindLocation() {
    _getCurrentLocation();
    if (_currentPosition != null && mapController != null) {
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 15,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Emin misiniz?',
                textAlign: TextAlign.center,
              ),
              content: Text('Önceki sayfaya dönmek istediğinizden emin misiniz?'),
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
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 1200 ? 500.0 : 0,
            vertical: MediaQuery.of(context).size.width > 1200 ? 5.0 : 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NumberCircleContainer(
                backgroundColor3: Colors.deepPurple,
                lineColor3: Colors.white,
              ),
              SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.25,
                child: GoogleMap(
                  initialCameraPosition: _currentPosition != null
                      ? CameraPosition(
                          target: LatLng(_currentPosition!.latitude,
                              _currentPosition!.longitude),
                          zoom: 15,
                        )
                      : CameraPosition(
                          target:
                              LatLng(39.070591663885786, 35.203930508888945),
                          zoom: 5,
                        ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: _onMapCreated,
                  markers: _currentPosition != null
                      ? {
                          Marker(
                            markerId: MarkerId("Current Location"),
                            position: LatLng(_currentPosition!.latitude,
                                _currentPosition!.longitude),
                            infoWindow: InfoWindow(
                              title: "Güncel Konumunuz",
                              snippet: _address,
                            ),
                          ),
                        }
                      : {},
                ),
              ),
              SizedBox(height: 20),
              MyTextField(
                controller: _ilController,
                maxLines: 1,
                hintText: "İl",
                obscureText: false,
                icon: Icon(UniconsLine.location_point),
              ),
              SizedBox(height: 16.0),
              MyTextField(
                controller: _ilceController,
                maxLines: 1,
                hintText: "İlçe",
                obscureText: false,
                icon: Icon(UniconsLine.location_point),
              ),
              SizedBox(height: 16.0),
              MyTextField(
                controller: _mahalleController,
                maxLines: 1,
                hintText: "Mahalle",
                obscureText: false,
                icon: Icon(UniconsLine.location_point),
              ),
              SizedBox(height: 16.0),
              MyTextField(
                controller: _sokakController,
                maxLines: 1,
                hintText: "Sokak",
                obscureText: false,
                icon: Icon(UniconsLine.location_point),
              ),
              SizedBox(height: 32.0),
              MyButton(
                text: 'Konumu Bul',
                onTap: _onFindLocation,
              ),
              const SizedBox(height: 15),
              MyButton(
                text: 'Devam Et',
                onTap: submitComplaints,
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
