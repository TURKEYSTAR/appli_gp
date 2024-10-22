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
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingScreen(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/chat': (context) => ChatPage(),
        '/settings': (context) => SettingsPage(),
        '/notifications': (context) => NotificationPage(),
        '/log': (context) => LoginScreen2(),
        '/inscription': (context) => InscriptionScreen(),
        '/reinitialisation': (context) => ReinitialisationScreen(),
        '/inscription1': (context) => InscriptionScreen2(
          prenom: '',
          nom: '',
          email: '',
          address: '',
          phone: '',
        ),
        '/annonce': (context) => AnnonceScreen(),
        '/annonce2': (context) => AnnonceScreen2(),
        '/reservation': (context) => ReservationScreen(),
        '/reservation2': (context) => ReservationScreen2(),
        '/reservation3': (context) => ReservationScreen3(),
        '/detailsAnnonce': (context) => DetailAnnoncePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  User? currentUser;
  String? role;

  List<Widget> _pages = [
    HomeBody(),
    ProfilePage(), // This will dynamically load based on user role
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Fetch additional user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          role = userDoc.data()!['role'];
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52.0),
        child: AppBar(
          backgroundColor: Colors.blueGrey,
          elevation: 1,
          leading: IconButton(
            icon: Icon(Icons.local_shipping, color: Colors.black54),
            onPressed: () {
              // Add action for the truck icon here
            },
          ),
          title: Text(
            'GP Express',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.black54),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(13),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[100],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30, color: Colors.blueGrey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30, color: Colors.blueGrey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 30, color: Colors.blueGrey),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.black45,
        onTap: _onItemTapped,
      ),
    );
  }
}
