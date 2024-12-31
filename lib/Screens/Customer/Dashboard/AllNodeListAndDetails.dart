import 'dart:convert';
import 'dart:js_interop';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:oro_irrigation_new/constants/MyFunction.dart';

import '../../../Models/Customer/Dashboard/DashboardNode.dart';
import '../../../constants/MQTTManager.dart';
import '../../../constants/theme.dart';

class AllNodeListAndDetails extends StatefulWidget {
  const AllNodeListAndDetails({Key? key, required this.userID, required this.customerID, required this.masterInx, required this.siteData}) : super(key: key);
  final int userID, customerID, masterInx;
  final DashboardModel siteData;

  @override
  State<AllNodeListAndDetails> createState() => _AllNodeListAndDetailsState();
}

class _AllNodeListAndDetailsState extends State<AllNodeListAndDetails> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text('Input/Output connection details'),
      ),
      body: MasonryGridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        itemCount: widget.siteData.master[widget.masterInx].gemLive[0].nodeList.length,
        itemBuilder: (context, index) {
          String strInOutCount = getOutputInputCount(widget.siteData.master[widget.masterInx].gemLive[0].nodeList[index].categoryName);
          List<String> parts = strInOutCount.split('_');
          double dynamicHeight = (int.parse(parts[0])+int.parse(parts[1]))*35+100;
          return Tile(
            index: index,
            masterIndex: widget.masterInx,
            extent: dynamicHeight,
            siteData: widget.siteData,
          );
        },
      ),
    );

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text('Input/Output connection details'),
        actions: [
          IconButton(tooltip: 'Set serial for all nodes', onPressed: (){
            /*String payLoadFinal = jsonEncode({
              "2300": [
                {"2301": "${widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].serialNumber}"},
              ]
            });*/
            //MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.siteData.master[widget.masterInx].deviceId}');
          }, icon: const Icon(Icons.format_list_numbered)),
          const SizedBox(width: 5,),
          IconButton(tooltip: 'Test communication', onPressed: (){
            /*String payLoadFinal = jsonEncode({
              "2300": [
                {"2301": "${widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].serialNumber}"},
              ]
            });*/
            //MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.siteData.master[widget.masterInx].deviceId}');
          }, icon: const Icon(Icons.network_check)),
          const SizedBox(width: 10,)
        ],
      ),
      body: ListView(
        children: [
          for (int i = 0; i < widget.siteData.master[widget.masterInx].gemLive[0].nodeList.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  shape: const RoundedRectangleBorder(),
                  surfaceTintColor: Colors.white,
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    tileColor: myTheme.primaryColor.withOpacity(0.1),
                    title: Text(widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].categoryName),
                    subtitle: Text(widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].deviceId),
                    leading: const CircleAvatar(radius:10, backgroundColor: Colors.green,),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.solar_power_outlined),
                        const SizedBox(width: 5,),
                        Text('${widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].sVolt} Volt', style: const TextStyle(fontWeight: FontWeight.normal),),
                        const SizedBox(width: 5,),
                        const Icon(Icons.battery_3_bar_rounded),
                        Text('${widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].batVolt} Volt', style: const TextStyle(fontWeight: FontWeight.normal),),
                        const SizedBox(width: 5,),
                        IconButton(tooltip : 'Serial set', onPressed: (){
                          String payLoadFinal = jsonEncode({
                            "2300": [
                              {"2301": "${widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].serialNumber}"},
                            ]
                          });
                          MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.siteData.master[widget.masterInx].deviceId}');
                        }, icon: const Icon(Icons.fact_check_outlined))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 5),
                        child: Text('Outputs', style: TextStyle(fontSize: 17, color: Colors.teal),),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].rlyStatus.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              surfaceTintColor: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.grey,
                                    child: Text('${widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].rlyStatus[index].rlyNo}', style: const TextStyle(color: Colors.black, fontSize: 12)),
                                  ),
                                  const SizedBox(height: 5,),
                                  Image.asset(getImageForProduct(widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].rlyStatus[index].name!),width: 40, height: 40,),
                                  Text(widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].rlyStatus[index].name!, style: const TextStyle(color: Colors.black, fontSize: 12)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 5, top: 5),
                        child: Text('Inputs', style: TextStyle(fontSize: 17, color: Colors.teal),),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].sensor.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              surfaceTintColor: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /*CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.grey,
                                    child: Text('${widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].sensor[index].id}', style: const TextStyle(color: Colors.black, fontSize: 12)),
                                  ),
                                  const SizedBox(height: 5,),*/

                                  Image.asset(getImageForProduct(widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].sensor[index].name),width: 40, height: 40,),

                                  Container(width: 40, height: 14,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: Colors.yellow,
                                      ),
                                      child: Center(child: Text('${widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].sensor[index].value}', style: const TextStyle(color: Colors.black, fontSize: 10)))
                                  ),
                                  /*Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage: AssetImage(getImageForProduct(widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].sensor[index].Name!)),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      Positioned(
                                        top: 40,
                                        left: 0,
                                        child: Container(width: 40, height: 14,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(3),
                                              color: Colors.yellow,
                                            ),
                                            child: Center(child: Text('${widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].sensor[index].Value}', style: const TextStyle(color: Colors.black, fontSize: 10)))
                                        ),
                                      ),
                                    ],
                                  ),*/
                                  const SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(widget.siteData.master[widget.masterInx].gemLive[0].nodeList[i].sensor[index].name!, style: const TextStyle(color: Colors.black, fontSize: 10)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final int index, masterIndex;
  final double extent;
  final DashboardModel siteData;

  const Tile({
    Key? key,
    required this.index,
    required this.masterIndex,
    required this.extent,
    required this.siteData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String strInOutCount = getOutputInputCount(siteData.master[masterIndex].gemLive[0].nodeList[index].categoryName);
    List<String> parts = strInOutCount.split('_');

    final List<RelayStatus> rlyStatusList = siteData.master[masterIndex].gemLive[0].nodeList[index].rlyStatus;
    final List<SensorStatus> sensorStatusList = siteData.master[masterIndex].gemLive[0].nodeList[index].sensor;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 5,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: SizedBox(
          height: extent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: primaryColorMedium.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                  ),
                ),
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(siteData.master[masterIndex].gemLive[0].nodeList[index].categoryName, style: const TextStyle(fontSize: 13, color: Colors.white),),
                      Text(siteData.master[masterIndex].gemLive[0].nodeList[index].deviceId, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70),),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: int.parse(parts[0])*35+30,
                      child: DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        minWidth: 350,
                        dataRowHeight: 35.0,
                        headingRowHeight: 30.0,
                        headingRowColor: WidgetStateProperty.all<Color>(primaryColorDark.withOpacity(0.1)),
                        columns: const [
                          DataColumn2(
                            label: Text('Output', style: TextStyle(fontSize: 13)),
                            fixedWidth: 70,
                          ),
                          DataColumn2(
                              label: Text('Id', style: TextStyle(fontSize: 13),),
                              size: ColumnSize.S
                          ),
                          DataColumn2(
                              label: Text('Name', style: TextStyle(fontSize: 13),),
                              size: ColumnSize.M
                          ),
                        ],
                        rows: List<DataRow>.generate(int.parse(parts[0]), (index) {

                          final RelayStatus rly = rlyStatusList.firstWhere(
                                (r) => r.rlyNo == (index + 1),
                            orElse: () => RelayStatus(
                              S_No: -1,
                              name: 'N/A',
                              swName: 'N/A',
                              rlyNo: -1,
                              Status: 0,
                            ),
                          );

                          return DataRow(cells: [
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(onPressed: () { }, icon: const Icon(Icons.add_circle, color: Colors.black54,),),
                                Text('${index+1}', style: const TextStyle(fontSize: 10),),
                              ],
                            )),
                            DataCell(Text(rly.rlyNo!=-1?'${rly.name}':'--', style: TextStyle(fontSize: 12),)),
                            DataCell(Text(rly.swName!='N/A'?'${rly.swName}':'--', style: TextStyle(fontSize: 12),)),
                          ]);
                        }),
                      ),
                    ),
                    SizedBox(
                      height: int.parse(parts[1])*35+30,
                      child: DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        minWidth: 350,
                        dataRowHeight: 35.0,
                        headingRowHeight: 30.0,
                        headingRowColor: WidgetStateProperty.all<Color>(primaryColorDark.withOpacity(0.1)),
                        columns: const [
                          DataColumn2(
                            label: Text('Input', style: TextStyle(fontSize: 13)),
                            fixedWidth: 70,
                          ),
                          DataColumn2(
                              label: Text('Id', style: TextStyle(fontSize: 13),),
                              size: ColumnSize.S
                          ),
                          DataColumn2(
                              label: Text('Name', style: TextStyle(fontSize: 13),),
                              size: ColumnSize.M
                          ),
                        ],
                        rows: List<DataRow>.generate(int.parse(parts[1]), (index) {

                          final SensorStatus snr = sensorStatusList.firstWhere(
                                (sr) => sr.angIpNo == (index + 1),
                            orElse: () => SensorStatus(
                              sNo: -1,
                              name: 'N/A',
                              swName: 'N/A',
                              angIpNo: -1,
                              pulseIpNo: -1,
                              value: '',
                              latLong: '',
                            ),
                          );

                          return DataRow(cells: [
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(onPressed: () { }, icon: const Icon(Icons.add_circle, color: Colors.black54,),),
                                Text('${index+1}', style: const TextStyle(fontSize: 10),),
                              ],
                            )),
                            DataCell(Text(snr.angIpNo!=-1?'${snr.name}':'--', style: TextStyle(fontSize: 12),)),
                            DataCell(Text(snr.swName!='N/A'?'${snr.swName}':'--', style: TextStyle(fontSize: 12),)),
                          ]);
                        }),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
