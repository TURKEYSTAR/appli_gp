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

  // Method to fetch annonces and users based on search query and filter
  Stream<List<Map<String, dynamic>>> searchFirestore(String query, String filter) {
    Stream<List<Map<String, dynamic>>> annoncesStream = FirebaseFirestore.instance
        .collection('annonces')
        .where('ville_depart', isGreaterThanOrEqualTo: query)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => {...doc.data(), 'type': 'annonce'}).toList());

    Stream<List<Map<String, dynamic>>> usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => {...doc.data(), 'type': 'user'}).toList());

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
                  return Center(child: Text('No results found'));
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

  // Widget to display Annonce layout similar to available_gp_card
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
              'Departure: ${annonce['ville_depart']}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Destination: ${annonce['ville_arrivee']}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.date_range, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Date: ${annonce['date']}',
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
      title: Text(user['username'] ?? 'Unknown Username'),
      subtitle: Text('${user['prenom'] ?? ''} ${user['nom'] ?? ''}'),
      onTap: () {
        // Navigate to user's profile
      },
    );
  }
}
