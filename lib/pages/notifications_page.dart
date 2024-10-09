import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.grey[300],
        iconTheme: IconThemeData(color: Colors.black45),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Notifications Page', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('You have no new notifications', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
