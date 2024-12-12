import 'package:flutter/material.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context, 1);
          },
        ),
        centerTitle: true,
        title: Text(
            " ",
        ),
        backgroundColor: Color(0xFF6672FF),
      ),
      body: Column(

      ),
    );
  }

  Widget body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.only(left : 35.0),
          child: Text(
            "ID de votre colis :",
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: GestureDetector(
            onTap: () {

            },
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: 'e.g Vtqc45fR23678',
                contentPadding:
                EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white70,
                filled: true,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/search_icon.png',
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.fromLTRB(35, 2, 31, 0),
          child: Row(
            children: [
              Text(
                "Résultats: ",
                style: TextStyle(fontSize: 25),
              ),
              Spacer(),
              Icon(
                Icons.close,
                size: 25,
              )
            ],
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
