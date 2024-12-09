import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ReinitialisationScreen extends StatefulWidget {
  final dynamic source;

  const ReinitialisationScreen({Key? key, required this.source}) : super(key: key);

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Réinitialisation",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (widget.source == 'settings') {
              Navigator.pop(context, 3);
            } else if (widget.source == 'login') {
              Navigator.pop(context);
            }
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
                          ),
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
                child: _buildTextField(
                  controller: emailController,
                  hintText: "Email",
                  iconPath: 'assets/images/email.png', // Update this path with your asset
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 5),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  minimumSize: WidgetStateProperty.all(const Size(50, 50)),
                  backgroundColor: WidgetStateProperty.all(Colors.deepPurpleAccent),
                  shadowColor: WidgetStateProperty.all(Colors.transparent),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: const Text(
                    "Envoyer",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: () {
                  // Validate and send the form
                },
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
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(iconPath, width: 20, height: 20),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
