import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithDetails({
    required String email,
    required String password,
    required String prenom,
    required String nom,
    required String address,
    required String phone,
    required String nin,
    required String role, // Expéditeur or Transporteur
    required String username,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;

      if (user != null) {
        // Add user details to Firestore database
        await _firestore.collection('users').doc(user.uid).set({
          'prenom': prenom,
          'nom': nom,
          'email': email,
          'address': address,
          'username': username,
          'phone': phone,
          'nin': nin,
          'role': role,
          'createdAt': DateTime.now(),
        });

        return user;
      }
    } catch (e) {
      print("Error during sign up: $e");
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print("Error during login: $e");
    }
    return null;
  }
}
