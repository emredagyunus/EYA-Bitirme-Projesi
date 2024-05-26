import 'package:EYA/companents/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:EYA/companents/my_drawer.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, String>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? notifications = prefs.getStringList('notifications');
    if (notifications != null) {
      setState(() {
        _notifications = notifications
            .map((e) => Map<String, String>.from(json.decode(e)))
            .toList();
      });
    }
  }

  Future<void> _removeNotification(int index) async {
    setState(() {
      _notifications.removeAt(index);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notifications = _notifications
        .map((e) => json.encode(e))
        .toList();
    await prefs.setStringList('notifications', notifications);
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return '';
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    } catch (e) {
      return timestamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: customAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  _notifications[index]['title'] ?? '',
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  _notifications[index]['body'] ?? '',
                  style: TextStyle(color: Colors.black),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTimestamp(_notifications[index]['timestamp']),
                      style: TextStyle(color: Colors.black),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.deepPurple),
                      onPressed: () {
                        _removeNotification(index);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
