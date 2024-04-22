import 'package:flutter/material.dart';
import 'package:flutter_application_1/companents/constants.dart';
import 'package:flutter_application_1/companents/my_image_box.dart';
import 'package:flutter_application_1/companents/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text(
          'E Y A',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MyImageox(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              width: MediaQuery.sizeOf(context).width * .9,
              decoration: BoxDecoration(
                color: Constants.primaryColor.withOpacity(.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.black54.withOpacity(.6),
                  ),
                  const Expanded(
                      child: TextField(
                    showCursor: false,
                    decoration: InputDecoration(
                      hintText: 'Search Plant',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  )),
                  Icon(
                    Icons.mic,
                    color: Colors.black54.withOpacity(.6),
                  ),
                ],
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
