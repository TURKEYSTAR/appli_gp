import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();
  String selectedFilter = "Tout";  // Current filter selection

  Stream<List<Map<String, dynamic>>> searchFirestore(String query, String filter) {
    // Convert search query to lowercase for case-insensitivity
    final lowerCaseQuery = query.toLowerCase();

    Stream<List<Map<String, dynamic>>> annoncesStream = FirebaseFirestore.instance
        .collection('annonces')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .where((doc) {
      final villeDepart = doc['ville_depart']?.toString().toLowerCase() ?? '';
      final villeArrivee = doc['ville_arrivee']?.toString().toLowerCase() ?? '';
      return villeDepart.contains(lowerCaseQuery) || villeArrivee.contains(lowerCaseQuery);
    })
        .map((doc) => {...doc.data(), 'type': 'annonce'})
        .toList());

    Stream<List<Map<String, dynamic>>> usersStream = FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .where((doc) {
      final username = doc['username']?.toString().toLowerCase() ?? '';
      return username.contains(lowerCaseQuery);
    })
        .map((doc) => {...doc.data(), 'type': 'user'})
        .toList());

    if (filter == 'Annonces') {
      return annoncesStream;
    } else if (filter == 'Utilisateurs') {
      return usersStream;
    } else {
      return StreamZip([annoncesStream, usersStream])
          .map((combined) => [...combined[0], ...combined[1]]);
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
          // Filter buttons
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
              stream: searchQuery.isEmpty ? null : searchFirestore(searchQuery, selectedFilter),
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

  // Filter button widget
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
          fontWeight: selectedFilter == label ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // Widget to display Annonce layout in French
  Widget _buildAnnonceCard(Map<String, dynamic> annonce) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              annonce['ville_depart'] ?? 'No Ville',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Départ: ${annonce['ville_depart']}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Arrivée: ${annonce['ville_arrivee']}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.date_range, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Date: ${annonce['date_depart']}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display User layout with username and full name (prenom nom)
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
        // Navigate to user's profile
      },
    );
  }
}
