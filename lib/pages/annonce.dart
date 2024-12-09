import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appli_gp/pages/annonce2.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:date_format_field/date_format_field.dart';
import '../widgets/transport_widget.dart';

class AnnonceScreen extends StatefulWidget {
  const AnnonceScreen({Key? key}) : super(key: key);

  @override
  _AnnonceScreenState createState() => _AnnonceScreenState();
}

class _AnnonceScreenState extends State<AnnonceScreen> {
  final _formKey = GlobalKey<FormState>();
  Country? _selectedCountry1;
  DateTime? _date;
  String? completePhoneNumber;

  // Controllers
  TextEditingController paysController = TextEditingController();
  TextEditingController villeController = TextEditingController();
  TextEditingController datePickerController = TextEditingController();

  String? selectedTransportMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade50,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/home',
                arguments: 2,
              );
            },
          ),
          centerTitle: true,
          title: Text(
            "Créer une annonce",
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Stack(children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/top_background.png',
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
            child: Column(
              children: [
                SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildStepIcon(Icons.list_alt_sharp, Colors.blue),
                      Expanded(
                        child: Divider(
                          color: Colors.white70,
                          thickness: 2,
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
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TransportWidget(
                                    data: Icons.airplanemode_active,
                                    label: 'Avion',
                                    selectedTransportMode:
                                        selectedTransportMode,
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
                                    selectedTransportMode:
                                        selectedTransportMode,
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
                                    selectedTransportMode:
                                        selectedTransportMode,
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
                      SizedBox(height: 30),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Départ",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                showCountryPicker(
                                  context: context,
                                  showPhoneCode: false,
                                  countryListTheme: const CountryListThemeData(
                                    flagSize: 25,
                                    backgroundColor: Colors.white,
                                    textStyle: TextStyle(
                                        fontSize: 16, color: Colors.blueGrey),
                                    bottomSheetHeight: 500,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  onSelect: (Country country) {
                                    setState(() {
                                      _selectedCountry1 = country;
                                    });
                                  },
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.3,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _selectedCountry1 == null
                                        ? Colors.black38
                                        : Colors.deepPurple,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _selectedCountry1 == null
                                            ? "Pays de départ"
                                            : _selectedCountry1!.name,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down,
                                        color: Colors.black38),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: TextFormField(
                          controller: villeController,
                          decoration: InputDecoration(
                            labelText: "Ville de départ",
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Image.asset(
                                'assets/images/ville.png',
                                // Update with your image path
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
                              borderSide:
                                  const BorderSide(color: Colors.black38),
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
                      Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: IntlPhoneField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Numéro de téléphone',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 20.0,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Colors.deepPurple,
                                // Focused border in deep purple
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Colors.black38,
                                // Enabled border in black38
                                width: 1.5,
                              ),
                            ),
                          ),
                          onChanged: (phone) {
                            setState(() {
                              completePhoneNumber = phone
                                  .completeNumber; // Update the complete number
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Ce champ est requis'; // Validation message
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: DateFormatField(
                          type: DateFormatType.type4,
                          decoration: InputDecoration(
                            labelText: 'Date de départ',
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Image.asset(
                                'assets/images/ic_5.png',
                                // Replace with your asset path
                                width: 18,
                                height: 18,
                              ),
                            ),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.10,
                  ), // Ajoute un peu de padding sur les côtés
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 130, vertical: 15),
                          // Ajuste la taille du bouton
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnnonceScreen2(
                                previousData: {
                                  'pays_depart': _selectedCountry1?.name,
                                  'ville_depart': villeController.text,
                                  'num_depart': completePhoneNumber ?? '',
                                  'date_depart': _date,
                                  'mode': selectedTransportMode,
                                },
                              ),
                            ),
                          );
                          // Action à réaliser lors du clic sur le bouton
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          // Garde le bouton compact
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
          ))
        ]));
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
