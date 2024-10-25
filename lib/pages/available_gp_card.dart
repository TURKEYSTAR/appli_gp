import 'package:flutter/material.dart';

class AvailableGPCard extends StatelessWidget {
  final String villeDepart;
  final String paysDepart;
  final String villeArrivee;
  final String paysArrivee;
  final DateTime dateDepart;

  AvailableGPCard({
    required this.villeDepart,
    required this.paysDepart,
    required this.villeArrivee,
    required this.paysArrivee,
    required this.dateDepart,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      villeDepart,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      paysDepart,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      dateDepart.day.toString(),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${dateDepart.month}',  // Format month to string if needed
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(dateDepart.year.toString()),
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
                    Text(
                      villeArrivee,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      paysArrivee,
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
