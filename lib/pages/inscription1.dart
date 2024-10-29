import 'dart:io';
import 'package:appli_gp/firebase_auth_impl/firebase_auth_services.dart';
import 'package:flutter/gestures.dart';
import 'package:appli_gp/pages/log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/header_widget.dart';
import '../widgets/custom_text_field.dart';

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
  TextEditingController usernameController = TextEditingController();
  TextEditingController ninController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  String? selectedValue;

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

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
        // Show a snackbar with the success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inscription réussie avec succès'),
            backgroundColor: Colors.green,
          ),
        );

        // Sign out the user so they aren't logged in automatically
        await FirebaseAuth.instance.signOut();

        // Delay to let the snackbar message appear
        await Future.delayed(Duration(seconds: 2));

        // Navigate to the login page
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
      backgroundColor: const Color(0xFFE0E0E0),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                const SizedBox(
                  height: 150,
                  child: HeaderWidget(150, false, Icons.add),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: _getImage,
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.13,
                      backgroundColor: Colors.white,
                      backgroundImage: imageXFile == null
                          ? null
                          : FileImage(File(imageXFile!.path)),
                      child: imageXFile == null
                          ? Icon(
                        Icons.person,
                        size: MediaQuery.of(context).size.width * 0.17,
                        color: Colors.black,
                      )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: usernameController,
                    hintText: "Nom d'utilisateur",
                    type: TextInputType.text,
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.card_membership,
                    controller: ninController,
                    hintText: "NIN",
                    type: TextInputType.number,
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: "Mot de passe",
                    type: TextInputType.visiblePassword,
                    isObsecre: true,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: confirmpasswordController,
                    hintText: "Confirmer le mot de passe",
                    type: TextInputType.visiblePassword,
                    isObsecre: true,
                  ),
                  const SizedBox(height: 20),

                  // Dropdown for selecting role (Expéditeur, Transporteur)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.12,
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Choisissez une option',
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
                      ),
                      value: selectedValue,
                      items: const [
                        DropdownMenuItem(
                          child: Text("Expéditeur"),
                          value: "Expéditeur",
                        ),
                        DropdownMenuItem(
                          child: Text("Transporteur"),
                          value: "Transporteur",
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      validator: (value) =>
                      value == null ? 'Veuillez sélectionner un rôle' : null,
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
                                horizontal: 25, vertical: 15),
                            backgroundColor: Colors.black,
                          ),
                          onPressed: signUp,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'S\'inscrire'.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_outlined,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1,
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: "Vous avez déjà un compte? ",
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Connectez-vous",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen2(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
