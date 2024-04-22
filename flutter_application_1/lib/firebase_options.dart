// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAKrqthgKu9Ssu9IGLjux-tS-ISb73B_tE',
    appId: '1:804087765930:web:a4bd6153950c8c7f26a9d3',
    messagingSenderId: '804087765930',
    projectId: 'food-edfd7',
    authDomain: 'food-edfd7.firebaseapp.com',
    storageBucket: 'food-edfd7.appspot.com',
    measurementId: 'G-GDCHXZWXJT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDMQ69NDQOeDKx48O5W5Ea3bGWbe2fwCkY',
    appId: '1:804087765930:android:a74ed7617d8b79d726a9d3',
    messagingSenderId: '804087765930',
    projectId: 'food-edfd7',
    storageBucket: 'food-edfd7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDuTxWyKdDU9tidLXvo9HOxiBprLlupqkw',
    appId: '1:804087765930:ios:218fa0b4235e953826a9d3',
    messagingSenderId: '804087765930',
    projectId: 'food-edfd7',
    storageBucket: 'food-edfd7.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDuTxWyKdDU9tidLXvo9HOxiBprLlupqkw',
    appId: '1:804087765930:ios:7a68f6b38bc7dcda26a9d3',
    messagingSenderId: '804087765930',
    projectId: 'food-edfd7',
    storageBucket: 'food-edfd7.appspot.com',
    iosBundleId: 'com.example.flutterApplication1.RunnerTests',
  );
}
