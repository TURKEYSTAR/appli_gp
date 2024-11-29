import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class PushNotificationService {
  // Replace this with your Firebase project's service account JSON
  static const serviceAccountJson = {
    "type": "service_account",
    "project_id": "my-appli-gp",
    "private_key_id": "22cf2c2a2f7dd5767297b3df3764450866564281",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCmzTok428kmaUF\nYbOD7LQvVbvWA+mOTOuE15BVorqHZg2Vv7bsfg2Bjv9YmaCKmAUAlERp5c20R8eX\njsd6KnyFIMJOh6Mc0Si07oR3Hk8SeIrNmbLWEnqEI6kxpdd1Qv+eatuvqsa3KDkc\n5vj28M7zonIl01RHCmLYCsfEISXKn+deHwnXT7BWJ7XBYAy9tdX/eddYVe06K6st\ndykF0AyqJldx847Tz4QiXOpfIouTpsXhx8AuAI4wjKBqZLeCyrCrWodkmPEkVEbi\ns0KF7iWr+yisvLsfnQgxqT13EGH/FJzK2lBXblWFdl/omvOGSm1AUTAVjZ6NnEEx\naXg6qSA1AgMBAAECggEAAh9meAW06mBSK0ldAXbHrDqJE2YlWLw92wjrO0vA1+xC\ni/9Okp/gCCALu9LoqhrZJXK9lCNqhLrNHW6htzpHL2KFVn5/YuR+gh7u7J0kIHYM\nPiWQkwzVJk1V393eag2aNyfg99FSig4m++ksjefumkcc8MJJtkW5kEpC1Iofcv6k\npDUGYZ9V5MtsgQ2PkVJxuun3ELymvCy6VdVnFr+N8b7IYQGe4/Vh73B63gLMp3pX\nyXF+ns+IJn6iTbWw2PBZPu5mSPdE1CMmbhIbDXuT5tpMY6jt4F/BmaTCp2bjQA9M\nUcSHwSVLnTpi59Kx61V69lKIQKoOkaaKZ8lyzsI+QQKBgQDqGwT9pHC+QJ9RXGxH\nL78izaqIOg98D9WFhZyjmkS9Pt7xEo3YaUWac3GosenP3z6F/vuA9F0N73b1QI8b\nL9RbpuuoIiDzUMWcfq/u0NVqVIOGUZb+Ee0vUjMipJcJf901SqiaIp6abx8MNXHJ\n1mUiom6H7Cb6WO6CEhq9q8fk+QKBgQC2Zs+Vg/5nTP56WUSd/k4qfWoFO9RqxdIA\nCO5/PBNiqknRQe4IMfmtRJXUQAxT3nX7MZlF4mq59Bry4p9qZ3fPZ/7EcUNCJw4v\nO/HK7pxMF48yBgX1Ig8CzYwdOl2FBX6AWAd/qvk+TZe/EdNLcXYVRGjtKoikS6qo\n68i2z6GwHQKBgQCH6lH2dJ8kRd55XSBcIANnUGKenp7Y11SPJahwb6NTAAptieki\naNQJPNcTKt/lWOYy43vfPYA9E/dLokSzcwxmfb25qr7YpN9l4UOBcmtFRXXq6Lmy\nHnRHEgEwLsCluj+Srhq/CjRs0vECpJDAryGefxGPBnMGy9UFXT97OR1f+QKBgQCK\nOKiv1cFwiIEDOChuTarwOe+gnbEfZF751crdsinCh+a+Y2a84RoiOioMGKj+2UKw\noupScfyMg7X0PtWtLVE2Y8lFFctxEuWF17goHt9kLio+LyBOnYughSDbeUIrLnmp\nSowMLAUKOIR4r0peDlH8VcXpi2TWk9x0e5CzL+6H5QKBgGG9vS9CNOlPOF7HTIcY\nCkPrBWmAg+dK5PqgvKWmMHPChK9VG0w+s6owWsIoeS00lU2SIox/e5SOQ20oOS5Z\nx3dd1b2R6DkkHaWKNlDu07nM4RaHS+6apDqHXlNPT788kj6xG2RbK1rTDsAqBLaV\ncF+56uZ91gL7QBtkUAUEhhzu\n-----END PRIVATE KEY-----\n",
    "client_email": "flutter-gp-appli-mlf@my-appli-gp.iam.gserviceaccount.com",
    "client_id": "110495155187674392766",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gp-appli-mlf%40my-appli-gp.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  static Future<String> getAccessToken() async {
    final scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    final client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    final credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();
    return credentials.accessToken.data;
  }

  // Method to get FCM token for the announcement creator
  static Future<String?> getCreatorToken(String transporteurId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(transporteurId).get();
    return userDoc.data()?['fcmToken'];
  }

  // Method to send notification
  // Method to send notification
  static Future<void> sendNotificationToUser(String deviceToken, String senderName, String packageWeight) async {
    final serverAccessToken = await getAccessToken();
    final endpoint = 'https://fcm.googleapis.com/v1/projects/my-appli-gp/messages:send';

    final message = {
      'message': {
        'token': deviceToken,
        'notification': {
          'title': "Nouvelle réservation",
          'body': "Vous avez reçu une réservation de $senderName. Poids à transporter: $packageWeight"
        },
        'data': {
          'type': 'reservation',
          'senderName': senderName,
          'packageWeight': packageWeight,
        }
      }
    };

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessToken',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }

  static Future<void> notifyAnnouncementCreator(BuildContext context, String transporteurId, String senderName, String packageWeight) async {
    final creatorToken = await getCreatorToken( transporteurId);
    if (creatorToken != null) {
      await sendNotificationToUser(creatorToken, senderName, packageWeight);
    } else {
      print('FCM token not found for the announcement creator');
    }
  }
  Future<void> saveFCMToken() async {
    // Récupère le token FCM
    final fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken != null) {
      // Appelle une fonction pour enregistrer le token dans Firestore
      await updateUserFCMToken(fcmToken);
    }
  }
  Future<void> updateUserFCMToken(String token) async {
    // Vérifie que l'utilisateur est connecté
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Enregistre le token dans le document Firestore de l'utilisateur
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'fcmToken': token,  // Associe le token à l'utilisateur
      });
    } else {
      print("Erreur : Utilisateur non connecté");
    }
  }
}
