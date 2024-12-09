import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appli_gp/pages/log.dart';
import 'package:country_picker/country_picker.dart';
import 'package:input_quantity/input_quantity.dart';
import '../widgets/custom_text_field1.dart';

class ReservationScreen3 extends StatefulWidget {
  final Map<String, dynamic>? arguments;

  const ReservationScreen3({Key? key, this.arguments}) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen3> {
  final _formKey = GlobalKey<FormState>();
  bool isWeightValid = true;
  bool isPackageTypeValid = true;

  // Controllers
  TextEditingController weightController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController villeController =
      TextEditingController(); // Pour la ville

  String? selectedPackageType;
  String? selectedFragility;
  bool isNonEmpilable = false;
  double quantity = 1;
  Country? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final annonceData = args?['annonce'];
    final previousData1 = args?['previousData1'] as Map<String, dynamic>?;
    String packageWeight = weightController.text;

    Future<String?> getSenderName() async {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        return userDoc.data()?['username'];
      }
      return null;
    }

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
                          "Informations sur le colis",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Etape 3 sur 3",
                          style: TextStyle(
                            color: Colors.white54,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildStepIcon(Icons.person, Colors.blue),
                      Expanded(
                        child: Divider(
                          color: Colors.blue,
                          thickness: 2,
                        ),
                      ),
                      _buildStepIcon(Icons.account_box_outlined,
                          Colors.blue),
                      Expanded(
                        child: Divider(
                          color: Colors.blue,
                          thickness: 2,
                        ),
                      ),
                      _buildStepIcon(
                          Icons.local_shipping, Colors.blue),
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
                              Expanded(
                                child: CustomTextField1(
                                  controller: weightController,
                                  hintText: "Poids du colis (kg)",
                                  type: TextInputType.number,
                                  isObscure: false,
                                ),
                              ),
                              SizedBox(width: 2),
                            ],
                          )),
                      SizedBox(height: 5),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        padding: const EdgeInsets.only(top: 10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Type de colis',
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Colors.deepPurple,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                color: Colors.black38,
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
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 2.0),
                            ),
                          ),
                          value: selectedPackageType,
                          items: [
                            DropdownMenuItem(
                              value: 'Enveloppe',
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              } else if (selectedPackageType == 'Carton1') {
                                // For 'Boite'
                                lengthController.text = '35';
                                widthController.text = '20';
                                heightController.text = '15';
                              } else if (selectedPackageType == 'Carton2') {
                                // For 'Carton'
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
                      Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Dimensions du colis (cm)",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
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
                                    isObscure: false,
                                  ),
                                ),
                                // Largeur
                                Expanded(
                                  child: CustomTextField1(
                                    controller: widthController,
                                    hintText: "Largeur (cm)",
                                    type: TextInputType.number,
                                    isObscure: false,
                                  ),
                                ),
                                // Hauteur
                                Expanded(
                                  child: CustomTextField1(
                                    controller: heightController,
                                    hintText: "Hauteur (cm)",
                                    type: TextInputType.number,
                                    isObscure: false,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Quantité",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            InputQty(
                              btnColor1: Colors.black38,
                              btnColor2: Colors.black38,
                              maxVal: double.maxFinite,
                              //max val to go
                              initVal: 1,
                              //min starting val
                              onQtyChanged: (value) {
                                setState(() {
                                  quantity = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isNonEmpilable,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isNonEmpilable = value ?? false;
                                    });
                                  },
                                ),
                                const Text(
                                  "Non empilable",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.12,
                  ),
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
                          backgroundColor: Colors.deepPurple.shade900,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _saveReservation();
                          }

                          // Call _sendNotificationToCreator when reservation is confirmed

                          // Ajoutez ici d'autres actions à réaliser après la réservation
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Réservation envoyée et notification envoyée au transporteur')),
                          );

                          // Optionally navigate back or show a confirmation message
                          Navigator.pop(
                              context, "Reservation completed successfully.");
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          // Garde le bouton compact
                          children: [
                            Text(
                              'Réserver'.toUpperCase(),
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

  Future<void> _saveReservation() async {
    final User? user =
        FirebaseAuth.instance.currentUser; // Récupère l'utilisateur actuel
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: Utilisateur non connecté")),
      );
      return;
    }

    final String userId = user.uid; // Récupère l'ID de l'utilisateur
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final annonceId = args?['annonceId'] as String?;
    final previousData1 = args?['previousData1'] as Map<String, dynamic>?;
    final previousData2 = args?['previousData2'] as Map<String, dynamic>?;
    final annonceData = args?['annonce'] as Map<String, dynamic>?;

    if (previousData1 != null && previousData2 != null && annonceData != null) {
      Map<String, dynamic> reservationData = {
        ...previousData1,
        ...previousData2,
        'expediteur_id': userId,
        'poids_colis': weightController.text,
        'type_colis': selectedPackageType,
        'longueur_colis': lengthController.text,
        'largeur_colis': widthController.text,
        'hauteur_colis': heightController.text,
        'fragilite': '${isNonEmpilable ? 'non empilable' : ''} '.trim(),
        'quantite': quantity,
        'statut': 'en attente',
        'date_cs': null,
        'dateCreation': Timestamp.now(),
        'transporteur_id': annonceData['user_id'],
        'annonce_id': annonceId,
      };

      // Enregistre la réservation et récupère son ID
      DocumentReference reservationRef = await FirebaseFirestore.instance
          .collection('reservations')
          .add(reservationData);
      String reservationId = reservationRef.id;

      // Enregistre la notification avec reservationId
      await _enregistrerNotificationReservation(
        annonceId: annonceId!,
        reservationId: reservationId,
        // Ajout de l'ID de la réservation
        expediteurId: userId,
        transporteurId: annonceData['user_id'],
        typeNotification: 'reservation',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Réservation envoyée avec succès"),
            backgroundColor: Colors.green),
      );

      // Redirection après succès
      Navigator.pushReplacementNamed(context, '/home', arguments: 1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: Données manquantes")),
      );
    }
  }

  Future<void> _enregistrerNotificationReservation({
    required String annonceId,
    required String reservationId,
    required String expediteurId,
    required String transporteurId,
    required String typeNotification,
  }) async {
    try {
      // Ajout de la notification pour le transporteur
      await FirebaseFirestore.instance.collection('notifications').add({
        'type': typeNotification,
        'transporteur_id': transporteurId,
        'expediteur_id': expediteurId,
        'annonce_id': annonceId,
        'reservation_id': reservationId,
        'date_notification': Timestamp.now(),
      });

      print("Notification envoyée au transporteur.");
    } catch (e) {
      print("Erreur : $e");
      throw Exception("Impossible d'envoyer la notification.");
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
