import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/companents/constants.dart';
import 'package:flutter_application_1/companents/my_button.dart';
import 'package:flutter_application_1/companents/my_image_box.dart';
import 'package:flutter_application_1/companents/my_drawer.dart';
import 'package:flutter_application_1/models/complaint.dart';
import 'package:flutter_application_1/user_pages/all_favorites_page.dart';
import 'package:flutter_application_1/user_pages/complaint_detail_page.dart';
import 'package:flutter_application_1/user_pages/root_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget buildComplaintsList(List<ComplaintModel> complaints) {
    return ListView.builder(
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        ComplaintModel complaint = complaints[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComplaintDetailPage(
                  complaint: complaint,
                ),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: complaint.imageURLs.isNotEmpty
                    ? Image.network(
                        complaint.imageURLs[0],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Image.asset("lib/images/eya/logo.png"),
              ),
              title: Text(complaint.title),
              subtitle: Text(
                complaint.description.length > 50
                    ? '${complaint.description.substring(0, 62)}...'
                    : complaint.description,
              ),
            ),
          ),
        );
      },
    );
  }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            MyImageBox(),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              width: MediaQuery.of(context).size.width * .9,
              decoration: BoxDecoration(
                color: Constants.primaryColor.withOpacity(.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      showCursor: false,
                      decoration: InputDecoration(
                        hintText: 'Şikayet Ara',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.mic),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.deepPurple,
              tabs: [
                Tab(text: 'En Yeni Şikayetler'),
                Tab(text: 'En Popüler Şikayetler'),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('sikayet')
                        .where('isVisible', isEqualTo: true)
                        .orderBy('timestamp', descending: true)
                        .limit(5)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Bir hata oluştu.'),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text('Hiç şikayet bulunamadı.'),
                        );
                      }

                      List<ComplaintModel> complaints =
                          snapshot.data!.docs.map((doc) {
                        return ComplaintModel.fromFirestore(doc);
                      }).toList();

                      return Column(
                        children: [
                          Expanded(
                            child: buildComplaintsList(complaints),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: MyButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RootPage(
                                      initialIndex: 2,
                                    ),
                                  ),
                                );
                              },
                              text: "Tum Sikayetleri gor",
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('sikayet')
                        .where('isVisible', isEqualTo: true)
                        .where('favoritesCount', isGreaterThan: 0)
                        .orderBy('favoritesCount', descending: true)
                        .limit(5)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Bir hata oluştu.'),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text('Hiç şikayet bulunamadı.'),
                        );
                      }

                      List<ComplaintModel> complaints =
                          snapshot.data!.docs.map((doc) {
                        return ComplaintModel.fromFirestore(doc);
                      }).toList();

                      return Column(
                        children: [
                          Expanded(
                            child: buildComplaintsList(complaints),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: MyButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AllFavoritesPage(),
                                  ),
                                );
                              },
                              text: "En Popüler Şikayetleri Gör",
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
