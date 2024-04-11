import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BuyCoffeePage extends StatelessWidget {
  final String url;
  const BuyCoffeePage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy Me a Coffee'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
