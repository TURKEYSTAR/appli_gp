import 'package:flutter/material.dart';

class TransporteurCard extends StatelessWidget {
  final String name;

  TransporteurCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Card(
        color: Colors.white70,
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
                  Text('@LouiseKf', style: TextStyle(fontSize: 14)),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Service rapide, très bon suivi',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 4),
              Text(
                '12/12/24',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
