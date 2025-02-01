import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:oro_irrigation_new/Models/bug_report_model.dart';
import 'package:oro_irrigation_new/constants/http_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:universal_html/js_util.dart';

import '../../constants/theme.dart';
import '../Customer/Dashboard/sevicecustomer.dart';
import '../Customer/IrrigationProgram/irrigation_program_main.dart';

class Bugreport extends StatefulWidget {
  const Bugreport({super.key});

  @override
  State<Bugreport> createState() => _BugreportState();
}

class _BugreportState extends State<Bugreport> {
  late List<BugReportModel> bugReportModel;
  bool _isLoading = true;
  bool _onError = false;
  String _errorMessage = '';
  DateTime date = DateTime.now();
  final List<String> statusList = [
    'Pending',
    'Completed'
  ];

  Set<String> selectedCustomerName = {'All'};
  Set<String> selectedStatus = {'All'};
  Set<String> selectedErrorName = {'All'};
  Set<String> selectedDateTime = {'All'};

  int selectedColumn = 0;
  bool isToday = false;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bugReportModel = [];
    if(mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getHardwareError();
      });
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> getHardwareError() async{
    try {
      Map<String, dynamic> userData = {
        "fromDate": DateFormat('yyyy-MM-dd').format(date),
        "toDate": DateFormat('yyyy-MM-dd').format(date),
      };
      final response = await HttpService().postRequest('getHardwareError', userData);
      if(response.statusCode == 200) {
        final result = jsonDecode(response.body);
        try {
          setState(() {
            _isLoading = false;
            _onError = false;
            bugReportModel = List.from(result['data'].map((json) => BugReportModel.fromJson(json)));
            selectedCustomerName.addAll({...bugReportModel.map((e) => e.userName)});
            selectedStatus.addAll({...bugReportModel.map((e) => e.status)});
            selectedErrorName.addAll({...bugReportModel.map((e) => e.errorName)});
            selectedDateTime.addAll({...bugReportModel.map((e) => e.controllerDate)});
            // bugReportModel = bugReportSampleData.map((e) => BugReportModel.fromJson(e)).toList();
          });
        } catch(error, stackTrace) {
          setState(() {
            _onError = true;
            _isLoading = false;
            _errorMessage = '$error';
          });
          print('error while parsing bugReportModel: $error');
          print('stackTrace while parsing bugReportModel: $stackTrace');
        }
      }
    } catch(error, stackTrace) {
      setState(() {
        _onError = true;
        _isLoading = false;
        _errorMessage = '$error';
      });
      print('error: $error');
      print('stackTrace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController tableScrollController = ScrollController();
    var filteredData = bugReportModel.where((row) {
      final matchesCustomerName = selectedCustomerName.contains('All') || selectedCustomerName.contains(row.userName);
      final matchesStatus = selectedStatus.contains('All') || selectedStatus.contains(row.status);
      final matchesErrorName = selectedErrorName.contains('All') || selectedErrorName.contains(row.errorName);
      final matchesDateTime = selectedDateTime.contains('All') || selectedDateTime.contains(row.controllerDate);

      return matchesCustomerName && matchesStatus && matchesErrorName && matchesDateTime;
    }).toList();

    List<String> customerNameOptions = ['All',...{...bugReportModel.map((e) => e.userName)}];
    List<String> errorNameOptions = ['All', ...{...bugReportModel.map((e) => e.errorName)}];
    List<String> dateTimeOptions = ['All', ...{...bugReportModel.map((e) => e.controllerDate)}];
    List<String> statusOptions = ['All', ...{...bugReportModel.map((e) => e.status)}];

    return Scaffold(
      appBar: AppBar(title: const Text('Bug Report'),),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        // boxShadow: customBoxShadow,
                       /* gradient: const LinearGradient(
                          colors: [
                            Color(0xff1C7C8A),
                            Color(0xff03464F)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          tileMode: TileMode.clamp,
                        )*/
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TableCalendar(
                            focusedDay: _focusedDay,
                            firstDay: DateTime.utc(2020, 10, 16),
                            lastDay: DateTime.utc(2100, 10, 16),
                            calendarFormat: CalendarFormat.month,
                            calendarStyle: CalendarStyle(
                              selectedDecoration: const BoxDecoration(
                                gradient: linearGradientLeading,
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              cellMargin: const EdgeInsets.all(2),
                              cellPadding: const EdgeInsets.all(0),
                              // selectedTextStyle: TextStyle(color: Theme.of(context).primaryColorDark),
                              // defaultTextStyle: const TextStyle(color: Colors.white),
                              weekendTextStyle: const TextStyle(color: Colors.red),
                              todayTextStyle: const TextStyle(color: Colors.black),
                              todayDecoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              // decoration: BoxDecoration(
                              //   color: Colors.white,
                              //   borderRadius: ci
                              // ),
                              titleCentered: true,
                              titleTextFormatter: (date, locale) {
                                return DateFormat('MMM yyyy', locale).format(date);
                              },
                              titleTextStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                              leftChevronPadding: EdgeInsets.zero,
                              rightChevronPadding: EdgeInsets.zero,
                              leftChevronMargin: EdgeInsets.zero,
                              rightChevronMargin: EdgeInsets.zero,
                              leftChevronIcon: Icon(
                                Icons.chevron_left,
                                color: Theme.of(context).primaryColor,
                              ),
                              rightChevronIcon: Icon(
                                Icons.chevron_right,
                                color: Theme.of(context).primaryColor,
                              ),
                              formatButtonVisible: false,
                              formatButtonPadding: const EdgeInsets.symmetric(vertical: 5),
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                              weekendStyle: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            selectedDayPredicate: (day) {
                              return isSameDay(date, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                date = selectedDay;
                                _focusedDay = focusedDay;
                                _isLoading = true;
                                _onError = false;
                              });
                              getHardwareError();
                              // scheduleViewProvider.fetchData(widget.deviceId, widget.customerId, widget.controllerId, context,);
                            },
                          ),
                        ),
                      ],
                    ),
                    // margin: EdgeInsets.symmetric(horizontal: 10),
                    /* child: TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime.utc(2020, 10, 16),
                    lastDay: DateTime.now(),
                    calendarFormat: CalendarFormat.month,
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        gradient: linearGradientLeading,
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    selectedDayPredicate: (day) {
                      return isSameDay(scheduleViewProvider.date, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        scheduleViewProvider.date = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      scheduleViewProvider.fetchData(widget.deviceId, widget.customerId, widget.controllerId, context);
                      scheduleViewProvider.updateSelectedProgramCategory(0);
                    },
                    // onFormatChanged: (format) {
                    //   if (_calendarFormat != format) {
                    //     setState(() {
                    //       _calendarFormat = format;
                    //     });
                    //   }
                    // },
                  ),*/
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    child: _isLoading ?
                    const Center(
                      child: SizedBox(
                        height: 45,
                        width: 80,
                        child: LoadingIndicator(
                            indicatorType: Indicator.ballPulse
                        ),
                      ),
                    )
                        : _onError
                        ? Center(
                      child: Text(_errorMessage,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                    )
                        : DataTable2(
                        columnSpacing: 20,
                        horizontalMargin: 12,
                        minWidth: 1300,
                        dataRowHeight: 50.0,
                        headingRowHeight: 35,
                        headingRowColor: WidgetStateProperty.all<Color>(primaryColorDark.withOpacity(0.1)),
                        border: TableBorder.all(color: Colors.teal.shade100, width: 0.5),
                        smRatio: 0.6,
                        fixedLeftColumns: 1,
                        lmRatio: 1.5,
                        isHorizontalScrollBarVisible: true,
                        scrollController: tableScrollController,
                        columns: [
                          _buildDataColumn('Error ID', ColumnSize.S, [], {}, null, ),
                          _buildDataColumn(
                            'Customer Name',
                            ColumnSize.M,
                            customerNameOptions,
                            selectedCustomerName,
                                (Set<String> newSelection) {
                              setState(() {
                                selectedCustomerName = newSelection;
                              });
                            },
                          ),
                          _buildDataColumn('Site Name', ColumnSize.M, [], {}, null, ),
                          _buildDataColumn('Device', ColumnSize.M, [], {}, null, ),
                          _buildDataColumn(
                            'Error Name',
                            ColumnSize.L,
                            errorNameOptions,
                            selectedErrorName,
                                (Set<String> newSelection) {
                              setState(() {
                                selectedErrorName = newSelection;
                              });
                            },
                          ),
                          _buildDataColumn(
                            'Datetime',
                            ColumnSize.M,
                            dateTimeOptions,
                            selectedDateTime,
                                (Set<String> newSelection) {
                              setState(() {
                                selectedDateTime = newSelection;
                              });
                            },
                          ),
                          _buildDataColumn('Description', ColumnSize.L, [], {}, null, ),
                          _buildDataColumn('Payload', ColumnSize.S, [], {}, null, ),
                          _buildDataColumn(
                            'Status',
                            ColumnSize.S,
                            statusOptions,
                            selectedStatus,
                                (Set<String> newSelection) {
                              setState(() {
                                selectedStatus = newSelection;
                              });
                            },
                          ),
                          _buildDataColumn(
                              'Action',
                              ColumnSize.S,
                              [],
                              {},
                              null
                          )
                        ],
                        rows: [
                          for(var i = 0; i < filteredData.length; i++)
                            DataRow2(
                                cells: [
                                  _buildDataCell('${filteredData[i].errorId}'),
                                  _buildDataCell(filteredData[i].userName),
                                  _buildDataCell(filteredData[i].groupName),
                                  _buildDataCell('${filteredData[i].deviceName} ${filteredData[i].deviceId}'),
                                  _buildDataCell(filteredData[i].errorName),
                                  _buildDataCell('${filteredData[i].controllerTime}, ${filteredData[i].controllerDate}'),
                                  // _buildDataCell(filteredData[i].description),
                                  _textFieldDataCell(bugReportModel[i].errorId, filteredData[i].description, filteredData[i].errorId),
                                  DataCell(
                                    TextButton(
                                        onPressed: () async{
                                          bugReportModel[i].errorPayload.clear();
                                          final response = await HttpService().postRequest('getHardwareErrorPayload', {"errorId" : bugReportModel[i].errorId});
                                          if(response.statusCode == 200) {
                                            setState(() {
                                              bugReportModel[i].errorPayload = jsonDecode(response.body)['data'];
                                            });
                                          }
                                          showPayload(filteredData[i].errorPayload, filteredData[i].errorName);
                                        },
                                        child: const Text('View')
                                    ),
                                  ),
                                  DataCell(
                                    PopupMenuButton(
                                      tooltip: 'Update status',
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          for(var j = 0; j < statusList.length; j++)
                                            PopupMenuItem(
                                                onTap: () {
                                                  setState(() {
                                                    filteredData[i].status = statusList[j];
                                                    bugReportModel.firstWhere((element) => element.errorId == filteredData[i].errorId).status = statusList[j];
                                                  });
                                                },
                                                child: Text(statusList[j])
                                            )
                                        ];
                                      },
                                      child: Text(
                                        filteredData[i].status,
                                        style: TextStyle(color: filteredData[i].status == statusList[0] ? Colors.red: Colors.green, fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    TextButton(
                                        onPressed: () async{
                                          Map<String, dynamic> data = {
                                            'errorId': bugReportModel.firstWhere((element) => element.errorId == filteredData[i].errorId).errorId,
                                            'description': bugReportModel.firstWhere((element) => element.errorId == filteredData[i].errorId).description,
                                            'status': bugReportModel.firstWhere((element) => element.errorId == filteredData[i].errorId).status
                                          };
                                          try {
                                            final updateHardwareErrorStatus = await HttpService().putRequest('updateHardwareErrorStatus', data);
                                            final response = jsonDecode(updateHardwareErrorStatus.body);
                                            showSnackBar(context, response['message']);
                                          } catch(error, stackTrace) {
                                            showSnackBar(context, '$error');
                                            print("error: $error");
                                            print("stackTrace: $stackTrace");
                                          }
                                        },
                                        child: const Text('Update')
                                    ),
                                  ),
                                ]
                            )
                        ]
                    ),
                  ),
                )
              ],
            );
          }
      ),
    );
  }

  DataCell _textFieldDataCell(int errorId, String description, int filteredDataErrorId) {
    return DataCell(
      TextFormField(
        key: Key('$errorId'),
        initialValue: description,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        onChanged: (newValue) {
          setState(() {
            description = newValue;
            bugReportModel.firstWhere((element) => element.errorId == filteredDataErrorId).description = description;
          });
        },
      ),
    );
  }


  DataColumn _buildDataColumn(
      String heading,
      ColumnSize columnSize,
      List<String> data,
      Set<String> selectedItems,
      void Function(Set<String>)? onSelectionChanged,
      ) {
    return DataColumn2(
      size: columnSize,
      label: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            heading,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          if (data.isNotEmpty)
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<void>(
                    child: StatefulBuilder(
                      builder: (context, stateSetter) {
                        return Column(
                          children: [
                            for (var i = 0; i < data.length; i++)
                              CheckboxListTile(
                                title: SizedBox(
                                  width: 100,
                                  child: Text(data[i]),
                                ),
                                value: selectedItems.contains(data[i]),
                                onChanged: (bool? newValue) {
                                  stateSetter(() {
                                    if(data[i] == 'All') {
                                      if(newValue == true) {
                                        selectedItems.clear();
                                        selectedItems.addAll(data);
                                      } else {
                                        selectedItems.clear();
                                      }
                                    } else {
                                      if (selectedItems.contains(data[i])) {
                                        selectedItems.remove(data[i]);
                                      } else {
                                        selectedItems.add(data[i]);
                                      }
                                      if (checkContainment(selectedItems, data)) {
                                        selectedItems.add('All');
                                      } else {
                                        selectedItems.remove('All');
                                      }
                                    }
                                  });
                                  onSelectionChanged?.call(selectedItems);
                                },
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ];
              },
              child: const Icon(
                Icons.filter_list,
                size: 20,
                color: Colors.teal,
              ),
            )
        ],
      ),
    );
  }

  bool checkContainment(Set<String> list, List<String> data) {
    // Filter out 'All' from the list before checking
    Set<String> filteredData = Set.from(data)..remove('All');
    return filteredData.difference(list).isEmpty;
  }

  DataCell _buildDataCell(String data) {
    return DataCell(
        SelectableText(data, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal,))
    );
  }

  void showPayload(Map<String, dynamic> errorPayload, String errorName) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(errorName),
            content: SizedBox(
              width: 400,
                child: SelectableText('$errorPayload')
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: jsonEncode(errorPayload)));
                    Navigator.pop(context);
                    showSnackBar(context, "Copied to clipboard!");
                  },
                  child: const Text('Copy',)
              ),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close', style: TextStyle(color: Colors.red),)),
            ],
          );
        }
    );
  }
}
