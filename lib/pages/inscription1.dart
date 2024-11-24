import 'package:appli_gp/pages/log.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase_services/firebase_auth_services.dart';

class InscriptionScreen2 extends StatefulWidget {
  final String prenom;
  final String nom;
  final String email;
  final String address;
  final String phone;

  const InscriptionScreen2({
    Key? key,
    required this.prenom,
    required this.nom,
    required this.email,
    required this.address,
    required this.phone,
  }) : super(key: key);

  @override
  _InscriptionScreen2State createState() => _InscriptionScreen2State();
}

class _InscriptionScreen2State extends State<InscriptionScreen2> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController ninController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  String? selectedValue;

  void signUp() async {
    if (_formKey.currentState!.validate()) {
      String password = passwordController.text.trim();
      String username = usernameController.text.trim();
      String nin = ninController.text.trim();
      String role = selectedValue ?? '';

      User? user = await _auth.signUpWithDetails(
        email: widget.email,
        password: password,
        username: username,
        prenom: widget.prenom,
        nom: widget.nom,
        address: widget.address,
        phone: widget.phone,
        nin: nin,
        role: role,
      );

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen2()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              width: double.infinity,
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
            const SizedBox(height: 10),
            // Form fields
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: usernameController,
                    hintText: "Nom d'utilisateur",
                    iconPath: 'assets/images/name.png',
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: ninController,
                    hintText: "NIN",
                    iconPath: 'assets/images/carte-didentite.png',
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: passwordController,
                    hintText: "Mot de passe",
                    iconPath: 'assets/images/password.png',
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: confirmpasswordController,
                    hintText: "Confirmer le mot de passe",
                    iconPath: 'assets/images/password.png',
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 12,
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Choisissez un rôle',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: selectedValue,
                      items: const [
                        DropdownMenuItem(
                          value: 'Expéditeur',
                          child: Text('Expéditeur'),
                        ),
                        DropdownMenuItem(
                          value: 'Transporteur',
                          child: Text('Transporteur'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      validator: (value) => value == null
                          ? 'Veuillez sélectionner un rôle'
                          : null,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Submit button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 12,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        backgroundColor: const Color(0xFF6672FF),
                      ),
                      onPressed: signUp,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'S\'INSCRIRE',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.arrow_forward_outlined,
                              color: Colors.white),
                        ],
                      ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String iconPath,
    bool isPassword = false,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: hintText,
          // Added label text
          hintText: hintText,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0), // Consistent padding
            child: Image.asset(
              iconPath,
              height: 20,
              width: 20,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) =>
            value!.isEmpty ? 'Veuillez remplir ce champ' : null,
      ),
    );
  }
}
