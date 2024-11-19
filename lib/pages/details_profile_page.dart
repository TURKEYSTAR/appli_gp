import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailsProfilePage extends StatefulWidget {
  final String transporteurId; // Accept transporteur ID (document ID)

  DetailsProfilePage({required this.transporteurId});

  @override
  _DetailsProfilePageState createState() => _DetailsProfilePageState();
}

class _DetailsProfilePageState extends State<DetailsProfilePage> {
  String? displayName;
  String? role;
  String? email;  // Add any other data you want to fetch
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    _fetchTransporteurData();
  }

  Future<void> _fetchTransporteurData() async {
    try {
      print('Fetching data for transporteurId: ${widget.transporteurId}');
      final transporteurDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.transporteurId)
          .get();

      if (transporteurDoc.exists) {
        setState(() {
          displayName = transporteurDoc.data()?['username'];
          role = transporteurDoc.data()?['role'];
          email = transporteurDoc.data()?['email'];
          phoneNumber = transporteurDoc.data()?['phone'];
        });
      } else {
        setState(() {
          displayName = "Utilisateur non trouvé";
          role = "Non défini";
        });
      }
    } catch (e) {
      print("Error fetching transporteur data: $e");
      setState(() {
        displayName = "Erreur de chargement";
        role = "Erreur";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // Show loading indicator until data is fetched
    if (displayName == null || role == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Chargement...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil de $displayName'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/avata.png'), // Placeholder image
              ),
              SizedBox(height: 20),
              Text(
                displayName!,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Rôle: $role',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 10),
              if (email != null)
                Text(
                  'Email: $email',
                  style: TextStyle(fontSize: 18),
                ),
              if (phoneNumber != null)
                Text(
                  'Téléphone: $phoneNumber',
                  style: TextStyle(fontSize: 18),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
