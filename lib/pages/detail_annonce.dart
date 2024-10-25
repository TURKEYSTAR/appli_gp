import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flag/flag.dart';

import '../main.dart';

class DetailAnnoncePage extends StatelessWidget {

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(), // Retourne à l'écran précédent
              ),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          "Detail annoncele",
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

      // Pour toute la largeur du body
      body: Center( // Center pour centrer horizontalement tout le contenu
        child: Container(
          width: MediaQuery.of(context).size.width / 1.1, // Même largeur pour tout le body
          child: Column(
            children: [
              // Espace entre l'AppBar et le premier Row
              const SizedBox(height: 30),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.05,
                      backgroundColor: Colors.white,
                      backgroundImage: imageXFile == null
                          ? null
                          : FileImage(
                        File(imageXFile!.path),
                      ),
                      child: imageXFile == null
                          ? Icon(
                        Icons.person,
                        size: MediaQuery.of(context).size.width * 0.07,
                        color: Colors.black,
                      )
                          : null,
                    ),
                  ),

                  // Espace entre l'icône et le texte
                  const SizedBox(width: 15),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mariiix", // ${Log.annonce.nom}
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const Text(
                        "Mariama Dib Faye", // ${Log.annonce.adresse}
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
              
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              // Espace entre le premier Row et le contenu suivant
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                      children: [
                        // Ligne au-dessus de l'icône
                        Container(
                          width: 2, // Épaisseur de la ligne
                          height: 30, // Ajuste la hauteur si nécessaire
                          color: Colors.grey, // Couleur de la ligne
                        ),
                        _buildStepIcon(Icons.airplane_ticket_outlined, Colors.black),
                        // Ligne en dessous de l'icône
                        Container(
                          width: 2, // Épaisseur de la ligne
                          height: 30, // Ajuste la hauteur si nécessaire
                          color: Colors.grey, // Couleur de la ligne
                        ),
                      ],
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: <Widget>[
                          Text(
                            'Seoul',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          Flag.fromString(
                      'KR',
                            height: 15,
                       width: 15,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'South Korea',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        '18/10/2024',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Row(
                        children: <Widget>[
                          Text(
                            'Dakar',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          Flag.fromString(
                            'SN',
                            height: 15,
                            width: 15,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Sénégal',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        '28/10/2024',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    Icons.airplanemode_active,
                    size: 120, // Ajuste la taille de l'icône
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey, // Couleur de la ligne
                      thickness: 1, // Épaisseur de la ligne
                    ),
                  ),
                  Text(
                      "Description de l'annoncele", // ${Log.annonce.description}
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 12,))),
                  Expanded(
                    child: Divider(
                      color: Colors.grey, // Couleur de la ligne
                      thickness: 1, // Épaisseur de la ligne
                    ),
                  ),
                ]
              ),

              const SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centrer verticalement
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Poids maximale 100kg",
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Prix/kg 3000 Fcfa",
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Telephone +221 775554874",
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.12,), // Ajoute un peu de padding sur les côtés
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Aligne le bouton à droite
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 85, vertical: 15), // Ajuste la taille du bouton
                            backgroundColor: Colors.black, // Couleur de fond du bouton
                          ),
                          onPressed: () {
                            //Navigator.push(
                            // context,
                            //MaterialPageRoute(
                            //builder: (context) => const AnnonceScreen2()));// Action à réaliser lors du clic sur le bouton
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // Garde le bouton compact
                            children: [
                              Text(
                                'Reserver'.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),



            ],
          ),
        ),
      ),
    );
  }
}
Widget _buildStepIcon(IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.all(10),
    child: Icon(
      icon,
      color: color,
    ),
  );
}
