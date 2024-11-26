import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';

class CustomTimePicker extends StatefulWidget {
  final String initialTime;
  final bool isSeconds;
  final Function(String) onChanged;
  final bool? is24HourMode;

  const CustomTimePicker({super.key, required this.onChanged, required this.initialTime, required this.isSeconds, this.is24HourMode});

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late ValueNotifier<String> selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = ValueNotifier<String>(widget.initialTime);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showTimePicker(context);
      },
      child: ValueListenableBuilder<String>(
        valueListenable: selectedTime,
        builder: (context, time, child) {
          return Text(
            time,
            style: Theme.of(context).textTheme.bodyMedium,
          );
        },
      ),
    );
  }

  void _showTimePicker(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String selectedValue = widget.initialTime;

        return AlertDialog(
          title: const Column(
            children: [
              Text(
                'Select time',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Container(
            alignment: Alignment.center,
            height: 200,
            child: TimePickerSpinner(
              alignment: Alignment.center,
              isForce2Digits: true,
              is24HourMode: widget.is24HourMode ?? true,
              isShowSeconds: widget.isSeconds,
              normalTextStyle: const TextStyle(fontSize: 20, color: Colors.grey),
              highlightedTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
              spacing: 50,
              itemHeight: 70,
              onTimeChange: (time) {
                final formattedTime = widget.isSeconds
                    ? DateFormat('HH:mm:ss').format(
                  DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    time.hour,
                    time.minute,
                    time.second,
                  ),
                )
                    : DateFormat('Hm').format(
                  DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    time.hour,
                    time.minute,
                    time.second,
                  ),
                );
                selectedValue = formattedTime;
              },
              time: widget.isSeconds ? DateFormat('HH:mm:ss').parse(selectedValue) : DateFormat('Hm').parse(selectedValue),
            ),
          ),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(selectedValue);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      selectedTime.value = result;
      widget.onChanged(result);
    }
  }
}
