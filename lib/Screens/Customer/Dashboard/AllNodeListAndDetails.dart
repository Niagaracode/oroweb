import 'dart:convert';
import 'package:flutter/material.dart';
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
    print(widget.siteData.master[widget.masterInx].gemLive[0].nodeList.toList());
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
