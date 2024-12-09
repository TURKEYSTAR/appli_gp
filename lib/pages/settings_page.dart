import 'package:appli_gp/pages/reinitialisation.dart';
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
      backgroundColor: Colors.deepPurple.shade50,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(height: 100),
          _buildSection(
            items: [
              _buildListTile(
                icon: Icons.person,
                text: 'Edit Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(),
                    ),
                  );
                },
              ),
              _buildListTile(
                icon: Icons.lock,
                text: 'Change Password',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReinitialisationScreen(source: 'settings')),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 30),
          _buildSection(
            items: [
              _buildSwitchTile(
                icon: Icons.notifications,
                text: 'Receive Notifications',
                value: true,
                onChanged: (value) {
                  // Handle switch toggle
                },
              ),
              _buildSwitchTile(
                icon: Icons.email,
                text: 'Receive Email Alerts',
                value: false,
                onChanged: (value) {
                  // Handle switch toggle
                },
              ),
            ],
          ),
          SizedBox(height: 30),
          _buildSection(
            items: [
              _buildListTile(
                icon: Icons.privacy_tip,
                text: 'Privacy Policy',
                onTap: () {
                  // Navigate to Privacy Policy Page
                },
              ),
              _buildListTile(
                icon: Icons.security,
                text: 'Security Settings',
                onTap: () {
                  // Navigate to Security Settings Page
                },
              ),
            ],
          ),
          SizedBox(height: 30),
          _buildSection(
            items: [
              _buildListTile(
                icon: Icons.language,
                text: 'Language',
                onTap: () {
                  // Navigate to Language Settings Page
                },
              ),
              _buildListTile(
                icon: Icons.help,
                text: 'Help & Support',
                onTap: () {
                  // Navigate to Help & Support Page
                },
              ),
              _buildListTile(
                icon: Icons.logout,
                text: 'Logout',
                textColor: Colors.indigo,
                onTap: () async {
                  await _logout(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required List<Widget> items}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Section background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...items,
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String text,
    Color textColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(text, style: TextStyle(color: textColor)),
      trailing: Icon(Icons.arrow_forward_ios, color: textColor),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String text,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.black),
      title: Text(text),
      value: value,
      onChanged: onChanged,
    );
  }
}
