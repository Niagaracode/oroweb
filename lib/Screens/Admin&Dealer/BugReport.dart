import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:oro_irrigation_new/Models/bug_report_model.dart';
import 'package:oro_irrigation_new/constants/http_service.dart';
import 'package:universal_html/js_util.dart';

import '../../constants/theme.dart';

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
  final List<String> statusList = [
    'Pending',
    'Completed'
  ];

  Set<String> selectedCustomerName = {'All'};
  Set<String> selectedStatus = {'All'};
  Set<String> selectedErrorName = {'All'};
  Set<String> selectedDateTime = {'All'};

  int selectedColumn = 0;

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
      final response = await HttpService().postRequest('getHardwareError', {});
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
      body: Container(
        child: _isLoading ?
        const Center(
          child: SizedBox(
            height: 45,
            width: 100,
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
                            onPressed: (){
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
