import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'log.dart';

class SettingsPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen2()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Error logging out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Text(
            'Account Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.person, color: Colors.black),
            title: Text('Edit Profile'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.black),
            title: Text('Change Password'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Change Password Page
            },
          ),
          Divider(),

          // Notification Settings Section
          Text(
            'Notification Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          SwitchListTile(
            title: Text('Receive Notifications'),
            secondary: Icon(Icons.notifications, color: Colors.black),
            value: true,
            onChanged: (value) {
              // Handle switch toggle for notifications
            },
          ),
          SwitchListTile(
            title: Text('Receive Email Alerts'),
            secondary: Icon(Icons.email, color: Colors.black),
            value: false,
            onChanged: (value) {
              // Handle switch toggle for email alerts
            },
          ),
          Divider(),

          // Privacy Settings Section
          Text(
            'Privacy Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.privacy_tip, color: Colors.black),
            title: Text('Privacy Policy'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Privacy Policy Page
            },
          ),
          ListTile(
            leading: Icon(Icons.security, color: Colors.black),
            title: Text('Security Settings'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Security Settings Page
            },
          ),
          Divider(),

          // Additional Settings Section
          Text(
            'Additional Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.language, color: Colors.black),
            title: Text('Language'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Language Settings Page
            },
          ),
          ListTile(
            leading: Icon(Icons.help, color: Colors.black),
            title: Text('Help & Support'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Help & Support Page
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout'),
            onTap: () async {
              await _logout(context);  // Call the logout method here
            },
          ),
        ],
      ),
    );
  }
}
