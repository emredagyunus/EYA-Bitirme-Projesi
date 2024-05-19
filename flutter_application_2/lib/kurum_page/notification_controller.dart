import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationPlugin = FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initializeNotification() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    const LinuxInitializationSettings linuxSettings = LinuxInitializationSettings(defaultActionName: 'Open notification');
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
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
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

  static Future<void> sendNotification(String token, String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Genel Bildirimler',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: 'lib/images/eya/logo.png',
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
   try {
      await _notificationPlugin.show(
        token.hashCode,
        title,
        body,
        notificationDetails,
      );
    } catch (e) {
      print('Bildirim gönderilirken hata oluştu: $e');
    }
  }

  static Future<void> handleFirestoreData(QuerySnapshot data) async {
    for (var document in data.docs) {
      String id = document['id'] ?? '';
      String title = document['title'] ?? '';
      String body = document['description'] ?? '';
      String deviceToken = document['deviceToken'] ?? '';

      bool isVisible = document['isVisible'] ?? false;
      bool islemDurumu = document['islemDurumu'] ?? false;
      bool cozuldumu = document['cozuldumu'] ?? false;    
      try {
        if (isVisible && !document['isVisibleSent']) {
          await sendNotification(deviceToken, 'Şikayet Onaylandı', 'Şikayetiniz Engelsiz Yaşam Platformu tarafından onaylanmış ve hesabınızda paylaşılmıştır.');
          await FirebaseFirestore.instance.collection('sikayet').doc(id).update({'isVisibleSent': true});
        }
        if (islemDurumu && !document['islemDurumuSent']) {
          await sendNotification(deviceToken, 'İşleme Alındı', 'Şikayetiniz Engelsiz Yaşam Platformu aracılığıyla ilgili kurum tarafından işlem sürecine alınmıştır.');
          await FirebaseFirestore.instance.collection('sikayet').doc(id).update({'islemDurumuSent': true});
        }
        if (cozuldumu && !document['cozuldumuSent']) {
          await sendNotification(deviceToken, 'Şikayet Çözüldü', 'Şikayetiniz ilgili kurum tarafından çözüldü.');
          await FirebaseFirestore.instance.collection('sikayet').doc(id).update({'cozuldumuSent': true});
        }
      } catch (e) {
        print('Firestore verisi işlenirken hata oluştu: $e');
      }
    }
  }
}

// AndroidManifest.xml dosyasından değişiklik yapıldı!!!
// ios için  Info.plist dosyasındaü
//<key>UIBackgroundModes</key>
//<array>
//  <string>fetch</string>
// <string>remote-notification</string>
//</array>
//<key>FirebaseAppDelegateProxyEnabled</key>
//<false/>
// eklemesi yap
