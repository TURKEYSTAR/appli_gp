import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:appli_gp/pages/annonce.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:date_format_field/date_format_field.dart';
import '../widgets/custom_text_field1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:currency_picker/currency_picker.dart';

class AnnonceScreen2 extends StatefulWidget {
  final Map<String, dynamic>? previousData;// To pass previous data if needed

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
  TextEditingController phoneController = TextEditingController();

  String? selectedTransportMode;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Country selection
              _buildCountryPicker(),
              SizedBox(height: 10),
              CustomTextField1(
                controller: villeController,
                hintText: "Ville d'arrivée",
                type: TextInputType.text,
                isObsecre: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est requis';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              _buildPhoneField(),
              SizedBox(height: 10),
              _buildDatePicker(),
              SizedBox(height: 10),
              const Text(
                "Colis",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              _buildPoidsField(),
              SizedBox(height: 10),
              _buildPrixField(),
              const SizedBox(height: 30),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountryPicker() {
    return GestureDetector(
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
            Text(_selectedCountry2 == null ? "Pays de d'arrivée" : _selectedCountry2!.name),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.3,
      child: IntlPhoneField(
        controller: phoneController,
        decoration: InputDecoration(
          labelText: "Numéro de téléphone d'arrivée",
          fillColor: Colors.white70,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
        validator: (value) {
          if (value == null ) {
            return 'Ce champ est requis';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.3,
      child: DateFormatField(
        type: DateFormatType.type4,
        decoration: InputDecoration(
          labelText: "Date d'arrivée",
          fillColor: Colors.white70,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
        onComplete: (date) {
          setState(() {
            _date = date;
          },
          );
        },
      ),
    );
  }

  Widget _buildPoidsField() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.3,
      child: Row(
        children: [
          Expanded(
            child: CustomTextField1(
              controller: poidsController,
              hintText: "Poids maximale à transporter",
              type: TextInputType.number,
              isObsecre: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est requis';
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 2),
          Image.asset(
            'assets/images/poids.jpeg',
            width: 20,
            height: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildPrixField() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.3,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: prixController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Prix/kg',
                fillColor: Colors.white70,
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
                    mainAxisSize: MainAxisSize.min,  // Limite la largeur du Row
                    children: [
                      Icon(Icons.arrow_drop_down),
                      Text(getCurrencySymbol(_selectedCurrency)),
                      SizedBox(width:7),
                    ],
                  ),
                ),
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
            ),
          ),

          SizedBox(width: 2),
          Icon(
            Icons.money,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 85, vertical: 15),
          backgroundColor: Colors.black,
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _saveAnnonce(); // Save the annonce to Firestore
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

    final User? user = FirebaseAuth.instance.currentUser; // Récupère l'utilisateur actuel
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
        'num_arrivee': phoneController.text,
        'date_arrivee': _date,
        'poids_max': poidsController.text,
        'prix_kg': '${prixController.text} ${getCurrencySymbol(_selectedCurrency)}',
      };

      // Enregistre les données dans Firestore
      await FirebaseFirestore.instance.collection('annonces').add(annonceData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Annonce enregistrée avec succès"), backgroundColor: Colors.green,),
      );

      // Navigate to the Profile page after successful submission
      Navigator.pushReplacementNamed(context, '/home', arguments: 1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: Données manquantes")),
      );
    }
  }

}