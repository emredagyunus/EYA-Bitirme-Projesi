import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        showNotification(notification);
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage)
    {  
      if(remoteMessage != null){
      final notification = remoteMessage.notification;
         if (notification != null) {
      showNotification(notification);
          }
       }
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
    final String serverKey = 'AAAAjVa2_8w:APA91bFgnE4GzeE-JerKw3SE3WOs5V2mx0YD0pMHTwplk7NNb1axhmdBvlqopX7OqfT2WySL2ig-_nEIBpP_wBni-Yuwtpqo3T2jneR4WkWMjnrA1UiIqRRVd6_jh3uUiil78hkw0OUd'; 
    final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final payload = {
      'to': token,
      'notification': {
        'title': title,
        'body': body,
      },
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done'
      },
      'android': {
        'priority': 'high',
        'notification': {
          'sound': 'default'
        }
      }
    };

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: headers,
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.body}');
    }
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
      if (userDoc.exists && userDoc.data() != null) {
        String deviceToken = userDoc.data()!['deviceToken'] ?? '';
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
      } else {
        print('User document or deviceToken not found');
      }
    } catch (e) {
      print('hata: $e');
    }
  }
}