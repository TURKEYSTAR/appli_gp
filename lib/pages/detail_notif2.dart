import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailNotif2Page extends StatefulWidget {
  @override
  _DetailNotif2PageState createState() => _DetailNotif2PageState();
}

class _DetailNotif2PageState extends State<DetailNotif2Page> {
  int _selectedStars = 0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), _showRatingDialog);
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateInDialog) {
            return AlertDialog(
              title: const Text("Notez le transporteur"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Veuillez attribuer une note au transporteur."),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          Icons.star,
                          color: index < _selectedStars
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setStateInDialog(() {
                            _selectedStars = index +
                                1; // Mettre à jour les étoiles sélectionnées
                          });
                          // Propager également la mise à jour dans l'état global
                          setState(() {});
                        },
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Noter plus tard"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showCommentDialog();
                  },
                  child: const Text("Valider"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCommentDialog() {
    TextEditingController _commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Laisser un commentaire"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  "Vous pouvez écrire un commentaire si vous le souhaitez."),
              const SizedBox(height: 10),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Entrez votre commentaire",
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                _submitRating(_commentController.text);
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: const Text("Envoyer"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitRating(String comment) async {
    try {
      // Exemple d'enregistrement dans Firestore (personnalisez selon votre structure)
      await FirebaseFirestore.instance.collection('ratings').add({
        'stars': _selectedStars,
        'comment': comment,
        'date': Timestamp.now(),
      });
      print("Note enregistrée: $_selectedStars étoiles, Commentaire: $comment");
    } catch (e) {
      print("Erreur lors de l'enregistrement de la note: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color(0xFF6672FF),
        centerTitle: true,
        title: Text(
          "",
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMessageRow(),
              const SizedBox(height: 20),
              _buildThankYouSection(),
              const SizedBox(height: 50),
              _buildTimeline(),
              const SizedBox(height: 20),
              _buildNextSteps(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThankYouSection() {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 50,
          ),
          const SizedBox(height: 10),
          Text(
            "Merci d'avoir utilisé notre service !",
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            "Nous espérons que votre expérience a été agréable.",
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: const Text(
            "Historique de la livraison",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text(
                "Colis récupéré à : Nouakchott",
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Center(
          child: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text(
                "En cours de livraison",
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Center(
          child: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text(
                "Livré à : Dakar",
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildNextSteps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: const Text(
            "Que faire ensuite ?",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        ListTile(
          leading: const Icon(Icons.star, color: Colors.yellow),
          title: const Text(
            "Évaluez votre expérience",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          onTap: _showRatingDialog,
        ),
        ListTile(
          leading: const Icon(Icons.reorder, color: Colors.black),
          title: const Text(
            "Voir vos autres colis",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          onTap: () {
            // Rediriger vers une page de suivi des colis
          },
        ),
        ListTile(
          leading: const Icon(Icons.help_outline, color: Colors.black),
          title: const Text(
            "Contacter le support",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          onTap: () {
            // Rediriger vers une page de support
          },
        ),
      ],
    );
  }

  Widget _buildMessageRow() {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Center-align the texts within the Column
              children: [
                SizedBox(height: 50),
                Text(
                  'Félicitations! Votre colis est arrivé à destination',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  // Ensure text alignment is centered
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(height: 8), // Espacement entre les deux textes
                Text(
                  "Il a été livré avec succès à l'adresse address_destinataire",
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  // Ensure text alignment is centered
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
