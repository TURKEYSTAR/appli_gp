import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appli_gp/pages/inscription.dart';
import 'package:appli_gp/pages/reinitialisation.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({Key? key}) : super(key: key);

  @override
  _LoginScreenState2 createState() => _LoginScreenState2();
}

class _LoginScreenState2 extends State<LoginScreen2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      body: Column(
        children: [
          //Logo
          const SizedBox(height: 150),
          // Delivery image
          Icon(
            Icons.lock_open_outlined, // Choisis une icône appropriée
            size: 120, // Ajuste la taille de l'icône
            color: Colors.black, // Tu peux aussi changer la couleur
          ),
          const SizedBox(height: 20),
          // GPExpress title
          Text(
            "GPExpress",
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
          ),
          // Subtitle

          const SizedBox(height: 20),
          // Form for email and password
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 5),
              child: Column(
                children: [
                  // Email field
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email or Phone",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Password field
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
      Expanded(
      child: Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 0),

      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReinitialisationScreen()));// Forgot password logic
              },
              child: Text(
                "Mot de passe oublié?",

              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Login logic
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.black,
            ),
            child: Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: "Pas de compte? "),
                TextSpan(
                  text: "S'inscrire",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InscriptionScreen()));
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
    )
      )]
    )
    );
  }




}
