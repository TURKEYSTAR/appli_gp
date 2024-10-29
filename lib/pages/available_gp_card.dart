import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flag/flag.dart';

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

  String? getCountryCodeFromName(String countryName) {
    final country = Country.tryParse(countryName);
    return country?.countryCode; // Return country code if found
  }

  @override
  Widget build(BuildContext context) {
    final countryCode = getCountryCodeFromName(paysDepart); // Retrieve country code
    final countryCode2 = getCountryCodeFromName(paysArrivee);

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
                    Row(
                      children: <Widget>[
                        Text(
                          villeDepart,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 10),
                        if (countryCode != null) // Check if country code is valid
                          Flag.fromString(
                            countryCode,
                            height: 15,
                            width: 15,
                          ),
                      ],
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
                      '${dateDepart.month}', // Format month to string if needed
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
                    Row(
                      children: <Widget>[
                        Text(
                          villeArrivee,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 10),
                        if (countryCode2 != null) // Check if country code is valid
                          Flag.fromString(
                            countryCode2,
                            height: 15,
                            width: 15,
                          ),
                      ],
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
