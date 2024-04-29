import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/admin_pages/admin_blog_detail_page.dart';
import 'package:flutter_application_1/admin_pages/admin_duyuru_detail_page.dart';
import 'package:flutter_application_1/companents/constants.dart';
import 'package:flutter_application_1/companents/my_button.dart';
import 'package:flutter_application_1/companents/my_image_box.dart';
import 'package:flutter_application_1/companents/my_drawer.dart';
import 'package:flutter_application_1/models/Blog.dart';
import 'package:flutter_application_1/models/complaint.dart';
import 'package:flutter_application_1/models/duyuru.dart';
import 'package:flutter_application_1/user_pages/all_favorites_page.dart';
import 'package:flutter_application_1/user_pages/blog_page.dart';
import 'package:flutter_application_1/user_pages/complaint_detail_page.dart';
import 'package:flutter_application_1/user_pages/duyuru_page.dart';
import 'package:flutter_application_1/user_pages/root_page.dart';
import 'package:unicons/unicons.dart';

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
    _tabController = TabController(length: 4, vsync: this);
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

  Widget buildBlogList(List<Blog> blog) {
    return ListView.builder(
      itemCount: blog.length,
      itemBuilder: (context, index) {
        Blog blogs = blog[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlogDetailPage(
                  blog: blogs,
                ),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: blogs.imageURLs.isNotEmpty
                    ? Image.network(
                        blogs.imageURLs[0],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Image.asset("lib/images/eya/logo.png"),
              ),
              title: Text(blogs.title),
              subtitle: Text(
                blogs.description.length > 50
                    ? '${blogs.description.substring(0, 62)}...'
                    : blogs.description,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildDuyuruList(List<Duyuru> duyuru) {
    return ListView.builder(
      itemCount: duyuru.length,
      itemBuilder: (context, index) {
        Duyuru duyurular = duyuru[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DuyuruDetailPage(
                  duyuru: duyurular,
                ),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: duyurular.imageURLs.isNotEmpty
                    ? Image.network(
                        duyurular.imageURLs[0],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Image.asset("lib/images/eya/logo.png"),
              ),
              title: Text(duyurular.title),
              subtitle: Text(
                duyurular.description.length > 50
                    ? '${duyurular.description.substring(0, 62)}...'
                    : duyurular.description,
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
              UniconsLine.bell,
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
                    icon: Icon(UniconsLine.search),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(UniconsLine.microphone),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.deepPurple,
              isScrollable: true,
              labelPadding: EdgeInsets.symmetric(horizontal: 10),
              tabAlignment: TabAlignment.start,
              tabs: [
                Tab(text: 'En Yeni Şikayetler'),
                Tab(text: 'En Popüler Şikayetler'),
                Tab(text: 'Blog'),
                Tab(text: 'Duyuru'),
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
                              text: "Tüm Şikayetleri Gör",
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
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('blog')
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

                      List<Blog> blogs = snapshot.data!.docs.map((doc) {
                        return Blog.fromFirestore(doc);
                      }).toList();

                      return Column(
                        children: [
                          Expanded(
                            child: buildBlogList(blogs),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: MyButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlogPage(),
                                  ),
                                );
                              },
                              text: "Tüm Blog Yazılarını Gör",
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('duyuru')
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

                      List<Duyuru> duyurular = snapshot.data!.docs.map((doc) {
                        return Duyuru.fromFirestore(doc);
                      }).toList();

                      return Column(
                        children: [
                          Expanded(
                            child: buildDuyuruList(duyurular),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: MyButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DuyuruPage(),
                                  ),
                                );
                              },
                              text: "Tüm Duyuruları Gör",
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
