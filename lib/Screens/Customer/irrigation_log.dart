import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:intl/intl.dart';

import 'dart:html' if (dart.library.html) 'dart:html' as html;

import '../../constants/http_service.dart';
import '../../state_management/irrigation_program_main_provider.dart';
import '../../state_management/schedule_view_provider.dart';
import '../../widgets/SCustomWidgets/custom_date_range_picker.dart';

class IrrigationLogScreen extends StatefulWidget {
  final int userId;
  final int controllerId;
  const IrrigationLogScreen({super.key, required this.userId, required this.controllerId});

  @override
  State<IrrigationLogScreen> createState() => _IrrigationLogScreenState();
}

class _IrrigationLogScreenState extends State<IrrigationLogScreen> {
  final HttpService httpService = HttpService();
  bool get isWeb => identical(0, 0.0);
  late dynamic data;
  bool isCompleted = false;
  bool isInCompleted = false;
  late DateTime fromDate;
  late DateTime toDate;
  String message = '';
  final dateFormatToServer = DateFormat('yyyy-MM-dd');
  final dateFormatForUser = DateFormat('dd-MM-yyyy');
  @override
  void initState() {
    fromDate = DateTime.now();
    toDate = DateTime.now();
    data = [];
    // TODO: implement initState
    getUserControllerLog();
    super.initState();
  }

  Future<void> getUserControllerLog() async {
    final userDetails = {
      "userId": widget.userId,
      "controllerId": widget.controllerId,
      "logType": "Irrigation",
      "fromDate": dateFormatToServer.format(fromDate),
      "toDate": dateFormatToServer.format(toDate),
    };
    try {
      final userIrrigationLog = await httpService.postRequest("getUserControllerLog", userDetails);
      final convertedJson = jsonDecode(userIrrigationLog.body);
      // print(convertedJson);
      setState(() {
        data = convertedJson["data"];
        message = convertedJson["message"];
      });
    } catch(e) {
      print("Error: $e");
    }
  }

  double columnWidth(index) {
    double width = 0;
    switch(index) {
      case 0:
        width = 5;
        break;
      case 1:
        width = 15;
        break;
      case 2:
        width = 15;
        break;
      case 3:
        width = 20;
        break;
      case 4:
        width = 20;
        break;
      case 5:
        width = 15;
        break;
      case 6:
        width = 15;
        break;
      case 7:
        width = 20;
        break;
      case 8:
        width = 10;
        break;
      case 9:
        width = 20;
        break;
    }
    return width;
  }

