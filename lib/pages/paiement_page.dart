import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaiementPage extends StatefulWidget {
  final String checkoutUrl; // URL obtained from initierPaiement

  const PaiementPage({required this.checkoutUrl, Key? key}) : super(key: key);

  @override
  _PaiementPageState createState() => _PaiementPageState();
}

class _PaiementPageState extends State<PaiementPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialiser le contrôleur WebView
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Autoriser JavaScript
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl)); // Charger l'URL du paiement
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text("Paiement"),
        backgroundColor: Colors.black54,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller), // Utiliser WebViewWidget
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
