import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/transporteur_card.dart';
import '../pages/available_gp_card.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  String _selectedTab = "Annonces";

  // Fetch annonces from Firestore
  Stream<List<DocumentSnapshot>> fetchAnnonces() {
    return FirebaseFirestore.instance
        .collection('annonces')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery App',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 16),

          Divider(
            color: Colors.white,
            thickness: 1,
          ),

          SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search here',
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white70,
                filled: true,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          SizedBox(height: 16),

          Divider(
            color: Colors.white,
            thickness: 1,
          ),

          SizedBox(height: 20),

          // Added part: horizontal scroll and transporteurs row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/images.png'),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/images.png'),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/images.png'),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.add),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(child: TransporteurCard(name: "James")),
                SizedBox(width: 16),
                Expanded(child: TransporteurCard(name: "Jean")),
              ],
            ),
          ),

          SizedBox(height: 16),

          Divider(
            color: Colors.white,
            thickness: 1,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = "Annonces";
                    });
                  },
                  child: Text(
                    'Annonces',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedTab == "Annonces" ? Colors.black : Colors
                          .grey,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = "Transporteurs";
                    });
                  },
                  child: Text(
                    'Transporteurs',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedTab == "Transporteurs"
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Show the list of annonces even for visitors
          _selectedTab == "Annonces"
              ? StreamBuilder<List<DocumentSnapshot>>(
            stream: fetchAnnonces(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error fetching data'));
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              var annonces = snapshot.data!;
              return Column(
                children: List.generate(annonces.length, (index) {
                  var annonce = annonces[index].data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              Navigator.pushReplacementNamed(context, '/detailsAnnonce', arguments: annonces[index]);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please log in to view details.')),
                              );
                            }
                          },
                          child: AvailableGPCard(
                            villeDepart: annonce['ville_depart'],
                            paysDepart: annonce['pays_depart'],
                            villeArrivee: annonce['ville_arrivee'],
                            paysArrivee: annonce['pays_arrivee'],
                            dateDepart: annonce['date_depart'].toDate(),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[200],
                        thickness: 1,
                        height: 10,
                      ),
                    ],
                  );
                }),
              );
            },
          )
              : Column(
            children: List.generate(
              3,
                  (index) =>
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TransporteurCard(name: "Transporteur ${index + 1}"),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}