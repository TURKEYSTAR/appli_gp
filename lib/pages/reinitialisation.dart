import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/header_widget.dart';
import '../widgets/custom_text_field.dart';
import 'log.dart';

class ReinitialisationScreen extends StatefulWidget {
  const ReinitialisationScreen({Key? key}) : super(key: key);

  @override
  _ReinitialisationScreenState createState() => _ReinitialisationScreenState();
}

class _ReinitialisationScreenState extends State<ReinitialisationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  // Image picker
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {}); // Updates the state to show the new image and color
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Réinitialisation"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Stack(
              children: [
                Center(
                  child: InkWell(
                    onTap: _getImage,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: imageXFile == null ? Colors.white : Colors.blueGrey,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      width: MediaQuery.of(context).size.width * 0.26,
                      height: MediaQuery.of(context).size.width * 0.26,
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.13,
                        backgroundColor: Colors.transparent,
                        backgroundImage: imageXFile == null
                            ? null
                            : FileImage(File(imageXFile!.path)),
                        child: imageXFile == null
                            ? Icon(
                          Icons.person,
                          size: MediaQuery.of(context).size.width * 0.17,
                          color: Colors.grey,
                        )
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Text(
              "Réinitialisez votre mot de passe",
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: "Email",
                  type: TextInputType.emailAddress,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 75, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 5.0)
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    minimumSize: WidgetStateProperty.all(const Size(50, 50)),
                    backgroundColor: WidgetStateProperty.all(Colors.blueGrey),
                    shadowColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: Text(
                      "Envoyer",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () {
                    //signUpFormValidation();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
