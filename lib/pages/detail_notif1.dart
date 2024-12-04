import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_picker/country_picker.dart';


class DetailReservationPage extends StatefulWidget {
  @override
  _DetailReservationPageState createState() => _DetailReservationPageState();
}

class _DetailReservationPageState extends State<DetailReservationPage> {

  String? getCountryCodeFromName(String countryName) {
    final country = Country.tryParse(countryName);
    return country?.countryCode; // Return country code if found
  }
  Future<void> _changerStatutReservation({
    required String annonceId,
    required String reservationId,
    required String expediteurId,
    required String transporteurId,
    required String nouveauStatut,
    required String typeNotification,
  }) async {
    try {
      // Mise à jour du statut dans Firestore
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .update({
        'statut': nouveauStatut,
        'date_cs': Timestamp.now(),
      });

      // Ajout de la notification pour l'expéditeur
      await FirebaseFirestore.instance.collection('notifications').add({
        'type': typeNotification,
        'expediteur_id': expediteurId,
        'transporteur_id': transporteurId,
        'annonce_id': annonceId,
        'reservation_id': reservationId,
        'date_notification': Timestamp.now(),
      });

      print("Statut mis à jour et notification envoyée.");
    } catch (e) {
      print("Erreur : $e");
      throw Exception("Impossible de changer le statut de la réservation.");
    }
  }


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final reservationData = args?['data'] as Map<String, dynamic>?;
    final annonceData = args?['annonceData'] as Map<String, dynamic>?;
    final username = args?['username'] as String?;
    final notificationData = args?['notificationData'] as Map<String, dynamic>?;

