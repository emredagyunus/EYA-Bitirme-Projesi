import 'package:flutter/material.dart';

class MyImageox extends StatelessWidget {
  const MyImageox({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/images/burgers/logo.png"),
            fit: BoxFit.cover,
          ),
          border: Border.all(color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(25),
      ),
    );
  }
}
