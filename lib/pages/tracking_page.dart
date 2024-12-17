import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../models/TimeLineTileUi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrackingPage extends StatefulWidget {
  final String parcelId; // Define parcelId as a field in the widget

  const TrackingPage({Key? key, required this.parcelId}) : super(key: key);

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String parcelId;
  String? reservationDate;
  String? parcelDate;
  String? reservationId;
  String? parcelStatus;

  late User currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser!;
    parcelId = widget.parcelId; // Initialize with widget's parcelId
    print('Parcel ID from widget: $parcelId'); // Debugging
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetch arguments passed through ModalRoute
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['parcelId'] != null) {
      setState(() {
        parcelId = args['parcelId'];
      });
      print('Parcel ID received: $parcelId'); // Debugging
      fetchReservationDetails();
      fetchParcelDetails();
    } else {
      print('No parcelId received in arguments.');
    }
  }

  Future<void> fetchReservationDetails() async {
    try {
      print('Fetching reservations for colis_id: ${parcelId}');
      QuerySnapshot reservationSnapshot = await _firestore
          .collection('reservations')
          .where('colis_id', isEqualTo: parcelId.trim())
          .get();

      print('Reservation docs found: ${reservationSnapshot.docs.length}');
      if (reservationSnapshot.docs.isNotEmpty) {
        var reservationData =
            reservationSnapshot.docs.first.data() as Map<String, dynamic>;
        print('Reservation data: $reservationData');

        setState(() {
          if (reservationData['date_creation'] is Timestamp) {
            reservationDate = DateFormat('dd/MM/yyyy HH:mm').format(
                (reservationData['date_creation'] as Timestamp).toDate());
          } else {
            reservationDate = 'Date inconnue';
          }
          reservationId = reservationSnapshot.docs.first.id;
        });
      } else {
        setState(() {
          reservationDate = 'Aucune réservation trouvée';
        });
      }
    } catch (e) {
      print('Error fetching reservation details: $e');
      setState(() {
        reservationDate = 'Erreur de chargement';
      });
    }
  }

  Future<void> fetchParcelDetails() async {
    try {
      if (parcelId.isEmpty) return;

      DocumentSnapshot parcelSnapshot =
          await _firestore.collection('parcels').doc(parcelId.trim()).get();

      if (parcelSnapshot.exists) {
        var parcelData = parcelSnapshot.data() as Map<String, dynamic>;
        setState(() {
          parcelDate = parcelData['date_creation'] is Timestamp
              ? DateFormat('dd/MM/yyyy HH:mm')
                  .format((parcelData['date_creation'] as Timestamp).toDate())
              : 'Date inconnue';
          parcelStatus = parcelData['status'];
        });
      } else {
        setState(() {
          parcelDate = 'Aucun colis trouvé';
        });
      }
    } catch (e) {
      setState(() {
        parcelDate = 'Erreur de chargement';
      });
    }
  }

  bool getIsPast(int index) {
    const statusOrder = [
      'En attente de validation',
      'En attente de paiement',
      'Paiement effectué',
      'Colis récupéré',
      'Pays quitté',
      'Bientot arrivé',
      'Colis livrée'
    ];

    if (parcelStatus == null || !statusOrder.contains(parcelStatus)) {
      return false;
    }

    final currentStatusIndex = statusOrder.indexOf(parcelStatus!);
    return index <= currentStatusIndex;
  }

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
              padding:
                  const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ...[
                    {
                      'title': 'Réservation enregistrée',
                      'description':
                      'Votre réservation a été enregistrée avec succès et sera traitée prochainement.',
                      'icon': Icons.event_available,
                      'date': reservationDate,
                    },
                    {
                      'title': 'Réservation validée',
                      'description':
                      'Votre réservation a été validée et est prête pour les prochaines étapes.',
                      'icon': Icons.check_circle_outline,
                    },
                    {
                      'title': 'Paiement effectué',
                      'description':
                      'Le paiement a été reçu avec succès et la réservation est en cours de traitement.',
                      'icon': Icons.payment,
                    },
                    {
                      'title': 'Votre colis est entre mes mains',
                      'description':
                      'Votre commande est en route. Veuillez rester disponible pour la recevoir.',
                      'icon': Icons.local_shipping,
                      'date': parcelDate,
                    },
                    {
                      'title': 'Il vient de quitter le pays',
                      'description':
                      'Votre colis a quitté le pays et est en route vers sa destination finale.',
                      'icon': Icons.airplane_ticket,
                    },
                    {
                      'title': 'Il est arrivé à son site de livraison',
                      'description':
                      'Le colis est arrivé à son site de livraison et sera livré sous peu.',
                      'icon': Icons.location_on,
                    },
                    {
                      'title': 'Colis livré',
                      'description':
                      'Votre colis a été livré avec succès. Merci pour votre patience.',
                      'icon': Icons.check_circle,
                    },
                  ].asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> event = entry.value;

                    return TimeLineTileUI(
                      isFirst: index == 0,
                      isLast: index == 6,
                      isPast: getIsPast(index),
                      eventChild: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Icon(
                                event['icon'],
                                color: getIsPast(index)
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                              const SizedBox(width: 15.0),
                              Text(
                                event['title']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: getIsPast(index)
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            event['description']!,
                            style: TextStyle(
                              color:
                                  getIsPast(index) ? Colors.white : Colors.black54,
                            ),
                          ),
                          if (event.containsKey('date') &&
                              event['date'] != null)
                            Text(
                              event['date']!,
                              style: const TextStyle(color: Colors.white),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
