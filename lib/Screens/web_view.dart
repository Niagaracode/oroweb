import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  const MyWebView({super.key});

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? Container() : FutureBuilder(
      future: _initializeWebView(),
      builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return WebView(
            initialUrl: 'https://www.example.com',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<WebViewController> _initializeWebView() async {
    // Perform any additional initialization here
    await Future.delayed(const Duration(seconds: 2)); // Simulating a delay

    // Return the WebViewController once initialized
    return _webViewController;
  }
}