    print("Données de réservation : $annonceData");
    print("Données de l'annonce : $reservationData");
    print("Données de la notification : $notificationData");


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Nouvelle réservation${username != null ? ' de $username' : ''}",
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.black54,
      ),
      backgroundColor: const Color(0xFFE0E0E0),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              _buildMessageRow(annonceData),
              const SizedBox(height: 20),
              _buildDescriptionSection(),
              const SizedBox(height: 30),
              _buildDetailsSection(reservationData),
              const SizedBox(height: 15),
              _buildReservationButton(notificationData),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageRow(Map<String, dynamic>? annonceData) {
    return Row(
      children: [
        Expanded( // Permet au texte de prendre toute la largeur disponible
          child: Text(
            'Vous avez une nouvelle réservation suite à votre annonce de transfert de colis pour le trajet ${annonceData?['ville_depart'] ?? 'N/A'} - ${annonceData?['ville_arrivee'] ?? 'N/A'}',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            softWrap: true, // Assure que le texte revient à la ligne si nécessaire
            overflow: TextOverflow.visible, // Gère les débordements
          ),
        ),
      ],
    );
  }


  Widget _buildDescriptionSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Divider(color: Colors.grey)),
        Text("Description de la reservation", style: GoogleFonts.roboto(textStyle: const TextStyle(fontSize: 12))),
        Expanded(child: Divider(color: Colors.grey)),
      ],
    );
  }

  Widget _buildDetailsSection(Map<String, dynamic>? reservationData) {
    return Column(
      children: [
        _buildDetailBox("Expediteur : ${reservationData?['prenom_expediteur'] ?? 'N/A'} ${reservationData?['nom_expediteur'] ?? 'N/A'}"),
        const SizedBox(height: 5),
        _buildDetailBox("Adresse expediteur : ${reservationData?['addresse_expediteur'] ?? 'N/A'}"),
        const SizedBox(height: 5),
        _buildDetailBox("Telephone expediteur ${reservationData?['phone_expediteur'] ?? 'N/A'} "),
        const SizedBox(height: 5),
        _buildDetailBox("Destinataire : ${reservationData?['prenom_destinataire'] ?? 'N/A'} ${reservationData?['nom_destinataire'] ?? 'N/A'}"),
        const SizedBox(height: 5),
        _buildDetailBox("Adresse destinataire : ${reservationData?['addresse_destinataire'] ?? 'N/A'}"),
        const SizedBox(height: 5),
        _buildDetailBox("Telephone destinataire ${reservationData?['phone_destinataire'] ?? 'N/A'} "),
        const SizedBox(height: 5),
        _buildDetailBox("Type de colis : ${reservationData?['type_colis'] ?? 'N/A'} - ${reservationData?['fragilite'] ?? 'N/A'} "),
        const SizedBox(height: 5),
        _buildDetailBox("Dimensions du colis : longueur= ${reservationData?['longueur_colis'] ?? 'N/A'} cm / largeur  = ${reservationData?['largeur_colis'] ?? 'N/A'} cm / hauteur= ${reservationData?['hauteur_colis'] ?? 'N/A'} cm"),
        const SizedBox(height: 5),
        _buildDetailBox("Poids : ${reservationData?['poids_colis'] ?? 'N/A'} Kg"),
        const SizedBox(height: 5),
        _buildDetailBox("Quantité : ${reservationData?['quantite'] ?? 'N/A'}"),

      ],
    );
  }

  Widget _buildDetailBox(String text) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 5, offset: const Offset(0, 5)),
        ],
      ),
      child: Center(child: Text(text, style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 14))),
    );
  }


  Widget _buildReservationButton(Map<String, dynamic>? notificationData) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.13),
      child : Row(
        children: [
          ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Valider la réservation'),
                  content: Text('Êtes-vous sûr de vouloir valider cette réservation ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), // Fermer le dialog
                      child: Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context); // Fermer le dialog
                        try {
                          String reservationId = notificationData?['reservation_id'];
                          String expediteurId = notificationData?['expediteur_id'];
                          String transporteurId = notificationData?['transporteur_id'];
                          String annonceId = notificationData?['annonce_id'];

                          await _changerStatutReservation(
                            reservationId: reservationId,
                            expediteurId: expediteurId,
                            transporteurId: transporteurId,
                            nouveauStatut: 'valide',
                            typeNotification: 'validation_reservation',
                            annonceId: annonceId,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Réservation validée')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur : ${e.toString()}')),
                          );
                        }
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            ),
            child: Text("Valider"),
          ),
          ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                String motif = ""; // Pour stocker le motif sélectionné
                return AlertDialog(
                  title: Text('Pour quelles raisons souhaitez vous decliner la réservation'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Checkbox(
                          value: motif == "Poids maximal dépassé",
                          onChanged: (_) {
                            setState(() => motif = "Poids maximal dépassé");
                          },
                        ),
                        title: Text("Poids maximal dépassé"),
                      ),
                      ListTile(
                        leading: Checkbox(
                          value: motif == "Données non conformes",
                          onChanged: (_) {
                            setState(() => motif = "Données non conformes");
                          },
                        ),
                        title: Text("Données non conformes"),
                      ),
                      ListTile(
                        leading: Checkbox(
                          value: motif == "Autre",
                          onChanged: (_) {
                            setState(() => motif = "Autre");
                          },
                        ),
                        title: Text("Autre..."),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), // Fermer le dialog
                      child: Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context); // Fermer le dialog
                        if (motif.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Veuillez sélectionner un motif')),
                          );
                          return;
                        }
                        try {
                          String reservationId = notificationData?['reservation_id'];
                          String expediteurId = notificationData?['expediteur_id'];
                          String transporteurId = notificationData?['transporteur_id'];
                          String annonceId = notificationData?['annonce_id'];

                          await FirebaseFirestore.instance.collection('notifications').add({
                            'motif': motif,
                            'type': 'refus_reservation',
                            'expediteur_id': expediteurId,
                            'transporteur_id': transporteurId,
                            'annonce_id': annonceId,
                            'reservation_id': reservationId,
                            'date_notification': Timestamp.now(),
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Réservation déclinée')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur : ${e.toString()}')),
                          );
                        }
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            ),
            child: Text("Décliner"),
          ),


        ],
      ),

    );
  }
}