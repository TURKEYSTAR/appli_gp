import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../models/TimeLineTileUi.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Suivi de commande'),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade100.withOpacity(0.8),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/top_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3), // Adjust opacity for effect
            ),
          ),
          // Foreground Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  TimeLineTileUI(
                    isFirst: true,
                    isLast: false,
                    isPast: true,
                    eventChild: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.book_online, color: Colors.white),
                            SizedBox(width: 15.0),
                            Text(
                              'Réservation enregistrée',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Text(
                          'Votre réservation a été enregistrée avec succès et sera traitée prochainement.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  TimeLineTileUI(
                    isFirst: false,
                    isLast: false,
                    isPast: true,
                    eventChild: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.card_giftcard, color: Colors.white),
                            SizedBox(width: 15.0),
                            Text(
                              'Réservation validée',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Text(
                          'Votre réservation a été validée et est prête pour les prochaines étapes.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  TimeLineTileUI(
                    isFirst: false,
                    isLast: false,
                    isPast: true,
                    eventChild: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.local_shipping, color: Colors.white),
                            SizedBox(width: 15.0),
                            Text(
                              'Paiement effectué',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Text(
                          'Le paiement a été reçu avec succès et la réservation est en cours de traitement.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  TimeLineTileUI(
                    isFirst: false,
                    isLast: true,
                    isPast: true,
                    eventChild: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.home_work, color: Colors.white),
                            SizedBox(width: 15.0),
                            Text(
                              'Livraison en cours',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Text(
                          'Votre commande est en route. Veuillez rester disponible pour la recevoir.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
