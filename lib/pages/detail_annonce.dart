import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flag/flag.dart';
import 'package:country_picker/country_picker.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class DetailAnnoncePage extends StatefulWidget {
  @override
  _DetailAnnoncePageState createState() => _DetailAnnoncePageState();
}

class _DetailAnnoncePageState extends State<DetailAnnoncePage> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  String? getCountryCodeFromName(String countryName) {
    final country = Country.tryParse(countryName);
    return country?.countryCode; // Return country code if found
  }

  IconData getTransportIcon(String mode) {
    switch (mode.toLowerCase()) {
      case 'avion':
        return Icons.airplanemode_active;
      case 'bateau':
        return Icons.directions_boat;
      case 'voiture':
        return Icons.directions_car;
      default:
        return Icons.help_outline; // Default icon if mode not recognized
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final annonceData = args?['annonce'] as Map<String, dynamic>?;
    final userData = args?['userData'] as Map<String, dynamic>?;
    final countryCode = annonceData != null ? getCountryCodeFromName(annonceData['pays_depart']) : null;
    final countryCode2 = annonceData != null ? getCountryCodeFromName(annonceData['pays_arrivee']) : null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Detail annonce",
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
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              _buildUserRow(userData),
              const SizedBox(height: 20),
              const Divider(color: Colors.grey),
              const SizedBox(height: 30),
              _buildLocationRow(annonceData, countryCode, countryCode2),
              const SizedBox(height: 30),
              _buildDescriptionSection(),
              const SizedBox(height: 20),
              _buildDetailsSection(annonceData),
              const SizedBox(height: 15),
              _buildReservationButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserRow(Map<String, dynamic>? userData) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          backgroundImage: imageXFile == null ? null : FileImage(File(imageXFile!.path)),
          child: imageXFile == null
              ? Icon(Icons.person, size: 35, color: Colors.black)
              : null,
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userData?['username'] ?? 'Unknown User', // Uses 'Unknown User' if null
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            Text(
              '${userData?['prenom'] ?? ''} ${userData?['nom'] ?? ''}'.trim(),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationRow(Map<String, dynamic>? annonceData, String? countryCode, String? countryCode2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(width: 2, height: 30, color: Colors.grey),
            _buildStepIcon(Icons.airplane_ticket_outlined, Colors.black),
            Container(width: 2, height: 30, color: Colors.grey),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationDetails(annonceData?['ville_depart'], countryCode, annonceData?['pays_depart']),
            const SizedBox(height: 5),
            Text(
              annonceData?['date_depart'] is Timestamp
                  ? DateFormat('dd/MM/yyyy').format((annonceData?['date_depart'] as Timestamp).toDate())
                  : 'Unknown Date',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 20),
            _buildLocationDetails(annonceData?['ville_arrivee'], countryCode2, annonceData?['pays_arrivee']),
            const SizedBox(height: 5),
            Text(
              annonceData?['date_arrivee'] is Timestamp
                  ? DateFormat('dd/MM/yyyy').format((annonceData?['date_arrivee'] as Timestamp).toDate())
                  : 'Unknown Date',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
        const Spacer(),
        Icon(getTransportIcon(annonceData?['mode'] ?? 'unknown'), size: 100, color: Colors.grey),
      ],
    );
  }

  Widget _buildLocationDetails(String? city, String? countryCode, String? country) {
    return Row(
      children: [
        Text(city ?? 'Unknown City', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        if (countryCode != null) Flag.fromString(countryCode, height: 15, width: 15),
        const SizedBox(width: 10),
        Text(country ?? 'Unknown Country', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Divider(color: Colors.grey)),
        Text("Description de l'annonce", style: GoogleFonts.roboto(textStyle: const TextStyle(fontSize: 12))),
        Expanded(child: Divider(color: Colors.grey)),
      ],
    );
  }

  Widget _buildDetailsSection(Map<String, dynamic>? annonceData) {
    return Column(
      children: [
        _buildDetailBox("Poids maximale ${annonceData?['poids_max'] ?? 'N/A'}"),
        const SizedBox(height: 5),
        _buildDetailBox("Prix/kg ${annonceData?['prix_kg'] ?? 'N/A'}"),
        const SizedBox(height: 5),
        _buildDetailBox("Telephone ${annonceData?['num_depart'] ?? 'N/A'}"),
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

  Widget _buildReservationButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.black,
        ),
        onPressed: () {},
        child: const Text("Reservation", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildStepIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 25),
    );
  }
}
