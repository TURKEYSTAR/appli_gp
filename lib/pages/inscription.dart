import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:appli_gp/pages/inscription1.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/header_widget.dart';
import '../widgets/custom_text_field.dart';
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
  TextEditingController phoneController = TextEditingController();

//image picker
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  String? selectedValue;
//location
  //Position? position;
  //List<Placemark>? placeMarks;

//address name variable
  String completeAddress = "";

//seller image url
  String sellerImageUrl = "";

//function for getting current location


//function for getting image
  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

//Form Validation




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      body: Container(
        height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [

              Stack(
                children: [
                  const SizedBox(
                    height: 150,
                    child: HeaderWidget(
                      150,
                      false,
                      Icons.add,
                    ),
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
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        _getImage();
                      },
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.13,
                        backgroundColor: Colors.white,
                        backgroundImage: imageXFile == null
                            ? null
                            : FileImage(
                          File(imageXFile!.path),
                        ),
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
                      controller: nomController,
                      hintText: "Nom",
                      isObsecre: false,
                    ),
                    CustomTextField(
                      data: Icons.person,
                      controller: prenomController,
                      hintText: "Prenom",
                      isObsecre: false,
                    ),
                    CustomTextField(
                      data: Icons.email,
                      controller: emailController,
                      hintText: "Email",
                      isObsecre: false,
                    ),
                    CustomTextField(
                      data: Icons.home,
                      controller: adressController,
                      hintText: "Adresse",
                      isObsecre: false,
                    ),
                    CustomTextField(
                      data: Icons.phone_android_outlined,
                      controller: phoneController,
                      hintText: "Numéro de téléphone",
                      isObsecre: false,
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
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15), // Ajuste la taille du bouton
                        backgroundColor: Colors.black, // Couleur de fond du bouton
                      ),
                      onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => const InscriptionScreen2()));// Action à réaliser lors du clic sur le bouton
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Garde le bouton compact
                        children: [
                          Text(
                            'Suivant'.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8), // Espace entre le texte et l'icône
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

              Container(
                margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: "Vous avez déjà un compte? "),
                      TextSpan(
                        text: 'Se connecter',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen2()));
                          },
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}