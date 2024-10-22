import 'package:flutter/material.dart';

class AvailableGPCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(10), // Ensure some padding around the card
        child: Column(
          mainAxisSize: MainAxisSize.min,  // Prevents overflow by not expanding unnecessarily
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Seoul ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Image.asset(
                          'assets/flags/korea_flag.png',
                          width: 16,
                          height: 16,
                        ),
                      ],
                    ),
                    Text(
                      'South Korea',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '21',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'September',
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text('2024'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Dakar ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Image.asset(
                          'assets/flags/senegal_flag.png',
                          width: 16,
                          height: 16,
                        ),
                      ],
                    ),
                    Text(
                      'Sénégal',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios, size: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
