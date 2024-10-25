import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appli_gp/pages/annonce2.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:date_format_field/date_format_field.dart';
import '../widgets/custom_text_field1.dart';
import '../widgets/transport_widget.dart';
import 'log.dart';

class AnnonceScreen extends StatefulWidget {
  const AnnonceScreen({Key? key}) : super(key: key);

  @override
  _AnnonceScreenState createState() => _AnnonceScreenState();
}

class _AnnonceScreenState extends State<AnnonceScreen> {
  final _formKey = GlobalKey<FormState>();
  Country? _selectedCountry1;
  DateTime? _date;  // Variable pour stocker la date sélectionnée

  // Controllers
  TextEditingController paysController = TextEditingController();
  TextEditingController villeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController datePickerController = TextEditingController();

  // Variable pour stocker le moyen de transport sélectionné
  String? selectedTransportMode;

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
                builder: (context) => const LoginScreen2(), // Retourne à l'écran précédent
              ),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          "Créer une annonce",
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
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildStepIcon(Icons.list_alt_sharp, Colors.black),
                Expanded(
                  child: Divider(
                    color: Colors.grey, // Couleur de la ligne
                    thickness: 2, // Épaisseur de la ligne
                  ),
                ),
                _buildStepIcon(Icons.list_alt_sharp, Colors.grey),
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
          SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Moyen de transport",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TransportWidget(
                              data: Icons.airplanemode_active,
                              label: 'Avion',
                              selectedTransportMode: selectedTransportMode,
                              onSelected: (value) {
                                setState(() {
                                  selectedTransportMode = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: TransportWidget(
                              data: Icons.directions_boat_filled_sharp,
                              label: 'Bateau',
                              selectedTransportMode: selectedTransportMode,
                              onSelected: (value) {
                                setState(() {
                                  selectedTransportMode = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: TransportWidget(
                              data: Icons.directions_car,
                              label: 'Voiture',
                              selectedTransportMode: selectedTransportMode,
                              onSelected: (value) {
                                setState(() {
                                  selectedTransportMode = value;
                                });
                              },
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
                        "Départ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode: false, // Cache les codes téléphoniques
                            countryListTheme: const CountryListThemeData(
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
                                _selectedCountry1 = country; // Stocker le pays sélectionné
                              });
                              print('Country selected: ${country.name}'); // Utilise seulement le nom du pays
                            },
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_selectedCountry1 == null
                                  ? "Pays de départ"
                                  : _selectedCountry1!.name), // Affiche seulement le nom du pays
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                CustomTextField1(
                  controller: villeController,
                  hintText: "Ville de depart",
                  isObsecre: false,
                  type: TextInputType.text,
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: IntlPhoneField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Numéro de téléphone de départ',
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
                    validator: (value) {
                      if (value == null ) {
                        return 'Ce champ est requis';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,  // Match width with CustomTextField1
                  child: DateFormatField(
                    type: DateFormatType.type4,
                    decoration: InputDecoration(
                      labelText: 'Date de départ ',
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

                    onComplete: (date) {
                      setState(() {
                        _date = date;
                      });
                    },
                  ),
                ),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnnonceScreen2(
                          previousData: {
                            'pays_depart': _selectedCountry1?.name,
                            'ville_depart': villeController.text,
                            'num_depart': phoneController.text,
                            'date_depart': _date,
                            'mode': selectedTransportMode,
                          },
                        ),
                      ),
                    );
                    // Action à réaliser lors du clic sur le bouton
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
}
