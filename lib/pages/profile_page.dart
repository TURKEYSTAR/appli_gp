import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Profile Page', style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          Text('Username: JohnDoe', style: TextStyle(fontSize: 18)),
          Text('Email: johndoe@example.com', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
