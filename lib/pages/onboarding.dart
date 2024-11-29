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
      "animation": "assets/lottie/truck.json",
      "title": "Livraison Rapide",
      "description": "Faites livrer vos colis dans les plus brefs délais par nos transporteurs de confiance."
    },
    {
      "animation": "assets/lottie/track1.json",
      "title": "Suivi en Temps Réel",
      "description": "Suivez vos colis en direct et en temps réel sur votre application."
    },
    {
      "animation": "assets/lottie/paymentpurple.json",
      "title": "Paiements Sécurisés",
      "description": "Payez en toute sécurité via nos plateformes de confiance."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 60),
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
                      onNextPressed: () {
                        if (_currentPage == onboardingData.length - 1) {
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      isLastPage: _currentPage == onboardingData.length - 1,
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                      (index) => buildDot(index: index),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text("Passer", style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot({required int index}) {
    return Container(
      height: 12,
      width: _currentPage == index ? 12 : 12,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.deepPurple : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String animationPath;
  final String title;
  final String description;
  final VoidCallback onNextPressed;
  final bool isLastPage;

  OnboardingPage({
    required this.animationPath,
    required this.title,
    required this.description,
    required this.onNextPressed,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animationPath, height: 400, width: 500),
          SizedBox(height: 25),
          Text(
            title,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6672FF), // Updated color
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 60),
          ElevatedButton(
            onPressed: onNextPressed,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 45, vertical: 15),
              backgroundColor: Color(0xFF6672FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              isLastPage ? "Commencer" : "Suivant",
              style: TextStyle(fontSize: 19, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
