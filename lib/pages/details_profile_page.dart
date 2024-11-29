import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailsProfilePage extends StatefulWidget {
  final String transporteurId;

  DetailsProfilePage({required this.transporteurId});

  @override
  _DetailsProfilePageState createState() => _DetailsProfilePageState();
}

class _DetailsProfilePageState extends State<DetailsProfilePage> {
  String? displayName;
  String? role;
  String? email;
  String? phoneNumber;
  String? address;

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
          address = transporteurDoc.data()?['address']; // Example field
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

    final userDetails = {
      if (email != null) "Email": email!,
      if (phoneNumber != null) "Mobile": phoneNumber!,
      if (address != null) "Adresse": address!,
    };

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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              style: TextStyle(fontSize: 14, color: Colors.grey),
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
}
