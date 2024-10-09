import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Chat Page', style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          Text('No new messages', style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add functionality to start a chat or view messages
            },
            child: Text('Start a Chat'),
          ),
        ],
      ),
    );
  }
}
