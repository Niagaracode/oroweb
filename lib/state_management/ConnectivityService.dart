import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import '../constants/MQTTManager.dart';

class ConnectivityService with ChangeNotifier {
  bool _isConnected = true;

  ConnectivityService() {
    html.window.onOnline.listen((event) {
      _updateConnectionStatus(true);
    });

    html.window.onOffline.listen((event) {
      _updateConnectionStatus(false);
    });

    // Initial check
    _isConnected = html.window.navigator.onLine!;
  }

  bool get isConnected => _isConnected;

  void _updateConnectionStatus(bool isConnected) {
    _isConnected = isConnected;
    notifyListeners();
  }
}