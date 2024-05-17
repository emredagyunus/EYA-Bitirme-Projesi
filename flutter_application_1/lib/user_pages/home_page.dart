import 'package:EYA/companents/customAppBar.dart';
import 'package:EYA/companents/home_page_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EYA/admin_pages/admin_blog_detail_page.dart';
import 'package:EYA/admin_pages/admin_duyuru_detail_page.dart';
import 'package:EYA/companents/my_button.dart';
import 'package:EYA/companents/my_image_box.dart';
import 'package:EYA/companents/my_drawer.dart';
import 'package:EYA/models/Blog.dart';
import 'package:EYA/models/complaint.dart';
import 'package:EYA/models/duyuru.dart';
import 'package:EYA/user_pages/all_favorites_page.dart';
import 'package:EYA/user_pages/blog_page.dart';
import 'package:EYA/user_pages/complaint_detail_page.dart';
import 'package:EYA/user_pages/duyuru_page.dart';
import 'package:EYA/user_pages/root_page.dart';
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
  bool _isSearching = false;

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

  Widget buildComplaintsList(
      List<ComplaintModel> complaints, BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 1250;
    final bool tablet = MediaQuery.of(context).size.width > 600;

    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: isWideScreen
          ? SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            )
          : tablet
              ? SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                )
              : SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 9,
                ),
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
            margin: EdgeInsets.all(1),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: isWideScreen
                        ? 4 / 3
                        : tablet
                            ? 4 / 3
                            : 7 / 2.9,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      child: complaint.imageURLs.isNotEmpty
                          ? Image.network(
                              complaint.imageURLs[0],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.asset("lib/images/eya/logo.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          complaint.title.trim(),
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          complaint.description.length > 50
                              ? '${complaint.description.substring(0, 50).trim()}...'
                              : complaint.description.trim(),
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                      
                    ),
                    
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildComplaintsSearchList(
      List<ComplaintModel> complaints, String searchText) {
    List<ComplaintModel> filteredComplaints = complaints
        .where((complaint) =>
            complaint.title.toLowerCase().contains(searchText.toLowerCase()) ||
            complaint.description
                .toLowerCase()
                .contains(searchText.toLowerCase()))
        .toList();

    return SizedBox(
      height: _calculateHeight(MediaQuery.of(context).size.width),
      child: ListView.builder(
        itemCount: filteredComplaints.length,
        itemBuilder: (context, index) {
          ComplaintModel complaint = filteredComplaints[index];
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
              margin: EdgeInsets.all(1),
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
                title: Text(complaint.title.trim()),
                subtitle: Text(
                  complaint.description.length > 50
                      ? '${complaint.description.substring(0, 50).trim()}...'
                      : complaint.description.trim(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildBlogList(List<Blog> blog) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 1250;
    final bool tablet = MediaQuery.of(context).size.width > 600;

    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: isWideScreen
          ? SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            )
          : tablet
              ? SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                )
              : SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 9,
                ),
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
            margin: EdgeInsets.all(1),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: isWideScreen
                        ? 4 / 3
                        : tablet
                            ? 4 / 3
                            : 7 / 2.9,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      child: blogs.imageURLs.isNotEmpty
                          ? Image.network(
                              blogs.imageURLs[0],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.asset("lib/images/eya/logo.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blogs.title.length > 10
                              ? '${blogs.title.substring(0, 10).trim()}...'
                              : blogs.title.trim(),
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          blogs.description.length > 50
                              ? '${blogs.description.substring(0, 50).trim()}...'
                              : blogs.description.trim(),
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildDuyuruList(List<Duyuru> duyuru) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 1250;
    final bool tablet = MediaQuery.of(context).size.width > 600;

    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: isWideScreen
          ? SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            )
          : tablet
              ? SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                )
              : SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 9,
                ),
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
            margin: EdgeInsets.all(1),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: isWideScreen
                        ? 4 / 3
                        : tablet
                            ? 4 / 3
                            : 7 / 2.9,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      child: duyurular.imageURLs.isNotEmpty
                          ? Image.network(
                              duyurular.imageURLs[0],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.asset("lib/images/eya/logo.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          duyurular.title.length > 10
                              ? '${duyurular.title.substring(0, 10).trim()}...'
                              : duyurular.title.trim(),
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          duyurular.description.length > 50
                              ? '${duyurular.description.substring(0, 50).trim()}...'
                              : duyurular.description.trim(),
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      drawer: MyDrawer(),
      appBar: customAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Container(
                height: 250,
                child: ImageSlider(),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                width: MediaQuery.of(context).size.width * .9,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (text) {
                          setState(() {
                            _isSearching = text.isNotEmpty;
                          });
                        },
                        showCursor: false,
                        decoration: InputDecoration(
                          hintText: 'Şikayet Ara',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          icon: Icon(UniconsLine.search),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(UniconsLine.microphone),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _isSearching
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('sikayet')
                          .where('isVisible', isEqualTo: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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

                        return _searchController.text.isEmpty
                            ? buildComplaintsList(complaints, context)
                            : buildComplaintsSearchList(
                                complaints, _searchController.text);
                      },
                    )
                  : SizedBox(
                      height: _calculateHeight(MediaQuery.of(context).size.width),
                      child: Column(
                        children: [
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
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Bir hata oluştu.'),
                                      );
                                    }

                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
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
                                          child: buildComplaintsList(
                                              complaints, context),
                                        ),
                                        SizedBox(height: 10),
                                        Center(
                                          child: MyButton(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      RootPage(
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
                                      .orderBy('favoritesCount',
                                          descending: true)
                                      .limit(5)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Bir hata oluştu.'),
                                      );
                                    }

                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
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
                                          child: buildComplaintsList(
                                              complaints, context),
                                        ),
                                        SizedBox(height: 10),
                                        Center(
                                          child: MyButton(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AllFavoritesPage(),
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
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Bir hata oluştu.'),
                                      );
                                    }

                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return Center(
                                        child: Text('Hiç blog bulunamadı.'),
                                      );
                                    }

                                    List<Blog> blogs =
                                        snapshot.data!.docs.map((doc) {
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
                                                  builder: (context) =>
                                                      BlogPage(),
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
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Bir hata oluştu.'),
                                      );
                                    }

                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return Center(
                                        child: Text('Hiç duyuru bulunamadı.'),
                                      );
                                    }

                                    List<Duyuru> duyurular =
                                        snapshot.data!.docs.map((doc) {
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
                                                  builder: (context) =>
                                                      DuyuruPage(),
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
              kIsWeb ? MyTenButtonsWidget() : SizedBox(height: 0),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateHeight(double screenWidth) {
    if (screenWidth >= 1250) {
      return 905;
    } else if (screenWidth > 600) {
      return 705;
    } else {
      return 505;
    }
  }
}

class MyTenButtonsWidget extends StatelessWidget {
  const MyTenButtonsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {},
                child: Text('Button 1'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Button 2'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Button 3'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {},
                child: Text('Button 4'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Button 5'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Button 6'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {},
                child: Text('Button 7'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Button 8'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Button 9'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {},
            child: Text('Button 10'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
