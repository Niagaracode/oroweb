import 'dart:async';
import 'package:flutter/material.dart';

class StreamProvider extends ChangeNotifier {
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get stream => _streamController.stream;

  StreamProvider();

  void updateStreamData(String newData) {
    _streamController.add(newData);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}