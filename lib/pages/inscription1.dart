import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:appli_gp/pages/inscription.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/header_widget.dart';
import '../widgets/custom_text_field.dart';
import 'log.dart';

class InscriptionScreen2 extends StatefulWidget {
  const InscriptionScreen2({Key? key}) : super(key: key);

  @override
  _InscriptionScreenState createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController ninController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

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

        child: SingleChildScrollView(
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
                  Positioned(
                    top: 10,
                    left: 10, // Adjust the position as needed
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const InscriptionScreen())); // Goes back to the previous screen
                      },
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
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      data: Icons.account_box,
                      controller: ninController,
                      hintText: "NIN ou passport",
                      isObsecre: false,
                    ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  padding: const EdgeInsets.only(top: 10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Choisissez une option', // Label comme dans CustomTextField
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
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.red, width: 2.0),
                      ),
                    ),
                    value: selectedValue, // Initialize this with a default value or null
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
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue = newValue!;
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
                CustomTextField(
                      data: Icons.lock_outline_rounded,
                      controller: passwordController,
                      hintText: "Mot de passe",
                      isObsecre: false,
                    ),
                    CustomTextField(
                      data: Icons.lock_outline_rounded,
                      controller: confirmpasswordController,
                      hintText: "Confirmer le mot de passe",
                      isObsecre: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 5.0)
                    ],
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 1.0],
                      colors: [
                        Colors.black,
                        Colors.black,
                      ],
                    ),
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      minimumSize:
                      MaterialStateProperty.all(const Size(50, 50)),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                      shadowColor:
                      MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                      child: Text(
                        "S'inscrire".toUpperCase(),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                      //signUpFormValidation();
                    },
                  ),
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
      ),
    );
  }
}