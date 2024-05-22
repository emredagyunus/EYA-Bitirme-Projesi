import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: Colors.deepPurple,
            padding: EdgeInsets.all(8),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: constraints.maxWidth > 600
                  ? GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      children: [
                        UserCard(),
                        InstitutionCard(),
                        VisibleComplaintsCard(),
                        ResolvedComplaintsCard(),
                      ],
                    )
                  : GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: [
                        UserCard(),
                        InstitutionCard(),
                        VisibleComplaintsCard(),
                        ResolvedComplaintsCard(),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 50),
          SizedBox(height: 10),
          Text('Kullanıcı Sayımız', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('users').get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              int userCount = snapshot.data!.docs.length;
              return Text('$userCount', style: TextStyle(fontSize: 24));
            },
          ),
        ],
      ),
    );
  }
}

class InstitutionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business, size: 50),
          SizedBox(height: 10),
          Text('Kurum Sayımız', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('kurum').get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              int institutionCount = snapshot.data!.docs.length;
              return Text('$institutionCount', style: TextStyle(fontSize: 24));
            },
          ),
        ],
      ),
    );
  }
}

class VisibleComplaintsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.report, size: 50),
          SizedBox(height: 10),
          Text('Aktif Şikayetler', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('sikayet').where('isVisible', isEqualTo: true).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              int visibleComplaintsCount = snapshot.data!.docs.length;
              return Text('$visibleComplaintsCount', style: TextStyle(fontSize: 24));
            },
          ),
        ],
      ),
    );
  }
}

class ResolvedComplaintsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 50),
          SizedBox(height: 10),
          Text('Çözülen Şikayetler', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('sikayet')
              .where('isVisible', isEqualTo: true)
              .where('cozuldumu', isEqualTo: true)
              .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              int resolvedComplaintsCount = snapshot.data!.docs.length;
              return Text('$resolvedComplaintsCount', style: TextStyle(fontSize: 24));
            },
          ),
        ],
      ),
    );
  }
}
