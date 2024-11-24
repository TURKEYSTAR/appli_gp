import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'inscription1.dart';
import 'log.dart';

class InscriptionScreen extends StatefulWidget {
  const InscriptionScreen({Key? key}) : super(key: key);

  @override
  _InscriptionScreenState createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController prenomController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  String? completePhoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Background Container with image and title
            Container(
              height: 400,
              width: double.infinity,
              // Ensures the container takes the full width
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/top_background2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align children to the left
                children: [
                  const SizedBox(height: 200), // Adjust space as per your need
                  Padding(
                    padding: const EdgeInsets.only(left: 60),
                    // Slightly adjust left padding
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Align children to the left
                      children: [
                        Text(
                          "Créer",
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6672FF),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Ton Compte",
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6672FF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10), // Space between background and form

            // Registration form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Custom TextField for 'Nom'
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextFormField(
                      controller: nomController,
                      decoration: InputDecoration(
                        labelText: 'Nom',
                        hintText: "Nom",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/name.png', // Replace with your icon
                            height: 20,
                            width: 20,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Custom TextField for 'Prénom'
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextFormField(
                      controller: prenomController,
                      decoration: InputDecoration(
                        labelText: 'Prénoms',
                        hintText: "Prénoms",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/name.png', // Replace with your icon
                            height: 20,
                            width: 20,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Custom TextField for 'Email'
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: "Email",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/email.png',
                            // Replace with your email icon
                            height: 20,
                            width: 20,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Custom TextField for 'Adresse'
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextFormField(
                      controller: adressController,
                      decoration: InputDecoration(
                        labelText: 'Adresse',
                        hintText: "Adresse",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(
                            'assets/images/home2.png',
                            height: 20,
                            width: 20,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Phone number field (already aligned)
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: IntlPhoneField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Numéro de téléphone',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.deepPurple),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      initialCountryCode: 'SN',
                      onChanged: (phone) {
                        setState(() {
                          completePhoneNumber = phone.completeNumber;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Rounded corners
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 55,
                              // Horizontal padding for a wide button
                              vertical: 15, // Vertical padding for height
                            ),
                            backgroundColor: const Color(
                                0xFF6672FF), // Button background color
                          ),
                          onPressed: () {
                            // Navigate to the second registration screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InscriptionScreen2(
                                  prenom: prenomController.text,
                                  nom: nomController.text,
                                  email: emailController.text,
                                  address: adressController.text,
                                  phone: completePhoneNumber ?? '',
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'SUIVANT', // Button text in uppercase
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold, // Bold text
                                  color: Colors.white, // Text color
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Spacing between text and icon
                              const Icon(
                                Icons.arrow_forward_outlined,
                                // Forward arrow icon
                                color: Colors.white, // Icon color
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add this inside the Form, after the ElevatedButton
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Vous avez déjà un compte ? ",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen2(),
                              ),
                            );
                          },
                          child: Text(
                            "Se connecter",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6672FF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
