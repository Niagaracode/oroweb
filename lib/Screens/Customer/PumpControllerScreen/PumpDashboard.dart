import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oro_irrigation_new/Screens/Customer/IrrigationProgram/schedule_screen.dart';
import 'package:oro_irrigation_new/Screens/Customer/PumpControllerScreen/PumpControllerSettings.dart';
import 'package:oro_irrigation_new/state_management/overall_use.dart';
import 'package:provider/provider.dart';

import '../../../Models/Customer/Dashboard/DashboardNode.dart';
import '../../../constants/MQTTManager.dart';
import '../../../constants/MyFunction.dart';
import '../Dashboard/SentAndReceived.dart';

import '../Logs/hourly_data.dart';
import '../Logs/pump_log.dart';
import '../PumpControllerScreens/pump_controller_dashboard.dart';

class PumpDashboard extends StatefulWidget {
  const PumpDashboard({Key? key, required this.siteData, required this.masterIndex, required this.customerId, required this.dealerId, required this.siteIndex}) : super(key: key);
  final DashboardModel siteData;
  final int customerId, masterIndex, siteIndex;
  final int dealerId;

  @override
  State<PumpDashboard> createState() => _PumpDashboardState();
}

class _PumpDashboardState extends State<PumpDashboard> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  late OverAllUse overAllUse;

  String valR = '000',valY = '000', valB = '000';
  String cVersion = '';
  int wifiStrength = 0;
  int batVolt = 0;

  Map<String, double> rybCurrentValues = {};
  List<CMType1> pumpList = [];


  //late List<ChartSampleData> chartData;

  // const actionForGeneral = "getUserPreferenceGeneral";
  // const actionForNotification = "getUserPreferenceNotification";
  // const actionForSetting = "getUserPreferenceSetting";
  // const actionForUserPassword = "checkUserUsingUserIdAndPassword";
  // const actionForCalibration = "getUserPreferenceCalibration";


  @override
  void initState() {
    super.initState();
    overAllUse = Provider.of<OverAllUse>(context, listen: false);
    _tabController = TabController(length: 4, vsync: this);
    syncLive();
  }

  void refreshCurrentTab() {
    setState(() {
      // Just calling setState will rebuild the current tab
    });
  }


  void syncLive() {
    String livePayload = jsonEncode({"sentSMS": "#live"});
    Future.delayed(const Duration(seconds: 3), () {
      MQTTManager().publish(livePayload,
          'AppToFirmware/${widget.siteData.master[widget.masterIndex].deviceId}');
    });
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    overAllUse = Provider.of<OverAllUse>(context, listen: true);
    // if (widget.siteData.master[widget.masterIndex].pumpLive[3] is CMType2) {
    //   List<String> rybValue = (widget.siteData.master[widget.masterIndex].pumpLive[3] as CMType2).v!.split(',');
    //   valR = rybValue[0];
    //   valY = rybValue[1];
    //   valB = rybValue[2];
    //   cVersion = (widget.siteData.master[widget.masterIndex].pumpLive[3] as CMType2).vs!;
    //
    //   wifiStrength = (widget.siteData.master[widget.masterIndex].pumpLive[3] as CMType2).ss!;
    //   batVolt = (widget.siteData.master[widget.masterIndex].pumpLive[3] as CMType2).b!;
    //
    //   pumpList = widget.siteData.master[widget.masterIndex].pumpLive.whereType< CMType1>().cast<CMType1>().toList();
    //
    //
    //   String cValue = (widget.siteData.master[widget.masterIndex].pumpLive[3] as CMType2).c!;
    //   List<String> values = cValue.split(',');
    //   for (var value in values) {
    //     var parts = value.split(':');
    //     if (parts.length == 2) {
    //       rybCurrentValues[parts[0]] = double.parse(parts[1]);
    //     }
    //   }
    //   refreshCurrentTab();
    // }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          // Card(
          //   elevation: 8,
          //   surfaceTintColor: Colors.white,
          //   shape: const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.zero,
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.all(5),
          //     child: Column(
          //       children: [
          //         SizedBox(
          //           width: 300,
          //           height: 40,
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               SizedBox(
          //                 width: 70,
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   crossAxisAlignment: CrossAxisAlignment.center,
          //                   children: [
          //                     Icon(wifiStrength == 0 ? Icons.wifi_off :
          //                     wifiStrength >= 1 && wifiStrength <= 20 ? Icons
          //                         .network_wifi_1_bar_outlined :
          //                     wifiStrength >= 21 && wifiStrength <= 40 ? Icons
          //                         .network_wifi_2_bar_outlined :
          //                     wifiStrength >= 41 && wifiStrength <= 60 ? Icons
          //                         .network_wifi_3_bar_outlined :
          //                     wifiStrength >= 61 && wifiStrength <= 80 ? Icons
          //                         .network_wifi_3_bar_outlined :
          //                     Icons.wifi, color: Colors.black,),
          //                     const SizedBox(width: 5,),
          //                     Text('$wifiStrength%'),
          //                   ],
          //                 ),
          //               ),
          //               MaterialButton(
          //                 color: Colors.green,
          //                 textColor: Colors.white,
          //                 onPressed: () {
          //                   String livePayload = jsonEncode(
          //                       {"sentSMS": "#live"});
          //                   MQTTManager().publish(livePayload,
          //                       'AppToFirmware/${widget.siteData.master[widget
          //                           .masterIndex].deviceId}');
          //                 },
          //                 child: const Text('Refresh'),
          //               ),
          //             ],
          //           ),
          //         ),
          //         const SizedBox(height: 5,),
          //         Container(
          //           width: 300,
          //           height: 30,
          //           decoration: BoxDecoration(
          //             color: Colors.green.shade50,
          //             border: Border.all(
          //               color: Colors.green,
          //               width: 0.5,
          //             ),
          //             borderRadius: BorderRadius.circular(2),
          //           ),
          //           child: SizedBox(
          //             width: 250,
          //             height: 30,
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: [
          //                 Flexible(flex: 1, child: Container(
          //                   color: Colors.red.shade100,
          //                   child: Center(child: Text('R : $valR V')),
          //                 )),
          //                 Flexible(flex: 1, child: Container(
          //                   color: Colors.yellow.shade100,
          //                   child: Center(child: Text('Y : $valY V')),
          //                 )),
          //                 Flexible(flex: 1, child: Container(
          //                   color: Colors.blue.shade100,
          //                   child: Center(child: Text('B : $valB V')),
          //                 )),
          //               ],
          //             ),
          //           ),
          //         ),
          //         const SizedBox(height: 5,),
          //         SizedBox(
          //           width: 300,
          //           height: MediaQuery.sizeOf(context).height - 190,
          //           child: ListView.builder(
          //             itemCount: pumpList.length,
          //             itemBuilder: (context, index) {
          //               List<String> floatVal = pumpList[index].ft!.split(':');
          //               return Column(
          //                 children: [
          //                   Container(
          //                     decoration: BoxDecoration(
          //                       color: Colors.white,
          //                       border: Border.all(
          //                         color: Colors.teal.shade100,
          //                         width: 0.9,
          //                       ),
          //                       borderRadius: BorderRadius.circular(2),
          //                     ),
          //                     child: Column(
          //                       children: [
          //                         Container(
          //                           width: 300,
          //                           height: 32,
          //                           color: Colors.teal.shade100,
          //                           child: Row(
          //                             children: [
          //                               Expanded(
          //                                 child: Padding(
          //                                   padding: const EdgeInsets.only(left: 5),
          //                                   child: Text(pumpList[index].rn!!=0? getContentByCode(pumpList[index].rn!):'',
          //                                     style: const TextStyle(fontSize: 10),),
          //                                 ),
          //                               ),
          //                               VerticalDivider(color: Colors.teal.shade200,),
          //                               SizedBox(
          //                                 width: 50,
          //                                 child: Center(child: Text(
          //                                   '${index==0?'Rc':index==1?'Yc':'Bc'} : ${rybCurrentValues['${index+1}']}',
          //                                   style: const TextStyle(fontSize: 11),)),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                         SizedBox(
          //                           width: 300,
          //                           height: 75,
          //                           child: Padding(
          //                             padding: const EdgeInsets.only(top: 5),
          //                             child: Row(
          //                               mainAxisAlignment: MainAxisAlignment
          //                                   .center,
          //                               children: [
          //                                 Center(child: Image(image: AssetImage(
          //                                     pumpList[index].st == 1
          //                                         ? "assets/GifFile/motor_on_new.gif"
          //                                         : "assets/GifFile/motor_off_new.gif"),
          //                                   width: 75,)),
          //                                 const SizedBox(width: 30,),
          //                                 Material(
          //                                   elevation: 8.0,
          //                                   // Add shadow elevation
          //                                   shape: const CircleBorder(),
          //                                   // Ensure the shadow has the same shape as the CircleAvatar
          //                                   child: CircleAvatar(
          //                                     radius: 22.0,
          //                                     backgroundColor: Colors.green,
          //                                     child: IconButton(tooltip: 'Start',
          //                                         onPressed: () {
          //                                           String onPayload = jsonEncode(
          //                                               {
          //                                                 "sentSMS": "MOTOR${index +
          //                                                     1}ON"
          //                                               });
          //                                           MQTTManager().publish(
          //                                               onPayload,
          //                                               'AppToFirmware/${widget
          //                                                   .siteData
          //                                                   .master[widget
          //                                                   .masterIndex]
          //                                                   .deviceId}');
          //                                         },
          //                                         icon: const Icon(
          //                                           Icons.power_settings_new,
          //                                           color: Colors.white,)),
          //                                   ),
          //                                 ),
          //                                 const SizedBox(width: 10,),
          //                                 Material(
          //                                   elevation: 8.0,
          //                                   // Add shadow elevation
          //                                   shape: const CircleBorder(),
          //                                   // Ensure the shadow has the same shape as the CircleAvatar
          //                                   child: CircleAvatar(
          //                                     radius: 22.0,
          //                                     backgroundColor: Colors.redAccent,
          //                                     child: IconButton(
          //                                         tooltip: 'Stop',
          //                                         onPressed: () {
          //                                           String onPayload = jsonEncode(
          //                                               {
          //                                                 "sentSMS": "MOTOR${index +
          //                                                     1}OF"
          //                                               });
          //                                           MQTTManager().publish(
          //                                               onPayload,
          //                                               'AppToFirmware/${widget
          //                                                   .siteData
          //                                                   .master[widget
          //                                                   .masterIndex]
          //                                                   .deviceId}');
          //                                         },
          //                                         icon: const Icon(
          //                                           Icons.power_settings_new,
          //                                           color: Colors.white,)),
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                         ),
          //                         SizedBox(
          //                           width: 300,
          //                           height: 100,
          //                           child: Column(
          //                             children: [
          //                               Flexible(
          //                                 flex: 1,
          //                                 child: Padding(
          //                                   padding: const EdgeInsets.only(
          //                                       left: 15, right: 15, top: 10),
          //                                   child: Row(
          //                                     mainAxisAlignment: MainAxisAlignment
          //                                         .spaceBetween,
          //                                     children: [
          //                                       Column(
          //                                         children: [
          //                                           pumpList[index].ft ==
          //                                               '-:-:-:-' ? const Text(
          //                                               '--') :
          //                                           Row(
          //                                             children: [
          //                                               Text('${floatVal[0]}%',
          //                                                 style: const TextStyle(
          //                                                     fontSize: 14,
          //                                                     fontWeight: FontWeight
          //                                                         .normal),),
          //                                               const Text(' | ',
          //                                                 style: TextStyle(
          //                                                     fontWeight: FontWeight
          //                                                         .normal,
          //                                                     fontSize: 14,
          //                                                     color: Colors
          //                                                         .teal),),
          //                                               Text('${floatVal[1]}%',
          //                                                 style: const TextStyle(
          //                                                     fontSize: 14,
          //                                                     fontWeight: FontWeight
          //                                                         .normal),),
          //                                               const Text(' | ',
          //                                                 style: TextStyle(
          //                                                     fontWeight: FontWeight
          //                                                         .normal,
          //                                                     fontSize: 14,
          //                                                     color: Colors
          //                                                         .teal),),
          //                                               Text('${floatVal[2]}%',
          //                                                 style: const TextStyle(
          //                                                     fontSize: 14,
          //                                                     fontWeight: FontWeight
          //                                                         .normal),),
          //                                               const Text(' | ',
          //                                                 style: TextStyle(
          //                                                     fontWeight: FontWeight
          //                                                         .normal,
          //                                                     fontSize: 14,
          //                                                     color: Colors
          //                                                         .teal),),
          //                                               Text('${floatVal[3]}%',
          //                                                 style: const TextStyle(
          //                                                     fontSize: 14,
          //                                                     fontWeight: FontWeight
          //                                                         .normal),),
          //                                             ],
          //                                           ),
          //                                           const Text('Float Status',
          //                                             style: TextStyle(
          //                                                 color: Colors.grey,
          //                                                 fontWeight: FontWeight
          //                                                     .normal),),
          //                                         ],
          //                                       ),
          //                                       Column(
          //                                         children: [
          //                                           Text(pumpList[index].lv == '-'
          //                                               ? '--'
          //                                               : '${pumpList[index]
          //                                               .lv} %',
          //                                             style: const TextStyle(
          //                                                 fontSize: 14,
          //                                                 fontWeight: FontWeight
          //                                                     .normal),),
          //                                           const Text('Level',
          //                                             style: TextStyle(
          //                                                 color: Colors.grey,
          //                                                 fontWeight: FontWeight
          //                                                     .normal),),
          //                                         ],
          //                                       ),
          //                                       Column(
          //                                         children: [
          //                                           Text('${pumpList[index].ph}',
          //                                             style: const TextStyle(
          //                                                 fontSize: 14,
          //                                                 fontWeight: FontWeight
          //                                                     .normal),),
          //                                           const Text('Phase',
          //                                             style: TextStyle(
          //                                                 color: Colors.grey,
          //                                                 fontWeight: FontWeight
          //                                                     .normal),),
          //                                         ],
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 ),
          //                               ),
          //                               Flexible(
          //                                 flex: 1,
          //                                 child: Padding(
          //                                   padding: const EdgeInsets.only(
          //                                       left: 20, right: 20),
          //                                   child: Row(
          //                                     mainAxisAlignment: MainAxisAlignment
          //                                         .spaceBetween,
          //                                     children: [
          //                                       Column(
          //                                         crossAxisAlignment: CrossAxisAlignment
          //                                             .center,
          //                                         mainAxisAlignment: MainAxisAlignment
          //                                             .center,
          //                                         children: [
          //                                           Text(pumpList[index].pr == '-'
          //                                               ? '--'
          //                                               : '${pumpList[index]
          //                                               .pr}/bar',
          //                                             style: const TextStyle(
          //                                                 fontSize: 14,
          //                                                 fontWeight: FontWeight
          //                                                     .normal),),
          //                                           const Text('Pressure',
          //                                             style: TextStyle(
          //                                                 color: Colors.grey,
          //                                                 fontWeight: FontWeight
          //                                                     .normal),),
          //                                         ],
          //                                       ),
          //                                       Column(
          //                                         crossAxisAlignment: CrossAxisAlignment
          //                                             .center,
          //                                         mainAxisAlignment: MainAxisAlignment
          //                                             .center,
          //                                         children: [
          //                                           Text(pumpList[index].wm == '-'
          //                                               ? '--'
          //                                               : '${pumpList[index]
          //                                               .wm}/bar',
          //                                             style: const TextStyle(
          //                                                 fontSize: 14,
          //                                                 fontWeight: FontWeight
          //                                                     .normal),),
          //                                           const Text('Flow rate',
          //                                             style: TextStyle(
          //                                                 color: Colors.grey,
          //                                                 fontWeight: FontWeight
          //                                                     .normal),),
          //                                         ],
          //                                       ),
          //                                       Column(
          //                                         crossAxisAlignment: CrossAxisAlignment
          //                                             .center,
          //                                         mainAxisAlignment: MainAxisAlignment
          //                                             .center,
          //                                         children: [
          //                                           Text(pumpList[index].cf == '-'
          //                                               ? '--'
          //                                               : '${pumpList[index]
          //                                               .cf}/Lts',
          //                                             style: const TextStyle(
          //                                                 fontSize: 14,
          //                                                 fontWeight: FontWeight
          //                                                     .normal),),
          //                                           const Text('C-Flow',
          //                                             style: TextStyle(
          //                                                 color: Colors.grey,
          //                                                 fontWeight: FontWeight
          //                                                     .normal),),
          //                                         ],
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                   const SizedBox(height: 5,),
          //                 ],
          //               );
          //             },
          //           ),
          //         ),
          //         const Divider(thickness: 0.3,),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             const Text('Version : ',
          //               style: TextStyle(fontWeight: FontWeight.normal),),
          //             Text(cVersion,
          //               style: const TextStyle(fontWeight: FontWeight.bold),),
          //           ],
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          Container(
            decoration: const BoxDecoration(
              color: cardColor
            ),
            width: 400,
            child: overAllUse.showTab ? PumpControllerDashboard(
              userId: widget.customerId,
              deviceId: widget.siteData.master[widget.masterIndex].deviceId,
              controllerId: widget.siteData.master[widget.masterIndex].controllerId,
              selectedSite: widget.siteIndex,
              selectedMaster: widget.masterIndex,
            ) : const Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator())),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width-400,
            height: double.infinity,
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.teal,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Row(
                        children: [
                          Icon(Icons.auto_graph),
                          SizedBox(width: 5,),
                          Tab(text: 'Power & Motor'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.question_answer_outlined),
                          SizedBox(width: 5,),
                          Tab(text: 'Sent & Received'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.report_gmailerrorred),
                          SizedBox(width: 5,),
                          Tab(text: 'Pump log'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.settings_outlined),
                          SizedBox(width: 5,),
                          Tab(text: 'Settings'),
                        ],
                      ),
                    ],
                  ),
                  // Expanded(
                  //   child: TabBarView(
                  //     controller: _tabController,
                  //     children: [
                  //       const Center(child: Text('Tab 1 Content')),
                  //       SentAndReceived(customerID: widget.customerId,
                  //         controllerId: widget.siteData.master[widget
                  //             .masterIndex].controllerId,
                  //         from: 'Pump',),
                  //       PumpLogScreen(customerId: widget.customerId, controllerId: widget.siteData.master[widget.masterIndex].controllerId,),
                  //       PumpControllerSettings(customerId: widget.customerId, controllerId: widget.siteData.master[widget.masterIndex].controllerId, adDrId: widget.dealerId,),
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          overAllUse.showTab
                              ? HourlyData(userId: widget.customerId, controllerId: widget.siteData.master[widget.masterIndex].controllerId,)
                              : const Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator())),
                          overAllUse.showTab ? SentAndReceived(customerID: widget.customerId,
                            controllerId: widget.siteData.master[widget
                                .masterIndex].controllerId,
                            from: 'Pump',) : const Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator())),
                          overAllUse.showTab
                              ? NewPumpLogScreen(userId: widget.customerId, controllerId: widget.siteData.master[widget.masterIndex].controllerId,)
                              : const Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator())),
                          overAllUse.showTab
                              ? PumpControllerSettings(customerId: widget.customerId, controllerId: widget.siteData.master[widget.masterIndex].controllerId, adDrId: widget.dealerId,)
                              : const Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator())),
                        ],
                      )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getContentByCode(int code) {
    return PumpReasonCode.fromCode(code).content;
  }

}


