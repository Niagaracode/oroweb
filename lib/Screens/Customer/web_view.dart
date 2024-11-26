
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;  // Use dart:ui_web for platformViewRegistry

class WebViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('External Weathers')),
      body: Center(child: Iframe()),
    );
  }
}

class Iframe extends StatelessWidget {
  Iframe() {
    // Register the iframe view with ui.platformViewRegistry
    ui.platformViewRegistry.registerViewFactory('iframe', (int viewId) {
      var iframe = html.IFrameElement();
      iframe.src = 'https://www.weatherandradar.in/';  // Replace with an embeddable URL
      iframe.width = '600';  // Set iframe width
      iframe.height = '400'; // Set iframe height
      iframe.style.border = 'none'; // Optional: removes border
      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(// Match the iframe size
      child: HtmlElementView(viewType: 'iframe'),
    );
  }
}
