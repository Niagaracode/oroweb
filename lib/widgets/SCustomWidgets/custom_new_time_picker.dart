import 'package:flutter/material.dart';

import '../my_number_picker.dart';

class NewCustomTimePicker extends StatefulWidget {
  final String title;
  final Function(int, int, int) onTimeSelected;

  const NewCustomTimePicker({
    Key? key,
    required this.title,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  _NewCustomTimePickerState createState() => _NewCustomTimePickerState();
}

class _NewCustomTimePickerState extends State<NewCustomTimePicker> {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      title: Column(
        children: [
          Text(
            widget.title,
            style: const TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: MyTimePicker(
        displayHours: true,
        hourString: 'hr',
        displayMins: true,
        minString: 'min',
        secString: 'sec',
        displaySecs: true,
        displayCustom: false,
        CustomString: '',
        CustomList: [0, 10],
        displayAM_PM: false,
      ),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onTimeSelected(hours, minutes, seconds);
            Navigator.of(context).pop();
          },
          child: Text(
            'OK',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
