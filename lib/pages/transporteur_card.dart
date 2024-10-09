import 'package:flutter/material.dart';

class TransporteurCard extends StatelessWidget {
  final String name;

  TransporteurCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,  // White border for the card
          width: 1.0,  // Thickness of the border
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Card(
        color: Colors.grey[200],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(5, (index) => Icon(Icons.star_border)),
              ),
              SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/reviewer.jpg'),
                  ),
                  SizedBox(width: 8),
                  Text('User13', style: TextStyle(fontSize: 14)),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Great service, really did his thangg',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 4),
              Text(
                '12/12/23',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
