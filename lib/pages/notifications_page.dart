import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_card.dart';

class NotificationPage extends StatelessWidget {
  // Fonction pour récupérer le username de l’expéditeur
  Future<String> _getExpediteurUsername(String expediteurId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(expediteurId)
          .get();
      if (userDoc.exists) {
        return userDoc.data()?['username'] ?? 'Nom inconnu';
      } else {
        return 'Nom inconnu';
      }
    } catch (e) {
      print("Erreur de récupération du username : $e");
      return 'Nom inconnu';
    }
  }

  // Fonction pour récupérer les informations d'une annonce
  Future<Map<String, dynamic>?> _getAnnonce(String annonceId) async {
    try {
      final annonceDoc = await FirebaseFirestore.instance
          .collection('annonces')
          .doc(annonceId)
          .get();
      return annonceDoc.data();
    } catch (e) {
      print("Erreur lors de la récupération de l'annonce : $e");
      return null;
    }
  }

  // Fonction pour récupérer les informations d'une annonce
  Future<Map<String, dynamic>?> _getReservation(String reservationId) async {
    try {
      final reservationDoc = await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .get();
      return reservationDoc.data();
    } catch (e) {
      print("Erreur lors de la récupération de l'annonce : $e");
      return null;
    }
  }

  // Vérifie si une notification est pertinente pour l'utilisateur courant
  bool isNotificationRelevant(Map<String, dynamic> data, String currentUserUid) {
    final notifType = data['type'] as String?;
    final transporteurId = data['transporteur_id'] as String?;
    final expediteurId = data['expediteur_id'] as String?;

    print("Notif Type: $notifType, Transporteur ID: $transporteurId, Expediteur ID: $expediteurId");
    switch (notifType) {
      case 'reservation':
        return transporteurId == currentUserUid; // Notifications pour transporteurs
      case 'validation_reservation':
      case 'refus_reservation':
        return expediteurId == currentUserUid; // Notifications pour expéditeurs
      default:
        return false; // Ignorer les notifications non pertinentes
    }
  }

  // Récupère les notifications pertinentes pour l'utilisateur courant
  Stream<List<Map<String, dynamic>>> fetchNotifications() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Stream.empty(); // Flux vide si aucun utilisateur n'est connecté
    }
    print("Utilisateur courant UID : ${currentUser.uid}");
    return FirebaseFirestore.instance
        .collection('notifications')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> filteredNotifications = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (isNotificationRelevant(data, currentUser.uid)) {
          filteredNotifications.add(data);
        }
      }

      return filteredNotifications;
    });
  }

  // Récupère les détails d'une notification (expéditeur et annonce)
  Future<Map<String, dynamic>> _fetchNotificationDetails(
      Map<String, dynamic> data) async {
    try {
      final expediteurUsername =
      await _getExpediteurUsername(data['expediteur_id']);
      final annonce = await _getAnnonce(data['annonce_id']);
      final reservation = await _getReservation(data['reservation_id']);
      return {
        'username': expediteurUsername,
        'annonce': annonce,
        'reservation': reservation,
      };
    } catch (e) {
      print("Erreur lors de la récupération des détails : $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.deepPurple.shade600,
        iconTheme: IconThemeData(color: Colors.black45),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("Erreur dans StreamBuilder : ${snapshot.error}");
            return Center(
                child: Text(
                    "Erreur de chargement des notifications : ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Notifications Page', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 20),
                  Text('Vous n\'avez pas de nouvelles notifications',
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          // Affiche les notifications si elles existent
          return ListView(
            children: snapshot.data!.map((notification) {
              return FutureBuilder<Map<String, dynamic>>(
                future: _fetchNotificationDetails(notification),
                builder: (context, detailsSnapshot) {
                  if (detailsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final details = detailsSnapshot.data;
                  if (details == null || details.isEmpty) {
                    return Text("Détails non disponibles");
                  }

                  final annonce = details['annonce'];
                  final data = details['reservation'];
                  final username = details['username'];

                  return GestureDetector(
                    onTap: () {
                      if (annonce != null && data != null) {
                        Navigator.pushNamed(
                          context,
                          '/detailNotif1',
                          arguments: {
                            'annonceData': annonce,
                            'data': data,
                            'username': username,
                            'notificationData': notification,
                          },
                        );
                      } else {
                        print(
                            "Données insuffisantes pour afficher les détails de la notification.");
                      }
                    },
                    child: NotificationCard(
                      username: username ?? 'Nom inconnu',
                      villeDepart:
                      annonce?['ville_depart'] ?? 'Départ inconnu',
                      villeArrivee:
                      annonce?['ville_arrivee'] ?? 'Arrivée inconnue',
                      dateReservation:
                      (notification['date_notification'] as Timestamp).toDate(),
                      notifType: notification['type'],
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}