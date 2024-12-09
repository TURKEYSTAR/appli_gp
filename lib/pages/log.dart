import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appli_gp/pages/inscription.dart';
import 'package:appli_gp/pages/reinitialisation.dart';
import '../firebase_services/firebase_auth_services.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({Key? key}) : super(key: key);

  @override
  _LoginScreenState2 createState() => _LoginScreenState2();
}

class _LoginScreenState2 extends State<LoginScreen2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuthServices _authServices = FirebaseAuthServices();
  bool _isLoading = false;

  Future<void> _checkUserAuth() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // User is already logged in, redirect to HomePage
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUserAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Background with Lock Icon
            Container(
              height: 500,
              width: double.infinity, // Ensures the container takes the full width
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/top_background1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 350),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.lock_open_outlined,
                            size: 100,
                            color: Color(0xFF6672FF),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "GPExpress",
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6672FF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            // Login Form
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    // Email Input with Custom Icon
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email ou Téléphone",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/email.png',
                            height: 20,
                            width: 20,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre email ou téléphone';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Password Input with Custom Icon
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Mot de passe",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/password.png',
                            height: 20,
                            width: 20,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre mot de passe';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Login Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            var user =
                                await _authServices.signInWithEmailAndPassword(
                              emailController.text,
                              passwordController.text,
                            );

                            setState(() {
                              _isLoading = false;
                            });

                            if (user != null) {
                              Navigator.pushReplacementNamed(context, '/home');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Login échoué ! Vérifiez vos informations."),
                                ),
                              );
                            }
                          }
                        },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30),
                    // Add spacing to the right
                    child: Image.asset(
                      'assets/images/btn_arraw1.png',
                      height: 70,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReinitialisationScreen(source: 'login'),
                      ),
                    );
                  },
                  child: const Text(
                    "Mot de passe oublié?",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Sign-up Redirect
            Text.rich(
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
                            builder: (context) => const InscriptionScreen(),
                          ),
                        );
                      },
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
}