  Future<void> exportToExcel() async {
    Excel excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Add header row
    List<String> headerRow = [
      'S.No',
      'Controller Date',
      'Controller Time',
      'Program Name',
      'Zone Name',
      'Start Time',
      'Duration',
      'Valves',
      'Cycle No',
      'Status',
    ];

    sheetObject.appendRow(headerRow.map((cell) => TextCellValue(cell)).toList());

    for (var i = 0; i < headerRow.length; i++) {
      sheetObject.setColumnWidth(i, columnWidth(i));
    }

    for (var entry in data) {
      List<String> controllerData = [
        entry['controllerDate'],
        entry['controllerTime'],
      ];

      List<dynamic> irrigationList = entry['irrigation'];

      for (var irrigation in irrigationList) {
        List<String> rowData = [
          irrigation['S_No'].toString(),
          dateFormatForUser.format(DateTime.parse(controllerData[0])),
          controllerData[1],
          irrigation['ProgramName'],
          irrigation['ZoneName'],
          irrigation['ScheduledStartTime'],
          irrigation['IrrigationDuration_Quantity'],
          irrigation['SequenceData'].split('+').join(', '),
          irrigation['CycleNumber'].toString(),
          ScheduleViewProvider().getStatusInfo(irrigation['Status'].toString()).statusString,
        ];

        sheetObject.appendRow(rowData.map((cell) => TextCellValue(cell)).toList());
      }
    }

    if (foundation.kIsWeb) {
      // Save the Excel file for web
      List<int> excelData = excel.encode()!;
      Uint8List uint8ListData = Uint8List.fromList(excelData);
      final blob = html.Blob([uint8ListData]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = 'IrrigationLog ${DateTime.now()}.xlsx'
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String filePath = '$appDocPath/IrrigationLog ${DateTime.now()}.xlsx';

      List<int> excelData = excel.encode()!;

      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(excelData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Scaffold(
              /*appBar: AppBar(
                title: const Text('Irrigation Log'),
              ),*/
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            DateRangePickerField(
                                startDate: fromDate,
                                onChanged: (start, end){
                                  Future.delayed(Duration.zero,() {
                                    setState(() {
                                      fromDate = start;
                                      toDate = end;
                                    });
                                  }).then((value) {
                                    getUserControllerLog();
                                  });
                                  // print("fromDate --> $fromDate \n toDate --> $toDate");
                                },
                                endDate: toDate
                            ),
                            const SizedBox(width: 10,),
                            _materialButton(
                                "Completed",
                                isCompleted ? Theme.of(context).colorScheme.secondary: Colors.white.withOpacity(0.8),
                                Icons.done,
                                    (){
                                  setState(() {
                                    isCompleted = !isCompleted;
                                    isInCompleted = false;
                                  });
                                }, data != null),
                            const SizedBox(width: 10,),
                            _materialButton(
                                "In completed",
                                isInCompleted ? Theme.of(context).colorScheme.secondary: Colors.white.withOpacity(0.8),
                                Icons.incomplete_circle,
                                    (){
                                  setState(() {
                                    isInCompleted = !isInCompleted;
                                    isCompleted = false;
                                  });
                                }, data != null),
                          ],
                        ),
                        Row(
                          children: [
                            _materialButton("Export", Theme.of(context).colorScheme.secondary, Icons.download, exportToExcel, data != null),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5,),
                  data != null
                      ? Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          List<dynamic> irrigationList = data[index]["irrigation"];
                          if(isCompleted) {
                            irrigationList = irrigationList.where((item) => item['Status'] == 2).toList();
                          } else if(isInCompleted) {
                            irrigationList = irrigationList.where((item) => item['Status'] != 2).toList();
                          } else {
                            irrigationList = data[index]["irrigation"];
                          }

                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            surfaceTintColor: Colors.white,
                            elevation: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text('Controller Date: ${dateFormatForUser.format(DateTime.parse(data[index]["controllerDate"]))}'),
                                  subtitle: Text('Controller Time: ${data[index]["controllerTime"]}', style: const TextStyle(fontSize: 12),),
                                ),
                                Divider(color: Theme.of(context).primaryColor, thickness: 0.3,),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: [
                                      _buildHeaderItem("S.NO", flex: 1),
                                      _buildHeaderItem("PROGRAM NAME", flex: 1),
                                      _buildHeaderItem("ZONE NAME", flex: 1),
                                      _buildHeaderItem("START TIME", flex: 1),
                                      _buildHeaderItem("PLANNED", flex: 1),
                                      _buildHeaderItem("VALVES", flex: 1),
                                      _buildHeaderItem("CYCLE NO.", flex: 1),
                                      _buildHeaderItem("STATUS", flex: 1),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    ...irrigationList.map((item){
                                      return Row(
                                        children: [
                                          _buildDataItem("${item["S_No"]}", null),
                                          _buildDataItem("${item["ProgramName"]}", null),
                                          _buildDataItem("${item["ZoneName"]}", null),
                                          _buildDataItem(item["ScheduledStartTime"], null),
                                          _buildDataItem("${item["IrrigationDuration_Quantity"]}", null),
                                          _buildDataItem("${item["SequenceData"].split('+').join(', ')}", null),
                                          _buildDataItem("${item["CycleNumber"]}", null),
                                          _buildDataItem(
                                              "",
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: ScheduleViewProvider().getStatusInfo(item['Status'].toString()).color.withOpacity(0.5),
                                                    borderRadius: BorderRadius.circular(8)
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    ScheduleViewProvider().getStatusInfo(item['Status'].toString()).statusString,
                                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              )
                                          ),
                                        ],
                                      );
                                    })
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      )
                  )
                      : Center(child: Text(message, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),)
                ],
              )
          );
        });
  }

  Widget _materialButton(String text, Color color, IconData? icon, void Function() onPressed, disable) {
    return MaterialButton(
      onPressed: disable ? onPressed : null,
      color: color,
      splashColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      child: icon == null ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text),
      ) : Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Text(text),
            const SizedBox(width: 5,),
            Icon(icon)
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderItem(String text, {int flex = 1  }) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }

  Widget _buildDataItem(String text, Widget? child, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: text != ""
              ? Text(
            text,
            textAlign: TextAlign.center,
          )
              : child,
        ),
      ),
    );
  }
}
