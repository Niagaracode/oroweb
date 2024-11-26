import 'package:flutter/material.dart';

class CustomOverlayWidget {
  static OverlayEntry? _overlayEntry;

  static void showOverlay(BuildContext context, String message) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50,
        left: 50,
        right: 50,
        child: Material(
          elevation: 4.0,
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(milliseconds: 1500), () {
      _overlayEntry?.remove();
    });
  }
}
