import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appli_gp/pages/inscription.dart';
import 'package:appli_gp/pages/log.dart';
import 'package:country_picker/country_picker.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../widgets/custom_text_field.dart';
import '../widgets/header_widget.dart';
import '../widgets/custom_text_field1.dart';

class ReservationScreen3 extends StatefulWidget {
  const ReservationScreen3({Key? key}) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen3> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController prenomController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController villeController = TextEditingController(); // Pour la ville

  String? selectedPackageType;
  String? selectedFragility;
  bool isNonEmpilable = false;  // State for "Non empilable"
  bool isFragile = false;
  Country? _selectedCountry; // Store the selected country here

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
                    builder: (context) =>
                    const LoginScreen2())); // Retourne à l'écran précédent
          },
        ),
        centerTitle: true,
        title: Text(
          "Reservation",
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
      backgroundColor: Color(0xFFE0E0E0),

      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.05), // 5% padding
            child: const Align(
              alignment: Alignment.centerRight,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Informations sur le colis",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5), // Espacement
                  Text(
                    "Etape 3 sur 3",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center, // Aligne les icônes et les lignes
              children: [
                _buildStepIcon(Icons.person, Colors.black),

                // Ligne entre les icônes
                Expanded(
                  child: Divider(
                    color: Colors.black, // Couleur de la ligne
                    thickness: 2, // Épaisseur de la ligne
                  ),
                ),

                _buildStepIcon(Icons.account_box_outlined, Colors.black),

                // Ligne entre les icônes
                Expanded(
                  child: Divider(
                    color: Colors.black, // Couleur de la ligne
                    thickness: 2, // Épaisseur de la ligne
                  ),
                ),

                _buildStepIcon(Icons.local_shipping, Colors.black),
              ],
            ),
          ),
          SizedBox(height: 30),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                      child: Row(
                        children: [
                          // Espace entre l'image et le champ de texte
                          Expanded(
                            child: CustomTextField1(// Vous devez mettre une icône, même si vous ne l'utilisez pas
                              controller: nomController,
                              hintText: "Poids du colis (kg)",
                              type: TextInputType.number,
                              isObsecre: false,
                            ),
                          ),
                          SizedBox(width: 2),
                          Image.asset(
                            'assets/images/poids.jpeg',
                            width: 20,
                            height: 24,
                          ),
                        ],
                      )),
                SizedBox(height: 8),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  padding: const EdgeInsets.only(top: 10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(

                      labelText: 'Type de colis', // Label comme dans CustomTextField
                      fillColor: Colors.white70,
                      filled: true,
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.red, width: 2.0),
                      ),
                    ),
                    value: selectedPackageType, // Initialize this with a default value or null
                    items: [
                      DropdownMenuItem(
                        value: 'Enveloppe',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espace entre le texte et l'icône
                          children: [
                            Text('Enveloppe'),
                            Image.asset(
                              'assets/images/enveloppe.jpeg',
                              width: 40,
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Carton1',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espace entre le texte et l'icône
                          children: [
                            Text('Boite'),
                            Image.asset(
                              'assets/images/chaussure1.jpeg',
                              width: 40,
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Carton2',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espace entre le texte et l'icône
                          children: [
                            Text('Carton'),
                            Image.asset(
                              'assets/images/produit.jpeg',
                              width: 40,
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Carton4',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espace entre le texte et l'icône
                          children: [
                            Text('Autre'),

                          ],
                        ),
                      ),
                    ],
                    onChanged: (newValue) {
                      setState(() {
                        selectedPackageType = newValue!;

                        if (selectedPackageType == 'Enveloppe') {
                        lengthController.text = '32';
                        widthController.text = '24';
                        heightController.text = '1';
                        } else if (selectedPackageType == 'Carton1') { // For 'Boite'
                        lengthController.text = '35';
                        widthController.text = '20';
                        heightController.text = '15';
                        } else if (selectedPackageType == 'Carton2') { // For 'Carton'
                        lengthController.text = '75';
                        widthController.text = '35';
                        heightController.text = '35';
                        } else {
                        // Reset fields if 'Autre' is selected or no type is selected
                        lengthController.clear();
                        widthController.clear();
                        heightController.clear();
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Veuillez sélectionner une option';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                // Pays et ville sur la même ligne
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Dimensions du colis (cm)",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            // Longueur
                            Expanded(
                              child: CustomTextField1(
                                controller: lengthController,
                                hintText: "Longueur (cm)",
                                type: TextInputType.number,
                                isObsecre: false,
                              ),
                            ),
                            // Largeur
                            Expanded(
                              child: CustomTextField1(
                                controller: widthController,
                                hintText: "Largeur (cm)",
                                type: TextInputType.number,
                                isObsecre: false,
                              ),
                            ),
                            // Hauteur
                            Expanded(
                              child: CustomTextField1(
                                controller: heightController,
                                hintText: "Hauteur (cm)",
                                type: TextInputType.number,
                                isObsecre: false,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Quantité",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      InputQty(//color of the increase and decrease icon
                        btnColor1: Colors.black,
                        btnColor2: Colors.black,
                        maxVal: double.maxFinite, //max val to go
                        initVal: 1,  //min starting val
                        onQtyChanged: (val) { //on value changed we may set the value
                          //setstate could be called
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Votre colis est...",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          // Longueur
                          Expanded(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isNonEmpilable,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isNonEmpilable = value!;
                                    });
                                  },
                                ),
                                const Text("Non empilable"),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isFragile,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isFragile = value!;
                                    });
                                  },
                                ),
                                const Text("Fragile"),
                              ],
                            ),
                          ),
                        ],
                      ),
                        ],
                      ),)
                    ],
                  ),
                ),

          const SizedBox(height: 30),
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
                    // MaterialPageRoute(
                    //   builder: (context) => const ReservationScreen2()));// Action à réaliser lors du clic sur le bouton
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Garde le bouton compact
                    children: [
                      Text(
                        'Enregistrer'.toUpperCase(),
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
    );
  }
}
Widget _buildStepIcon(IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      border: Border.all(color: color, width: 2),
    ),
    child: Icon(
      icon,
      color: color,
    ),
  );
}
