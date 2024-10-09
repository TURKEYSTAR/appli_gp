import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      "animation": "assets/lottie/lotcarte.json",
      "title": "Livraison Rapide",
      "description": "Faites livrer vos colis à toute vitesse par nos transporteurs de confiance."
    },
    {
      "animation": "assets/lottie/lot2.json",
      "title": "Suivi en Temps Réel",
      "description": "Suivez vos colis en direct et en temps réel."
    },
    {
      "animation": "assets/lottie/lot1.json",
      "title": "Paiements Sécurisés",
      "description": "Payez en toute sécurité via nos plateformes de confiance."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                return OnboardingPage(
                  animationPath: onboardingData[index]["animation"]!,
                  title: onboardingData[index]["title"]!,
                  description: onboardingData[index]["description"]!,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Text("Passer"),
              ),
              Row(
                children: List.generate(
                  onboardingData.length,
                      (index) => buildDot(index: index),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_currentPage == onboardingData.length - 1) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                },
                child: Text(_currentPage == onboardingData.length - 1
                    ? "Commencer"
                    : "Suivant"),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildDot({required int index}) {
    return Container(
      height: 10,
      width: _currentPage == index ? 20 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String animationPath;
  final String title;
  final String description;

  OnboardingPage({
    required this.animationPath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animationPath, height: 400, width: 400),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
