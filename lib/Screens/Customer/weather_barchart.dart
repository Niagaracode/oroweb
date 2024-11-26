import 'package:flutter/material.dart';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';

import '../../constants/theme.dart';
enum Segment { Weekly, Monthly, Yearly }



// Define data structure for a bar group
class DataItem {
  int x;
  double y1;
  double y2;
  double y3;
  DataItem(
      {required this.x, required this.y1, required this.y2, required this.y3});
}

class WeatherBar extends StatefulWidget {
  WeatherBar(
      {super.key, required this.tempdata,required this.timedata,required this.title});
  List tempdata = [];
  List timedata = [];
  String title;

  @override
  State<WeatherBar> createState() => _WeatherBarState();
}

class _WeatherBarState extends State<WeatherBar> {
  Segment selectedSegment = Segment.Weekly;

  // HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = [];
    List first30Values = [];
    print(widget.tempdata,);
    if(selectedSegment == Segment.Weekly) {
      first30Values = widget.tempdata.sublist(0, 7);
    }
    else if(selectedSegment == Segment.Monthly) {
      first30Values = widget.tempdata.sublist(0, 30);
    }
    else{
      first30Values = widget.tempdata.sublist(0, 90);
      // first30Values = widget.tempdata;
    }

    for (int index = 0; index < first30Values.length; index++) {
      BarChartGroupData barChartGroupData = BarChartGroupData(
        x: index + 1,
        barRods: [
          BarChartRodData(
            fromY: 0,
            toY: first30Values[index],
            width: 10,
            color: Colors.amber,
          ),
        ],
      );

      barGroups.add(barChartGroupData);
    }



    return Scaffold(
      appBar: AppBar(
        title:  Text('${widget.title}'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          SegmentedButton<Segment>(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                  myTheme.primaryColor.withOpacity(0.1)),
              iconColor: MaterialStateProperty.all(myTheme.primaryColor),
            ),
            segments:  const <ButtonSegment<Segment>>[
              ButtonSegment<Segment>(
                  value: Segment.Weekly,
                  label: Text('Weekly'),
                  icon: Icon(Icons.calendar_today_outlined)),
              ButtonSegment<Segment>(
                  value: Segment.Monthly,
                  label: Text('Monthly'),
                  icon: Icon(Icons.calendar_view_week)),
              ButtonSegment<Segment>(
                  value: Segment.Yearly,
                  label: Text('Yearly'),
                  icon: Icon(Icons.calendar_month)),
            ],
            selected: <Segment>{selectedSegment},
            onSelectionChanged: (Set<Segment> newSelection) {
              setState(() {
                print('selectedSegment$selectedSegment');
                selectedSegment = newSelection.first;
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(  decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
                child: BarChart(BarChartData(
                    minY: 0,
                    borderData: FlBorderData(
                        border: const Border(
                          top: BorderSide.none,
                          right: BorderSide.none,
                          left: BorderSide(width: 1),
                          bottom: BorderSide(width: 1),
                        )),
                    groupsSpace: 10,
                    barGroups:  barGroups)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}