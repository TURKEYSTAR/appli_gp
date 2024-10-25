// lib/models/annonce.dart

class Annonce {
  final String mode;
  final String departVille;
  final String departPays;
  final String arriveeVille;
  final String arriveePays;
  final DateTime dateDepart;
  final DateTime dateArrivee;
  final String poidsMax;
  final String prixKg;
  final String numArrivee;
  final String numDepart;

  Annonce({
    required this.mode,
    required this.departVille,
    required this.departPays,
    required this.arriveeVille,
    required this.arriveePays,
    required this.dateDepart,
    required this.dateArrivee,
    required this.poidsMax,
    required this.prixKg,
    required this.numArrivee,
    required this.numDepart,
  });
}
