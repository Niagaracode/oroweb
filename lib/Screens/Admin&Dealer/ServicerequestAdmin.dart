import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/Customer/servicerequestdealermodel.dart';
import '../../constants/http_service.dart';
import '../../constants/snack_bar.dart';
import '../../constants/theme.dart';
import '../../state_management/overall_use.dart';

class ServiceRequestAdmin extends StatefulWidget {
  const ServiceRequestAdmin({
    Key? key,});

  @override
  State<ServiceRequestAdmin> createState() => _ServiceRequestAdminState();
}

class _ServiceRequestAdminState extends State<ServiceRequestAdmin> {
  // Example JSON string
  ServiceDealerModel _serviceDealerModel = ServiceDealerModel();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> filteredData = [];
  String searchQuery = '';
  String filterStatus = 'All';
  String filterRequestType = 'All';



  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    filteredData = List.from(data);
  }

  Future<void> fetchData() async {
    var overAllPvd = Provider.of<OverAllUse>(context, listen: false);
    Map<String, Object> body = {};
    final response = await HttpService().postRequest("getAllUserAllServiceRequestForAdmin",body);
    // print("getUserServiceRequestForDealer ==> ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        var jsonData1 = jsonDecode(response.body);

        if (jsonData1 is Map<String, dynamic> && jsonData1.containsKey('data')) {
          data = List<Map<String, dynamic>>.from(jsonData1['data']);
        } else if (jsonData1 is List) {
          // If it's already a list, use it directly
          data = List<Map<String, dynamic>>.from(jsonData1);
        } else {
          print("Unexpected JSON format");
        }




        // print("jsonData1------->${jsonData1.runtimeType}");
        // data = [];
        // filteredData = [];
        // data = jsonData1;
        filteredData = List.from(data);
      });
    } else {
      GlobalSnackBar.show(context,response.body,200);
    }
  }


  void updateFilters() {
    setState(() {
      filteredData = data.where((item) {
        final matchesSearchQuery = searchQuery.isEmpty ||
            item.values.any((value) =>
            value != null &&
                value.toString().toLowerCase().contains(searchQuery.toLowerCase()));
        final matchesStatus = filterStatus == 'All' ||
            item['status'].toString().toLowerCase() == filterStatus.toLowerCase();
        final matchesRequestType = filterRequestType == 'All' ||
            item['requestType']
                .toString()
                .toLowerCase()
                .contains(filterRequestType.toLowerCase());

        return matchesSearchQuery && matchesStatus && matchesRequestType;
      }).toList();
    });
  }

  Color getRowColor(String status) {
    switch (status.toLowerCase()) {
      case 'closed':
        return Colors.green.withOpacity(0.2); // Light green color
      case 'waiting':
        return Colors.red.withOpacity(0.2); // Light red color
      case 'in-progress':
        return Colors.yellow.withOpacity(0.2); // Light yellow color
      default:
        return Colors.transparent; // No color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Service Request List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30 ,right: 30 ,top: 8 ,bottom:8 ),
            child: TextField(
              onChanged: (value) {
                searchQuery = value;
                updateFilters();
              },
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Status:"),
              SizedBox(width: 5,),
              DropdownButton<String>(
                value: filterStatus,
                items: ['All', 'Waiting', 'In-Progress', 'Closed']
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    filterStatus = value!;
                    updateFilters();
                  });
                },
                hint: Text('Filter by Status'),
              ),
              SizedBox(width: 10,),
              Text("Request Type:"),
              SizedBox(width: 5,),
              DropdownButton<String>(
                value: filterRequestType,
                items: ['All', 'Valve Issue', 'Other Issue', 'Hardware Issue', 'Software Issue']
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    filterRequestType = value!;
                    updateFilters();
                  });
                },
                hint: Text('Filter by Request Type'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total Records: ${filteredData.length}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Request ID',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('User Name',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Dealer Name',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Group Name',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Device Name',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Request Type',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Description',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Date',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Time',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Status',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Priority',style: TextStyle(fontWeight: FontWeight.bold),)),
                    ],
                    rows: filteredData
                        .map(
                          (item) => DataRow(
                        color: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              return getRowColor(item['status'].toString());
                            }),
                        cells: [
                          DataCell(Text(item['requestId'].toString())),
                          DataCell(Text(item['userName'].toString())),
                          DataCell(Text(item['responsibleUserName'].toString())),
                          DataCell(Text(item['groupName'].toString())),
                          DataCell(Text(item['deviceName'].toString())),
                          DataCell(Text(item['requestType'].toString())),
                          DataCell(Text(item['requestDescription'].toString())),
                          DataCell(Text(item['requestDate'].toString())),
                          DataCell(Text(item['requestTime'].toString())),
                          DataCell(Text(item['status'].toString())),
                          DataCell(Text(item['priority'].toString())),
                        ],
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

