
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

class WebViewExample extends StatelessWidget {
  final int userid; // Define the userid field
  final int controllerid;
  // Constructor to accept userid
  const WebViewExample({super.key, required this.userid,required this.controllerid});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('External Weathers')),
      body: Center(child: Iframe(urlstr: (userid == 55 && controllerid == 300)  ? 'https://www.ecowitt.net/home/share?authorize=T9TPX8' : 'https://www.weatherandradar.in/')),
    );
  }
}

class Iframe extends StatefulWidget {
  final String urlstr;

  const Iframe({required this.urlstr});

  @override
  _IframeState createState() => _IframeState();
}

class _IframeState extends State<Iframe> {
  late String iframeViewType;

  @override
  void initState() {
    super.initState();
    // Generate a unique iframe view type for this instance
    iframeViewType = 'iframe-${DateTime.now().millisecondsSinceEpoch}';

    // Register the iframe view with the platform view registry
    ui.platformViewRegistry.registerViewFactory(iframeViewType, (int viewId) {
      var iframe = html.IFrameElement();
      iframe.src = widget.urlstr;
      iframe.style.border = 'none'; // Optional: removes border
      return iframe;
    });
  }

  @override
  void dispose() {
    // Hide the iframe (not unregistering the view)
    final iframe = html.document.querySelector('iframe');
    if (iframe != null) {
      iframe.style.display = 'none'; // Hide the iframe if it's present
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: HtmlElementView(viewType: iframeViewType),
    );
  }
}


