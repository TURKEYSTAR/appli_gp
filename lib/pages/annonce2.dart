import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:date_format_field/date_format_field.dart';
import '../widgets/custom_text_field1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:currency_picker/currency_picker.dart';

class AnnonceScreen2 extends StatefulWidget {
  final Map<String, dynamic>? previousData; // To pass previous data if needed

  const AnnonceScreen2({Key? key, this.previousData}) : super(key: key);

  @override
  _AnnonceScreen2State createState() => _AnnonceScreen2State();
}

class _AnnonceScreen2State extends State<AnnonceScreen2> {
  final _formKey = GlobalKey<FormState>();
  Country? _selectedCountry2;
  DateTime? _date;
  String _selectedCurrency = 'EUR';

  String getCurrencySymbol(String currencyCode) {
    var format = NumberFormat.simpleCurrency(name: currencyCode);
    return format.currencySymbol;
  }

  // Controllers
  TextEditingController poidsController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController villeController = TextEditingController();

  String? completePhoneNumber;

  String? selectedTransportMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade50,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text(
            "Créer une annonce",
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.indigo,
        ),
        body: Stack(children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/top_background2.png',
              fit: BoxFit.cover,
            ),
          ),
          // Semi-transparent Overlay (optional, for better readability)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
            ),
          ),
          // Foreground Content
          SingleChildScrollView(
              child: Container(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height, // Make it fill the screen
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 70),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 140.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildStepIcon(Icons.list_alt_sharp, Colors.blue),
                          Expanded(
                            child: Divider(
                              color: Colors.blue,
                              thickness: 2,
                            ),
                          ),
                          _buildStepIcon(Icons.local_shipping, Colors.blue),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    const Text(
                      "Arrivée",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildCountryPicker(),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: villeController,
                        decoration: InputDecoration(
                          labelText: "Ville d'arrivée",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          prefixIcon: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Image.asset(
                              'assets/images/ville.png',
                              width: 15,
                              height: 15,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide:
                                const BorderSide(color: Colors.deepPurple),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Colors.black38),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est requis';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildPhoneField(),
                    SizedBox(height: 10),
                    _buildDatePicker(),
                    SizedBox(height: 10),
                    const Text(
                      "Colis",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildPoidsField(),
                    SizedBox(height: 10),
                    _buildPrixField(),
                    const SizedBox(height: 10),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ))
        ]));
  }

  Widget _buildCountryPicker() {
    return Container(
      width:
          MediaQuery.of(context).size.width * 0.8, // Same width as other fields
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black38),
      ),
      child: GestureDetector(
        onTap: () {
          showCountryPicker(
            context: context,
            showPhoneCode: false,
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
                _selectedCountry2 = country;
              });
              print('Country selected: ${country.name}');
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedCountry2 == null
                  ? "Pays d'arrivée"
                  : _selectedCountry2!.name,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: IntlPhoneField(
        decoration: InputDecoration(
          labelText: "Numéro de téléphone",
          fillColor: Colors.white,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.black38),
          ),
        ),
        onChanged: (phone) {
          setState(() {
            completePhoneNumber =
                phone.completeNumber; // Met à jour le numéro complet
          }); // Sauvegarde le numéro complet
        },
        validator: (value) {
          if (value == null) {
            return 'Ce champ est requis';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: DateFormatField(
        type: DateFormatType.type4,
        decoration: InputDecoration(
          labelText: "Date d'arrivée",
          fillColor: Colors.white,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Image.asset(
              'assets/images/ic_5.png',
              // Replace with your asset path
              width: 18,
              height: 18,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.black38),
          ),
        ),
        onComplete: (date) {
          setState(
            () {
              _date = date;
            },
          );
        },
      ),
    );
  }

  Widget _buildPoidsField() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Row(
        children: [
          Expanded(
            child: CustomTextField1(
              controller: poidsController,
              hintText: "Poids maximale à transporter",
              type: TextInputType.number,
              isObscure: false,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Image.asset(
                  'assets/images/ic_5.png',
                  width: 18,
                  height: 18,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est requis';
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 2),
        ],
      ),
    );
  }

  Widget _buildPrixField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: prixController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Prix/kg',
                fillColor: Colors.white,
                filled: true,
                prefixIcon: GestureDetector(
                  onTap: () {
                    showCurrencyPicker(
                      context: context,
                      showFlag: true,
                      showCurrencyName: true,
                      showCurrencyCode: true,
                      onSelect: (Currency currency) {
                        setState(() {
                          _selectedCurrency = currency.code;
                        });
                      },
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Limite la largeur du Row
                    children: [
                      Icon(Icons.arrow_drop_down),
                      Text(getCurrencySymbol(_selectedCurrency)),
                      SizedBox(width: 7),
                    ],
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Colors.black38,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 2),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 15),
          backgroundColor: Colors.blue.shade300,
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _saveAnnonce();
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
    );
  }

  Future<void> _saveAnnonce() async {
    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez sélectionner une date d'arrivée")),
      );
      return;
    }

    final User? user =
        FirebaseAuth.instance.currentUser; // Récupère l'utilisateur actuel
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: Utilisateur non connecté")),
      );
      return;
    }

    final String userId = user.uid; // Récupère l'ID de l'utilisateur

    if (widget.previousData != null) {
      Map<String, dynamic> annonceData = {
        ...widget.previousData!,
        'user_id': userId, // Ajoute l'ID de l'utilisateur
        'pays_arrivee': _selectedCountry2?.name,
        'ville_arrivee': villeController.text,
        'num_arrivee': completePhoneNumber ?? '',
        'date_arrivee': _date,
        'poids_max': poidsController.text,
        'prix_kg':
            '${prixController.text} ${getCurrencySymbol(_selectedCurrency)}',
      };

      // Enregistre les données dans Firestore
      await FirebaseFirestore.instance.collection('annonces').add(annonceData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Annonce enregistrée avec succès"),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to the Profile page after successful submission
      Navigator.pushReplacementNamed(context, '/home', arguments: 1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: Données manquantes")),
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
}
