import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  final String username;
  final String villeDepart;
  final String villeArrivee;
  final DateTime dateReservation;
  final String notifType;
  final XFile? imageXFile;

  NotificationCard({
    required this.villeDepart,
    required this.villeArrivee,
    required this.username,
    required this.dateReservation,
    required this.notifType,
    this.imageXFile,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final bool isDatePast = dateReservation.isBefore(now);

    // Déterminez le format d'affichage
    final String dateDisplay = isDatePast
        ? DateFormat('dd/MM').format(dateReservation)
        : DateFormat('HH:mm').format(dateReservation);

    // Affiche le bon widget en fonction de notifType
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: _getNotificationWidget(dateDisplay),
      ),
    );
  }

  // Gestion dynamique des widgets selon notifType
  Widget _getNotificationWidget(String dateDisplay) {
    switch (notifType) {
      case 'reservation':
        return _reservationNotif(dateDisplay);
      case 'validation_reservation':
        return _validationNotifExpediteur(dateDisplay);
      case 'refus_reservation':
        return _refusNotifExpediteur(dateDisplay);
      case 'paiement_frais':
        return _paiementNotif(dateDisplay);
      case 'paiement_frais_reussi':
        return _paiementNotif1(dateDisplay);
      default:
        return Text('Type de notification inconnu');
    }
  }

  // Widgets pour chaque type de notification
  Widget _reservationNotif(String dateDisplay) => _buildNotificationTemplate(
    title: "Nouvelle reservation de : $username",
    description:
    "Vous avez une reservation suite à votre annonce du transfert $villeDepart - $villeArrivee...",
    dateDisplay: dateDisplay,
  );

  Widget _validationNotifExpediteur(String dateDisplay) => _buildNotificationTemplate(
    title: "Votre réservation a été validée",
    description: "Votre demande de transfert a été approuvée pour le trajet $villeDepart - $villeArrivee.",
    dateDisplay: dateDisplay,
  );

// Nouveau widget pour une notification de déclinaison (expéditeur)
  Widget _refusNotifExpediteur(String dateDisplay) => _buildNotificationTemplate(
    title: "Votre réservation a été déclinée",
    description: "Malheureusement, votre demande de transfert $villeDepart - $villeArrivee a été refusée.",
    dateDisplay: dateDisplay,
  );

  Widget _paiementNotif(String dateDisplay) => _buildNotificationTemplate(
    title: "Paiement des frais de reservation",
    description:
    "L'expéditeur $username a confirmé sa reservation en procédant au paiement.",
    dateDisplay: dateDisplay,
  );

  Widget _paiementNotif1(String dateDisplay) => _buildNotificationTemplate(
    title: "Paiement des frais réussi",
    description: "Votre paiement a été enregistré avec succès.",
    dateDisplay: dateDisplay,
  );

  // Template générique
  Widget _buildNotificationTemplate({
    required String title,
    required String description,
    required String dateDisplay,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              backgroundImage:
              imageXFile == null ? null : FileImage(File(imageXFile!.path)),
              child: imageXFile == null
                  ? const Icon(Icons.person, size: 25, color: Colors.black)
                  : null,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              dateDisplay,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}