import 'package:flutter/cupertino.dart';

class DurationNotifier extends ChangeNotifier {
  ValueNotifier<String> leftDurationOrFlow = ValueNotifier<String>('00:00:00');
  ValueNotifier<String> onDelayLeft = ValueNotifier<String>('00:00:00');

  void updateDuration(String newDuration) {
    leftDurationOrFlow.value = newDuration;
  }

  void updateOnDelayTime(String onDelayTime) {
    onDelayLeft.value = onDelayTime;
  }
}