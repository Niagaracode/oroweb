import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:oro_irrigation_new/Models/Customer/Dashboard/SentAndReceivedModel.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../constants/MyFunction.dart';
import '../../../constants/http_service.dart';

class SentAndReceived extends StatefulWidget {
  const SentAndReceived({Key? key, required this.customerID, required this.controllerId, required this.from}) : super(key: key);
  final int customerID, controllerId;
  final String from;

  @override
  State<SentAndReceived> createState() => _SentAndReceivedState();
}

class _SentAndReceivedState extends State<SentAndReceived> {

  List<SentAndReceivedModel> sentAndReceivedList =[];

  int logFlag = 0;
  bool visibleLoading = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  //weekly calendar
  CalendarFormat _calendarFormat = CalendarFormat.week;

  bool hasPayloadViewPermission = false;
  TextEditingController passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();
    logFlag = 0;
    fetchUserType();
    getLogs(widget.controllerId, DateFormat('yyyy-MM-dd').format(_focusedDay));
  }

  Future<void> fetchUserType() async {
    String? userType = await MyFunction().getParameter('userType');
    if(userType.toString()=='1'){
      hasPayloadViewPermission = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth>600? SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 350,
            height: 400,
            child: TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                enabledDayPredicate: (day) {
                  return day.isBefore(DateTime.now()) || isSameDay(day, DateTime.now());
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    getLogs(widget.controllerId, DateFormat('yyyy-MM-dd').format(_selectedDay!));

                  });
                },
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.deepOrange,
                    shape: BoxShape.circle,
                  ),
                  disabledTextStyle: TextStyle(color: Colors.grey),  // To make the disabled dates greyed out
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                )
            ),
          ),
          const SizedBox(width: 5,),
          Container(width: 0.5, height: widget.from=='Gem'? MediaQuery.sizeOf(context).height-77: MediaQuery.sizeOf(context).height-120, color: Colors.teal.shade200,),
          msgListBox(screenWidth),
        ],
      ),
    ):
    SizedBox(
      width: screenWidth,
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              print(selectedDay);
              print(focusedDay);
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                getLogs(widget.controllerId, DateFormat('yyyy-MM-dd').format(_selectedDay!));

              });
            },
            enabledDayPredicate: (day) {
              return day.isBefore(DateTime.now()) || isSameDay(day, DateTime.now());
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepOrange,
                shape: BoxShape.circle,
              ),
              disabledTextStyle: TextStyle(color: Colors.grey),  // To make the disabled dates greyed out
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
            ),
          ),
          const SizedBox(height: 5,),
          Container(width: screenWidth-50, height: 0.5, color: Colors.teal.shade200,),
          msgListBox(screenWidth),
        ],
      ),
    );
  }

  SizedBox msgListBox(screenWidth) {
    return SizedBox(
      width: screenWidth>600? widget.from=='Gem'? MediaQuery.sizeOf(context).width-512 : MediaQuery.sizeOf(context).width-676: MediaQuery.sizeOf(context).width,
      height: screenWidth>600? widget.from=='Gem'? MediaQuery.sizeOf(context).height-77: MediaQuery.sizeOf(context).height-120 : MediaQuery.sizeOf(context).height-230,
      child: visibleLoading? Visibility(
        visible: visibleLoading,
        child: Container(
          height: double.infinity,
          color: Colors.transparent,
          padding: EdgeInsets.fromLTRB(MediaQuery.sizeOf(context).width/2 - 280, 0, MediaQuery.sizeOf(context).width/2 - 280, 0),
          child: const LoadingIndicator(
            indicatorType: Indicator.ballPulse,
          ),
        ),
      ):
      sentAndReceivedList.isNotEmpty? ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemCount: sentAndReceivedList.length,
        itemBuilder: (context, index)
        {
          if(sentAndReceivedList[index].messageType == 'RECEIVED')
          {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onLongPress: () {
                      if(!hasPayloadViewPermission){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Enter Password'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('This content is protected.\nPlease enter your password to\nview the payload.',
                                    style: TextStyle(fontWeight: FontWeight.normal),),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: passwordController,
                                    obscureText: false,
                                    decoration: const InputDecoration(
                                      labelText: 'Password',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    String enteredPassword = passwordController.text;
                                    if (enteredPassword == 'Oro@321') {
                                      hasPayloadViewPermission=true;
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Access granted. Showing payload...')),
                                      );
                                      getUserSoftwareOrHardwarePayload(sentAndReceivedList[index].sentAndReceivedId,'Hardware payload',sentAndReceivedList[index].message);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Incorrect password.')),
                                      );
                                    }
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    onTap: (){
                      if(hasPayloadViewPermission){
                        getUserSoftwareOrHardwarePayload(sentAndReceivedList[index].sentAndReceivedId,'Hardware payload',sentAndReceivedList[index].message);
                      }
                    },
                    child: BubbleSpecialOne(
                      textStyle: const TextStyle(fontSize: 12),
                      text: sentAndReceivedList[index].message,
                      color: Colors.green.shade100,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Text(convertTo12hrs(sentAndReceivedList[index].time), style: const TextStyle(fontSize: 11, color: Colors.grey),),
                  ),
                ],
              ),
            );
          }
          else
          {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onLongPress: () {
                      if(!hasPayloadViewPermission){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Enter Password'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('This content is protected.\nPlease enter your password to\nview the payload.',
                                    style: TextStyle(fontWeight: FontWeight.normal),),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: passwordController,
                                    obscureText: false,
                                    decoration: const InputDecoration(
                                      labelText: 'Password',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    String enteredPassword = passwordController.text;
                                    if (enteredPassword == 'Oro@321') {
                                      hasPayloadViewPermission=true;
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Access granted. Showing payload...')),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Incorrect password.')),
                                      );
                                    }
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    onTap: (){
                      if(hasPayloadViewPermission){
                        getUserSoftwareOrHardwarePayload(sentAndReceivedList[index].sentAndReceivedId,'Software payload', sentAndReceivedList[index].message);
                      }
                    },
                    child: BubbleSpecialOne(
                      text: sentAndReceivedList[index].message,
                      isSender: false,
                      color: Colors.blue.shade100,
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text('${sentAndReceivedList[index].sentUser}(${sentAndReceivedList[index].sentMobileNumber}) - ${convertTo12hrs(sentAndReceivedList[index].time)}', style: const TextStyle(fontSize: 11, color: Colors.grey),),
                  ),
                ],
              ),
            );
          }
        },
      ):
      const Center(child: Text('Message not found',
        style: TextStyle(fontSize: 17,fontWeight: FontWeight.normal),),),
    );
  }

  void indicatorViewShow() {
    if(mounted){
      setState(() {
        visibleLoading = true;
      });
    }
  }

  void indicatorViewHide() {
    if(mounted){
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          visibleLoading = false;
        });
      });
    }
  }

  String convertTo12hrs(String timeString) {
    DateTime dateTime = DateFormat("HH:mm:ss").parse(timeString);
    String formattedTime = DateFormat("h:mm a").format(dateTime);
    return formattedTime;
  }


  Future<void> getLogs(int controllerId, String date) async {
    indicatorViewShow();
    try {
      sentAndReceivedList.clear();
      Map<String, Object> body = {"userId": widget.customerID, "controllerId": controllerId, "fromDate":date, "toDate":date};
      final response = await HttpService().postRequest("getUserSentAndReceivedMessageStatus", body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if(jsonResponse['code']==200){
          sentAndReceivedList = [
            ...jsonResponse['data'].map((programJson) => SentAndReceivedModel.fromJson(programJson)).toList(),
          ];
          indicatorViewHide();
        }else{
          indicatorViewHide();
        }
      }
    } catch (e) {
      print('Error: $e');
      indicatorViewHide();
    }
  }

  Future<void> getUserSoftwareOrHardwarePayload(int sentAndReceivedId, String aTitle, String pyTitle) async {
    var data = {
      "userId": widget.customerID,
      "controllerId": widget.controllerId,
      "sentAndReceivedId": sentAndReceivedId,
    };
    try {
      final getUserSentAndReceivedHardwarePayload = await HttpService().postRequest("getUserSentAndReceivedHardwarePayload", data);
      final response = jsonDecode(getUserSentAndReceivedHardwarePayload.body);
      if (getUserSentAndReceivedHardwarePayload.statusCode == 200) {
        if(response['code']==200){
          final message = response?['data']?['message'];
          if (message != null) {
            print(response['data']['message']);
            displayJsonData(context, response['data']['message'] ?? 'Empty message', aTitle, pyTitle);
          }else{
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(aTitle),
                  content: const Text("No data available."),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        }
      } else {
        log('Failed to load data');
      }
    } catch (e, stackTrace) {
      log("$e");
      log("stackTrace ==> $stackTrace");
    }
  }

  void displayJsonData(BuildContext context, Map<String, dynamic> jsonData, String aTitle, String pyTitle,) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(aTitle),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pyTitle, style: const TextStyle(color: Colors.teal),),
                  const Divider(),
                  Text(jsonEncode(jsonData), style: const TextStyle(color: Colors.black54),),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

}
