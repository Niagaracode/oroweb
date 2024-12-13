import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
 import 'package:provider/provider.dart';
import '../../Models/Customer/servicerequestdealermodel.dart';
import '../../constants/http_service.dart';
import '../../constants/snack_bar.dart';
import '../../constants/theme.dart';
import '../../state_management/overall_use.dart';

class ServiceRequestsTable extends StatefulWidget {
  const ServiceRequestsTable({
    Key? key,
    required this.userId,
  });
  final int userId;

  @override
  State<ServiceRequestsTable> createState() => _ServiceRequestsTableState();
}

class _ServiceRequestsTableState extends State<ServiceRequestsTable> {
  // Example JSON string
  ServiceDealerModel _serviceDealerModel = ServiceDealerModel();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var overAllPvd = Provider.of<OverAllUse>(context, listen: false);
    Map<String, Object> body = {"userId": widget.userId};
    final response = await HttpService().postRequest("getUserServiceRequestForDealer", body);
    print("getUserServiceRequestForDealer ==> ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        var jsonData1 = jsonDecode(response.body);
        _serviceDealerModel = ServiceDealerModel.fromJson(jsonData1);
      });
    } else {
      // _showSnackBar(response.body);
    }
  }



  @override
  Widget build(BuildContext context) {
    if (_serviceDealerModel.data == null) {
      return const Center(
        child: Text(
          'Currently no service Request available ',
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
      );
    } else if (_serviceDealerModel.data!.length <= 0) {
      return const Center(
        child: Text(
          'Currently No service Request available on Customer Account',
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
      );
    } else {

      return Scaffold(

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DataTable2(
            minWidth: 1200,
            showBottomBorder: true,
            headingRowColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                return myTheme.primaryColorDark; // default color
              },
            ),
            headingRowHeight: 29,
            dataRowHeight: 45,
            columns: const [
              DataColumn2(
                fixedWidth: 50,
                label: Text(
                  'SNo',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              // DataColumn2(
              //   fixedWidth: 120,
              //   label: Text(
              //     'Customer Name',softWrap: true,
              //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
              //   ),
              // ),
              DataColumn2(
                fixedWidth: 150,
                label: Text(
                  'Site Name',softWrap: true,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn2(
                size: ColumnSize.L,
                label: Text(
                  'Issue', softWrap: true,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn2(
                size: ColumnSize.L,
                label: Text(
                  'Description',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn2(
                fixedWidth: 140,
                label: Text(
                  'Request Date',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn2(
                fixedWidth: 160,
                label: Text(
                  'Estimated Date',softWrap: true,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn2(
                fixedWidth: 165,
                label: Text(
                  'Status',softWrap: true,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn2(
                fixedWidth: 150,
                label: Text(
                  'Update',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: List<DataRow>.generate(
              _serviceDealerModel.data!.length,
                  (index) {
                return DataRow(
                  color: _serviceDealerModel.data![index].status == 'Closed'
                      ? WidgetStateProperty.all(Colors.green.shade100)
                      : _serviceDealerModel.data![index].priority == 'High'
                      ? WidgetStateProperty.all(Colors.red.shade100)
                      : _serviceDealerModel.data![index].priority == 'Medium'
                      ? WidgetStateProperty.all(Colors.yellow.shade100)
                      : WidgetStateProperty.all(Colors.white),
                  cells: [
                    DataCell(Text(_serviceDealerModel.data![index].requestId.toString())),
                    // DataCell(Text(_serviceDealerModel.data![index].groupName ?? '')),
                    DataCell(Text(_serviceDealerModel.data![index].groupName ?? '')),
                    DataCell(Text(_serviceDealerModel.data![index].requestType ?? '')),
                    DataCell(Text(_serviceDealerModel.data![index].requestDescription ?? '')),
                    DataCell(Text(DateFormat('yyyy-MM-dd').format(_serviceDealerModel.data![index].requestDate!).toString())),
                    DataCell(
                      InkWell(
                        child: Row(
                          children: [
                            Text(DateFormat('yyyy-MM-dd').format(_serviceDealerModel.data![index].estimatedDate!).toString()),
                            Icon(Icons.date_range),
                          ],
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _serviceDealerModel.data![index].estimatedDate ?? DateTime.now(),
                            firstDate: DateTime(DateTime.now().year),
                            lastDate: DateTime(2026),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _serviceDealerModel.data![index].estimatedDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ),
                    DataCell(
                      DropdownButton<String>(
                        value: _serviceDealerModel.data![index].status,
                        items: <String>['Waiting', 'In-Progress', 'Closed'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _serviceDealerModel.data![index].status = newValue;
                          });
                        },
                      ),
                    ),
                    DataCell(
                      ElevatedButton(
                        onPressed: () {
                          updateData(
                            widget.userId,
                            _serviceDealerModel.data![index].controllerId!,
                            _serviceDealerModel.data![index].requestTypeId!,
                            _serviceDealerModel.data![index].responsibleUser!,
                            dateFormat.format(_serviceDealerModel.data![index].estimatedDate!).toString(),
                            _serviceDealerModel.data![index].status!,
                            _serviceDealerModel.data![index].requestId!,
                          );
                          fetchData();
                        },
                        child: const Text('Update'),
                      ),
                    ),
                  ],
                );
                  },
            ),
          ),
        ),
      );
    }
  }


  Future<void> updateData(
      int userid,
      int controllerId,
      int requestTypeId,
      int responsibleUser,
      String estimatedDate,
      String status,
      int requestId,
      ) async {
    // getUserServiceRequest => userId, controllerId
    // createUserServiceRequest => userId, controllerId, requestTypeId, requestDate, requestTime, responsibleUser, estimatedDate, siteLocation, createUser
    // updateUserServiceRequest => userId, controllerId, requestId, requestTypeId, responsibleUser, estimatedDate, status, closedDate, modifyUser
    Map<String, dynamic> body = {
      "userId": userid,
      "controllerId": controllerId,
      "requestTypeId": requestTypeId,
      "requestId": requestId,
      "responsibleUser": responsibleUser,
      "estimatedDate": estimatedDate,
      "status": status,
      "closedDate":
      status == 'Closed' ? '${dateFormat.format(DateTime.now())}' : null,
      "modifyUser": userid
    };
    final response =
    await HttpService().putRequest("updateUserServiceRequest", body);
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        GlobalSnackBar.show(context, jsonData['message'], response.statusCode);
        fetchData();
      });
    } else {
      GlobalSnackBar.show(context, jsonData['message'], response.statusCode);
    }
  }
}

