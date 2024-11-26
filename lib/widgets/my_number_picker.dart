import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../state_management/overall_use.dart';

class MyTimePicker extends StatefulWidget {
  final bool displayHours;
  final bool displayMins;
  final bool displaySecs;
  final bool displayCustom;
  final bool displayAM_PM;
  final String CustomString;
  String? hourString;
  String? minString;
  String? secString;
  int? hrsLimit;
  int? minLimit;
  final List<int> CustomList;
  MyTimePicker({super.key,
    required this.displayHours,
    this.hourString,
    this.minString,
    this.secString,
    this.hrsLimit,
    this.minLimit,
    required this.displayMins,
    required this.displaySecs,
    required this.displayCustom, required this.CustomString, required this.CustomList, required this.displayAM_PM});
  @override
  State<MyTimePicker> createState() => _MyTimePickerState();
}

class _MyTimePickerState extends State<MyTimePicker> {
  int _currentSegment = 0; // Store the currently selected segment index
  // Create a list of options for the segmented control
  final Map<int, Widget> segmentedOptions = {
    0: Padding(padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
        child : Text('AM',style: TextStyle(color: Colors.black),)),
    1: Padding(padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
        child : Text('PM',style: TextStyle(color: Colors.black),)),
  };
  @override
  Widget build(BuildContext context) {
    var overAllPvd = Provider.of<OverAllUse>(context,listen: true);
    return Container(
      height: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: widget.displayAM_PM,
            child: Container(
              width: 200,
              child: CupertinoSegmentedControl(
                unselectedColor: Colors.grey.shade100,
                borderColor: Colors.white,
                selectedColor: Colors.green.shade200,
                children: segmentedOptions,
                groupValue: _currentSegment,
                onValueChanged: (value) {
                  setState(() {
                    _currentSegment = value;
                  });
                  overAllPvd.edit_am_pm(value == 0 ? 'AM' : 'PM');
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: widget.displayHours,
                child: Container(
                  width: 50,
                  child: NumberPicker(
                    itemHeight: 80,
                    textStyle: TextStyle(color: Colors.grey,fontSize: 12),
                    selectedTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(width: 1,color: Colors.black),bottom: BorderSide(width: 1,color: Colors.black))
                    ),
                    infiniteLoop: true,
                    minValue: 0,
                    maxValue: widget.displayAM_PM == true ? 11 : widget.hrsLimit != null ? widget.hrsLimit! : 23,
                    value: overAllPvd.hrs,
                    onChanged: (value){
                      overAllPvd.editTime('hrs', value);
                    },
                    forWhat: widget.hourString == null ? 'hrs' : widget.hourString!,
                  ),
                ),
              ),
              Visibility(
                visible: widget.displayMins,
                child: Container(
                  width: 50,
                  child: NumberPicker(
                    itemHeight: 80,
                    textStyle: TextStyle(color: Colors.grey,fontSize: 12),
                    selectedTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(width: 1,color: Colors.black),bottom: BorderSide(width: 1,color: Colors.black))
                    ),
                    infiniteLoop: true,
                    minValue: 0,
                    maxValue: widget.minLimit != null ? widget.minLimit! : 59,
                    value: overAllPvd.min,
                    onChanged: (value){
                      overAllPvd.editTime('min', value);
                    },
                    forWhat: widget.minString == null ? 'min' : widget.minString!,
                  ),
                ),
              ),
              Visibility(
                visible: widget.displaySecs,
                child: Container(
                  width: 50,
                  child: NumberPicker(
                    itemHeight: 80,
                    textStyle: TextStyle(color: Colors.grey,fontSize: 12),
                    selectedTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(width: 1,color: Colors.black),bottom: BorderSide(width: 1,color: Colors.black))
                    ),
                    infiniteLoop: true,
                    minValue: 0,
                    maxValue: 60,
                    value: overAllPvd.sec,
                    onChanged: (value){
                      overAllPvd.editTime('sec', value);
                    },
                    forWhat: widget.secString == null ? 'sec' : widget.secString!,
                  ),
                ),
              ),
              Visibility(
                visible: widget.displayCustom,
                child: NumberPicker(
                  itemHeight: 80,
                  textStyle: TextStyle(color: Colors.grey,fontSize: 12),
                  selectedTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(width: 1,color: Colors.black),bottom: BorderSide(width: 1,color: Colors.black))
                  ),
                  infiniteLoop: true,
                  minValue: widget.CustomList[0],
                  maxValue: widget.CustomList[1],
                  value: overAllPvd.other,
                  onChanged: (value){
                    overAllPvd.editTime('other', value);
                  },
                  forWhat: '${widget.CustomString}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}