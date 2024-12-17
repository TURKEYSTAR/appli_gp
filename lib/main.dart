import 'package:appli_gp/pages/annonce.dart';
import 'package:appli_gp/pages/annonce2.dart';
import 'package:appli_gp/pages/detail_annonce.dart';
import 'package:appli_gp/pages/reservation.dart';
import 'package:appli_gp/pages/reservation2.dart';
import 'package:appli_gp/pages/reservation3.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_links3/uni_links.dart';
import 'dart:async';

import 'pages/home_body.dart';
import 'pages/onboarding.dart';
import 'pages/profile_page.dart';
import 'pages/chat_page.dart';
import 'pages/settings_page.dart';
import 'pages/notifications_page.dart';
import 'pages/log.dart';
import 'pages/inscription.dart';
import 'pages/reinitialisation.dart';
import 'pages/inscription1.dart';
import 'pages/tracking_page.dart';
import 'pages/details_profile_page.dart';
import 'pages/detail_notif1.dart';
import 'pages/edit_profile_page.dart';
import 'pages/paiement_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDxdiSMQzpeX174sxtBy2z0MzR1P8g1TmM",
        authDomain: "my-appli-gp.firebaseapp.com",
        projectId: "my-appli-gp",
        storageBucket: "my-appli-gp.appspot.com",
        messagingSenderId: "20806797663",
        appId: "1:20806797663:web:436aaa5b8d4201204cceea",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: (FirebaseAuth.instance.currentUser != null) ? '/home' : '/',
      routes: {
        '/': (context) => OnboardingScreen(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/chat': (context) => ChatPage(),
        '/settings': (context) => SettingsPage(),
        '/notifications': (context) => NotificationPage(),
        '/log': (context) => LoginScreen2(),
        '/inscription': (context) => InscriptionScreen(),
        '/reinitialisation': (context) => ReinitialisationScreen(source: 'source',),
        '/inscription1': (context) => InscriptionScreen2(
          prenom: '',
          nom: '',
          email: '',
          address: '',
          phone: '',
        ),
        '/annoncele': (context) => AnnonceScreen(),
        '/annonce2': (context) => AnnonceScreen2(),
        '/reservation': (context) => ReservationScreen(),
        '/reservation2': (context) => ReservationScreen2(),
        '/reservation3': (context) => ReservationScreen3(),
        '/detailsAnnonce': (context) => DetailAnnoncePage(),
        '/tracking': (context) => TrackingPage(parcelId: ''),
        '/detailsProfile': (context) => DetailsProfilePage(),
        '/detailNotif1': (context) => DetailReservationPage(),
        '/editProfile': (context) => EditProfilePage(),
        '/paiement': (context) => PaymentPage(paymentUrl: '',),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription? _sub;

  int _selectedIndex = 0;
  User? currentUser;
  String? role;
  String? userName;

  final List<Widget> _pages = [
    HomeBody(),
    ProfilePage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
    _checkUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as int?;
      if (args != null) {
        setState(() {
          _selectedIndex = args;
        });
      }
    });
  }

  /// Initialize Deep Link Listener
  void _initDeepLinkListener() {
    // Check if the platform is NOT Web
    if (!kIsWeb) {
      _sub = uriLinkStream.listen(
            (Uri? uri) async {
          if (uri != null) {
            print("Received deep link: $uri");

            if (uri.path == '/success') {
              print("Payment success detected, updating Firestore...");
              await _updateColisStatus();
              Navigator.of(context).pushReplacementNamed('/home');
            }
          }
        },
        onError: (err) {
          print("Error occurred while listening for deep links: $err");
        },
      );
    } else {
      print("Deep link listening is not supported on Web.");
    }
  }

  /// Update the parcel status in Firestore to "Paiement effectué"
  Future<void> _updateColisStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final userId = user.uid;

        // Query parcels belonging to the current user
        final querySnapshot = await FirebaseFirestore.instance
            .collection('parcels')
            .where('expediteur_id', isEqualTo: userId)
            .where('status', isNotEqualTo: 'Paiement effectué')
            .get();

        // Update each parcel's status to "Paiement effectué"
        for (var doc in querySnapshot.docs) {
          await doc.reference.update({'status': 'Paiement effectué'});
        }

        print("Parcel status updated to 'Paiement effectué'");
      } catch (e) {
        print("Error updating parcel status: $e");
      }
    } else {
      print("No user is logged in.");
    }
  }

  Future<void> _checkUser() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          role = userDoc.data()!['role'];
          userName = userDoc.data()!['username'];
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[100],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30, color: Colors.blue),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30, color: Colors.blue),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 30, color: Colors.blue),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
