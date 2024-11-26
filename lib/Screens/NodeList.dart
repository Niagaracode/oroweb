import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Models/Customer/Dashboard/DashboardNode.dart';
import '../constants/theme.dart';
import '../state_management/MqttPayloadProvider.dart';

class CustomerNodeList extends StatefulWidget {
  const CustomerNodeList({Key? key, required this.siteData}) : super(key: key);
  final DashboardModel siteData;

  @override
  State<CustomerNodeList> createState() => _CustomerNodeListState();
}

class _CustomerNodeListState extends State<CustomerNodeList>{

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    final double textSize1 = screenSize.width * 0.024;
    final double textSize2 = screenSize.width * 0.017;

    var provider = Provider.of<MqttPayloadProvider>(context, listen: true);
    try{
      Map<String, dynamic> data = jsonDecode(provider.receivedDashboardPayload);
      /*setState(() {
        if (data['2400'][0].containsKey('2401')) {
          for (var item in data['2400'][0]['2401']) {
            if (item is Map<String, dynamic>) {
              try {
                int position = getNodePositionInNodeList(0, item['SNo']);
                if (position != -1) {
                  widget.siteData.nodeList[position].status = item['Status'];
                  widget.siteData.nodeList[position].batVolt = item['BatVolt'];
                  widget.siteData.nodeList[position].slrVolt = item['SVolt'];
                  widget.siteData.nodeList[position].rlyStatus = [];
                  if (item['RlyStatus'] != null) {
                    List<dynamic> rlyStatusJsonList = item['RlyStatus'];
                    List<RelayStatus> rlyStatusList = rlyStatusJsonList.map((rs) => RelayStatus.fromJson(rs)).toList();
                    widget.siteData.nodeList[position].rlyStatus = rlyStatusList;
                  }

                } else {
                  print('${item['SNo']} The serial number not found');
                }
              } catch (e) {
                print('Error updating node properties: $e');
              }
            }
          }
        }
      });*/
    }
    catch(e){
      print(e);
    }

