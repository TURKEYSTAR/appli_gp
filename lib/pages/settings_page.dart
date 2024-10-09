import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Settings Page', style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          Text('Notification Settings', style: TextStyle(fontSize: 18)),
          Text('Privacy Settings', style: TextStyle(fontSize: 18)),
          Text('Account Settings', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
