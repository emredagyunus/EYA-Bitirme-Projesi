import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final String text;
  final IconData? icon;
  final void Function()? onTap;

  const MyDrawerTile(
      {super.key, required this.text, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: ListTile(
        tileColor: Colors.white10,
        title: Text(
          text,
          style: TextStyle(color: Colors.deepPurple),
        ),
        leading: Icon(
          icon,
          color: Colors.deepPurple,
        ),
        onTap: onTap,
      ),
    );
  }
}
