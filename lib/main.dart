import 'package:flutter/material.dart';
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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/log',
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
        '/inscription1': (context) => InscriptionScreen2(),
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

  List<Widget> _pages = [
    HomeBody(),
    ProfilePage(),
    ChatPage(),
    SettingsPage(),
  ];

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
          backgroundColor: Colors.grey[200],
          elevation: 1,
          leading: IconButton(
            icon: Icon(Icons.local_shipping, color: Colors.black45),
            onPressed: () {
              // Add action for the truck icon here
            },
          ),
          title: Text(
            'GP Express',
            style: TextStyle(
              color: Colors.grey[800],
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.black45),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[300],
        padding: EdgeInsets.all(13),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[200],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30, color: Colors.black45),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30, color: Colors.black45),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, size: 30, color: Colors.black45),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 30, color: Colors.black45),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.black45,
        onTap: _onItemTapped,
      ),
    );
  }
}
