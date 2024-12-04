import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final _prenomController = TextEditingController();
  final _nomController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _adresseController = TextEditingController();

  String? selectedValue;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final snapshot =
        await _firestore.collection('users').doc(user.uid).get();
        if (snapshot.exists) {
          final data = snapshot.data()!;
          setState(() {
            _prenomController.text = data['prenom'] ?? '';
            _nomController.text = data['nom'] ?? '';
            _usernameController.text = data['username'] ?? '';
            _phoneController.text = data['phone'] ?? '';
            _emailController.text = data['email'] ?? '';
            _adresseController.text = data['address'] ?? '';
            selectedValue = data['role'];
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _updateUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'prenom': _prenomController.text,
          'nom': _nomController.text,
          'username': _usernameController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'adresse': _adresseController.text,
          'role': selectedValue,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil mis à jour avec succès!')),
        );
      }
    } catch (e) {
      print('Error updating user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour du profil.')),
      );
    }
  }

  @override
  void dispose() {
    _prenomController.dispose();
    _nomController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        title: Text(
          'Modifier le profil',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/settings',
              arguments: 3,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profile_pic.png'),
              ),
              const SizedBox(height: 30),
              _buildTextField(
                controller: _prenomController,
                hintText: 'Prénom',
                iconPath: 'assets/images/name.png',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _nomController,
                hintText: 'Nom',
                iconPath: 'assets/images/name.png',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _usernameController,
                hintText: "Nom d'utilisateur",
                iconPath: 'assets/images/name.png',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _phoneController,
                hintText: 'Numéro de téléphone',
                iconPath: 'assets/images/appel.png',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                hintText: 'E-Mail',
                iconPath: 'assets/images/email.png',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _adresseController,
                hintText: 'Adresse',
                iconPath: 'assets/images/home2.png',
              ),
              const SizedBox(height: 30),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _updateUserData,
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Text(
                      'Enregistrer',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/settings',
                        arguments: 3,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Text(
                      'Annuler',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(iconPath, width: 20, height: 20),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
