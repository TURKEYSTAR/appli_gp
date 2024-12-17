import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  User? currentUser;
  String? role;
  String? displayName;
  Map<int, bool> _isExpandedMap = {};

  Map<String, String> userDetails = {
    "Adresse": "Chargement...",
    "Mobile": "Chargement...",
    "Email": "Chargement...",
  };

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _fetchUserData();

    // Initialize TabController for sliding between sections
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _fetchUserData() async {
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          displayName = userDoc.data()!['username'] ?? 'Utilisateur';
          role = userDoc.data()!['role'];
          // Fetch additional details
          userDetails = {
            "Adresse": userDoc.data()!['address'] ?? 'Non spécifiée',
            "Mobile": userDoc.data()!['phone'] ?? 'Non spécifié',
            "Email": userDoc.data()!['email'] ?? 'Non spécifié',
          };
        });
      }
    }
  }

  Stream<List<QueryDocumentSnapshot>> fetchAnnonces() {
    return FirebaseFirestore.instance
        .collection('annonces')
        .where('user_id', isEqualTo: currentUser?.uid)
        .snapshots()
        .map((query) => query.docs);
  }

  Stream<List<QueryDocumentSnapshot>> fetchReservations() {
    return FirebaseFirestore.instance
        .collection('reservations')
        .where('expediteur_id', isEqualTo: currentUser?.uid)
        .snapshots()
        .map((query) => query.docs);
  }

  Stream<List<QueryDocumentSnapshot>> fetchColis() {
    return FirebaseFirestore.instance
        .collection('parcels')
        .where('expediteur_id', isEqualTo: currentUser?.uid)
        .snapshots()
        .map((query) => query.docs);
  }

  Stream<List<QueryDocumentSnapshot>> fetchColisTrans() {
    return FirebaseFirestore.instance
        .collection('parcels')
        .where('transporteur_id', isEqualTo: currentUser?.uid)
        .snapshots()
        .map((query) => query.docs);
  }

  // Function to update the status in Firestore
  Future<void> _updateStatus(String newStatus, String colisId) async {
    try {
      await FirebaseFirestore.instance
          .collection('parcels')
          .doc(colisId)
          .update({'status': newStatus});
    } catch (e) {
      print("Erreur lors de la mise à jour du statut: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_outline,
                  size: 100, color: Colors.deepPurple.shade100),
              SizedBox(height: 10),
              Text(
                'Vous n\'êtes pas connecté',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  backgroundColor: Colors.deepPurple.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                onPressed: () {
                  // Navigate to the login screen
                  Navigator.pushNamed(context, '/log');
                },
                child: Text(
                  'Se connecter',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Top Background Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/top_background.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),

          // Profile Content
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 150), // Space for the background image
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/avata.png'),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  displayName ?? 'Utilisateur',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  role ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 20),

                // Collapsible Information Section
                _buildSectionWithDetails(
                  title: "Informations personnelles",
                  icon: Icons.person,
                  details: userDetails,
                ),

                // Sliding Tabs for Role-Specific Sections
                if (role == "Transporteur" || role == "Expéditeur") ...[
                  _buildSlidingTabs(context),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionWithDetails({
    required String title,
    required IconData icon,
    required Map<String, String> details,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 40, color: Colors.deepPurple.shade200),
                  SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ...details.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _getIconForDetail(entry.key),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Text(
                              entry.value,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Icon _getIconForDetail(String detailType) {
    switch (detailType) {
      case "Adresse":
        return Icon(Icons.home, color: Colors.blue);
      case "Mobile":
        return Icon(Icons.phone, color: Colors.blue.shade800);
      case "Email":
        return Icon(Icons.email, color: Colors.indigo);
      default:
        return Icon(Icons.info, color: Colors.grey);
    }
  }

  Widget _buildSlidingTabs(BuildContext context) {
    return Column(
      children: [
        // Tab Bar
        TabBar(
          controller: _tabController,
          labelColor: Colors.deepPurple.shade900,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.deepPurple.shade900,
          tabs: [
            Tab(
              icon: role == "Transporteur"
                  ? Icon(Icons.local_shipping)
                  : Icon(Icons.inbox),
              text: role == "Transporteur" ? "Annonces" : "Colis",
            ),
            Tab(
              icon: role == "Transporteur"
                  ? Icon(Icons.bar_chart)
                  : Icon(Icons.bookmark),
              text: role == "Transporteur" ? "Colis" : "Réservations",
            ),
          ],
        ),

        // TabBarView for Sliding Content
        SizedBox(
          height: 300,
          child: TabBarView(
            controller: _tabController,
            children: [
              // First Tab: Annonces or Colis
              if (role == "Transporteur")
                _buildAnnoncesList(context)
              else
                _buildColisList(),

              // Second Tab: Colis or Réservations
              if (role == "Transporteur")
                _buildColisTransList()
              else
                _buildReservationsList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnnoncesList(BuildContext context) {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: fetchAnnonces(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text('Erreur lors de la récupération des annonces'));
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var annonces = snapshot.data!;
        return Column(
          children: [
            ...annonces.map((doc) {
              var annonceData = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(annonceData['mode'] ?? 'Titre inconnu'),
                subtitle: Text(
                  "${annonceData['ville_depart'] ?? '---'} → ${annonceData['ville_arrivee'] ?? '---'}",
                ),
                onTap: () async {
                  if (FirebaseAuth.instance.currentUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Veuillez vous connecter pour plus de détails')),
                    );
                  } else {
                    String? userId = annonceData['user_id'] as String?;
                    Map<String, dynamic>? userData;

                    if (userId != null && userId.isNotEmpty) {
                      try {
                        DocumentSnapshot userDoc = await FirebaseFirestore
                            .instance
                            .collection('users')
                            .doc(userId)
                            .get();

                        if (userDoc.exists) {
                          userData = userDoc.data() as Map<String, dynamic>?;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Utilisateur non trouvé.')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Erreur lors de la récupération des données.')),
                        );
                      }
                    }

                    Navigator.pushNamed(
                      context,
                      '/detailsAnnonce',
                      arguments: {
                        'annonce': annonceData,
                        'userData': userData,
                      },
                    );
                  }
                },
              );
            }),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/annoncele');
              },
              child: Text('+ Créer une nouvelle annonce'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReservationsList() {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: fetchReservations(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text('Erreur lors de la récupération des réservations'));
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var reservations = snapshot.data!;
        if (reservations.isEmpty) {
          return Center(child: Text('Aucune réservation trouvée'));
        }
        return ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            var reservationData =
                reservations[index].data() as Map<String, dynamic>;

            // Convert and format the Firestore timestamp
            String formattedDate = "Non spécifiée";
            if (reservationData['date_creation'] != null &&
                reservationData['date_creation'] is Timestamp) {
              final timestamp = reservationData['date_creation'] as Timestamp;
              final dateTime = timestamp.toDate();
              formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
            }

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text("Réservation ${index + 1}"),
                subtitle: Text(
                  "Destination: ${reservationData['ville_destinataire'] ?? 'Non spécifiée'}\n"
                  "Date: $formattedDate",
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildColisList() {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: fetchColis(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text('Erreur lors de la récupération des colis'));
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var colisList = snapshot.data!;
        if (colisList.isEmpty) {
          return Center(child: Text('Aucun colis trouvé'));
        }

        return ListView.builder(
          itemCount: colisList.length,
          itemBuilder: (context, index) {
            var colis = colisList[index];
            String formattedDate = "Non spécifiée";
            String status =
                colis['status'] ?? 'Inconnu'; // Default status if not available

            // Format the creation date if available
            if (colis['date_creation'] != null) {
              formattedDate = DateFormat('dd/MM/yyyy')
                  .format((colis['date_creation'] as Timestamp).toDate());
            }

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: Icon(Icons.inbox, color: Colors.indigo),
                title: Text("Colis N°${index + 1}"),
                subtitle: Text(
                  '$formattedDate\n'
                  '$status',
                ),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward, color: Colors.grey),
                  onPressed: () {
                    // Navigate to the TrackingPage with colis data as arguments
                    Navigator.pushNamed(
                      context,
                      '/tracking',
                      arguments: {'parcelId': colis.id}, // Pass colis ID or any other required data
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildColisTransList() {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: fetchColisTrans(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Erreur lors de la récupération des colis'));
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var colisList = snapshot.data!;
        if (colisList.isEmpty) {
          return Center(child: Text('Aucun colis trouvé'));
        }

        return ListView.builder(
          itemCount: colisList.length,
          itemBuilder: (context, index) {
            var colis = colisList[index];
            String formattedDate = "Non spécifiée";
            String status = colis['status'] ?? 'Inconnu'; // Default status if not available

            // Format the creation date if available
            if (colis['date_creation'] != null) {
              formattedDate = DateFormat('dd/MM/yyyy')
                  .format((colis['date_creation'] as Timestamp).toDate());
            }

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.inbox, color: Colors.indigo),
                    title: Text("Colis N°${index + 1}"),
                    subtitle: Text(
                      '$formattedDate\n'
                          '$status',
                    ),
                  ),
                  // Buttons will always be visible
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => _updateStatus('Colis récupéré', colis.id),
                          child: Text('Récupéré'),
                        ),
                        ElevatedButton(
                          onPressed: () => _updateStatus('Pays quitté', colis.id),
                          child: Text('Départ'),
                        ),
                        ElevatedButton(
                          onPressed: () => _updateStatus('Bientôt arrivé', colis.id),
                          child: Text('En route'),
                        ),
                        ElevatedButton(
                          onPressed: () => _updateStatus('Colis livrée', colis.id),
                          child: Text('Livré'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContentSection(
      {required String title, required String description}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info, size: 50, color: Colors.deepPurple.shade900),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}


