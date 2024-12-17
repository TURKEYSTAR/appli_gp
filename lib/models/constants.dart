import 'dart:convert';
import 'package:http/http.dart' as http;

const String payTechApiUrl = 'https://paytech.sn/api/payment/request-payment';
const String payTechPublicKey = '9ed91844541cace52fb3e0480fa44ee1f9df268fc847013ee97a895c36dc4b7c';
const String payTechSecretKey = 'dc56248303d51eaa40f1d973522f77682aa319b9ce9635ebbc58d97e48da1a81';

Future<String?> initierPaiement(String description, double montant) async {
  final url = Uri.parse(payTechApiUrl);
  final headers = {
    'Content-Type': 'application/json',
    'API_KEY': payTechPublicKey,
    'API_SECRET': payTechSecretKey,
  };

  final body = jsonEncode({
    "item_name": description,
    "item_price": montant.toStringAsFixed(2),
    "currency": "XOF",
    "ref_command": DateTime.now().millisecondsSinceEpoch.toString(),
    "ipn_url": "https://votre-url-callback",
    "success_url": "appli_gp://success",
    "cancel_url": "https://votre-url-annulation",
    "customer_email": "client@email.com",
    "customer_phone": "+221771234567",
    "env": "test"
  });

  try {
    final response = await http.post(url, headers: headers, body: body);
    print("Statut de la réponse HTTP: ${response.statusCode}");
    print("Réponse de l'API: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == 1) {
        final redirectUrl = data['redirect_url'];
        print("URL de redirection : $redirectUrl");
        return redirectUrl;
      } else {
        print("Erreur PayTech : ${data['message']}");
      }
    } else {
      print("Erreur HTTP : ${response.statusCode}");
      print("Détail de la réponse : ${response.body}");
    }
  } catch (e) {
    print("Exception attrapée : $e");
  }

  return null;
}
