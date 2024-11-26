import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/constants/MQTTManager.dart';
import 'package:oro_irrigation_new/constants/http_service.dart';
import 'package:oro_irrigation_new/constants/snack_bar.dart';
import 'package:oro_irrigation_new/constants/theme.dart';
import 'package:provider/provider.dart';

import '../../Models/reset_AccumalationModel.dart';
import '../../state_management/MqttPayloadProvider.dart';
import '../../widgets/FontSizeUtils.dart';
import '../Customer/IrrigationProgram/program_library.dart';

class Reset_Accumalation extends StatefulWidget {
  const Reset_Accumalation(
      {Key? key,
        required this.userId,
        required this.controllerId,
        required this.deviceID});
  final userId, controllerId, deviceID;

  @override
  State<Reset_Accumalation> createState() => _Reset_AccumalationState();
}

class _Reset_AccumalationState extends State<Reset_Accumalation>
    with SingleTickerProviderStateMixin {
  // late TabController _tabController;
  ResetModel _resetModel = ResetModel();
  int tabclickindex = 0;
  final _formKey = GlobalKey<FormState>();
  late MqttPayloadProvider mqttPayloadProvider;
  @override
  void initState() {
    mqttPayloadProvider = Provider.of<MqttPayloadProvider>(context, listen: false);
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if(mounted) {
      Request();
    }
    Map<String, Object> body = {
      "userId": widget.userId,
      "controllerId": widget.controllerId
    };
    final response =
    await HttpService().postRequest("getUserResetAccumulation", body);
    if (response.statusCode == 200) {
      setState(() {
        var jsondata = jsonDecode(response.body);
        _resetModel = ResetModel.fromJson(jsondata);
      });
    } else {
      //_showSnackBar(response.body);`
    }
    //  _resetModel = ResetModel.fromJson(json);
  }

  @override
  Widget build(BuildContext context) {

    if (_resetModel.code != 200) {
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 8, bottom: 80, right: 8, top: 8),
          child: Column(
            children: [
              Center(child: Text(_resetModel.message ?? 'Currently No data Available')),
              Spacer(),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red),foregroundColor: WidgetStatePropertyAll(Colors.white)),
                child: Text("Factory Reset"),
                onPressed: () async {
                  setState(() {
                    _showMyDialog(context);
                  });
                },
              ),
            ],
          ),
        ),
      ) ;
    }   else if (_resetModel.data == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (_resetModel.data!.accumulation!.isEmpty) {
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 8, bottom: 80, right: 8, top: 8),
          child: Column(
            children: [
              Center(child: Text(_resetModel.message ?? 'Currently No data Available')),
              Spacer(),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red),foregroundColor: WidgetStatePropertyAll(Colors.white)),
                child: Text("Factory Reset"),
                onPressed: () async {
                  setState(() {
                    _showMyDialog(context);
                  });
                },
              ),
            ],
          ),
        ),
      ) ;
    }
    else{
      return DefaultTabController(
        length: _resetModel.data!.accumulation!.length ?? 0,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(left: 8, bottom: 80, right: 8, top: 8),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: const Border(
                        top: BorderSide(color: Colors.black, width: 0.5),  // Top border
                        left: BorderSide(color: Colors.black, width: 0.5),  // Left border
                        right: BorderSide(color: Colors.black, width: 0.5), // Right border
                        bottom: BorderSide.none, // No bottom border
                      ),
                      borderRadius: BorderRadius.circular(8.0), // Optional: Set rounded corners
                    ),
                    height: 50,
                    child: TabBar(
                      // controller: _tabController,
                      indicatorColor: const Color.fromARGB(255, 175, 73, 73),
                      isScrollable: true,
                      unselectedLabelColor: Colors.grey,
                      labelColor: myTheme.primaryColor,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      tabs: [
                        for (var i = 0; i < _resetModel.data!.accumulation!.length; i++)
                          Tab(
                            text: '${_resetModel.data!.accumulation![i].name}',
                          ),
                      ],
                      onTap: (value) {
                        setState(() {
                          tabclickindex = value;
                          changeval(value);
                        });
                      },
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      decoration: BoxDecoration(
                        border: const Border(
                          bottom: BorderSide(color: Colors.black, width: 0.5),  // Top border
                          left: BorderSide(color: Colors.black, width: 0.5),  // Left border
                          right: BorderSide(color: Colors.black, width: 0.5), // Right border
                          top: BorderSide.none, // No bottom border
                        ),
                        borderRadius: BorderRadius.circular(8.0), // Optional: Set rounded corners
                      ),
                      child: TabBarView(children: [
                        for (var i = 0; i < _resetModel.data!.accumulation!.length; i++)
                          buildTab(_resetModel.data!.accumulation![i].list)
                      ]),
                    ),
                  ),

                  SizedBox(height: 10,),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red),foregroundColor: WidgetStatePropertyAll(Colors.white)),
                    child: Text("Factory Reset"),
                    onPressed: () async {
                      setState(() {
                        _showMyDialog(context);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to Reset All data?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                _showSnackBar("send to Factory Reset... ");
                FResetAll();
                Navigator.of(context).pop(); // Close the alert dialog
              },
            ),
          ],
        );
      },
    );
  }
  double Changesize(int? count, int val) {
    count ??= 0;
    double size = (count * val).toDouble();
    return size;
  }
  changeval(int Selectindexrow) {}
  Widget buildTab(List<ListElement>? Listofvalue,){
    // List<Source>? Listofvalue, int i, String sourceid, String sourcename) {
    // if (MediaQuery.of(context).size.width > 600) {
    return Column(
      children: [
        Expanded(
          child: Container(
            child: DataTable2(
                headingRowColor: MaterialStateProperty.all<Color>(
                    primaryColorDark.withOpacity(0.2)),
                // fixedCornerColor: myTheme.primaryColor,
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 600,
                // border: TableBorder.all(width: 0.5),
                // fixedColumnsColor: Colors.amber,
                headingRowHeight: 50,
                columns: [
                  DataColumn2(
                    fixedWidth: 70,
                    label: Center(
                        child: Text(
                          'Sno',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: FontSizeUtils.fontSizeHeading(context) ?? 16,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        )),
                  ),
                  DataColumn2(
                    label: Center(
                        child: Text(
                          'Name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: FontSizeUtils.fontSizeHeading(context) ?? 16,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        )),
                  ),
                  DataColumn2(
                    fixedWidth: 150,
                    label: Center(
                        child: Text(
                          'Daily Accumalation',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: FontSizeUtils.fontSizeHeading(context) ?? 16,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        )),
                  ),
                  DataColumn2(
                    fixedWidth: 150,
                    label: Center(
                        child: Text(
                          'Total Accumalation',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: FontSizeUtils.fontSizeHeading(context) ?? 16,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        )),
                  ),
                  DataColumn2(
                    fixedWidth: 150,
                    label: Center(
                        child: Text(
                          'Reset',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: FontSizeUtils.fontSizeHeading(context) ?? 16,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        )),
                  ),
                ],
                rows: List<DataRow>.generate(Listofvalue!.length, (index) => DataRow(cells: [
                  DataCell(Center(child: Text('${Listofvalue![index].sNo}'))),
                  DataCell(Center(
                    child: Text(
                      '${Listofvalue![index].name}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSizeUtils.fontSizeLabel(context) ?? 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      '${Listofvalue![index].todayCumulativeFlow} L',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSizeUtils.fontSizeLabel(context) ?? 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      '${Listofvalue![index].totalCumulativeFlow} L',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSizeUtils.fontSizeLabel(context) ?? 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
                  DataCell(
                    Center(
                      child: ElevatedButton(
                        style:  ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 18)),
                        onPressed: () {
                          Reset(Listofvalue![index].sNo!);

                          Future.delayed(Duration(minutes: 1), () {
                            fetchData();
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ),
                  ),]),
                )),
          ),
        ),
        SizedBox(height: 5,),
        // Listofvalue.isNotEmpty ? ElevatedButton(
        //   child: const Text("RESET ALL"),
        //   onPressed: () async {
        //     setState(() {
        //       ResetAll(Listofvalue);
        //       Future.delayed(Duration(minutes: 1), () {
        //         fetchData();
        //       });
        //     });
        //   },
        // ) : Container() ,
        SizedBox(height: 5,),
      ],
    );
    // }
  }
  updateradiationset() async {
    Map<String, Object> body = {
      "userId": widget.userId,
      "controllerId": widget.controllerId,
      "hardware":"{}",
      "modifyUser": widget.userId
    };
    // String Mqttsenddata = toMqttformat(_resetModel.data);
    final response =
    await HttpService().postRequest("updateUserResetAccumulation", body);
    final jsonDataresponse = jsonDecode(response.body);
    GlobalSnackBar.show(
        context, jsonDataresponse['message'], response.statusCode);

    String payLoadFinal = jsonEncode({
      "2900": [
        {"2901": body},
      ]
    });
    MQTTManager().publish( payLoadFinal, 'AppToFirmware/${widget.deviceID}');
  }
  Request(){
    // _showSnackBar("Send to Reset to resetAccumulation");
    String payLoadFinal = jsonEncode({
      "5300": [
        {"5301": "1"},
      ]
    });
    MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.deviceID}');
    print('AppToFirmware/${widget.deviceID}');
  }

  Reset(int Srno)   async{
    _showSnackBar("send to Reset");
    Map<String, dynamic> payLoadFinal = {
      "5400": [
        {"5401": '${Srno},1;'},
      ]
    };
    print(payLoadFinal);
    if (MQTTManager().isConnected == true) {
      await validatePayloadSent(
          dialogContext: context,
          context: context,
          mqttPayloadProvider: mqttPayloadProvider,
          acknowledgedFunction: () {
          },
          payload: payLoadFinal,
          payloadCode: "4202",
          deviceId: widget.deviceID,
          maxWaitTime: 50
      );
    } else {
      GlobalSnackBar.show(context, 'MQTT is Disconnected', 201);
    }



  }
  ResetAll(List<ListElement>? data) async{
    String restsrn = '';
    for (var j = 0; j < data!.length; j++) {
      restsrn += "${data[j].sNo},1;";
    }
    Map<String, dynamic> payLoadFinal = {
      "5400": [
        {"5401": restsrn},
      ]
    };
    if (MQTTManager().isConnected == true) {
      await validatePayloadSent(
          dialogContext: context,
          context: context,
          mqttPayloadProvider: mqttPayloadProvider,
          acknowledgedFunction: () {
          },
          payload: payLoadFinal,
          payloadCode: "4202",
          deviceId: widget.deviceID,
          maxWaitTime: 50
      );
    } else {
      GlobalSnackBar.show(context, 'MQTT is Disconnected', 201);
    }




  }
  sendHttp(String val, String msgstatus) async
  {
    Map<String, dynamic> payLoadFinal = {
      "5300": [
        {"5301": "$val"},
      ]
    };
    Map<String, dynamic> body = {
      "userId": widget.userId,
      "controllerId": widget.controllerId,
      "hardware": payLoadFinal,
      "messageStatus": msgstatus,
      "createUser": widget.userId
    };
    final response = await HttpService().postRequest("createUserSentAndReceivedMessageManually", body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["code"] == 200) {
        _showSnackBar(data["message"]);
      } else {
        _showSnackBar(data["message"]);
      }
    }
  }

  FResetAll()   async{
    sendHttp("2","Factory Reset...");
    mqttPayloadProvider.messageFromHw = {};

    Map<String, dynamic> payLoadFinal = {
      "5300": [
        {"5301": "2"},
      ]
    };
    if (MQTTManager().isConnected == true) {
      await validatePayloadSent(
          dialogContext: context,
          context: context,
          mqttPayloadProvider: mqttPayloadProvider,
          acknowledgedFunction: (){},
          payload: payLoadFinal,
          payloadCode: '4202',
          deviceId: widget.deviceID,
          maxWaitTime: 60
      );
    } else {
      GlobalSnackBar.show(context, 'MQTT is Disconnected', 201);
    }

  }
}
