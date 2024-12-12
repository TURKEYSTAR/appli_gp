import 'package:appli_gp/pages/detail_notif2.dart';
import 'package:appli_gp/pages/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/transporteur_card.dart';
import '../pages/available_gp_card.dart';
import '../pages/transporteur_list.dart';
import 'notifications_page.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  String _selectedTab = "Annonces";

  final ScrollController _scrollController = ScrollController();

  final GlobalKey _revuesKey = GlobalKey();
  final GlobalKey _annoncesKey = GlobalKey();
  final GlobalKey _notificationsKey = GlobalKey();

  String? firstName;
  String? lastName;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            firstName = userDoc.get('prenom');
            lastName = userDoc.get('nom');
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

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
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/top_background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 90),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              firstName != null && lastName != null
                                  ? 'Hello, \n$firstName $lastName'
                                  : 'Welcome to\nGP Express',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                            'assets/images/images.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 60),
                  // Ajout du bouton vers DetailNotif2
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailNotif2Page()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Voir les détails de Notification",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStyledActionButton(
                                'assets/images/voice_call.png',
                                'Annonces',
                                _annoncesKey,
                                false),
                            _buildStyledActionButton(
                                'assets/images/video_call.png',
                                'Revues',
                                _revuesKey,
                                true),
                            _buildStyledActionButton(
                                'assets/images/notification.png',
                                'Notification',
                                _notificationsKey,
                                false),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30),
          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Tapez ici...',
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.white70,
                  filled: true,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/search_icon.png',
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildBanner(),
          Divider(color: Colors.white, thickness: 1),
          Padding(
            key: _revuesKey,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(child: TransporteurCard(name: "James")),
                SizedBox(width: 16),
                Expanded(child: TransporteurCard(name: "Jean")),
              ],
            ),
          ),
          SizedBox(height: 15),
          Divider(color: Colors.grey[300], thickness: 1),
          SizedBox(height: 15),
          Padding(
            key: _annoncesKey,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => _setTab("Annonces"),
                  child: Text(
                    'Annonces',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedTab == "Annonces"
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _setTab("Transporteurs"),
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
          // Content based on selected tab
          _selectedTab == "Annonces" ? _buildAnnonces() : TransporteurList(),
        ],
      ),
    );
  }

  void _setTab(String tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  Widget _buildStyledActionButton(
      String imagePath, String label, GlobalKey key, bool isScrollOnly) {
    return GestureDetector(
      onTap: () {
        if (label == "Notification") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationPage()),
          );
        } else if (isScrollOnly) {
          _scrollToSection(key);
        } else {
          _setTab(label);
          _scrollToSection(key);
        }
      },
      child: Container(
        width: 100,
        height: 85,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              child: Image.asset(
                imagePath,
                height: 50,
                width: 50,
              ),
            ),
            SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context,
          duration: Duration(seconds: 1), curve: Curves.easeInOut);
    }
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.blue.shade100,
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Laissez nous venir vers vous où que vous soyez',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: 130,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.fill,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAnnonces() {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: fetchAnnonces(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No annonces available"));
        }

        final annonces = snapshot.data!;
        return Column(
          children: List.generate(annonces.length, (index) {
            var annonceData = {
              ...annonces[index].data() as Map<String, dynamic>,
              'id': annonces[index].id,
            };
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () async {
                      if (FirebaseAuth.instance.currentUser == null) {
                        // Show an AlertDialog instead of Snackbar
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Vous n\'êtes pas connecté'),
                              content: Text(
                                  'Veuillez vous connecter pour plus de détails.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/log');
                                  },
                                  child: Text('Se connecter'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Annuler'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        String? userId = annonceData['user_id'] as String?;
                        Map<String, dynamic>? userData;

                        if (userId != null && userId.isNotEmpty) {
                          DocumentSnapshot userDoc = await FirebaseFirestore
                              .instance
                              .collection('users')
                              .doc(userId)
                              .get();

                          if (userDoc.exists) {
                            userData = userDoc.data() as Map<String, dynamic>?;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Utilisateur non trouvé.')),
                            );
                          }
                        }
                        String annonceId = annonceData['id'];
                        Navigator.pushNamed(
                          context,
                          '/detailsAnnonce',
                          arguments: {
                            'annonce': annonceData,
                            'userData': userData, // Will be null if not
                            'annonceId': annonceId,
                          },
                        );
                      }
                    },
                    child: AvailableGPCard(
                      villeDepart: annonceData['ville_depart'] ?? 'Unknown',
                      paysDepart: annonceData['pays_depart'] ?? 'Unknown',
                      villeArrivee: annonceData['ville_arrivee'] ?? 'Unknown',
                      paysArrivee: annonceData['pays_arrivee'] ?? 'Unknown',
                      dateDepart: (annonceData['date_depart'] as Timestamp?)
                          ?.toDate() ??
                          DateTime.now(),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  thickness: 1,
                ),
              ],
            );
          }),
        );
      },
    );
  }
}