// lib/main.dart
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../Models/Customer/servicecustomermodel.dart';
import '../../../constants/http_service.dart';
import '../../../constants/snack_bar.dart';
import '../../../state_management/overall_use.dart';

class TicketHomePage extends StatefulWidget {
  final int userId, controllerId;
  const TicketHomePage(
      {super.key, required this.userId, required this.controllerId});

  @override
  State<TicketHomePage> createState() => _TicketHomePageState();
}

class _TicketHomePageState extends State<TicketHomePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController otherstextctrl = TextEditingController();
  RequestType _selectedCategory = RequestType();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateFormat timeformat = DateFormat("HH:mm:ss");
  DateFormat ExceptdateFormat = DateFormat("yyyy-MM-dd");
  ServicecustomerModel _servicecustomerModel = ServicecustomerModel();
  String dropdownvalue =  'Controller Regarding';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    Map<String, Object> body = {
      "userId": widget.userId,
      "controllerId": widget.controllerId
    };
    final response =
    await HttpService().postRequest("getUserServiceRequest", body);
    if (response.statusCode == 200) {
      setState(() {
        var jsonData1 = jsonDecode(response.body);
        _servicecustomerModel = ServicecustomerModel.fromJson(jsonData1);
      });
    } else {
      // _showSnackBar(response.body);
    }
  }

  Future<void> updateData(
      int requestTypeId,
      String requestType,
      String requestDate,
      String requestDescription,
      String requestTime,
      int responsibleUser,
      String estimatedDate) async {
    otherstextctrl.clear();

    var overAllPvd = Provider.of<OverAllUse>(context, listen: false);
    Map<String, Object> body = {
      "userId": widget.userId,
      "controllerId": widget.controllerId,
      "requestTypeId": requestTypeId,
      "requestType": requestType,
      "requestDescription": requestDescription,
      "requestDate": requestDate,
      "requestTime": requestTime,
      "responsibleUser": responsibleUser,
      "estimatedDate": estimatedDate,
      "siteLocation": '',
      "createUser": widget.userId
    };
    final response =
    await HttpService().postRequest("createUserServiceRequest", body);
    print('response    ${response.body}');
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

  @override
  Widget build(BuildContext context) {
    if (_servicecustomerModel.data == null) {
      return const Center(
          child: Text(
            'Currently no service Request available ',
            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
          ));
    } else if (_servicecustomerModel.data!.dataDefault!.requestType!.length <=
        0) {
      return const Center(
          child: Text(
            'Currently service Request Not available our Account',
            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
          ));
    } else {
      // _categories =   _servicecustomerModel.data?.dataDefault!.requestType!.where(e) -> value

      return Scaffold(
        backgroundColor: Colors.white,
         body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    DropdownButton(
                      iconSize: 32,
                      dropdownColor: Colors.teal.shade100,
                      // Initial Value
                      value: dropdownvalue,
                      // Down Arrow Icon
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      // Array list of items
                      items: _servicecustomerModel
                          .data!.dataDefault!.requestType!
                          .map((items) {
                        return DropdownMenuItem(
                          value: items.requestType,
                          child: Text(items.requestType!),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                          _selectedCategory = _servicecustomerModel
                              .data!.dataDefault!.requestType!
                              .firstWhere((e) => e.requestType == newValue);
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 100,
                      width: 400,
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 5) {
                            return 'Please Enter a Valid Reason';
                          }
                          return null;
                        },
                        maxLength: 200,
                        controller: otherstextctrl,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: _selectedCategory.requestType,
                          hintText: 'Type here...',
                        ),
                        autofocus: true,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print('_selectedCategory.requestTypeId ----->${_selectedCategory.requestTypeId}');
                        try{
                          if(_formKey.currentState != null) {
                            if (_formKey.currentState!.validate()) {
                              updateData(
                                  _selectedCategory.requestTypeId ?? 3,
                                  _selectedCategory.requestType ?? "",
                                  dateFormat.format(DateTime.now()),
                                  otherstextctrl.text,
                                  timeformat.format(DateTime.now()),
                                  _servicecustomerModel.data!.dataDefault!.dealer![0].userId!,
                                  ExceptdateFormat.format(
                                      DateTime.now().add(const Duration(days: 2))));
                            }
                          }
                        } catch(error, stackTrace) {

                        }
                      },
                      child: const Text('Raise Ticket'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                    child: Center(
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.start,
                        children: [
                          for (var index = 0;
                          index <
                              _servicecustomerModel.data!.serviceRequest!.length;
                          index++)
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: '${_servicecustomerModel.data!.serviceRequest![index].status}' ==
                                        'Closed' ?  Colors.grey.withOpacity(0.5) : Colors.teal.shade50,
                                    boxShadow: customBoxShadow),
                                height: 270,
                                width: 250,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IntrinsicHeight(
                                        child: Center(
                                            child: Text(
                                              '${_servicecustomerModel.data!.serviceRequest![index].requestType}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 21),
                                            ))),
                                    Container(
                                        height: 60,
                                        width: double.infinity,
                                        child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Text(
                                                '${_servicecustomerModel.data!.serviceRequest![index].requestDescription}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.normal)))),
                                    Text(
                                      '${_servicecustomerModel.data!.serviceRequest![index].requestDate} ${_servicecustomerModel.data!.serviceRequest![index].requestTime}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),  const SizedBox(height: 5,),
                                    const Text(
                                      'Estimated Closing Date:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: const Color(0xff15C0E6),
                                      ),
                                    ),
                                    Text(
                                      '${_servicecustomerModel.data!.serviceRequest![index].estimatedDate}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5,),
                                    const Text(
                                      'Responsibility:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: const Color(0xff15C0E6),
                                      ),
                                    ),
                                    Text(
                                      '${_servicecustomerModel.data!.serviceRequest![index].responsibleUserName}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5,),
                                    const Text(
                                      'Status:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xff15C0E6),
                                      ),
                                    ),
                                    Text(
                                        '${_servicecustomerModel.data!.serviceRequest![index].status}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 21,
                                            color: '${_servicecustomerModel.data!.serviceRequest![index].status}' ==
                                                'Waiting'
                                                ? const Color(0xfff3bf21)
                                                : '${_servicecustomerModel.data!.serviceRequest![index].status}' ==
                                                'Closed'
                                                ? const Color(0xff21f33d)
                                                : const Color(0xff1c7b89))),
                                  ],
                                ))
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      );
    }
  }
}

List<BoxShadow> customBoxShadow = [
  BoxShadow(
      offset: const Offset(0, 45),
      blurRadius: 112,
      color: Colors.black.withOpacity(0.06)),
  BoxShadow(
      offset: const Offset(0, 22.78),
      blurRadius: 48.83,
      color: Colors.black.withOpacity(0.0405)),
  BoxShadow(
      offset: const Offset(0, 9),
      blurRadius: 18.2,
      color: Colors.black.withOpacity(0.03)),
  BoxShadow(
      offset: const Offset(0, 1.97),
      blurRadius: 6.47,
      color: Colors.black.withOpacity(0.0195)),
];