    return Container(
      width: screenSize.width,
      height: screenSize.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [myTheme.primaryColor, myTheme.primaryColorDark],
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          /*SizedBox(
            height: 50,
            child: Row(
              children: [
                const SizedBox(width: 5),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 5),
                        CircleAvatar(radius: 5, backgroundColor: Colors.green,),
                        SizedBox(width: 5),
                        Text('Connected', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.white))
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 5),
                        CircleAvatar(radius: 5, backgroundColor: Colors.grey),
                        SizedBox(width: 5),
                        Text('No Communication', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.white))
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10),
                        CircleAvatar(radius: 5, backgroundColor: Colors.redAccent,),
                        SizedBox(width: 5),
                        Text('Set Serial Error', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.white))
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        CircleAvatar(radius: 5, backgroundColor: Colors.yellow),
                        SizedBox(width: 5),
                        Text('Low Battery', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.white))
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 40,
                  child: IconButton(
                    tooltip: 'Set serial for all Nodes',
                    icon: const Icon(Icons.format_list_numbered, color: Colors.white),
                    onPressed: () async {
                      String payLoadFinal = jsonEncode({
                        "2300": [
                          {"2301": ""},
                        ]
                      });
                      MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.siteData.deviceId}');
                    },
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: IconButton(
                    tooltip: 'Test Communication',
                    icon: const Icon(Icons.network_check, color: Colors.white),
                    onPressed: () async {
                      *//*String payLoadFinal = jsonEncode({
                        "2300": [
                          {"2301": ""},
                        ]
                      });
                      MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.siteData.deviceId}');*//*
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 325,
              dataRowHeight: 40.0,
              headingRowHeight: 35.0,
              headingRowColor: MaterialStateProperty.all<Color>(primaryColorLight.withOpacity(0.3)),
              columns: [
                DataColumn2(
                    label: Center(child: Text('S.No', style: TextStyle(fontWeight: FontWeight.normal, fontSize: textSize1, color: Colors.white),)),
                    fixedWidth: 35
                ),
                DataColumn2(
                  label: Center(child: Text('Status', style: TextStyle(fontWeight: FontWeight.normal, fontSize: textSize1, color: Colors.white),)),
                  fixedWidth: 55,
                ),
                DataColumn2(
                  label: Center(child: Text('Rf.No', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.white),)),
                  fixedWidth: 45,
                ),
                DataColumn2(
                  label: Text('Category', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.white),),
                  size: ColumnSize.M,
                  numeric: true,
                ),
                DataColumn2(
                  label: Text('Info', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.white),),
                  fixedWidth: 40,
                ),
              ],
              rows: List<DataRow>.generate(widget.siteData.nodeList.length, (index) => DataRow(cells: [
                DataCell(Center(child: Text('${widget.siteData.nodeList[index].serialNumber}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.white),))),
                DataCell(Center(child: CircleAvatar(radius: 7, backgroundColor:
                widget.siteData.nodeList[index].status == 1 ? Colors.green.shade400:
                widget.siteData.nodeList[index].status == 2 ? Colors.grey :
                widget.siteData.nodeList[index].status == 3 ? Colors.redAccent :
                widget.siteData.nodeList[index].status == 4 ? Colors.yellow :
                Colors.grey,
                ))),
                DataCell(Center(child: Text('${widget.siteData.nodeList[index].referenceNumber}', style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white)))),
                DataCell(Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.siteData.nodeList[index].categoryName, style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.white)),
                    Text(widget.siteData.nodeList[index].deviceId, style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 11, color: Colors.white)),
                  ],
                )),
                DataCell(Center(child: IconButton(tooltip: 'View Relay status',
                  icon: widget.siteData.nodeList[index].rlyStatus.any((rly) => rly.Status == 2 || rly.Status == 3)? const Icon(Icons.warning, color: Colors.orangeAccent):
                  const Icon(Icons.info_outline, color: Colors.white), // Icon to display
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: widget.siteData.nodeList[index].rlyStatus.length > 8? 275 : 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                tileColor: myTheme.primaryColor,
                                textColor: Colors.white,
                                leading: const Icon(Icons.developer_board_rounded, color: Colors.white),
                                title: Text('${widget.siteData.nodeList[index].categoryName} - ${widget.siteData.nodeList[index].deviceId}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.solar_power_outlined, color: Colors.white),
                                    const SizedBox(width: 5,),
                                    Text('${widget.siteData.nodeList[index].slrVolt} Volt', style: const TextStyle(fontWeight: FontWeight.normal),),
                                    const SizedBox(width: 5,),
                                    const Icon(Icons.battery_3_bar_rounded, color: Colors.white),
                                    const SizedBox(width: 5,),
                                    Text('${widget.siteData.nodeList[index].batVolt} Volt', style: const TextStyle(fontWeight: FontWeight.normal),),
                                    const SizedBox(width: 5,),
                                    IconButton(tooltip : 'Serial set for all Relay', onPressed: (){
                                      String payLoadFinal = jsonEncode({
                                        "2300": [
                                          {"2301": "${widget.siteData.nodeList[index].serialNumber}"},
                                        ]
                                      });
                                      MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.siteData.deviceId}');
                                    }, icon: Icon(Icons.fact_check_outlined, color: Colors.white))
                                  ],
                                ),
                              ),
                              const Divider(height: 0),
                              SizedBox(
                                width : double.infinity,
                                height : widget.siteData.nodeList[index].rlyStatus.length > 8? 206 : 130,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: widget.siteData.nodeList[index].rlyStatus.isNotEmpty ? Column(
                                    children: [
                                      const SizedBox(
                                        width: double.infinity,
                                        height : 40,
                                        child: Row(
                                          children: [
                                            SizedBox(width: 10),
                                            CircleAvatar(radius: 5,backgroundColor: Colors.green,),
                                            SizedBox(width: 5),
                                            Text('ON'),
                                            SizedBox(width: 20),
                                            CircleAvatar(radius: 5,backgroundColor: Colors.black45),
                                            SizedBox(width: 5),
                                            Text('OFF'),
                                            SizedBox(width: 20),
                                            CircleAvatar(radius: 5,backgroundColor: Colors.orange),
                                            SizedBox(width: 5),
                                            Text('ON IN OFF'),
                                            SizedBox(width: 20),
                                            CircleAvatar(radius: 5,backgroundColor: Colors.redAccent),
                                            SizedBox(width: 5),
                                            Text('OFF IN ON'),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        height : widget.siteData.nodeList[index].rlyStatus.length > 8? 150 : 70,
                                        child: GridView.builder(
                                          itemCount: widget.siteData.nodeList[index].rlyStatus.length, // Number of items in the grid
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 8,
                                            crossAxisSpacing: 10.0,
                                            mainAxisSpacing: 10.0,
                                          ),
                                          itemBuilder: (BuildContext context, int indexGv) {
                                            return Column(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: widget.siteData.nodeList[index].rlyStatus[indexGv].Status==0 ? Colors.grey :
                                                  widget.siteData.nodeList[index].rlyStatus[indexGv].Status==1 ? Colors.green :
                                                  widget.siteData.nodeList[index].rlyStatus[indexGv].Status==2 ? Colors.orange :
                                                  widget.siteData.nodeList[index].rlyStatus[indexGv].Status==3 ? Colors.redAccent : Colors.black12, // Avatar background color
                                                  child: Text((widget.siteData.nodeList[index].rlyStatus[indexGv].RlyNo).toString(), style: const TextStyle(color: Colors.white)),
                                                ),
                                                Text((widget.siteData.nodeList[index].rlyStatus[indexGv].Name).toString(), style: const TextStyle(color: Colors.black, fontSize: 10)),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ) :
                                  const Center(child: Text('Relay Status Not Found')),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ))),
              ])),
            ),
          )*/
        ],
      ),
    );
  }

  int getNodePositionInNodeList(int siteIndex, int srlNo)
  {
    /*List<NodeModel> nodeList = widget.siteData.nodeList;
    for (int i = 0; i < nodeList.length; i++) {
      if (nodeList[i].serialNumber == srlNo) {
        return i;
      }
    }*/
    return -1;
  }

  String getCurrentDate() {
    var now = DateTime.now();
    return DateFormat('MMMM dd, yyyy').format(now);
  }

  String getCurrentTime() {
    var now = DateTime.now();
    return DateFormat('hh:mm:ss').format(now);
  }
}
