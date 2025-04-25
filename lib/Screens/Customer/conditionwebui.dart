import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/widgets.dart';
import 'package:oro_irrigation_new/constants/MQTTManager.dart';
import 'package:oro_irrigation_new/constants/theme.dart';
import 'package:oro_irrigation_new/state_management/condition_provider.dart';
import 'package:oro_irrigation_new/state_management/irrigation_program_main_provider.dart';
import 'package:provider/provider.dart';

import '../../Models/condition_model.dart';
import '../../constants/http_service.dart';
import '../../constants/snack_bar.dart';
import '../../state_management/MqttPayloadProvider.dart';
import '../../state_management/overall_use.dart';
import '../../widgets/HoursMinutesSeconds.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'IrrigationProgram/program_library.dart';

enum Conditiontype { program, moisture, level }

class ConditionWebUI extends StatefulWidget {
  const ConditionWebUI(
      {Key? key,
        required this.userId,
        required this.controllerId,
        required this.imeiNo, required this.serialNumber, required this.isProgram});
  final userId, controllerId, serialNumber;
  final String imeiNo;
  final bool isProgram;

  @override
  State<ConditionWebUI> createState() => _ConditionWebUIState();
}

class _ConditionWebUIState extends State<ConditionWebUI>
    with TickerProviderStateMixin {
  dynamic jsonData;
  late MqttPayloadProvider mqttPayloadProvider;
  List<String> conditionHdrList = [
    'SNo',
    'Name',
    'Enable',
    'Scan Time',
    'Condition IsTrue',
    'Start Time',
    'Stop Time',
    'conditionBypass',
  ];
  String usedProgramDropDownStr = '';
  List<UserNames>? usedProgramDropDownList = [];
  List<String>? AfterProgramDropDownList = [];
  String usedProgramDropDownStr2 = '';
  String usedProgramDropDownStr3 = '';
  String dropDownValues = '';
  ConditionModel _conditionModel = ConditionModel();
  String hint = 'Enter Flow Values';
  String dropDownTitle = '';
  int selectIndexRow = 0;
  String programStr = '';
  String zoneStr = '';
  List<String> operatorList = [
    '&& -Both are true',
    '|| -Anyone true',
    // '^ -No one true'
  ];
  List<String> manualoperatorList = ['High', 'Low'];
  String selectedOperator = '';
  String selectedCondition = '';
  List<String> conditionList = [];
  List<ConditionLibrary>? conditionLibrary = [];
  Conditiontype selectedSegment = Conditiontype.program;
  int applycheck = 1;
  late ConditionProvider sensorProvider;

  @override
  void initState() {
    mqttPayloadProvider =
        Provider.of<MqttPayloadProvider>(context, listen: false);
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await fetchData();
    if (_conditionModel.data != null &&
        _conditionModel.data!.conditionProgram != null &&
        _conditionModel.data!.conditionProgram!.isNotEmpty) {
      setState(() {
        conditionList.clear();
        for (var i = 0; i < _conditionModel.data!.condition!.length; i++) {
          conditionList.add(_conditionModel.data!.condition![i].name!);
        }

        // _conditionModel.data!.conditionProgram!.forEach((conditionProgram) {
        //   conditionList.add(conditionProgram.name!);
        // });
      });
    }
  }

  addIntToSF(int val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('checkval', val);
  }

  getIntValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? intValue = prefs.getInt('checkval');
    return intValue;
  }

  Future<void> fetchData() async {
    Map<String, Object> body = {
      "userId": widget.userId,
      "controllerId": widget.controllerId
    };
    print(body);
    final response = await HttpService()
        .postRequest("getUserPlanningConditionLibrary", body);
    if (response.statusCode == 200) {
      setState(() {
        var jsonData1 = jsonDecode(response.body);
        _conditionModel = ConditionModel.fromJson(jsonData1);
        _conditionModel.data!.dropdown!.insert(0, '--Select Category--');
        conditionLibrary = _conditionModel.data!.conditionProgram!;
      });
    } else {
      //_showSnackBar(response.body);
    }
  }

  String conditionselection(String name, String id, String value) {
    print('conditionselection ---> name$name id $id value$value');

    programStr = '';
    zoneStr = '';
    String conditionselectionstr = '';
    if (usedProgramDropDownStr.contains('Program')) {
      var usedprogramdropdownstrarr = usedProgramDropDownStr.split('is');
      conditionselectionstr = '$id is ${usedprogramdropdownstrarr[1]}';
      programStr = id;
    }
    if (usedProgramDropDownStr.contains('Analog Sensor')) {
      var usedprogramdropdownstrarr = usedProgramDropDownStr.split(' is');
      conditionselectionstr =
      '$id is ${usedprogramdropdownstrarr[1]} value $value ';
    }
    if (usedProgramDropDownStr.contains('Contact')) {
      var usedprogramdropdownstrarr = usedProgramDropDownStr.split('is');
      conditionselectionstr = '$name value is $value ';
    }
    if (usedProgramDropDownStr.contains('Water')) {
      var usedprogramdropdownstrarr = usedProgramDropDownStr.split('is');
      conditionselectionstr = '$id is ${usedprogramdropdownstrarr[1]} $value';
    }
    if (usedProgramDropDownStr.contains('Conbined')) {
      var usedprogramdropdownstrarr = usedProgramDropDownStr.split('is');
      conditionselectionstr = '${usedprogramdropdownstrarr[0]} $value';
    }
    if (usedProgramDropDownStr.contains('Zone')) {
      var usedprogramdropdownstrarr = usedProgramDropDownStr.split('is');
      conditionselectionstr = '${usedprogramdropdownstrarr[0]} $value';
      zoneStr = name;
    }
    if (usedProgramDropDownStr.contains('Tank')) {
      if (value.isEmpty) {
        value = "High";
      }
      conditionselectionstr = '${usedProgramDropDownStr} Value is  $value';
      zoneStr = name;
    }
    if (usedProgramDropDownStr.contains('Switch')) {
      var usedprogramdropdownstrarr = usedProgramDropDownStr.split('is');
      conditionselectionstr = '${usedprogramdropdownstrarr[0]} $value';
      zoneStr = name;
    }
    if (usedProgramDropDownStr.contains('Manual Button')) {
      if (value.isEmpty) {
        value = "High";
      }
      var usedprogramdropdownstrarr = usedProgramDropDownStr.split('is');
      conditionselectionstr = '${usedprogramdropdownstrarr[0]} $value';
      zoneStr = name;
    }
    if (usedProgramDropDownStr.contains('Digital Sensor')) {
      if (value.isEmpty) {
        value = "High";
      }
      conditionselectionstr = '$usedProgramDropDownStr is $value';
      zoneStr = name;
    }
    if (usedProgramDropDownStr.contains('Sensor')) {
       conditionselectionstr = '$name $id is $value';
      programStr = id;
    }
    print('conditionselectionstr $conditionselectionstr');
    return conditionselectionstr;
  }

  //add second dropdown list
  void checklistdropdown() async {
    usedProgramDropDownList = [];
    dropDownTitle = '';
    hint = '';

    if (usedProgramDropDownStr.contains('Program')) {
      usedProgramDropDownList = _conditionModel.data!.program;
      dropDownTitle = 'Program';
      hint = 'Programs';
    }
    if (usedProgramDropDownStr.contains('Contact')) {
      usedProgramDropDownList = _conditionModel.data!.contact;
      dropDownTitle = 'Contact';
      hint = 'Contacts';
    }
    if (usedProgramDropDownStr.contains('Level')) {
      usedProgramDropDownList = _conditionModel.data!.levelSensor;
      dropDownTitle = 'Sensor';
      hint = 'Values';
    }
    if (usedProgramDropDownStr.contains('Moisture')) {
      usedProgramDropDownList = _conditionModel.data!.moistureSensor;
      dropDownTitle = 'Sensor';
      hint = 'Values';
    }
    if (usedProgramDropDownStr.contains('Analog')) {
      usedProgramDropDownList = _conditionModel.data!.analogSensor;
      dropDownTitle = 'Sensor';
      hint = 'Values';
    }
    if (usedProgramDropDownStr.contains('Digital')) {
      usedProgramDropDownList = _conditionModel.data!.digitalSensor;
      dropDownTitle = 'Sensor';
      hint = 'Values';
    }
    if (usedProgramDropDownStr.contains('Water')) {
      usedProgramDropDownList = _conditionModel.data!.waterMeter;
      dropDownTitle = 'Water Meter';
      hint = 'Flow';
    }
    if (usedProgramDropDownStr.contains('Conbined')) {
      usedProgramDropDownList = _conditionModel.data!.condition;
      dropDownTitle = 'Expression';
      hint = 'Expression';
    }
    if (usedProgramDropDownStr.contains('Pressure Switch')) {
      usedProgramDropDownList = _conditionModel.data!.pressureSwitch;
      dropDownTitle = 'Pressure values';
      hint = 'values';
    }
    if (usedProgramDropDownStr.contains('Top Tank is High')) {
      print('usedProgramDropDownStr======> $usedProgramDropDownStr');
      usedProgramDropDownList = _conditionModel.data!.topFloathigh;
      dropDownTitle = 'Float values';
      hint = 'values';
    }
    if (usedProgramDropDownStr.contains('Sump Tank is Hig')) {
      print('usedProgramDropDownStr======> $usedProgramDropDownStr');
      usedProgramDropDownList = _conditionModel.data!.sumpFloathigh;
      dropDownTitle = 'Float values';
      hint = 'values';
    }
    if (usedProgramDropDownStr.contains('Top Tank is Low')) {
      print('usedProgramDropDownStr======> $usedProgramDropDownStr');
      usedProgramDropDownList = _conditionModel.data!.topFloatlow;
      dropDownTitle = 'Float values';
      hint = 'values';
    }
    if (usedProgramDropDownStr.contains('Sump Tank is Low')) {
      print('usedProgramDropDownStr======> $usedProgramDropDownStr');
      usedProgramDropDownList = _conditionModel.data!.sumpFloatlow;
      dropDownTitle = 'Float values';
      hint = 'values';
    }
    if (usedProgramDropDownStr.contains('Manual Button')) {
      usedProgramDropDownList = _conditionModel.data!.manualButton;
      dropDownTitle = 'Manual Button';
      hint = 'values';
    }

    if (usedProgramDropDownStr.contains('Zone')) {
      usedProgramDropDownList = _conditionModel.data!.sequence;
      dropDownTitle = 'Zone values';
      hint = 'values';
    }
    if (usedProgramDropDownList!.isNotEmpty) {
      usedProgramDropDownStr2 = usedProgramDropDownStr2 == ''
          ? '${usedProgramDropDownList?[0].name}'
          : usedProgramDropDownStr2;
    }
    // if (usedProgramDropDownList!.isNotEmpty) {
    //   usedProgramDropDownStr3 = usedProgramDropDownStr3 == ''
    //       ? '${usedProgramDropDownList?[0].name}'
    //       : usedProgramDropDownStr3;
    // }
  }

  Widget build(BuildContext context) {
    var overAllPvd = Provider.of<OverAllUse>(context, listen: true);
    mqttPayloadProvider =
        Provider.of<MqttPayloadProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: Color(0xffE6EDF5),
      appBar: widget.isProgram ? AppBar(title: Text("Condition Library"),) : PreferredSize(preferredSize: Size.zero, child: Container()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Expanded(
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: myTheme.primaryColor.withOpacity(0.1),
                            ),
                            child:
                            CupertinoSlidingSegmentedControl<Conditiontype>(
                              children: {
                                Conditiontype.program: Text(
                                  'Program',
                                  style: TextStyle(
                                    color:
                                    selectedSegment == Conditiontype.program
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Conditiontype.moisture: Text(
                                  'Moisture',
                                  style: TextStyle(
                                    color: selectedSegment ==
                                        Conditiontype.moisture
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Conditiontype.level: Text(
                                  'Level',
                                  style: TextStyle(
                                    color:
                                    selectedSegment == Conditiontype.level
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              },
                              groupValue: selectedSegment,
                              onValueChanged: (value) {
                                setState(() {
                                  selectedSegment = value!;
                                  if (selectedSegment ==
                                      Conditiontype.program) {
                                    conditionLibrary =
                                    _conditionModel.data!.conditionProgram!;
                                  } else if (selectedSegment ==
                                      Conditiontype.moisture) {
                                    conditionLibrary = _conditionModel
                                        .data!.conditionMoisture!;
                                  } else {
                                    conditionLibrary =
                                    _conditionModel.data!.conditionLevel!;
                                  }
                                  selectIndexRow = 0;
                                });
                              },
                              thumbColor: myTheme.primaryColor,
                              backgroundColor:
                              myTheme.primaryColor.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Spacer(),
                    ],
                  ),

                  const SizedBox(height: 5),
                  conditionTable(context)
                  //  _currentSelection == 0 ? rain() : buildFrostselection(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myTheme.primaryColorDark,
        foregroundColor: Colors.white,
        onPressed: () async {
          print('applycheck-----------$applycheck');

          if (applycheck == 1) {
            updateconditions();
            // applycheck = 0;
            print('pplycheck 13');
          } else {
           await applychangeclick();
            updateconditions();
            // Widget okButton = TextButton(
            //   child: const Text("OK"),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // );
            //  AlertDialog alert = AlertDialog(
            //   title: const Text("warning"),
            //   content: const Text(
            //       "We are changed conditions also first  Apply changes Again send conditions "),
            //   actions: [
            //     okButton,
            //   ],
            // );
            // showDialog(
            //   context: context,
            //   builder: (BuildContext context) {
            //     return alert;
            //   },
            // );
          }
        },
        tooltip: 'Send',
        child: const Icon(Icons.send),
      ),
    );
    // }
  }

//show table condition
  Widget conditionTable(BuildContext context) {
    var overAllPvd = Provider.of<OverAllUse>(context, listen: true);

    if (_conditionModel.data == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (conditionLibrary!.length <= 0) {
      return Container(
        height: 300,
        width: 300,
        child: const Center(
            child: Text(
              'There are no conditions found',
              style: TextStyle(color: Colors.black, fontSize: 20),
              textAlign: TextAlign.center,
            )),
      );
    } else {
      AfterProgramDropDownList?.clear();
      for (var i = 0; i < _conditionModel.data!.program!.length; i++) {
        AfterProgramDropDownList?.add(
            _conditionModel.data!.program![i].name.toString());
      }
      AfterProgramDropDownList!.insert(0, "");

      return SizedBox(
        height: MediaQuery.of(context).size.height - 150,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: DataTable2(
                  decoration: BoxDecoration(
                    border: Border(),
                    // border: const Border(bottom: BorderSide(color: Colors.black),left: BorderSide(color: Colors.black),right: BorderSide(color: Colors.black)),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  headingRowDecoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  headingRowColor: MaterialStateProperty.all<Color>(
                      primaryColorDark.withOpacity(0.8)),
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 1200,
                  // fixedLeftColumns: 2,
                  columns: [
                    for (int i = 0; i < conditionHdrList.length; i++)
                      i == 0
                          ? DataColumn2(
                        fixedWidth: 50,
                        label: Center(
                            child: Text(
                              conditionHdrList[i].toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              softWrap: true,
                            )),
                      )
                          : i == 2 || i == 7
                          ? DataColumn2(
                        fixedWidth: 60,
                        label: Center(
                            child: Text(
                              conditionHdrList[i].toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              softWrap: true,
                            )),
                      )
                          : i == 3 || i == 5 || i == 6
                          ? DataColumn2(
                        fixedWidth: 80,
                        label: Center(
                            child: Text(
                              conditionHdrList[i].toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              softWrap: true,
                            )),
                      )
                          : DataColumn2(
                        fixedWidth: 200,
                        label: Center(
                            child: Text(
                              conditionHdrList[i].toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              softWrap: true,
                            )),
                      ),
                  ],
                  rows: List<DataRow>.generate(
                      conditionLibrary!.length,
                          (index) => DataRow(
                        color: MaterialStateColor.resolveWith((states) {
                          if (index == selectIndexRow) {
                            return primaryColorDark; // Selected row color
                          }
                          return Colors.white;
                        }),
                        cells: [
                          for (int i = 0; i < conditionHdrList.length; i++)
                            if (conditionHdrList[i] == 'Enable')
                              DataCell(
                                onTap: () {
                                  setState(() {
                                    selectIndexRow = index;
                                  });
                                },
                                Center(
                                  child: Transform.scale(
                                    scale: 0.75,
                                    child: Switch(
                                      value:
                                      conditionLibrary![index].enable ??
                                          false,
                                      onChanged: ((value) {
                                        setState(() {
                                          selectIndexRow = index;
                                          conditionLibrary![index].enable =
                                              value;
                                          print('pplycheck 1');
                                          applycheck = 0;
                                          // sensorProvider.updateapplycheck(0);
                                        });
                                      }),
                                    ),
                                  ),
                                ),
                              )
                            else if (conditionHdrList[i] == 'Notification')
                              DataCell(
                                onTap: () {
                                  setState(() {
                                    selectIndexRow = index;
                                  });
                                },
                                Center(
                                  child: Transform.scale(
                                    scale: 0.75,
                                    child: Switch(
                                      value: conditionLibrary![index]
                                          .notification ??
                                          false,
                                      onChanged: ((value) {
                                        setState(() {
                                          selectIndexRow = index;
                                          conditionLibrary![index]
                                              .notification = value;
                                        });
                                      }),
                                    ),
                                  ),
                                ),
                              )
                            else if (conditionHdrList[i] ==
                                  'conditionBypass')
                                DataCell(
                                  onTap: () {
                                    setState(() {
                                      selectIndexRow = index;
                                    });
                                  },
                                  Center(
                                    child: Transform.scale(
                                      scale: 0.75,
                                      child: Switch(
                                        value: conditionLibrary![index]
                                            .conditionBypass ??
                                            false,
                                        onChanged: ((value) {
                                          setState(() {
                                            selectIndexRow = index;
                                            conditionLibrary![index]
                                                .conditionBypass = value;
                                          });
                                        }),
                                      ),
                                    ),
                                  ),
                                )
                              else if (conditionHdrList[i] == 'Scan Time')
                                  DataCell(onTap: () {
                                    setState(() {
                                      selectIndexRow = index;
                                    });
                                  },
                                      Center(
                                          child: InkWell(
                                            child: Text(
                                              '${conditionLibrary![index].duration}' !=
                                                  ''
                                                  ? '${conditionLibrary![index].duration}'
                                                  : '00:00:00',
                                              style: TextStyle(
                                                  fontSize: _fontSizeLabel(),
                                                  color: index == selectIndexRow
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                            onTap: () async {
                                              selectIndexRow = index;
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: HoursMinutesSeconds(
                                                      initialTime:
                                                      '${conditionLibrary![index].duration}' !=
                                                          ''
                                                          ? '${conditionLibrary![index].duration}'
                                                          : '00:00:00',
                                                      onPressed: () {
                                                        setState(() {
                                                          print('pplycheck 2');
                                                          applycheck = 0;
                                                          // sensorProvider.updateapplycheck(0);
                                                          conditionLibrary![index]
                                                              .duration =
                                                          '${overAllPvd.hrs.toString().padLeft(2, '0')}:${overAllPvd.min.toString().padLeft(2, '0')}:${overAllPvd.sec.toString().padLeft(2, '0')}';
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          )))
                                else if (conditionHdrList[i] == 'Stop Time')
                                    DataCell(onTap: () {
                                      setState(() {
                                        selectIndexRow = index;
                                      });
                                    },
                                        Center(
                                            child: InkWell(
                                              child: Text(
                                                '${conditionLibrary![index].untilTime}' !=
                                                    ''
                                                    ? '${conditionLibrary![index].untilTime == '00:00:00' ? '23:59:59' : conditionLibrary![index].untilTime}'
                                                    : '23:59:59',
                                                style: TextStyle(
                                                    fontSize: _fontSizeLabel(),
                                                    color: index == selectIndexRow
                                                        ? Colors.white
                                                        : Colors.black),
                                              ),
                                              onTap: () async {
                                                selectIndexRow = index;
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: HoursMinutesSeconds(
                                                        initialTime:
                                                        '${conditionLibrary![index].untilTime}' !=
                                                            ''
                                                            ? '${conditionLibrary![index].untilTime == '00:00:00' ? '23:59:59' : conditionLibrary![index].untilTime}'
                                                            : '23:59:59',
                                                        onPressed: () {
                                                          setState(() {
                                                            print('pplycheck 3');
                                                            applycheck = 0;
                                                            // sensorProvider.updateapplycheck(0);
                                                            conditionLibrary![index]
                                                                .untilTime =
                                                            '${overAllPvd.hrs.toString().padLeft(2, '0')}:${overAllPvd.min.toString().padLeft(2, '0')}:${overAllPvd.sec.toString().padLeft(2, '0')}';
                                                          });
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            )))
                                  else if (conditionHdrList[i] == 'Start Time')
                                      DataCell(onTap: () {
                                        setState(() {
                                          selectIndexRow = index;
                                        });
                                      },
                                          Center(
                                              child: InkWell(
                                                child: Text(
                                                  '${conditionLibrary![index].fromTime}' !=
                                                      ''
                                                      ? '${conditionLibrary![index].fromTime}'
                                                      : '00:00:00',
                                                  style: TextStyle(
                                                      fontSize: _fontSizeLabel(),
                                                      color: index == selectIndexRow
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                                onTap: () async {
                                                  selectIndexRow = index;
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: HoursMinutesSeconds(
                                                          initialTime:
                                                          '${conditionLibrary![index].fromTime}' !=
                                                              ''
                                                              ? '${conditionLibrary![index].fromTime}'
                                                              : '00:00:00',
                                                          onPressed: () {
                                                            setState(() {
                                                              print('pplycheck 4');
                                                              applycheck = 0;
                                                              // sensorProvider.updateapplycheck(0);
                                                              conditionLibrary![index]
                                                                  .fromTime =
                                                              '${overAllPvd.hrs.toString().padLeft(2, '0')}:${overAllPvd.min.toString().padLeft(2, '0')}:${overAllPvd.sec.toString().padLeft(2, '0')}';
                                                            });
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              )))
                                    else if (conditionHdrList[i] == 'SNo')
                                        DataCell(onTap: () {
                                          setState(() {
                                            selectIndexRow = index;
                                          });
                                        },
                                            Center(
                                                child: Text(
                                                    snosplit(
                                                        conditionLibrary![index].sNo),
                                                    style: TextStyle(
                                                      color: index == selectIndexRow
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ))))
                                      else if (conditionHdrList[i] == 'ID')
                                          DataCell(onTap: () {
                                            setState(() {
                                              selectIndexRow = index;
                                            });
                                          },
                                              Center(
                                                  child: Text(
                                                      '${conditionLibrary![index].id}',
                                                      style: TextStyle(
                                                        color: index == selectIndexRow
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ))))
                                        else if (conditionHdrList[i] == 'Name')
                                            DataCell(onTap: () {
                                              setState(() {
                                                selectIndexRow = index;
                                              });
                                            },
                                                Center(
                                                    child: Text(
                                                      '${conditionLibrary![index].name}',
                                                      style: TextStyle(
                                                        fontSize: _fontSizeLabel(),
                                                        color: index == selectIndexRow
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                    )))
                                          else if (conditionHdrList[i] ==
                                                'Condition IsTrue')
                                              DataCell(onTap: () {
                                                setState(() {
                                                  print('pplycheck 5');
                                                  applycheck = 0;
                                                  // sensorProvider.updateapplycheck(0);
                                                  selectIndexRow = index;
                                                });
                                              },
                                                  Center(
                                                      child: SingleChildScrollView(
                                                        scrollDirection: Axis.vertical,
                                                        child: Container(
                                                          child: Tooltip(
                                                            message:
                                                            '${conditionLibrary![index].dropdown1}, ${conditionLibrary![index].dropdown2} ,${(conditionLibrary![index].dropdown1!.contains('Analog') == true || conditionLibrary![index].dropdown1!.contains('Program') == true || conditionLibrary![index].dropdown1!.contains('Moisture') == true || conditionLibrary![index].dropdown1!.contains('Level') == true) ? '' : conditionLibrary![index].dropdown3} ${(conditionLibrary![index].dropdown1!.contains('Analog') == true || conditionLibrary![index].dropdown1!.contains('Program') == true || conditionLibrary![index].dropdown1!.contains('Moisture') == true || conditionLibrary![index].dropdown1!.contains('Level') == true || conditionLibrary![index].dropdown1!.contains('Combined') == true) ? conditionLibrary![index].dropdownValue : ''}, ',
                                                            child: Text(
                                                              '${conditionLibrary![index].conditionIsTrueWhen != '' ? conditionLibrary![index].conditionIsTrueWhen!.contains('Combined condition') ? conditionLibrary![index].dropdown1 : conditionLibrary![index].conditionIsTrueWhen : ''}',
                                                              style: TextStyle(
                                                                fontSize: _fontSizeLabel(),
                                                                color: index == selectIndexRow
                                                                    ? Colors.white
                                                                    : Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )))
                                            else
                                              DataCell(onTap: () {
                                                setState(() {
                                                  selectIndexRow = index;
                                                });
                                              },
                                                  Center(
                                                      child: Text(
                                                        '',
                                                        style: TextStyle(
                                                          fontSize: _fontSizeLabel(),
                                                          color: index == selectIndexRow
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      )))
                        ],
                      ))
                // )
              ),
            ),
            SizedBox(
              width: 300,
              child: conditionselectionsidemenu(
                conditionLibrary![selectIndexRow].id,
                selectIndexRow,
              ),
            )
          ],
        ),
      );
    }
  }

  String snosplit(String sno) {
    var csno = sno.split('.');
    return csno[1];
  }

  Widget conditionselectionsidemenu(String? title, int index) {
    final valueController = TextEditingController();
    sensorProvider = Provider.of<ConditionProvider>(context, listen: true);
    changeval();
    String conditiontrue = conditionLibrary![index].conditionIsTrueWhen!;
    // bool containsOnlyNumbers = RegExp(r'^[0-9]+$').hasMatch(dropDownValues);
    valueController.text =
    RegExp(r'^[0-9]+(\.[0-9]+)?$').hasMatch(dropDownValues)
        ? dropDownValues
        : '';
    print('usedProgramDropDownStr------->$usedProgramDropDownStr');
    print('dropDownValues------->$dropDownValues');
    bool containsOnlyOperators =
    RegExp(r'^(&&|\|\||\^) -.*$').hasMatch(dropDownValues);
//dropdownflist is program,contact.... 1-st dropdown
    List<String>? dropdownflist = _conditionModel.data!.dropdown!;

    if (selectedSegment == Conditiontype.program) {
      if (conditionLibrary!.length >= 3) {
        dropdownflist = _conditionModel.data!.dropdown!
            .where(
                (item) => !item.contains("Moisture") && !item.contains("Level"))
            .toList();
      } else {
        dropdownflist = _conditionModel.data!.dropdown!
            .where((item) =>
        !item.contains("Moisture") &&
            !item.contains("Level") &&
            !item.contains("Combined"))
            .toList();
      }
    } else if (selectedSegment == Conditiontype.moisture) {
      if (conditionLibrary!.length >= 3) {
        dropdownflist = _conditionModel.data!.dropdown!
            .where((item) =>
        item.contains("Moisture") || item.contains("Combined"))
            .toList();
      } else {
        dropdownflist = _conditionModel.data!.dropdown!
            .where((item) => item.contains("Moisture"))
            .toList();
      }
      dropdownflist.insert(0, '--Select Category--');
    } else {
      if (conditionLibrary!.length >= 3) {
        // dropdownflist = Moiturelistcombained;
        dropdownflist = _conditionModel.data!.dropdown!
            .where(
                (item) => item.contains("Level") || item.contains("Combined"))
            .toList();
      } else {
        dropdownflist = _conditionModel.data!.dropdown!
            .where((item) => item.contains("Level"))
            .toList();
      }
      dropdownflist.insert(0, '--Select Category--');
    }
    print('final  $dropdownflist');

    if ((usedProgramDropDownStr.contains('Combined') == true)) {
      if (conditionList.contains(usedProgramDropDownStr2)) {
        usedProgramDropDownStr2 = conditionLibrary![index].dropdown2!;
        usedProgramDropDownStr3 = conditionLibrary![index].dropdown3!;
      } else {
        usedProgramDropDownStr2 = "";
        usedProgramDropDownStr3 = "";
      }
    } else {
      List<String> names = usedProgramDropDownList!
          .map((contact) => contact.name as String)
          .toList();
      if (names.contains(usedProgramDropDownStr2)) {
        usedProgramDropDownStr2 = usedProgramDropDownStr2;
      } else {
        if (usedProgramDropDownList!.length > 0) {
          usedProgramDropDownStr2 = '${usedProgramDropDownList![0].name}';
        }
      }
      // usedProgramDropDownStr3 = "";
    }
    if (usedProgramDropDownStr2.isEmpty &&
        usedProgramDropDownList!.isNotEmpty) {
      usedProgramDropDownStr2 = '${usedProgramDropDownList![0].name}';
    }
    String id = findHId(
        '$usedProgramDropDownStr2', _conditionModel.data!.analogSensor!);
    if (conditiontrue.contains("&&")) {
      selectedOperator = "&&";
    } else if (conditiontrue.contains("||")) {
      selectedOperator = "||";
    } else if (conditiontrue.contains("^")) {
      selectedOperator = "^";
    } else {
      selectedOperator = "";
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        decoration: BoxDecoration(
          border: const Border(),
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: primaryColorDark,
              ),
              height: 40,
              width: double.infinity,
              child: Center(
                  child: Text(
                    '$title',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  )),
            ),
            // const Text('When in Used'),
            //First Dropdown values
            DropdownButton(
              items: dropdownflist.map((String? items) {
                return DropdownMenuItem(
                  value: items,
                  child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        items!,
                        style: const TextStyle(fontSize: 12.5),
                      )),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  print('pplycheck 6');
                  // sensorProvider.updateapplycheck(0);
                  applycheck = 0;
                  usedProgramDropDownStr = value.toString();
                  conditionLibrary![selectIndexRow].dropdown1 = value!;
                  checklistdropdown();
                  finddetails(usedProgramDropDownStr, usedProgramDropDownStr2);
                });
              },
              value: usedProgramDropDownStr == '--Select Category--' ||
                  usedProgramDropDownStr == ''
                  ? conditionLibrary![selectIndexRow].dropdown1!.isEmpty
                  ? (_conditionModel.data!.dropdown![0])
                  : conditionLibrary![selectIndexRow].dropdown1!.toString()
                  : usedProgramDropDownStr,
            ),
            if (usedProgramDropDownList?.length != 0) Text(dropDownTitle),
            if (usedProgramDropDownStr.contains('Combined') == false &&
                usedProgramDropDownList?.length != 0 &&
                usedProgramDropDownStr.contains('Manual') == false &&
                usedProgramDropDownStr.contains('Tank') == false)
              DropdownButton(
                hint: const Text(''),
                items: usedProgramDropDownList?.map((UserNames items) {
                  return DropdownMenuItem(
                    value: '${items.name}',
                    child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text('${items.name}')),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    print('pplycheck 7');
                    applycheck = 0;
                    // sensorProvider.updateapplycheck(0);
                    usedProgramDropDownStr2 = value.toString();
                    conditionLibrary![selectIndexRow].dropdown2 =
                        value.toString();

                    var hid = findHId(
                        value.toString(), _conditionModel.data!.analogSensor!);
                    var srno = findSNo(
                        value.toString(), _conditionModel.data!.analogSensor!);
                    finddetails(
                        usedProgramDropDownStr, usedProgramDropDownStr2);
                  });
                },
                value: usedProgramDropDownStr2,
              ),
            if (usedProgramDropDownStr.contains('Manual') == true)
              Column(
                children: [
                  DropdownButton(
                    hint: const Text(''),
                    items: usedProgramDropDownList?.map((UserNames items) {
                      return DropdownMenuItem(
                        value: '${items.name}',
                        child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('${items.name}')),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        print('pplycheck manual $value');
                        applycheck = 0;
                        // sensorProvider.updateapplycheck(0);
                        usedProgramDropDownStr2 = value.toString();
                        conditionLibrary![selectIndexRow].dropdown2 =
                            value.toString();
                        // var hid = findHId(value.toString(),
                        //     _conditionModel.data!.manualButton!);
                        // var srno = findSNo(value.toString(),
                        //     _conditionModel.data!.manualButton!);
                        // finddetails(
                        //     usedProgramDropDownStr, usedProgramDropDownStr2);
                      });
                    },
                    value: usedProgramDropDownStr2,
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: conditionLibrary![selectIndexRow]
                        .dropdown3!
                        .contains('High')
                        ? "High"
                        : conditionLibrary![selectIndexRow]
                        .dropdown3!
                        .contains('Low')
                        ? 'Low'
                        : 'High',
                    onChanged: (value) {
                      setState(() {
                        print('pplycheck manual$value');
                        applycheck = 0;
                        // sensorProvider.updateapplycheck(0);
                        usedProgramDropDownStr3 = value!;
                        conditionLibrary![selectIndexRow].dropdown3 = value;
                      });
                    },
                    items: manualoperatorList.map((operator) {
                      return DropdownMenuItem(
                        value: operator,
                        child: Text(operator),
                      );
                    }).toList(),
                  ),
                ],
              ),
            if (usedProgramDropDownStr.contains('Tank') == true)
              Column(
                children: [
                  DropdownButton(
                    hint: const Text(''),
                    items: usedProgramDropDownList?.map((UserNames items) {
                      return DropdownMenuItem(
                        value: '${items.name}',
                        child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('${items.name}')),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        print('pplycheck manual $value');
                        applycheck = 0;
                        // sensorProvider.updateapplycheck(0);
                        usedProgramDropDownStr2 = value.toString();
                        conditionLibrary![selectIndexRow].dropdown2 =
                            value.toString();
                        // var hid = findHId(value.toString(),
                        //     _conditionModel.data!.manualButton!);
                        // var srno = findSNo(value.toString(),
                        //     _conditionModel.data!.manualButton!);
                        // finddetails(
                        //     usedProgramDropDownStr, usedProgramDropDownStr2);
                      });
                    },
                    value: usedProgramDropDownStr2,
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: conditionLibrary![selectIndexRow]
                        .dropdown3!
                        .contains('High')
                        ? "High"
                        : conditionLibrary![selectIndexRow]
                        .dropdown3!
                        .contains('Low')
                        ? 'Low'
                        : 'High',
                    onChanged: (value) {
                      setState(() {
                        print('pplycheck manual$value');
                        applycheck = 0;
                        // sensorProvider.updateapplycheck(0);
                        usedProgramDropDownStr3 = value!;
                        conditionLibrary![selectIndexRow].dropdown3 = value;
                      });
                    },
                    items: manualoperatorList.map((operator) {
                      return DropdownMenuItem(
                        value: operator,
                        child: Text(operator),
                      );
                    }).toList(),
                  ),
                ],
              ),
            if (usedProgramDropDownStr.contains('Digital'))
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: DropdownButton<String>(
                    value: conditionLibrary![selectIndexRow]
                        .dropdown3!
                        .contains('High')
                        ? "High"
                        : conditionLibrary![selectIndexRow]
                        .dropdown3!
                        .contains('Low')
                        ? 'Low'
                        : 'High',
                    onChanged: (value) {
                      setState(() {
                        print('pplycheck PSP$value');
                        applycheck = 0;
                        // sensorProvider.updateapplycheck(0);
                        usedProgramDropDownStr3 = value!;
                        conditionLibrary![selectIndexRow].dropdown3 = value;
                      });
                    },
                    items: manualoperatorList.map((operator) {
                      return DropdownMenuItem(
                        value: operator,
                        child: Text(operator),
                      );
                    }).toList(),
                  ),
                ),
              ),
            if (usedProgramDropDownStr.contains('Analog') ||
                usedProgramDropDownStr.contains('Moisture') ||
                usedProgramDropDownStr.contains('Level') ||
                usedProgramDropDownStr.contains('Contact') ||
                usedProgramDropDownStr.contains('Water') ||
                usedProgramDropDownStr.contains('Zone'))
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: TextFormField(
                    controller: valueController,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    // initialValue: containsOnlyNumbers ? dropdownvalues : null,
                    showCursor: true,
                    inputFormatters: usedProgramDropDownStr.contains('Sensor')
                        ? [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d{0,3}(\.\d{0,3})?$'))
                    ]
                        : [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    decoration: InputDecoration(
                        hintText: hint, border: const OutlineInputBorder()),
                    onChanged: (value) {
                      // setState(() {
                      print('pplycheck 8');
                      applycheck = 0;
                      // sensorProvider.updateapplycheck(0);
                      dropDownValues = value;
                      conditionLibrary![selectIndexRow].dropdownValue =
                          dropDownValues;
                      // });
                    },
                  ),
                ),
              ),
            if (usedProgramDropDownStr.contains('Combined'))
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  //Dropdown for operator  values
                  child: Column(
                    children: [
                      //Dropdown for Condition 2 values for first condition selections
                      DropdownButton<String>(
                        value: usedProgramDropDownStr2.isEmpty
                            ? null : usedProgramDropDownStr2,
                        hint: Text(usedProgramDropDownStr2.isEmpty
                            ? 'Select an option'
                            : '$usedProgramDropDownStr2',overflow: TextOverflow.ellipsis,maxLines: 1,),
                        onChanged: (value) {
                          setState(() {
                            print('pplycheck 9');
                            applycheck = 0;
                            usedProgramDropDownStr2 = value!;
                            conditionLibrary![selectIndexRow].dropdown2 = value;
                          });
                        },
                        items: filterlist(
                          conditionList,
                          conditionList[selectIndexRow],
                          conditionLibrary![selectIndexRow].dropdown3,
                        ).map((condition) {
                          return DropdownMenuItem<String>(
                            value: condition,
                            child: Container(
                              width: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(condition,
                                      style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                                  Tooltip(
                                    message: conditiondescriptionlistAssign(condition),
                                    child: Text(conditiondescriptionlistAssign(condition),
                                      style: TextStyle(color: Colors.grey),overflow: TextOverflow.ellipsis,
                                      maxLines: 1,softWrap: true,),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: containsOnlyOperators ? dropDownValues : null,
                        hint: const Text('Select Operator'),
                        onChanged: (value) {
                          setState(() {
                            print('pplycheck 10');
                            applycheck = 0;
                            // sensorProvider.updateapplycheck(0);
                            dropDownValues = value!;
                            conditionLibrary![selectIndexRow].dropdownValue =
                                value;
                          });
                        },
                        items: operatorList.map((operator) {
                          return DropdownMenuItem(
                            value: operator,
                            child: Text(operator),
                          );
                        }).toList(),
                      ),
                      const SizedBox(width: 16),
                      //Dropdown for Condition 2 values based on first and second values
                      DropdownButton<String>(
                        value: usedProgramDropDownStr3.isEmpty
                            ? null
                            : usedProgramDropDownStr3,
                        hint: Text(usedProgramDropDownStr3.isEmpty
                            ? 'Select an option'
                            : '$usedProgramDropDownStr3',overflow: TextOverflow.ellipsis,maxLines: 1,),
                        onChanged: (value) {
                          setState(() {
                            print('pplycheck 11');
                            applycheck = 0;
                            // sensorProvider.updateapplycheck(0);
                            usedProgramDropDownStr3 = value!;
                            conditionLibrary![selectIndexRow].dropdown3 = value;
                          });
                        },
                        items: filterlist(
                            conditionList,
                            conditionList[selectIndexRow],
                            conditionLibrary![selectIndexRow].dropdown2)
                            .map((condition) {
                          return DropdownMenuItem(
                            value: condition,
                            child: Container(
                              width: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(condition,
                                      style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                                  Tooltip(
                                    message: conditiondescriptionlistAssign(condition) ,
                                    child: Text(conditiondescriptionlistAssign(condition),
                                        style: TextStyle(color: Colors.grey),overflow: TextOverflow.ellipsis,softWrap: true, maxLines: 1),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                    ],
                  )),
            const SizedBox(
              height: 20,
            ),
            IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(sensorProvider.SensorDetails),
                )),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  print('pplycheck 12');
                  applycheck = 1;
                  // sensorProvider.updateapplycheck(0);
                  applychangeclick();
                },
                child: const Text('Apply Changes'))
          ],
        ),
      ),
    );
  }

  applychangeclick() {
    setState(() {
      finddetails(usedProgramDropDownStr, usedProgramDropDownStr2);
      if (usedProgramDropDownStr.contains('Program')) {
        conditionLibrary![selectIndexRow].conditionIsTrueWhen =
            conditionselection(
                usedProgramDropDownStr, usedProgramDropDownStr2, '');
        conditionLibrary![selectIndexRow].dropdown1 = usedProgramDropDownStr;
        conditionLibrary![selectIndexRow].dropdown2 = usedProgramDropDownStr2;
        // conditionLibrary![Selectindexrow]
        //     .dropdownValue = '';
        conditionLibrary![selectIndexRow].usedByProgram = programStr;

        List<UserNames>? program = _conditionModel.data!.program!;
        String? sNo = getSNoByName(program, usedProgramDropDownStr2);
        if (sNo != null) {
          conditionLibrary![selectIndexRow].program = '$sNo';
        } else {
          conditionLibrary![selectIndexRow].program = '0';
        }
      } else if (usedProgramDropDownStr.contains('Contact')) {
        conditionLibrary![selectIndexRow].conditionIsTrueWhen =
            conditionselection(usedProgramDropDownStr, '', dropDownValues);
        conditionLibrary![selectIndexRow].dropdown1 = usedProgramDropDownStr;
        conditionLibrary![selectIndexRow].dropdown2 = usedProgramDropDownStr2;
        conditionLibrary![selectIndexRow].usedByProgram = '';
        // conditionLibrary![Selectindexrow]
        //     .dropdownValue = dropdownvalues;
        List<UserNames>? program = _conditionModel.data!.contact!;
        String? sNo = getSNoByName(program, usedProgramDropDownStr2);
        if (sNo != null) {
          conditionLibrary![selectIndexRow].program = '$sNo';
        } else {
          conditionLibrary![selectIndexRow].program = '0';
        }
      } else if (usedProgramDropDownStr.contains('Manual')) {
        print(
            'conditionLibrary![selectIndexRow].dropdown3 ${conditionLibrary![selectIndexRow].dropdown3} usedProgramDropDownStr3$usedProgramDropDownStr3 usedProgramDropDownStr $usedProgramDropDownStr usedProgramDropDownStr2 $usedProgramDropDownStr2');
        conditionLibrary![selectIndexRow].conditionIsTrueWhen =
            conditionselection(usedProgramDropDownStr, usedProgramDropDownStr2,
                conditionLibrary![selectIndexRow].dropdown3!);
        conditionLibrary![selectIndexRow].dropdown1 = usedProgramDropDownStr;
        conditionLibrary![selectIndexRow].dropdown2 = usedProgramDropDownStr2;
        conditionLibrary![selectIndexRow].dropdown3 =
        usedProgramDropDownStr3.isEmpty
            ? conditionLibrary![selectIndexRow].dropdown3
            : usedProgramDropDownStr3;

        conditionLibrary![selectIndexRow].dropdown3 =
        conditionLibrary![selectIndexRow].dropdown3!.contains('High')
            ? "High"
            : conditionLibrary![selectIndexRow].dropdown3!.contains('Low')
            ? 'Low'
            : 'High';
        // conditionLibrary![selectIndexRow].dropdown3 = usedProgramDropDownStr3;
        conditionLibrary![selectIndexRow].dropdownValue = '';
        List<UserNames>? program = _conditionModel.data!.manualButton!;
        String? sNo = getSNoByName(program, usedProgramDropDownStr2);
        if (sNo != null) {
          conditionLibrary![selectIndexRow].program = '$sNo';
        } else {
          conditionLibrary![selectIndexRow].program = '0';
        }
      } else if (usedProgramDropDownStr.contains('Analog')) {
        print('usedProgramDropDownStr2 analog --> $usedProgramDropDownStr3');
        String id = findHId(
            '$usedProgramDropDownStr2', _conditionModel.data!.analogSensor!);

        conditionLibrary![selectIndexRow].conditionIsTrueWhen =
            conditionselection(usedProgramDropDownStr, usedProgramDropDownStr2,
                dropDownValues);

        conditionLibrary![selectIndexRow].dropdown1 = usedProgramDropDownStr;
        conditionLibrary![selectIndexRow].dropdown2 = usedProgramDropDownStr2;
        conditionLibrary![selectIndexRow].dropdown3 = '';
        conditionLibrary![selectIndexRow].usedByProgram = '';
        conditionLibrary![selectIndexRow].dropdownValue = dropDownValues;
        // conditionLibrary![Selectindexrow]
        //     .dropdownValue = dropdownvalues;
        List<UserNames>? program = _conditionModel.data!.analogSensor!;
        String? sNo = getSNoByName(program, usedProgramDropDownStr2);
        if (sNo != null) {
          conditionLibrary![selectIndexRow].program = '$sNo';
        } else {
          conditionLibrary![selectIndexRow].program = '0';
        }
      } else if (usedProgramDropDownStr.contains('Digital')) {
        print('usedProgramDropDownStr2 Digital --> $usedProgramDropDownStr3');
        String id = findHId(
            '$usedProgramDropDownStr2', _conditionModel.data!.digitalSensor!);

        conditionLibrary![selectIndexRow].dropdown1 = usedProgramDropDownStr;
        conditionLibrary![selectIndexRow].dropdown2 = usedProgramDropDownStr2;
        conditionLibrary![selectIndexRow].dropdown3 =
        usedProgramDropDownStr3.isEmpty
            ? conditionLibrary![selectIndexRow].dropdown3
            : usedProgramDropDownStr3;

        conditionLibrary![selectIndexRow].dropdown3 =
        conditionLibrary![selectIndexRow].dropdown3!.contains('High')
            ? "High"
            : conditionLibrary![selectIndexRow].dropdown3!.contains('Low')
            ? 'Low'
            : 'High';
        conditionLibrary![selectIndexRow].conditionIsTrueWhen =
            conditionselection(
                usedProgramDropDownStr,
                usedProgramDropDownStr2,
                usedProgramDropDownStr3.isEmpty
                    ? conditionLibrary![selectIndexRow].dropdown3!
                    : usedProgramDropDownStr3);

        conditionLibrary![selectIndexRow].usedByProgram = '';
        conditionLibrary![selectIndexRow].dropdownValue = '';
        List<UserNames>? program = _conditionModel.data!.digitalSensor!;
        String? sNo = getSNoByName(program, usedProgramDropDownStr2);
        if (sNo != null) {
          conditionLibrary![selectIndexRow].program = '$sNo';
        } else {
          conditionLibrary![selectIndexRow].program = '0';
        }
      } else if (usedProgramDropDownStr.contains('Moisture')) {
        conditionLibrary![selectIndexRow].conditionIsTrueWhen =
            conditionselection(usedProgramDropDownStr, usedProgramDropDownStr2,
                dropDownValues);
        conditionLibrary![selectIndexRow].dropdown1 = usedProgramDropDownStr;
        conditionLibrary![selectIndexRow].dropdown2 = usedProgramDropDownStr2;
        conditionLibrary![selectIndexRow].usedByProgram = '';
        // conditionLibrary![Selectindexrow]
        //     .dropdownValue = dropdownvalues;
        List<UserNames>? program = _conditionModel.data!.analogSensor!;
        String? sNo = getSNoByName(program, usedProgramDropDownStr2);
        if (sNo != null) {
          conditionLibrary![selectIndexRow].program = '$sNo';
        } else {
          conditionLibrary![selectIndexRow].program = '0';
        }
      } else if (usedProgramDropDownStr.contains('Level')) {
        conditionLibrary![selectIndexRow].conditionIsTrueWhen =
            conditionselection(usedProgramDropDownStr, usedProgramDropDownStr2,
                dropDownValues);
        conditionLibrary![selectIndexRow].dropdown1 = usedProgramDropDownStr;
        conditionLibrary![selectIndexRow].dropdown2 = usedProgramDropDownStr2;
        conditionLibrary![selectIndexRow].usedByProgram = '';
        // conditionLibrary![Selectindexrow]
        //     .dropdownValue = dropdownvalues;
        List<UserNames>? program = _conditionModel.data!.analogSensor!;
        String? sNo = getSNoByName(program, usedProgramDropDownStr2);
        if (sNo != null) {
          conditionLibrary![selectIndexRow].program = '$sNo';
        } else {
          conditionLibrary![selectIndexRow].program = '0';
        }
      } else if (usedProgramDropDownStr.contains('Water')) {
        conditionLibrary![selectIndexRow].conditionIsTrueWhen =
            usedProgramDropDownStr;
        conditionLibrary![selectIndexRow].dropdown1 = usedProgramDropDownStr;
        conditionLibrary![selectIndexRow].dropdown2 = usedProgramDropDownStr2;
        conditionLibrary![selectIndexRow].usedByProgram = '';
        // conditionLibrary![Selectindexrow]
        //     .dropdownValue = dropdownvalues;
        List<UserNames>? program = _conditionModel.data!.waterMeter!;
        String? sNo = getSNoByName(program, usedProgramDropDownStr2);
        if (sNo != null) {
          conditionLibrary![selectIndexRow].program = '$sNo';
        } else {
          conditionLibrary![selectIndexRow].program = '0';
        }
      } else if (usedProgramDropDownStr.contains('condition')) {




        conditionLibrary![selectIndexRow].conditionIsTrueWhen =
        '$usedProgramDropDownStr $usedProgramDropDownStr2 $dropDownValues $usedProgramDropDownStr3';
        conditionLibrary![selectIndexRow].dropdown1 = usedProgramDropDownStr;
        conditionLibrary![selectIndexRow].dropdown2 = usedProgramDropDownStr2;
        conditionLibrary![selectIndexRow].usedByProgram = '';
        // conditionLibrary![Selectindexrow]
        //     .dropdownValue = dropdownvalues;
        // conditionLibrary![Selectindexrow].program = dropdownvalues;

        List<ConditionLibrary>? program = conditionLibrary;
        if (program != null) {
          String sNo = getSNoByNamecondition(program, usedProgramDropDownStr2);
          if (sNo != null) {
            conditionLibrary![selectIndexRow].program = '$sNo';
          } else {
            conditionLibrary![selectIndexRow].program = '0';
          }
        }
print("usedProgramDropDownStr$usedProgramDropDownStr");
print("usedProgramDropDownStr2$usedProgramDropDownStr2");
        if(usedProgramDropDownStr == '' || usedProgramDropDownStr2 == '')
        {
          conditionLibrary![selectIndexRow].conditionIsTrueWhen = '';
          conditionLibrary![selectIndexRow].dropdown1 = '';
          conditionLibrary![selectIndexRow].dropdown2 = '';
          conditionLibrary![selectIndexRow].program = '0';
          conditionLibrary![selectIndexRow].usedByProgram = '--Select Category--';
        }
      } else if (usedProgramDropDownStr.contains('Zone')) {
        conditionLibrary![selectIndexRow].conditionIsTrueWhen =
            usedProgramDropDownStr;
        conditionLibrary![selectIndexRow].dropdown1 = usedProgramDropDownStr;
        conditionLibrary![selectIndexRow].dropdown2 = usedProgramDropDownStr2;
        conditionLibrary![selectIndexRow].usedByProgram = '';
        // conditionLibrary![Selectindexrow]
        //     .dropdownValue = '';
        conditionLibrary![selectIndexRow].program = '0';
      } else if (usedProgramDropDownStr.contains('Tank')) {
        print(
            'tank dropdown3:$usedProgramDropDownStr3 model:${conditionLibrary![selectIndexRow].dropdown3}');
        conditionLibrary![selectIndexRow].dropdown1 = usedProgramDropDownStr;
        conditionLibrary![selectIndexRow].dropdown2 = usedProgramDropDownStr2;
        conditionLibrary![selectIndexRow].dropdown3 =
        usedProgramDropDownStr3.isEmpty
            ? conditionLibrary![selectIndexRow].dropdown3
            : usedProgramDropDownStr3;
        conditionLibrary![selectIndexRow].dropdown3 =
        conditionLibrary![selectIndexRow].dropdown3!.contains('High')
            ? "High"
            : conditionLibrary![selectIndexRow].dropdown3!.contains('Low')
            ? 'Low'
            : 'High';

        conditionLibrary![selectIndexRow].conditionIsTrueWhen =
            conditionselection(
                usedProgramDropDownStr,
                usedProgramDropDownStr2,
                usedProgramDropDownStr3.isEmpty
                    ? conditionLibrary![selectIndexRow].dropdown3!
                    : usedProgramDropDownStr3);

        conditionLibrary![selectIndexRow].usedByProgram = '';
        // conditionLibrary![Selectindexrow]
        //     .dropdownValue = dropdownvalues;
        List<UserNames>? program = _conditionModel.data!.analogSensor!;
        String? sNo = getSNoByName(program, usedProgramDropDownStr2);
        if (sNo != null) {
          conditionLibrary![selectIndexRow].program = '$sNo';
        } else {
          conditionLibrary![selectIndexRow].program = '0';
        }
      } else if (usedProgramDropDownStr.contains('Switch')) {
        conditionLibrary![selectIndexRow].conditionIsTrueWhen =
            conditionselection(usedProgramDropDownStr, usedProgramDropDownStr2,
                dropDownValues);
        conditionLibrary![selectIndexRow].dropdown1 = usedProgramDropDownStr;
        conditionLibrary![selectIndexRow].dropdown2 = usedProgramDropDownStr2;
        conditionLibrary![selectIndexRow].usedByProgram = '';
        // conditionLibrary![Selectindexrow]
        //     .dropdownValue = dropdownvalues;
        List<UserNames>? program = _conditionModel.data!.analogSensor!;
        String? sNo = getSNoByName(program, usedProgramDropDownStr2);
        if (sNo != null) {
          conditionLibrary![selectIndexRow].program = '$sNo';
        } else {
          conditionLibrary![selectIndexRow].program = '0';
        }
      } else {
        conditionLibrary![selectIndexRow].conditionIsTrueWhen = '';
        conditionLibrary![selectIndexRow].dropdown1 = '';
        conditionLibrary![selectIndexRow].dropdown2 = '';
        // conditionLibrary![Selectindexrow]
        //     .dropdownValue = '';
        conditionLibrary![selectIndexRow].program = '0';
        conditionLibrary![selectIndexRow].usedByProgram = '--Select Category--';
      }
    });
  }

  changeval() {
    usedProgramDropDownStr = conditionLibrary![selectIndexRow].dropdown1!;
    usedProgramDropDownStr2 = conditionLibrary![selectIndexRow].dropdown2!;
    // valueforwhentrue =
    //     conditionLibrary![Selectindexrow].dropdownValue!;
    dropDownValues = conditionLibrary![selectIndexRow].dropdownValue!;
    checklistdropdown();
  }

  List<String> filterlist(
      List<String> conditionlist, String removevalue, String? removevalue2) {
    conditionlist =
        conditionlist.where((item) => item != '$removevalue').toList();
    if (removevalue2!.isNotEmpty) {
      conditionlist =
          conditionlist.where((item) => item != '$removevalue2').toList();
    }
    return conditionlist;
  }

  String conditiondescriptionlistAssign(String conditionlist)
  {
    String desc = '';
    for (var condition in _conditionModel.data!.condition!) {
      if (condition.name == conditionlist) {
        desc = '${condition.conditionIsTrueWhen}';
      }
    }
    return desc;
  }

  updateconditions() async {
    List<Map<String, dynamic>> programJson = _conditionModel
        .data!.conditionProgram!
        .map((condition) => condition.toJson())
        .toList();
    List<Map<String, dynamic>> levelJson = _conditionModel.data!.conditionLevel!
        .map((condition) => condition.toJson())
        .toList();
    List<Map<String, dynamic>> moistureJson = _conditionModel
        .data!.conditionMoisture!
        .map((condition) => condition.toJson())
        .toList();

    // var conditionJson = _conditionModel.data!.conditionLevel.to
    Map<String, dynamic> conditionJo2n = _conditionModel.data!.toJson();
    Map<String, dynamic> finaljson = {
      "program": programJson,
      "moisture": moistureJson,
      "level": levelJson,
      "controllerReadStatus": "0"
    };
    String Mqttsenddata = toMqttFormat(conditionLibrary);
    Map<String, dynamic> payLoadFinal = {
      "1000": [
        {"1001": Mqttsenddata},
      ]
    };
    Map<String, Object> body = {
      "userId": widget.userId,
      "controllerId": widget.controllerId,
      "hardware": payLoadFinal,
      "condition": finaljson,
      "createUser": widget.userId
    };

    if (MQTTManager().isConnected == true) {
      await validatePayloadSent(
          dialogContext: context,
          context: context,
          mqttPayloadProvider: mqttPayloadProvider,
          acknowledgedFunction: () async {
            setState(() {
              finaljson["controllerReadStatus"] = "1";
            });
          },
          payload: payLoadFinal,
          payloadCode: '1000',
          deviceId: widget.imeiNo);
    } else {
      // Map<String, dynamic>
      GlobalSnackBar.show(context, 'MQTT is Disconnected', 201);
    }
    final response = await HttpService()
        .postRequest("createUserPlanningConditionLibrary", body);
    final jsonDataresponse = json.decode(response.body);
    GlobalSnackBar.show(
        context, jsonDataresponse['message'], response.statusCode);
    Future.delayed(Duration(seconds: 1), () async{
      if(widget.isProgram) {
        final irrigationProvider = Provider.of<IrrigationProgramProvider>(context, listen: false);
        await irrigationProvider.getUserProgramCondition(widget.userId, widget.controllerId, widget.serialNumber);
        Navigator.pop(context);
      }
    });
  }

  String? getSNoByName(List<UserNames> data, String name) {
    UserNames? user = data.firstWhere((element) => element.name == name,
        orElse: () => UserNames());
    return user.sNo.toString();
  }

  String getSNoByNamecondition(List<ConditionLibrary>? data, String name) {
    ConditionLibrary user = data!.firstWhere((element) => element.name == name,
        orElse: () => ConditionLibrary());
    return user.sNo;
  }

  String toMqttFormat(
      List<ConditionLibrary>? data,
      ) {
    String mqttData = '';
    String ccheckType = '1.';
    for (var ccheck = 0; ccheck < 3; ccheck++) {
      if (ccheck == 0) {
        ccheckType = '1.';
        data = _conditionModel.data!.conditionProgram!;
      } else if (ccheck == 1) {
        ccheckType = '2.';
        data = _conditionModel.data!.conditionMoisture!;
      } else if (ccheck == 2) {
        ccheckType = '3.';
        data = _conditionModel.data!.conditionLevel!;
      }
      data?.forEach((item) {
        // for (var i = 0; i < data!.length; i++) {
        String enableValue = item.enable! ? '1' : '0';
        String notifigation = item.notification! ? '1' : '0';
        String conditionBypass = item.conditionBypass! ? '1' : '0';
        String conditionIsTrueWhenValue = '0,0,0,0';

        //  TODO:/// 1-program,contact,...,2-running,clossing,opening....,3-which program,contact....,4-values of sensors ----    sno is used to only program and contact and id
        if (item.dropdown1!.contains('Program')) {
          int sno =
          findSNo('${item.dropdown2}', _conditionModel.data!.program!);
          if (item.conditionIsTrueWhen!.contains('not running')) {
            conditionIsTrueWhenValue = "1,$sno,11,0";
          } else if (item.conditionIsTrueWhen!.contains('running')) {
            conditionIsTrueWhenValue = "1,$sno,10,0";
          } else if (item.conditionIsTrueWhen!.contains('starting')) {
            conditionIsTrueWhenValue = "1,$sno,8,0";
          } else if (item.conditionIsTrueWhen!.contains('ending')) {
            conditionIsTrueWhenValue = "1,$sno,9,0";
          } else {
            conditionIsTrueWhenValue = "1,0,1,0";
          }
        } else if (item.dropdown1!.contains('Contact')) {
          String id =
          findHId('${item.dropdown2}', _conditionModel.data!.contact!);
          if (item.dropdown1!.contains('opened')) {
            conditionIsTrueWhenValue = "2,$id,15,${item.dropdownValue}";
          } else if (item.dropdown1!.contains('closed')) {
            conditionIsTrueWhenValue = "2,$id,16,${item.dropdownValue}";
          } else if (item.dropdown1!.contains('opening')) {
            conditionIsTrueWhenValue = "2,$id,17,${item.dropdownValue}";
          } else if (item.dropdown1!.contains('closing')) {
            conditionIsTrueWhenValue = "2,$id,18,${item.dropdownValue}";
          } else {
            conditionIsTrueWhenValue = "2,0,1,0";
          }
        } else if (item.dropdown1!.contains('Zone')) {
          String sno =
          findSNostr('${item.dropdown2}', _conditionModel.data!.sequence!);
          if (item.dropdown1!.contains('low flow than')) {
            conditionIsTrueWhenValue = "3,$sno,14,${item.dropdownValue}";
          } else if (item.dropdown1!.contains('high flow than')) {
            conditionIsTrueWhenValue = "3,$sno,13,${item.dropdownValue}";
          } else if (item.dropdown1!.contains('no flow than')) {
            conditionIsTrueWhenValue = "3,$sno,12,${item.dropdownValue}";
          } else {
            conditionIsTrueWhenValue = "3,0,1,0";
          }
        } else if (item.dropdown1!.contains('Water')) {
          String id =
          findHId('${item.dropdown2}', _conditionModel.data!.waterMeter!);
          if (item.dropdown1!.contains('higher than')) {
            conditionIsTrueWhenValue = "4,$id,4,${item.dropdownValue}";
          } else if (item.dropdown1!.contains('lower than')) {
            conditionIsTrueWhenValue = "4,$id,5,${item.dropdownValue}";
          } else {
            conditionIsTrueWhenValue = "4,0,1,0";
          }
        } else if (item.dropdown1!.contains('Level Sensor')) {
          String id =
          findHId('${item.dropdown2}', _conditionModel.data!.levelSensor!);
          if (item.dropdown1!.contains('higher than')) {
            conditionIsTrueWhenValue = "9,$id,4,${item.dropdownValue}";
          } else if (item.dropdown1!.contains('lower than')) {
            conditionIsTrueWhenValue = "9,$id,5,${item.dropdownValue}";
          } else {
            conditionIsTrueWhenValue = "9,0,1,0";
          }
        } else if (item.dropdown1!.contains('Moisture Sensor')) {
          print(' mos item.dropdownValue ${item.dropdownValue}');
          print('item.dropdown2 ${item.dropdown2}');
          String id = findHId(
              '${item.dropdown2}', _conditionModel.data!.moistureSensor!);
          if (item.dropdown1!.contains('higher than')) {
            conditionIsTrueWhenValue = "8,$id,4,${item.dropdownValue}";
          } else if (item.dropdown1!.contains('lower than')) {
            conditionIsTrueWhenValue = "8,$id,5,${item.dropdownValue}";
          } else {
            conditionIsTrueWhenValue = "8,0,1,0";
          }
          // print('mos conditionIsTrueWhenValue until${item.untilTime}duration${item.duration}from${item.fromTime} $conditionIsTrueWhenValue');
        } else if (item.dropdown1!.contains('Analog Sensor')) {
          print('Analog');
          String id =
          findHId('${item.dropdown2}', _conditionModel.data!.analogSensor!);

          if (item.dropdown1!.contains('higher than')) {
            conditionIsTrueWhenValue = "5,$id,4,${item.dropdownValue}";
          } else if (item.dropdown1!.contains('lower than')) {
            conditionIsTrueWhenValue = "5,$id,5,${item.dropdownValue}";
          } else {
            conditionIsTrueWhenValue = "5,0,1,0";
          }
        } else if (item.dropdown1!.contains('Digital Sensor')) {
          String id = findHId(
              '${item.dropdown2}', _conditionModel.data!.digitalSensor!);
          if (item.dropdown1!.contains('Digital Sensor')) {
            conditionIsTrueWhenValue =
            "5,$id,6,${item.dropdown3 == 'Low' ? '0' : '1'}";
            // } else if (item.dropdown1!.contains('lower than')) {
            //   conditionIsTrueWhenValue = "5,$id,6,${item.dropdown3 == 'Low' ? '0' : '1'}";
          } else {
            conditionIsTrueWhenValue = "5,0,1,0";
          }
        } else if (item.dropdown1!.contains('Manual')) {
          String id =
          findHId('${item.dropdown2}', _conditionModel.data!.manualButton!);
          print("manual $id");
          if (item.conditionIsTrueWhen!.contains('High')) {
            conditionIsTrueWhenValue = "5,$id,6,1";
          } else if (item.conditionIsTrueWhen!.contains('Low')) {
            conditionIsTrueWhenValue = "5,$id,6,0";
          } else {
            conditionIsTrueWhenValue = "5,0,1,0";
          }
          print('id$id');
        } else if (item.dropdown1!.contains('Tank is ')) {
          String id =
          findHId('${item.dropdown2}', _conditionModel.data!.float!);
          if (item.dropdown1!.contains('Top Tank is High')) {
            conditionIsTrueWhenValue =
            "5,$id,6,${item.dropdown3 == 'Low' ? '0' : '1'}";
          } else if (item.dropdown1!.contains('Top Tank is Low')) {
            conditionIsTrueWhenValue =
            "5,$id,6,${item.dropdown3 == 'Low' ? '0' : '1'}";
          } else if (item.dropdown1!.contains('Sump Tank is High')) {
            conditionIsTrueWhenValue =
            "5,$id,6,${item.dropdown3 == 'Low' ? '0' : '1'}";
          } else if (item.dropdown1!.contains('Sump Tank is Low')) {
            conditionIsTrueWhenValue =
            "5,$id,6,${item.dropdown3 == 'Low' ? '0' : '1'}";
          } else {
            conditionIsTrueWhenValue = "5,0,6,0";
          }
        }
        //  Combine =
        else if (item.dropdown1!.contains('condition'))
        {
          String sno1 =
          findSNostr('${item.dropdown2}', _conditionModel.data!.condition!);
          String sno2 =
          findSNostr('${item.dropdown3}', _conditionModel.data!.condition!);

          String operator = item.dropdownValue!;
          if (operator.contains("&&")) {
            operator = "1";
          } else if (operator.contains("||")) {
            operator = "2";
          } else if (operator.contains("^")) {
            operator = "3";

            ///Future
          } else if (operator == "=<") {
            operator = "4";
          } else if (operator == ">=") {
            operator = "5";
          } else if (operator == "==") {
            operator = "6";
          } else if (operator == "!=") {
            operator = "7";
          } else {
            operator = "0";
          }

          if (item.dropdown1!.contains('Combined condition is true')) {
            conditionIsTrueWhenValue = "6,$sno1,$operator,$sno2";
          }
          else if (item.dropdown1!.contains('Combined condition is false'))
          {
            if(operator == "1")
            {
              operator = "2";
            }
            else if(operator == "2")
            {
              operator = "1";
            }
            conditionIsTrueWhenValue = "7,$sno1,$operator,$sno2";
          }
          else {
            conditionIsTrueWhenValue = "5,0,1,0";
          }
          print('conditionIsTrueWhenValue--${item.name}---$conditionIsTrueWhenValue');
        } else {
          conditionIsTrueWhenValue = ",,,";
        }

       enableValue == '1' ? mqttData +=
          '${item.sNo},${item.name},$enableValue,${item.duration},${item.fromTime},${item.untilTime == "00:00:00" ? "23:59:59" : item.untilTime},$notifigation,$conditionIsTrueWhenValue,$conditionBypass,${item.conditionIsTrueWhen?.contains('Combined') == true ? '${item.dropdown1}  ${item.dropdown2} ${item.dropdownValue} ${item.dropdown3}' : item.conditionIsTrueWhen};' : '';



      });
    }
    print("Mqtt Data -------> $mqttData");
    return mqttData;
  }

  double? _fontSizeLabel() {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double fontSize = (screenWidth / 100) + 3;
    return 11.5;
  }

  String findSNostr(String searchString, List<UserNames> waterMeters) {
    for (var waterMeter in waterMeters) {
      if (waterMeter.name == searchString) {
        return waterMeter.sNo;
      }
    }
    return '0';
  }

  int findSNo(String searchString, List<UserNames> waterMeters) {
    for (var waterMeter in waterMeters) {
      if (waterMeter.name == searchString) {
        return waterMeter.sNo;
      }
    }
    return 0;
  }

  String findHId(String searchString, List<UserNames> waterMeters) {
    for (var waterMeter in waterMeters) {
      if (waterMeter.name == searchString) {
        return waterMeter.hid!;
      }
    }
    return '';
  }

  finddetails(
      String searchString,
      String sensorsstr,
      ) {
    String details = '';
    sensorProvider = Provider.of<ConditionProvider>(context, listen: false);
    late List<UserNames> waterMeters;
    late String typestring;
    if (searchString.contains('Water meter')) {
      typestring = 'Water meter';
      waterMeters = _conditionModel.data!.waterMeter!;
    } else if (searchString.contains('Zone')) {
      typestring = 'Sequence';
      waterMeters = _conditionModel.data!.sequence!;
    } else if (searchString.contains('Analog Sensor')) {
      typestring = 'Analog Sensor';
      waterMeters = _conditionModel.data!.analogSensor!;
    } else if (searchString.contains('Digital Sensor')) {
      typestring = 'Digital Sensor';
      waterMeters = _conditionModel.data!.digitalSensor!;
    } else if (searchString.contains('Moisture Sensor')) {
      typestring = 'Moisture Sensor';
      waterMeters = _conditionModel.data!.moistureSensor!;
    } else if (searchString.contains('Level Sensor')) {
      typestring = 'Level Sensor';
      waterMeters = _conditionModel.data!.levelSensor!;
    } else if (searchString.contains('Pressure Switch')) {
      typestring = 'Pressure Switch';
      waterMeters = _conditionModel.data!.pressureSwitch!;
    } else if (searchString.contains('Top Tank is High')) {
      typestring = 'Top Tank Float';
      waterMeters = _conditionModel.data!.topFloathigh!;
    } else if (searchString.contains('Sump Tank is High')) {
      typestring = 'Sump Tank Float';
      waterMeters = _conditionModel.data!.sumpFloathigh!;
    } else if (searchString.contains('Top Tank is Low')) {
      typestring = 'Top Tank Float';
      waterMeters = _conditionModel.data!.topFloatlow!;
    } else if (searchString.contains('Sump Tank is Low')) {
      typestring = 'Sump Tank Float';
      waterMeters = _conditionModel.data!.sumpFloatlow!;
    } else if (searchString.contains('Manual Button')) {
      typestring = 'Manual Button';
      waterMeters = _conditionModel.data!.manualButton!;
    } else {
      typestring = '';
      waterMeters = [];
    }
    // print('waterMeters--test--->${waterMeters.map((e) => print(e.toJson()))}');
    if (typestring != '' && typestring != 'Manual Button') {
      for (var waterMeter in waterMeters) {
        if (waterMeter.name == sensorsstr) {
          List<dynamic> irrigationLine = waterMeter.irrigationLine ?? ['', ''];
          String irrigationLinestring = irrigationLine.join(' , ');
          details =
          'This $typestring used for ${waterMeter.locationName ?? ''}, $irrigationLinestring';
          if (typestring == 'Sequence') {
            var zonepo = waterMeter.id!.split('.');
            details =
            'This $typestring used for ${waterMeter.locationName} in ${zonepo[1]}  Sequence';
          } else if (typestring == 'Digital Sensor' ||
              typestring == 'Analog Sensor') {
            details = 'This $typestring used for ${waterMeter.locationName}';
          }
        }
      }
    } else {
      details = '';
    }
    // sensorProvider.updateSensorData('');
    //  details = '';
    print('finddetailsvalue is $details');
    sensorProvider.updateSensorData(details);
  }

  Printfunc(dynamic Message) {
    print('Printfunc $Message');
  }

  String findId(String searchString, List<UserNames> waterMeters) {
    for (var waterMeter in waterMeters) {
      if (waterMeter.name == searchString) {
        return waterMeter.id!;
      }
    }
    return '';
  }
}