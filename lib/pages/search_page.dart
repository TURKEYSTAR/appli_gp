import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'details_profile_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();
  String selectedFilter = "Tout"; // Filter selection

  Stream<List<Map<String, dynamic>>> searchFirestore(
      String query, String filter) {
    final lowerCaseQuery = query.toLowerCase();

    Stream<List<Map<String, dynamic>>> annoncesStream = FirebaseFirestore
        .instance
        .collection('annonces')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((doc) {
              final villeDepart =
                  doc['ville_depart']?.toString().toLowerCase() ?? '';
              final villeArrivee =
                  doc['ville_arrivee']?.toString().toLowerCase() ?? '';
              return villeDepart.contains(lowerCaseQuery) ||
                  villeArrivee.contains(lowerCaseQuery);
            })
            .map((doc) => {
                  ...doc.data(),
                  'type': 'annonce',
                  'id': doc.id
                }) // Add the document ID
            .toList());

    Stream<List<Map<String, dynamic>>> usersStream = FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((doc) {
              final username = doc['username']?.toString().toLowerCase() ?? '';
              return username.contains(lowerCaseQuery);
            })
            .map((doc) => {
                  ...doc.data(),
                  'type': 'user',
                  'id': doc.id
                }) // Add the document ID
            .toList());

    // Handle filter-specific logic
    if (filter == 'Annonces') {
      return annoncesStream;
    } else if (filter == 'Utilisateurs') {
      return usersStream;
    } else {
      // Combine streams manually for "Tout"
      return Stream.fromFuture(Future.wait([
        annoncesStream.first,
        usersStream.first,
      ])).map((results) => [...results[0], ...results[1]]);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: (query) {
            setState(() {
              searchQuery = query;
            });
          },
          decoration: InputDecoration(
            hintText: 'Rechercher ici...',
            border: InputBorder.none,
          ),
          autofocus: true,
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFilterButton("Tout"),
              _buildFilterButton("Utilisateurs"),
              _buildFilterButton("Annonces"),
            ],
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: searchQuery.isEmpty
                  ? null
                  : searchFirestore(searchQuery, selectedFilter),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun résultat trouvé'));
                }

                var results = snapshot.data!;
                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    var result = results[index];
                    return result['type'] == 'annonce'
                        ? _buildAnnonceCard(result)
                        : _buildUserTile(result);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Text(
        label,
        style: TextStyle(
          color: selectedFilter == label ? Colors.blue : Colors.black,
          fontWeight:
              selectedFilter == label ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildAnnonceCard(Map<String, dynamic> annonce) {
    return GestureDetector(
      onTap: () async {
        if (FirebaseAuth.instance.currentUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Veuillez vous connecter pour plus de détails')),
          );
        } else {
          String transporteurId = annonce['user_id'] ??
              ''; // Replace with the document ID of the user
          Map<String, dynamic>? userData;

          if (transporteurId.isNotEmpty) {
            DocumentSnapshot userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(transporteurId) // Use the user document ID
                .get();
            if (userDoc.exists) {
              userData = userDoc.data() as Map<String, dynamic>?;
            }
          }

          Navigator.pushNamed(
            context,
            '/detailsAnnonce',
            arguments: {
              'annonce': annonce,
              'userData': userData,
            },
          );
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                annonce['ville_depart'] ?? 'Ville inconnue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Départ: ${annonce['ville_depart']}'),
              Text('Arrivée: ${annonce['ville_arrivee']}'),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.date_range, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    annonce['date_depart'] is Timestamp
                        ? DateFormat('dd/MM/yyyy').format(
                            (annonce['date_depart'] as Timestamp).toDate())
                        : 'Date inconnue',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        child: Text(
          user['username']?.substring(0, 1)?.toUpperCase() ?? 'U',
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(user['username'] ?? 'Nom d’utilisateur inconnu'),
      subtitle: Text('${user['prenom'] ?? ''} ${user['nom'] ?? ''}'),
      onTap: () {
        String transporteurId = user['id'] ?? ''; // Ensure 'id' is present
        if (transporteurId.isNotEmpty) {
          Navigator.pushNamed(
            context,
            '/detailsProfile',
            arguments: transporteurId, // Pass correct ID
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Identifiant du transporteur introuvable')),
          );
        }
      },
    );
  }
}
