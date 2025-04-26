import 'dart:convert';
import 'dart:js_interop';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
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
                            fixedWidth: 90,
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
                                Text('DO-${index+1}', style: const TextStyle(fontSize: 10),),
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
                            fixedWidth: 90,
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
                                Text('DI-${index+1}', style: const TextStyle(fontSize: 10),),
                              ],
                            )),
                            DataCell(Text(snr.angIpNo!=-1?snr.name:'--', style: TextStyle(fontSize: 12),)),
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
