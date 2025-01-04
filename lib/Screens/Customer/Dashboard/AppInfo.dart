
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key,});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('App Info')),
      body: const Center(child: Iframe(urlstr: 'https://oro-smart-drip-fix5wv9.gamma.site/')),
    );
  }
}

class Iframe extends StatefulWidget {
  final String urlstr;

  const Iframe({super.key, required this.urlstr});

  @override
  _IframeState createState() => _IframeState();
}

class _IframeState extends State<Iframe> {
  late String iframeViewType;

  @override
  void initState() {
    super.initState();
    iframeViewType = 'iframe-${DateTime.now().millisecondsSinceEpoch}';

    ui.platformViewRegistry.registerViewFactory(iframeViewType, (int viewId) {
      var iframe = html.IFrameElement();
      iframe.src = widget.urlstr;
      iframe.style.border = 'none'; // Optional: removes border
      return iframe;
    });
  }

  @override
  void dispose() {
    final iframe = html.document.querySelector('iframe');
    if (iframe != null) {
      iframe.style.display = 'none';
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: iframeViewType);
  }
}