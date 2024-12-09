import 'package:flutter/material.dart';
import '../models/constants.dart';
import '../pages/paiement_page.dart';

class DetailNotifValidationPage extends StatefulWidget {
  final String villeDepart;
  final String villeArrivee;
  final String prix_kg;
  final int quantite;
  final String poids_colis;

  const DetailNotifValidationPage({
    required this.villeDepart,
    required this.villeArrivee,
    required this.prix_kg,
    required this.quantite,
    required this.poids_colis,
    Key? key,
  }) : super(key: key);

  @override
  _DetailNotifValidationPageState createState() =>
      _DetailNotifValidationPageState();
}

class _DetailNotifValidationPageState extends State<DetailNotifValidationPage> {
  double extrairePrix(String prixAvecMonnaie) {
    final prixString = prixAvecMonnaie.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.parse(prixString);
  }

  String extraireDevise(String prixAvecDevise) {
    final devise = prixAvecDevise.replaceAll(RegExp(r'[^a-zA-Z\$€¥£]'), '');
    return devise;
  }

  @override
  Widget build(BuildContext context) {
    final double montant = extrairePrix(widget.prix_kg) * widget.quantite *
        extrairePrix(widget.poids_colis);
    final String devise = extraireDevise(widget.prix_kg);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Validation réservation'),
        backgroundColor: Colors.black54,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Montant total : $montant $devise',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final checkoutUrl = await initierPaiement(
                  "Frais de transport ${widget.villeDepart} - ${widget
                      .villeArrivee}",
                  montant,
                );

                if (checkoutUrl != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PaymentPage(paymentUrl: checkoutUrl),
                    ),
                  );
                } else {
                  print("Échec de l'initialisation du paiement");
                }
              },
              child: const Text("Procéder au paiement"),
            ),
          ],
        ),
      ),
    );
  }
}
