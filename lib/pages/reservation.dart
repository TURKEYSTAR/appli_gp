import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appli_gp/pages/log.dart';
import 'package:country_picker/country_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../widgets/custom_text_field1.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({Key? key}) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController prenomController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController villeController = TextEditingController(); // Pour la ville

  String? completePhoneNumber;
  String? selectedPackageType;
  String? selectedFragility;
  Country? _selectedCountry; // Store the selected country here

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final annonceData = args?['annonce'] as Map<String, dynamic>?;

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
                    "Informations sur l'expéditeur",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5), // Espacement
                  Text(
                    "Etape 1 of 3",
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
                    color: Colors.grey, // Couleur de la ligne
                    thickness: 2, // Épaisseur de la ligne
                  ),
                ),

                _buildStepIcon(Icons.account_box_outlined, Colors.grey),

                // Ligne entre les icônes
                Expanded(
                  child: Divider(
                    color: Colors.grey, // Couleur de la ligne
                    thickness: 2, // Épaisseur de la ligne
                  ),
                ),

                _buildStepIcon(Icons.local_shipping, Colors.grey),
              ],
            ),
          ),
          SizedBox(height: 30),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField1(
                  controller: nomController,
                  hintText: "Nom",
                  type: TextInputType.text,
                  isObsecre: false,
                ),
                CustomTextField1(
                  controller: prenomController,
                  hintText: "Prénom",
                  type: TextInputType.text,
                  isObsecre: false,
                ),
                SizedBox(height: 8),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: IntlPhoneField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Numéro de téléphone',
                      fillColor: Colors.white70,
                      filled: true,
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onChanged: (phone) {
                      setState(() {
                        completePhoneNumber = phone.completeNumber; // Met à jour le numéro complet
                      });// Sauvegarde le numéro complet
                    },
                  ),
                ),

                CustomTextField1(
                  controller: adressController,
                  hintText: "Adresse",
                  type: TextInputType.text,
                  isObsecre: false,
                ),
                SizedBox(height: 12),
                // Pays et ville sur la même ligne
                Container(
                  width: MediaQuery.of(context).size.width / 1.3, // Définir la largeur du Row
                  child: Row(
                    children: [
                      // Container pour le champ du pays
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: false, // Cache les codes téléphoniques
                              countryListTheme: CountryListThemeData(
                                flagSize: 25,
                                backgroundColor: Colors.white,
                                textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                                bottomSheetHeight: 500,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                              ),
                              onSelect: (Country country) {
                                setState(() {
                                  _selectedCountry = country; // Stocker le pays sélectionné
                                });
                                print('Country selected: ${country.name}'); // Utilise seulement le nom du pays
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_selectedCountry == null
                                    ? "Pays"
                                    : _selectedCountry!.name
                                ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      // Container pour le champ ville
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: villeController,
                          decoration: InputDecoration(
                            labelText: 'Ville',
                            fillColor: Colors.white70,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )


              ],
            ),
          ),
          SizedBox(height: 30),
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
                    Navigator.pushNamed(
                      context,
                      '/reservation2',
                      arguments: {
                        'annonce': annonceData,
                        'previousData1': {
                          'prenom_expediteur': prenomController.text,
                          'nom_expediteur': nomController.text,
                          'addresse_expediteur': adressController.text,
                          'phone_expediteur': completePhoneNumber ?? '',
                          'ville_expediteur': villeController.text,
                          'pays_expediteur':  _selectedCountry?.name ?? '',
                        },
                        // Ajoutez d'autres informations de réservation au besoin
                      },

                    );// Action à réaliser lors du clic sur le bouton
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Garde le bouton compact
                    children: [
                      Text(
                        'Continuer'.toUpperCase(),
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
