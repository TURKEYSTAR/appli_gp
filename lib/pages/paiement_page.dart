import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaiementPage extends StatefulWidget {

  final String prix_kg;
  final int quantite;

  const PaiementPage({
    required this.prix_kg,
    required this.quantite,
    Key? key,
  }) : super(key: key);

  @override
  _PaiementPageState createState() => _PaiementPageState();
}

class _PaiementPageState extends State<PaiementPage> {
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
    final double montant = extrairePrix(widget.prix_kg) * widget.quantite;
    final String devise = extraireDevise(widget.prix_kg);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Paiement",
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
                "$devise $montant ",
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(fontSize: 26),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(child: Divider(color: Colors.grey)),
                  Text(
                    "Méthodes de paiement",
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const Expanded(child: Divider(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3, // Chaque box sur une seule ligne
                crossAxisSpacing: 8, // Espacement horizontal réduit
                mainAxisSpacing: 8, // Espacement vertical réduit
                childAspectRatio: 1, // Ajuste la proportion largeur/hauteur
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildPaymentOption('Wave', Icons.waves, Colors.blue),
                  _buildPaymentOption('OM', Icons.phone_android, Colors.orange),
                  _buildPaymentOption('PayPal', Icons.account_balance_wallet, Colors.blueAccent),
                  _buildPaymentOption('Visa', Icons.credit_card, Colors.deepPurple),
                  _buildPaymentOption('PayDunya', Icons.payment, Colors.green),
                ],
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Action pour le paiement
                },
                child: const Text("Payer"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String name, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        // Action à effectuer lors de la sélection d'une option de paiement
        print("$name sélectionné");
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              name,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}