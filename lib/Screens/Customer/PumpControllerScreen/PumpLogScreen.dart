import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:timezone/browser.dart';

import '../../../Models/Customer/Dashboard/PumpControllerModel/PumpLogMDL.dart';
import '../../../constants/http_service.dart';

DateTime get _now => DateTime.now();

class PumpLogScreen extends StatefulWidget {
  const PumpLogScreen({Key? key, required this.customerId, required this.controllerId}) : super(key: key);
  final int customerId, controllerId;

  @override
  State<PumpLogScreen> createState() => _PumpLogScreenState();
}

class _PumpLogScreenState extends State<PumpLogScreen> {

  List<PumpLogMDL> pumpLogs= [];

  final List<CalendarEventData> _events = [];

  /*final List<CalendarEventData> _events = [
    CalendarEventData(
      date: _now,
      title: "Project meeting",
      description: "Today is project meeting.",
      startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
      endTime: DateTime(_now.year, _now.month, _now.day, 22),
    ),
    CalendarEventData(
      date: _now.add(Duration(days: 1)),
      startTime: DateTime(_now.year, _now.month, _now.day, 18),
      endTime: DateTime.now(),
      title: "Wedding anniversary",
      description: "Attend uncle's wedding anniversary.",
    ),
    CalendarEventData(
      date: _now,
      startTime: DateTime(_now.year, _now.month, _now.day, 14),
      endTime: DateTime(_now.year, _now.month, _now.day, 17),
      title: "Football Tournament",
      description: "Go to football tournament.",
    ),
    CalendarEventData(
      date: _now.add(Duration(days: 3)),
      startTime: DateTime(_now.add(Duration(days: 3)).year,
          _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 10),
      endTime: DateTime(_now.add(Duration(days: 3)).year,
          _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 14),
      title: "Sprint Meeting.",
      description: "Last day of project submission for last year.",
    ),
    CalendarEventData(
      date: _now.subtract(Duration(days: 2)),
      startTime: DateTime(
          _now.subtract(Duration(days: 2)).year,
          _now.subtract(Duration(days: 2)).month,
          _now.subtract(Duration(days: 2)).day,
          14),
      endTime: DateTime(
          _now.subtract(Duration(days: 2)).year,
          _now.subtract(Duration(days: 2)).month,
          _now.subtract(Duration(days: 2)).day,
          16),
      title: "Team Meeting",
      description: "Team Meeting",
    ),
    CalendarEventData(
      date: _now.subtract(Duration(days: 2)),
      startTime: DateTime(
          _now.subtract(Duration(days: 2)).year,
          _now.subtract(Duration(days: 2)).month,
          _now.subtract(Duration(days: 2)).day,
          10),
      endTime: DateTime(
          _now.subtract(Duration(days: 2)).year,
          _now.subtract(Duration(days: 2)).month,
          _now.subtract(Duration(days: 2)).day,
          12),
      title: "Chemistry Viva",
      description: "Today is Joe's birthday.",
    ),
  ];*/

  @override
  void initState() {
    super.initState();
    getPumpLogs();
  }

  Future<void> getPumpLogs() async
  {
    Map<String, Object> body = {
      "userId": widget.customerId,
      "controllerId": widget.controllerId,
      "fromDate": "2024-07-10",
      "toDate": "2024-07-15"
    };
    print(body);
    final response = await HttpService().postRequest("getUserPumpLog", body);
    if (response.statusCode == 200) {
      pumpLogs.clear();
      _events.clear();
      var data = jsonDecode(response.body);
      print(response.body);
      if (data["code"] == 200) {
        final jsonData = data["data"] as List;
        try {
          pumpLogs = jsonData.map((json) => PumpLogMDL.fromJson(json)).toList();

          for(var log in pumpLogs){

            if (log.logDate != null) {
              List<String> dateParts = log.logDate!.split('-');
              int year = int.parse(dateParts[0]);
              int month = int.parse(dateParts[1]);
              int day = int.parse(dateParts[2]);

              // Split the string by the first comma
              List<String> parts = log.motor1!.split(',');
              String title = parts[0]; // The title is the first part
              String remaining = parts.sublist(1).join(','); // Rejoin the remaining parts

              // Extract N and F times using a regex
              RegExp timeRegex = RegExp(r'(N|F)=(\d{2}:\d{2}:\d{2})');
              Iterable<Match> matches = timeRegex.allMatches(remaining);

              List<String> onTimes = [];
              List<String> offTimes = [];

              for (var match in matches) {
                String type = match.group(1)!;
                String time = match.group(2)!;
                if (type == 'N') {
                  onTimes.add(time);
                } else if (type == 'F') {
                  offTimes.add(time);
                }
              }

              // Print the extracted information
              print('Title: $title');
              print('On Times: ${onTimes.join(', ')}');
              print('Off Times: ${offTimes.join(', ')}');

              for(var onTime in onTimes){

              }

              _events.add(CalendarEventData(
                date: DateTime(year, month, day),
                title: title,
                startTime: DateTime(year, month, day, 18, 30),
                endTime: DateTime(year, month, day, 22),
              ));
            } else {
              // Handle the case where logDate is null, if necessary
              print("logDate is null for log: $log");
            }
          }

          setState(() {
          });

        } catch (e) {
          print('Error: $e');
        }
      }
    }
    else {
      //_showSnackBar(response.body);
    }
  }



  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController()..addAll(_events),
      child: DayView(
        maxDay: DateTime.now(),
        timeLineWidth: 100.0,
        heightPerMinute: 1.5,
      ),
    );
  }
}