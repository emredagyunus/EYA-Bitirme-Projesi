import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHelper extends StatefulWidget {
  @override
  _NotificationHelperState createState() => _NotificationHelperState();
}

class _NotificationHelperState extends State<NotificationHelper> {
  final FlutterLocalNotificationsPlugin _notificationPlugin =
      FlutterLocalNotificationsPlugin();
  // ignore: unused_field
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    initializeNotification();
    setupFirebaseMessaging();
  }

  Future<void> initializeNotification() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _notificationPlugin.initialize(initSettings);
  }

  void setupFirebaseMessaging() {
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

  void showNotification(RemoteNotification notification) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'Genel Bildirimler',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );


    await _notificationPlugin.show(
      notification.hashCode,
      notification.title ?? '',
      notification.body ?? '',
      NotificationDetails(android: androidDetails),
    );
  }

  Future<void> sendNotification(String token, String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'Genel Bildirimler',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await _notificationPlugin.show(
      token.hashCode,
      title,
      body,
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bildirimler'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('sikayet').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Bir hata oluştu');
          } else if (!snapshot.hasData) {
            return Text('Veri yok');
          } else {
            QuerySnapshot data = snapshot.data!;

            return ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                var document = data.docs[index];
                String userID = document['userID'] ?? '';
                String id = document['id'] ?? '';
                String title = document['title'] ?? '';
                String body = document['description'] ?? '';

                bool isVisible = document['isVisible'] ?? false;
                bool islemDurumu = document['islemDurumu'] ?? false;
                bool cozuldumu = document['cozuldumu'] ?? false;


                if (isVisible && !document['isVisibleSent']) {
                  sendNotification(userID, 'Şikayet Onaylandı',
                      'Şikayetiniz Engelsiz Yaşam Platformu tarafından onaylanmış ve hesabınızda paylaşılmıştır.');

                  FirebaseFirestore.instance
                      .collection('sikayet')
                      .doc(id)
                      .update({'isVisibleSent': true});
                }
                if (islemDurumu && !document['islemDurumuSent']) {
                  sendNotification(userID, 'İşleme Alındı',
                      'Şikayetiniz Engelsiz Yaşam Platformu aracılığıyla ilgili kurum tarafından işlem sürecine alınmıştır.');
                  FirebaseFirestore.instance
                      .collection('sikayet')
                      .doc(id)
                      .update({'islemDurumuSent': true});
                }

                if (cozuldumu && !document['cozuldumuSent']) {
                  sendNotification(userID, 'Şikayet Çözüldü',
                      'Şikayetiniz ilgili kurum tarafından çözüldü.');
                  FirebaseFirestore.instance
                      .collection('sikayet')
                      .doc(id)
                      .update({'cozuldumuSent': true});
                }
                return ListTile(
                  title: Text(title),
                  subtitle: Text(body),
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {

    super.dispose();
  }
}
