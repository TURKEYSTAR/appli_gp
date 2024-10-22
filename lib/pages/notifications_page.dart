import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blueGrey,
        iconTheme: IconThemeData(color: Colors.black45),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You have no new notifications', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
