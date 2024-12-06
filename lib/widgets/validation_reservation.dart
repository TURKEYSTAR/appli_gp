import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/constants.dart';
import '../pages/webview_page.dart'; // Updated import for WebViewPage

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
  bool _isProcessing = false; // To handle button loading state

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
    final double montant = extrairePrix(widget.prix_kg) * widget.quantite * extrairePrix(widget.poids_colis) ;
    final String devise = extraireDevise(widget.prix_kg);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Validation réservation",
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.black54,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Votre demande de transfert de colis pour le trajet ${widget.villeDepart} - ${widget.villeArrivee} a été approuvée par le transporteur.',
                style: const TextStyle(fontSize: 16),
                softWrap: true,
              ),
              const SizedBox(height: 10),
              const Text(
                'Veuillez finaliser votre réservation en procédant au paiement.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(child: Divider(color: Colors.grey)),
                  Text(
                    "Détails paiement ",
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const Expanded(child: Divider(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Frais de l'expédition : ",
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Text(
                    "$montant $devise",
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(fontSize: 22),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isProcessing
                    ? null
                    : () async {
                  setState(() {
                    _isProcessing = true;
                  });
                  final String? checkoutUrl = await initierPaiement(
                    "Frais de transport ${widget.villeDepart} - ${widget.villeArrivee}",
                    montant,
                    devise,
                  );

                  setState(() {
                    _isProcessing = false;
                  });

                  if (checkoutUrl != null) {
                    // Redirect to WebView
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewPage(
                          paymentUrl: checkoutUrl,
                        ),
                      ),
                    );
                  } else {
                    // Show error
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Échec de l'initialisation du paiement."),
                      ),
                    );
                  }
                },
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Procéder au paiement"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
