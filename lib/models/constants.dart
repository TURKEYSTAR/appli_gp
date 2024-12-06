import 'dart:convert';
import 'package:http/http.dart' as http;

const String payDunyaTestPublicKey = 'test_public_wBBuQi1HzyuzE7JvVSiQVqq2zSG';
const String payDunyaTestPrivateKey =
    'test_private_v9m098H9L9LyUcMoKcVHh5w9GDZ';
const String payDunyaTestToken = '63cMPPhXHUMvGsd0JIyE';
const String payDunyaBaseUrl =
    'https://app.paydunya.com/sandbox-api/v1/checkout-invoice';

Future<String?> initierPaiement(String description, double montant,
    String devise) async {
  final url = Uri.parse('$payDunyaBaseUrl/create');

  final headers = {
    'Content-Type': 'application/json',
    'PAYDUNYA-MASTER-KEY': 'BnBBFiPm-bBCr-PV8n-9Xud-p9jn3HdIxUYZ',
    'PAYDUNYA-PRIVATE-KEY': payDunyaTestPrivateKey,
    'PAYDUNYA-PUBLIC-KEY': payDunyaTestPublicKey,
    'PAYDUNYA-TOKEN': payDunyaTestToken,
  };

  final body = jsonEncode({
    "invoice": {
      "items": [
        {
          "name": "Réservation de colis",
          "quantity": 1,
          "unit_price": montant.toStringAsFixed(2),
          "total_price": montant.toStringAsFixed(2),
          "description": description,
        }
      ],
      "total_amount": montant.toStringAsFixed(2),
      "currency": devise,
    },
    "store": {
      "name": "Nom de l'Application",
      "tagline": "Tagline de votre app",
      "postal_address": "Adresse de votre entreprise",
      "phone": "Numéro de téléphone",
      "logo_url": "https://votre-logo-url.png"
    },
    "actions": {
      "cancel_url": "https://votre-url-annulation",
      "return_url": "https://votre-url-retour",
      "callback_url": "https://votre-url-callback"
    }
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['response_code'] == '00') {
        return data['response_text']; // Checkout URL
      } else {
        throw Exception("Erreur API : ${data['response_text']}");
      }
    } else {
      throw Exception("Erreur HTTP : ${response.statusCode}");
    }
  } catch (e) {
    print("Exception : $e");
    return null;
  }
}

