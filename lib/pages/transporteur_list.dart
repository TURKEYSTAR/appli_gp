import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransporteurList extends StatelessWidget {
  const TransporteurList({Key? key}) : super(key: key);

  // Method to fetch users with role "transporteur"
  Stream<List<Map<String, dynamic>>> fetchTransporteurs() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Transporteur')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: fetchTransporteurs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No transporteurs found.'));
        }

        var transporteurs = snapshot.data!;
        return Column(
          children: List.generate(transporteurs.length, (index) {
            var transporteur = transporteurs[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text(transporteur['username'] ?? 'Unknown'),
                subtitle: Text('${transporteur['prenom'] ?? ''} ${transporteur['nom'] ?? ''}'),
                leading: CircleAvatar(
                  backgroundImage: transporteur['profile_picture_url'] != null
                      ? NetworkImage(transporteur['profile_picture_url'])
                      : AssetImage('assets/images/default_avatar.png') as ImageProvider,
                ),
                onTap: () {
                  // Handle navigation or display of transporteur details here
                },
              ),
            );
          }),
        );
      },
    );
  }
}
