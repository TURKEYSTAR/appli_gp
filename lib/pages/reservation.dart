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
  TextEditingController villeController =
      TextEditingController(); // Pour la ville

  String? completePhoneNumber;
  String? selectedPackageType;
  String? selectedFragility;
  Country? _selectedCountry; // Store the selected country here

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final annonceData = args?['annonce'] as Map<String, dynamic>?;
    final annonceId = args?['annonceId'] as String?;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text(
            "Reservation",
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
            child: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width *
                          0.05), // 5% padding
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Informations sur l'expéditeur",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Etape 1 of 3",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildStepIcon(Icons.person, Colors.blue),
                      Expanded(
                        child: Divider(
                          color: Colors.white70,
                          thickness: 2,
                        ),
                      ),
                      _buildStepIcon(
                          Icons.account_box_outlined, Colors.black38),
                      Expanded(
                        child: Divider(
                          color: Colors.white70,
                          thickness: 2,
                        ),
                      ),
                      _buildStepIcon(Icons.local_shipping, Colors.black38),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField1(
                        controller: nomController,
                        hintText: "Nom",
                        type: TextInputType.text,
                        isObscure: false,
                        prefixIcon: Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Image.asset(
                            'assets/images/name.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      CustomTextField1(
                        controller: prenomController,
                        hintText: "Prénom",
                        type: TextInputType.text,
                        isObscure: false,
                        prefixIcon: Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Image.asset(
                            'assets/images/name.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: IntlPhoneField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Numéro de téléphone',
                            fillColor: Colors.white,
                            filled: true,
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
                          onChanged: (phone) {
                            setState(() {
                              completePhoneNumber = phone.completeNumber;
                            });
                          },
                        ),
                      ),
                      CustomTextField1(
                        controller: adressController,
                        hintText: "Adresse",
                        type: TextInputType.text,
                        isObscure: false,
                        prefixIcon: Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Image.asset(
                            'assets/images/home2.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    showPhoneCode: false,
                                    // Cache les codes téléphoniques
                                    countryListTheme: CountryListThemeData(
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
                                        _selectedCountry =
                                            country; // Stocker le pays sélectionné
                                      });
                                      print(
                                          'Country selected: ${country.name}'); // Utilise seulement le nom du pays
                                    },
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.black38),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _selectedCountry == null
                                            ? "Pays"
                                            : _selectedCountry!.name,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: villeController,
                                decoration: InputDecoration(
                                  labelText: 'Ville',
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 15.0),
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
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.12,
                  ), // Ajoute un peu de padding sur les côtés
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // Aligne le bouton à droite
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 130, vertical: 15),
                          backgroundColor: Colors.deepPurple.shade900,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/reservation2',
                            arguments: {
                              'annonce': annonceData,
                              'annonceId': annonceId,
                              'previousData1': {
                                'prenom_expediteur': prenomController.text,
                                'nom_expediteur': nomController.text,
                                'addresse_expediteur': adressController.text,
                                'phone_expediteur': completePhoneNumber ?? '',
                                'ville_expediteur': villeController.text,
                                'pays_expediteur': _selectedCountry?.name ?? '',
                              },
                            },
                          );
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
