import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../Models/Customer/alarmlog_model.dart';
import '../../../constants/http_service.dart';
import '../../../constants/theme.dart';
import '../../../widgets/FontSizeUtils.dart';

class AlarmLog extends StatefulWidget {
  const AlarmLog(
      {Key? key,
        required this.userId,
        required this.controllerId,
        required this.deviceID});
  final userId, controllerId, deviceID;

  @override
  State<AlarmLog> createState() => _AlarmLogTableState();
}





class _AlarmLogTableState extends State<AlarmLog> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  AlertLogModel _alertLogModel = AlertLogModel();
  // var json = {
  //   "code": 200,
  //   "message": "User planning Alarm Log listed successfully",
  //   "data":
  //   [
  //     {
  //       "S_No": 1,
  //       "Location": "",
  //       "Date": "2024-01-11",
  //       "Time": "12:00 PM",
  //       "Type": "Alert",
  //       "Issue": "HighFlow",
  //       "ObjectName": "IW.1",
  //       "Program": "Program1",
  //       "Status": "critical",
  //       "Message": "",
  //       "ResetBy": "",
  //       "ResetDate": "",
  //       "ResetTime": ""
  //     },
  //     {
  //       "S_No": 2,
  //       "Location": "",
  //       "Date": "2024-01-12",
  //       "Time": "12:00 PM",
  //       "Type": "Alert",
  //       "Issue": "Low Flow",
  //       "ObjectName": "IW.2",
  //       "Program": "Program1",
  //       "Status": "warning",
  //       "Message": "",
  //       "ResetBy": "",
  //       "ResetDate": "",
  //       "ResetTime": ""
  //     }
  //   ]
  // };

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await fetchData();
   }

  Future<void> fetchData() async {
    Map<String, Object> body = {
      "userId":  widget.userId,
      "controllerId": widget.controllerId,
      // "userId": 15,
      // "controllerId": 1,
      "fromDate": '${_formatDate(fromDate)}',
      "toDate":'${(toDate)}',
    };
     final response = await HttpService()
        .postRequest("getUserAlarmLog", body);
    if (response.statusCode == 200) {
      setState(() {
        var jsondata1 = jsonDecode(response.body);
         _alertLogModel = AlertLogModel.fromJson(jsondata1);
       });
    } else {
      //_showSnackBar(response.body);
    }

  }

  @override
  Widget build(BuildContext context) {
    // List Colorlist1 = [
    //   'critical',
    //   'critical',
    //   'normal',
    //   'critical',
    //   'not issue',
    //   'normal',
    //   'critical',
    //   'critical',
    //   'warning',
    //   'warning'
    // ];
    if (_alertLogModel.data == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (_alertLogModel.data!.isEmpty) {
      return const Center(
          child: Text(
              'Currently No one Alarm Logs'));
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                ),
                Text('From Date: '),
                SizedBox(
                  width: 50,
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text('${_formatDate(fromDate)}'),
                ),
                SizedBox(
                  width: 100,
                ),
                Text('To Date: '),
                SizedBox(
                  width: 50,
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text('${_formatDate(toDate)}'),
                ),
                SizedBox(
                  width: 100,
                ),
                ElevatedButton(
                  onPressed: () => {  initializeData(),
                    _showSnackBar('Get data send request')
        },
                  child: Text('Get Log'),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height - 200,
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: DataTable2(
                    headingRowColor: MaterialStateProperty.all<Color>(
                        primaryColorDark.withOpacity(0.7)),
                    fixedCornerColor: myTheme.primaryColor,
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: 600,
                    border: TableBorder.all(width: 0.02),
                    columns: [
                      DataColumn2(
                          fixedWidth: 50,
                          label: Center(
                            child: Text(
                              'Sno',
                              style: TextStyle(
                                  fontSize: FontSizeUtils.fontSizeHeading(
                                      context) ??
                                      16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              softWrap: true,
                            ),
                          )),
                      DataColumn2(
                          fixedWidth: 100,
                          label: Center(
                            child: Text(
                              'Date',
                              style: TextStyle(
                                  fontSize: FontSizeUtils.fontSizeHeading(
                                      context) ??
                                      16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              softWrap: true,
                            ),
                          )),
                      DataColumn2(
                          fixedWidth: 100,
                          label: Center(
                            child: Text(
                              'Time',
                              style: TextStyle(
                                  fontSize: FontSizeUtils.fontSizeHeading(
                                      context) ??
                                      16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              softWrap: true,
                            ),
                          )),
                      DataColumn2(
                          fixedWidth: 100,
                          label: Center(
                            child: Text(
                              'Type',
                              style: TextStyle(
                                  fontSize: FontSizeUtils.fontSizeHeading(
                                      context) ??
                                      16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              softWrap: true,
                            ),
                          )),
                      DataColumn2(
                          fixedWidth: 100,
                          label: Center(
                            child: Text(
                              'Issue',
                              style: TextStyle(
                                  fontSize: FontSizeUtils.fontSizeHeading(
                                      context) ??
                                      16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              softWrap: true,
                            ),
                          )),
                      DataColumn2(
                          label: Center(
                            child: Text(
                              'Device',
                              style: TextStyle(
                                  fontSize:
                                  FontSizeUtils.fontSizeHeading(context) ??
                                      16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              softWrap: true,
                            ),
                          )),
                      DataColumn2(
                          label: Center(
                            child: Text(
                              'Location',
                              style: TextStyle(
                                  fontSize:
                                  FontSizeUtils.fontSizeHeading(context) ??
                                      16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              softWrap: true,
                            ),
                          )),
                      DataColumn2(
                          fixedWidth: 60,
                          label: Center(
                            child: Text(
                              'Status',
                              style: TextStyle(
                                  fontSize: FontSizeUtils.fontSizeHeading(
                                      context) ??
                                      16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              softWrap: true,
                            ),
                          )),
                      DataColumn2(
                          fixedWidth: 100,
                          label: Center(
                            child: Text(
                              'Program',
                              style: TextStyle(
                                  fontSize: FontSizeUtils.fontSizeHeading(
                                      context) ??
                                      16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              softWrap: true,
                            ),
                          )),
                      DataColumn2(
                          fixedWidth: 100,
                          label: Center(
                            child: Text(
                              'Reset By',
                              style: TextStyle(
                                  fontSize: FontSizeUtils.fontSizeHeading(
                                      context) ??
                                      16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              softWrap: true,
                            ),
                          )),
                      DataColumn2(
                          fixedWidth: 100,
                          label: Center(
                            child: Text(
                              'Date',
                              style: TextStyle(
                                  fontSize: FontSizeUtils.fontSizeHeading(
                                      context) ??
                                      16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              softWrap: true,
                            ),
                          )),
                      DataColumn2(
                          fixedWidth: 100,
                          label: Center(
                            child: Text(
                              'Time',
                              style: TextStyle(
                                  fontSize: FontSizeUtils.fontSizeHeading(
                                      context) ??
                                      16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              softWrap: true,
                            ),
                          )),
                      DataColumn2(
                          size: ColumnSize.L,
                          label: Center(
                            child: Text(
                              'Message',
                              style: TextStyle(
                                  fontSize: FontSizeUtils.fontSizeHeading(
                                      context) ??
                                      16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              softWrap: true,
                            ),
                          )),
                    ],
                    rows: List<DataRow>.generate(
                        _alertLogModel.data!.length,
                            (index) =>
                            DataRow(
                              // color: MaterialStateColor.resolveWith((states) {
                              //   return getStatusColor(Colorlist[index]).withOpacity(0.2);
                              // }),
                              color: MaterialStateColor.resolveWith((states) {
                                return Colors.white70;
                              }),
                              cells: [
                                DataCell(Center(child: Text('${_alertLogModel
                                    .data![index].sNo}'))),
                                DataCell(Center(child: Text('${_alertLogModel
                                    .data![index].date}'))),
                                DataCell(Center(child: Text('${_alertLogModel
                                    .data![index].time}'))),
                                DataCell(Center(child: Text('${_alertLogModel
                                    .data![index].type}'))),
                                DataCell(Center(child: Text('${_alertLogModel
                                    .data![index].issue}'))),
                                DataCell(Center(child: Text('${_alertLogModel
                                    .data![index].objectName}'))),
                                DataCell(Center(child: Text('${_alertLogModel
                                    .data![index].location}'))),
                                DataCell(Padding(padding: EdgeInsets.all(12.0),
                                  child: Center(child: CircleAvatar(
                                    backgroundColor:
                                    getStatusColor(
                                        '${_alertLogModel.data![index]
                                            .status}'),
                                  )),)),
                                DataCell(Center(child: Text('${_alertLogModel
                                    .data![index].program}'))),
                                DataCell(Center(child: Text('${_alertLogModel
                                    .data![index].resetBy}'))),
                                DataCell(Center(child: Text('${_alertLogModel
                                    .data![index].resetDate}'))),
                                DataCell(Center(child: Text('${_alertLogModel
                                    .data![index].resetTime}'))),
                                DataCell(Center(child: Text('${_alertLogModel
                                    .data![index].message}'))),
                              ],
                            )))),
          ],
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? fromDate : toDate,
      firstDate:
          isFromDate ? DateTime.now().subtract(Duration(days: 365)) : fromDate,
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != (isFromDate ? fromDate : toDate)) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'normal':
        return Colors.orange;
      case 'warning':
        return Colors.yellow;
      case 'Active':
        return Colors.green;
      default:
        return Colors.red;
    }
  }
}
