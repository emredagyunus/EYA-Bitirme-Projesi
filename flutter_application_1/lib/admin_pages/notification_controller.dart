import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> initializeNotification() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const LinuxInitializationSettings linuxSettings =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      linux: linuxSettings,
    );
    await _notificationPlugin.initialize(initSettings);
  }

  static void setupFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        showNotification(notification);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Kullanıcı bildirime tıkladığında yapılacak işlemler
      // Örneğin, ilgili sayfaya yönlendirme yapılabilir.
    });
  }

  static Future<void> showNotification(RemoteNotification notification) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'Genel Bildirimler',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    // Bildirimi göster
    await _notificationPlugin.show(
      notification.hashCode,
      notification.title ?? '',
      notification.body ?? '',
      NotificationDetails(android: androidDetails),
    );
  }

  static Future<void> sendNotification(
      String token, String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'Genel Bildirimler',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      
    );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentSound: true,
      presentBanner: true,
      presentAlert: true,
    );

    const LinuxNotificationDetails linuxDetails = LinuxNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      linux: linuxDetails,
    );

    // Bildirimi gönder
    await _notificationPlugin.show(
      token.hashCode,
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> handleFirestoreData(
      DocumentSnapshot<Map<String, dynamic>> document) async {


    try {
       
      String id = document.id;
      Map<String, dynamic> data = document.data() ?? {};

      String title = data['title'] ?? '';
      String body = data['description'] ?? '';
      String userId = data['userID'] ?? '';

      bool isVisible = data['isVisible'] ?? false;
      bool islemDurumu = data['islemDurumu'] ?? false;
      bool cozuldumu = data['cozuldumu'] ?? false;
      print(isVisible);

      DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
        String deviceToken = userDoc['deviceToken'] ?? '';
        print('Device Token: $deviceToken');
      

      if (isVisible) {
        await sendNotification(deviceToken, 'Şikayet Onaylandı',
            'Şikayetiniz Engelsiz Yaşam Platformu tarafından onaylanmış ve hesabınızda paylaşılmıştır.');
            print("calisti ");
      }
      if (islemDurumu) {
        await sendNotification(deviceToken, 'İşleme Alındı',
            'Şikayetiniz Engelsiz Yaşam Platformu aracılığıyla ilgili kurum tarafından işlem sürecine alınmıştır.');

      }
      if (cozuldumu) {
        await sendNotification(deviceToken, 'Şikayet Çözüldü',
            'Şikayetiniz ilgili kurum tarafından çözüldü.');

      }
    } catch (e) {
      print('hata: $e');
    }
  }
}

