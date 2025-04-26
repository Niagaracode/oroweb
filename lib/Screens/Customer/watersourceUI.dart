import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oro_irrigation_new/constants/MQTTManager.dart';
import 'package:oro_irrigation_new/constants/http_service.dart';
import 'package:oro_irrigation_new/constants/snack_bar.dart';
import 'package:oro_irrigation_new/constants/theme.dart';
import 'package:oro_irrigation_new/screens/Config/dealer_definition_config.dart';
import 'package:provider/provider.dart';

import '../../Models/WaterSource.dart';
import '../../state_management/MqttPayloadProvider.dart';
import '../../widgets/FontSizeUtils.dart';
import 'IrrigationProgram/program_library.dart';

class watersourceUI extends StatefulWidget {
  const watersourceUI(
      {Key? key,
        required this.userId,
        required this.controllerId,
        required this.deviceID});
  final userId, controllerId, deviceID;

  @override
  State<watersourceUI> createState() => _watersourceUIState();
}

class _watersourceUIState extends State<watersourceUI>
    with SingleTickerProviderStateMixin {
  // late TabController _tabController;
  TimeOfDay _selectedTime = TimeOfDay.now();
  Watersource _watersource = Watersource();
  int tabclickindex = 0;
  List<String> dropdownlist = ["Static", "Flow", "Nominal"];
  final _formKey = GlobalKey<FormState>();
  late MqttPayloadProvider mqttPayloadProvider;

  @override
  void initState() {
    mqttPayloadProvider = Provider.of<MqttPayloadProvider>(context, listen: false);
     super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // _watersource = Watersource.fromJson(json);
    Map<String, Object> body = {
      "userId": widget.userId,
      "controllerId": widget.controllerId
    };
    final response =
    await HttpService().postRequest("getUserPlanningWaterSource", body);
    if (response.statusCode == 200) {
      setState(() {
        var jsondata1 = jsonDecode(response.body);
        _watersource = Watersource.fromJson(jsondata1);
      });
    } else {
      //_showSnackBar(response.body);
    }
  }

  Future<String?> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      _selectedTime = picked;
      final hour = _selectedTime.hour.toString().padLeft(2, '0');
      final minute = _selectedTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    mqttPayloadProvider = Provider.of<MqttPayloadProvider>(context, listen: true);

    if (_watersource.code != 200) {
      return Center(
          child: Text(
              _watersource.message ?? 'Currently No Water source Available'));
    } else if (_watersource.data == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (_watersource.data!.isEmpty) {
      return const Center(child: Text('Currently No Water source Available'));
    }
    {
      return DefaultTabController(
        length: _watersource.data!.length ?? 0,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(left: 8, bottom: 80, right: 8, top: 8),
            child: Center(
              child: Container(
                width: MediaQuery.sizeOf(context).width > 1100
                    ? 1100
                    : MediaQuery.sizeOf(context).width,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        child: TabBar(
                          // controller: _tabController,
                          indicatorColor:
                          const Color.fromARGB(255, 175, 73, 73),
                          isScrollable: true,
                          unselectedLabelColor: Colors.grey,
                          labelColor: myTheme.primaryColor,
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          tabs: [
                            for (var i = 0; i < _watersource.data!.length; i++)
                              Tab(
                                text: '${_watersource.data![i].name}',
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
                      Container(
                        height: 300,
                        // decoration: BoxDecoration(
                        //   border: Border.all(
                        //     color: myTheme.primaryColor, // Border color
                        //     // width: 10.0, // Border width
                        //   ),
                        // ),
                        // decoration: BoxDecoration(
                        //   color: Colors.white.withOpacity(0.1),
                        //   borderRadius: BorderRadius.circular(1.0),
                        //   boxShadow: [
                        //     BoxShadow(
                        //       color: Colors.blueGrey.shade100,
                        //       spreadRadius: 5,
                        //       blurRadius: 7,
                        //       offset: Offset(0, 3),
                        //     ),
                        //   ],
                        // ),
                        child: TabBarView(children: [
                          for (var i = 0; i < _watersource.data!.length; i++)
                            buildTab(
                              _watersource.data![i].source,
                              i,
                              _watersource.data![i].id!,
                              _watersource.data![i].name!,
                            )
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              setState(() {
                updateRadiationSet();
              });
            },
            tooltip: 'Send',
            child: const Icon(Icons.send),
          ),
        ),
      );
    }
  }

  double Changesize(int? count, int val) {
    count ??= 0;
    double size = (count * val).toDouble();
    return size;
  }

  changeval(int Selectindexrow) {}
  Widget buildTab(
      List<Source>? Listofvalue, int i, String sourceid, String sourcename) {
    if (MediaQuery.of(context).size.width > 600) {
      String? dropdownval = Listofvalue?[0].value;
      dropdownlist.contains(dropdownval) == true
          ? dropdownval
          : dropdownval = 'Static';
      return Container(
        child: DataTable2(
            headingRowColor: MaterialStateProperty.all<Color>(primaryColorDark),
            // fixedCornerColor: myTheme.primaryColor,
            columnSpacing: 12,
            horizontalMargin: 12,
            minWidth: 600,
            border: TableBorder.all(width: 0.5),
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
                          color: Colors.white),
                      softWrap: true,
                    )),
              ),
              DataColumn2(
                label: Center(
                    child: Text(
                      'Water Source Name',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: FontSizeUtils.fontSizeHeading(context) ?? 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      softWrap: true,
                    )),
              ),
              DataColumn2(
                fixedWidth: 150,
                label: Center(
                    child: Text(
                      'VALUE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: FontSizeUtils.fontSizeHeading(context) ?? 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      softWrap: true,
                    )),
              ),
            ],
            rows: [
              DataRow(
                  color: MaterialStateProperty.all<Color>(
                      primaryColorDark.withOpacity(0.05)),
                  cells: [
                    DataCell(Center(
                        child: Text(
                          "${Listofvalue?[0].sNo}",
                        ))),
                    DataCell(Text(
                      "${Listofvalue?[0].title}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSizeUtils.fontSizeLabel(context) ?? 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    DataCell(DropdownButton(
                        items: dropdownlist.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(items)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            Listofvalue?[0].value = value!;
                            dropdownval = Listofvalue?[0].value;
                          });
                        },
                        value: Listofvalue?[0].value == ''
                            ? dropdownlist[0]
                            : Listofvalue?[0].value)),
                  ]),
              DataRow(
                  color: MaterialStateProperty.all<Color>(
                      primaryColorDark.withOpacity(0.2)),
                  cells: [
                    DataCell(Center(
                        child: Text(
                          "${Listofvalue?[1].sNo}",
                        ))),
                    DataCell(Text(
                      "${Listofvalue?[1].title}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSizeUtils.fontSizeLabel(context) ?? 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    DataCell(
                      TextFormField(
                        textAlign: TextAlign.center,
                        onChanged: (text) {
                          setState(() {
                            Listofvalue?[1].value = text;
                          });
                        },
                        decoration: InputDecoration(hintText: '0'),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        initialValue: Listofvalue?[1].value == ''
                            ? ''
                            : Listofvalue?[1].value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Warranty is required';
                          } else {
                            setState(() {
                              Listofvalue?[1].value = value;
                            });
                          }
                          return null;
                        },
                      ),
                    ),
                  ]),
              DataRow(
                  color: MaterialStateProperty.all<Color>(
                      primaryColorDark.withOpacity(0.05)),
                  cells: [
                    DataCell(Center(
                        child: Text(
                          "${Listofvalue?[2].sNo}",
                        ))),
                    DataCell(Text(
                      "${Listofvalue?[2].title}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSizeUtils.fontSizeLabel(context) ?? 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    DataCell(
                      TextFormField(
                        textAlign: TextAlign.center,
                        onChanged: (text) {
                          setState(() {
                            Listofvalue?[2].value = text;
                          });
                        },
                        decoration: InputDecoration(hintText: '0'),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        initialValue: Listofvalue?[2].value == ''
                            ? ''
                            : Listofvalue?[2].value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Warranty is required';
                          } else {
                            setState(() {
                              Listofvalue?[2].value = value;
                            });
                          }
                          return null;
                        },
                      ),
                    ),
                  ]),
              DataRow(
                  color: MaterialStateProperty.all<Color>(
                      primaryColorDark.withOpacity(0.2)),
                  cells: [
                    DataCell(Center(
                        child: Text(
                          "${Listofvalue?[3].sNo}",
                        ))),
                    DataCell(Text(
                      "${Listofvalue?[3].title}",
                      style: TextStyle(
                        fontSize: FontSizeUtils.fontSizeLabel(context) ?? 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )),
                    DataCell(
                      TextFormField(
                        textAlign: TextAlign.center,
                        onChanged: (text) {
                          setState(() {
                            Listofvalue?[3].value = text;
                          });
                        },
                        decoration: InputDecoration(hintText: '0'),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        initialValue: Listofvalue?[3].value == ''
                            ? ''
                            : Listofvalue?[3].value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Warranty is required';
                          } else {
                            setState(() {
                              Listofvalue?[3].value = value;
                            });
                          }
                          return null;
                        },
                      ),
                    ),
                  ]),
            ]),
      );
    } else {
      return Column(
        children: [
          Card(
            // elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.1),
            ),
            child: ListTile(
                title: Text(
                  sourcename ?? '',
                  style: TextStyle(
                    fontSize: FontSizeUtils.fontSizeHeading(context) ?? 16,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
                trailing: Text(sourceid ?? '',
                    style: TextStyle(
                        fontSize: FontSizeUtils.fontSizeHeading(context) ?? 16,
                        fontWeight: FontWeight.bold))),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: Listofvalue?.length ?? 0,
              itemBuilder: (context, index) {
                if (Listofvalue?[index].widgetTypeId == 1) {
                  return Column(
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 0.1,
                        child: ListTile(
                          title: Text('${Listofvalue?[index].title}',
                              style: TextStyle(
                                fontSize:
                                FontSizeUtils.fontSizeLabel(context) ?? 16,
                                fontWeight: FontWeight.bold,
                              )),
                          trailing: SizedBox(
                              width: 100,
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                onChanged: (text) {
                                  setState(() {
                                    Listofvalue?[index].value = text;
                                  });
                                },
                                decoration: InputDecoration(hintText: '0'),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                initialValue: Listofvalue?[index].value == ''
                                    ? ''
                                    : Listofvalue?[index].value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Warranty is required';
                                  } else {
                                    setState(() {
                                      Listofvalue?[index].value = value;
                                    });
                                  }
                                  return null;
                                },
                              )),
                        ),
                      ),
                    ],
                  );
                } else if (Listofvalue?[index].widgetTypeId == 2) {
                  return Column(
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 0.1,
                        child: ListTile(
                          title: Text('${Listofvalue?[index].title}',
                              style: TextStyle(
                                fontSize:
                                FontSizeUtils.fontSizeLabel(context) ?? 16,
                                fontWeight: FontWeight.bold,
                              )),
                          trailing: MySwitch(
                            value: Listofvalue?[index].value == '1',
                            onChanged: ((value) {
                              setState(() {
                                Listofvalue?[index].value = !value ? '0' : '1';
                              });
                              // Listofvalue?[index].value = value;
                            }),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (Listofvalue?[index].widgetTypeId == 3) {
                   String? dropdownval = Listofvalue?[index].value;
                  dropdownlist.contains(dropdownval) == true
                      ? dropdownval
                      : dropdownval = 'Static';
                   return Column(
                    children: [
                      Container(
                        child: Card(
                          color: Colors.white,
                          elevation: 0.1,
                          child: ListTile(
                            title: Text('${Listofvalue?[index].title}',
                                style: TextStyle(
                                  fontSize:
                                  FontSizeUtils.fontSizeLabel(context) ??
                                      16,
                                  fontWeight: FontWeight.bold,
                                )),
                            trailing: Container(
                              color: Colors.white70,
                              width: 100,
                              child: DropdownButton(
                                  items: dropdownlist.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(items)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      Listofvalue?[index].value = value!;
                                      dropdownval = Listofvalue?[index].value;
                                    });
                                  },
                                  value: Listofvalue?[index].value == ''
                                      ? dropdownlist[0]
                                      : Listofvalue?[index].value),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (Listofvalue?[index].widgetTypeId == 5) {
                  String? dropdownval = Listofvalue?[index].value;
                  return Column(
                    children: [
                      Card(
                        color: Colors.white,
                        child: ListTile(
                          title: Text('${Listofvalue?[index].title}',
                              style: TextStyle(
                                fontSize:
                                FontSizeUtils.fontSizeLabel(context) ?? 16,
                                fontWeight: FontWeight.bold,
                              )),
                          trailing: SizedBox(
                            width: 100,
                            child: Container(
                                child: Center(
                                  child: InkWell(
                                    child: Text(
                                      '${Listofvalue?[index].value}' != ''
                                          ? '${Listofvalue?[index].value}'
                                          : '00:00',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    onTap: () async {
                                      String? time = await _selectTime(context);
                                      setState(() {
                                        if (time != null) {
                                          Listofvalue?[index].value = time;
                                        }
                                      });
                                    },
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [Container()],
                  );
                }
              },
            ),
          ),
        ],
      );
    }
  }

  updateRadiationSet() async {

    List<Map<String, dynamic>> waterSource =
    _watersource.data!.map((condition) => condition.toJson()).toList();
    String mqttSendData = toMqttformat(_watersource.data);

    Map<String, dynamic> payLoadFinal = {
      "1600": [
        {"1601": mqttSendData},
      ]
    };
    Map<String, dynamic> body = {
      "userId": widget.userId,
      "controllerId": widget.controllerId,
      "waterSource": {"waterSource": waterSource,"controllerReadStatus": "0"},
      "hardware": payLoadFinal,
      "createUser": widget.userId
    };


    if (MQTTManager().isConnected == true) {
      await validatePayloadSent(
          dialogContext: context,
          context: context,
          mqttPayloadProvider: mqttPayloadProvider,
          acknowledgedFunction: () async{
            setState(() {
              body["waterSource"]["controllerReadStatus"] = "1";
            });
            final response = await HttpService()
                .postRequest("createUserPlanningWaterSource", body);
            final jsonDataResponse = json.decode(response.body);
            GlobalSnackBar.show(
                context, jsonDataResponse['message'], response.statusCode);
          },
          payload: payLoadFinal,
          payloadCode: '1600',
          deviceId: widget.deviceID
      );
    } else {
      GlobalSnackBar.show(context, 'MQTT is Disconnected', 201);
    }
  }


  String toMqttformat(
      List<Datum>? data,
      ) {
    String Mqttdata = '';
    for (var i = 0; i < data!.length; i++) {
      int sno = data[i].sNo!;
      String id = '${data[i].id!}';
      List<String> time = [];
      String name = '${data[i].name}';
      // String line = '${data[i].source}';
      String mode = '0';
      if (data[i].source![0].value!! == 'Static') {
        mode = '0';
      } else if (data[i].source![0].value!! == 'Flow') {
        mode = '1';
      } else if (data[i].source![0].value!! == 'Nominal') {
        mode = '2';
      } else {
        mode = '0';
      }

      String Pump =
      data[i].source![1].value!.isEmpty ? '0' : data[i].source![1].value!;
      String line = data[i].source![2].value!.isEmpty
          ? '0'
          : '${data[i].source![2].value!}';
      String flow = data[i].source![3].value!.isEmpty
          ? '0'
          : '${data[i].source![3].value!}';
      Mqttdata += '$sno,$name,$Pump,$line,$flow,$mode;';
    }
    return Mqttdata;
  }
}
