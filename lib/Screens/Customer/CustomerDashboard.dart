import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oro_irrigation_new/screens/Customer/Dashboard/NextSchedule.dart';
import 'package:oro_irrigation_new/screens/Customer/Dashboard/ScheduledProgramList.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
 import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../Models/Customer/Dashboard/DashboardNode.dart';
import '../../Models/Customer/SensorHourlyData.dart';
import '../../constants/MQTTManager.dart';
import '../../constants/MyFunction.dart';
import '../../constants/http_service.dart';
import '../../constants/snack_bar.dart';
import '../../state_management/MqttPayloadProvider.dart';
import 'Dashboard/CurrentSchedule.dart';
import 'Dashboard/DisplayAllLine.dart';
import 'Dashboard/PumpLineCentral.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({Key? key, required this.userId, required this.type, required this.customerName, required this.mobileNo, required this.siteData, required this.masterInx, required this.lineIdx, required this.customerId}) : super(key: key);
  final int userId, customerId, type, masterInx, lineIdx;
  final String customerName, mobileNo;
  final DashboardModel siteData;

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  late IrrigationLine crrIrrLine;
  int wifiStrength = 0, siteIndex = 0;
  List<RelayStatus> rlyStatusList = [];
  bool showNoHwCm = false;

  int? getIrrigationPauseFlag(String line, List<IrrigationLinePLD> payload2408) {
    for (var data in payload2408) {
      if (data.line == line) {
        return data.irrigationPauseFlag;
      }
    }
    return null;
  }

  String getContentByCode(int code) {
    return GemLineSSReasonCode.fromCode(code).content;
  }


  @override
  Widget build(BuildContext context) {

    if(widget.siteData.master[widget.masterInx].irrigationLine.isNotEmpty){
      crrIrrLine = widget.siteData.master[widget.masterInx].irrigationLine[widget.lineIdx];
    }else{
      print('irrigation line empty');
    }

    if(widget.siteData.master[widget.masterInx].irrigationLine.isNotEmpty){
      MqttPayloadProvider provider = Provider.of<MqttPayloadProvider>(context, listen: false);

      try{
        for (var items in provider.nodeList) {
          if (items is Map<String, dynamic>){
            try {
              int position = getNodePositionInNodeList(widget.masterInx, items['DeviceId']);
              if (position != -1) {

                //output relay
                List<dynamic> rlyStatus = items['RlyStatus'];

                Map<int, int> rlyStatusMap = {};
                try{
                  rlyStatusMap = {for (var item in rlyStatus) item['S_No']:item['Status']};
                }catch(e){
                  rlyStatusMap = {for (var item in rlyStatus) item.S_No:item.Status};
                }

                //input
                List<dynamic> sensorStatus = items['Sensor'];
                Map<int, dynamic> sensorStatusMap = {};
                try{
                  sensorStatusMap = {for (var item in sensorStatus) item['S_No']:item['Value']};
                }catch(e){
                  sensorStatusMap = {for (var item in sensorStatus) item.sNo:item.value};
                }

                for (var line in widget.siteData.master[widget.masterInx].irrigationLine) {
                  // Update mainValves
                  for (var mainValve in line.mainValve) {
                    if (rlyStatusMap.containsKey(mainValve.sNo)) {
                      mainValve.status = rlyStatusMap[mainValve.sNo]!;
                    }
                  }
                  // Update valves
                  for (var valve in line.valve) {
                    if (rlyStatusMap.containsKey(valve.sNo)) {
                      valve.status = rlyStatusMap[valve.sNo]!;
                    }
                  }

                  if(sensorStatus.isNotEmpty)
                  {
                    // Update Water Meter
                    for (var wm in line.waterMeter) {
                      if (sensorStatusMap.containsKey(wm.sNo)) {
                        wm.value = sensorStatusMap[wm.sNo] ?? '0';
                      }
                    }

                    // Update Pressure Sensor
                    for (var ls in line.levelSensor) {
                      if (sensorStatusMap.containsKey(ls.sNo)) {
                        ls.value = sensorStatusMap[ls.sNo] ?? '0';
                      }
                    }
                    updateSensorValues(line.pressureSensor, sensorStatusMap);
                    updateSensorValues(line.moistureSensor, sensorStatusMap);
                  }
                }
                Provider.of<MqttPayloadProvider>(context).nodeConnection(true);
              }else{
                if(items['SNo']!=0){
                  //print(items['DeviceId']);
                  Provider.of<MqttPayloadProvider>(context).nodeConnection(false);
                }
              }
            } catch (e) {
              print('Error updating node properties: $e');
            }
          }
        }
        setState(() {
          crrIrrLine;
        });
      }
      catch(e){
        print(e);
      }

      if(widget.siteData.master[widget.masterInx].irrigationLine[widget.lineIdx].sNo==0 || widget.siteData.master[widget.masterInx].irrigationLine.length==1){
        return Column(
          children: [
            provider.liveSync? stoppedAnimation(): const SizedBox(),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    DisplayAllLine(currentMaster: (widget.siteData.master[widget.masterInx]), provider: provider, userId: widget.userId, customerId: widget.siteData.customerId,),
                    provider.currentSchedule.isNotEmpty? CurrentSchedule(siteData: widget.siteData, userId: widget.userId, currentSchedule: provider.currentSchedule,):
                    const SizedBox(),
                    provider.programQueue.isNotEmpty? NextSchedule(siteData: widget.siteData, userID: widget.userId, customerID: widget.siteData.customerId, programQueue: provider.programQueue,):
                    const SizedBox(),
                    provider.scheduledProgram.isNotEmpty? ScheduledProgramList(siteData: widget.siteData, userId: widget.userId, scheduledPrograms: provider.scheduledProgram, masterInx: widget.masterInx,):
                    const SizedBox(),
                    const SizedBox(height: 8,),
                  ],
                ),
              ),
            ),
          ],
        );
      }else{
        int? irrigationFlag = 0;
        final filteredScheduledPrograms = filterProgramsByCategory(Provider.of<MqttPayloadProvider>(context).scheduledProgram, crrIrrLine.id);
        final filteredProgramsQueue = filterProgramsQueueByCategory(Provider.of<MqttPayloadProvider>(context).programQueue, crrIrrLine.id);
        final filteredCurrentSchedule = filterCurrentScheduleByCategory(Provider.of<MqttPayloadProvider>(context).currentSchedule, crrIrrLine.id);
        filteredCurrentSchedule.insertAll(0, filterCurrentScheduleByProgramName(Provider.of<MqttPayloadProvider>(context).currentSchedule, 'StandAlone - Manual'));
        if(Provider.of<MqttPayloadProvider>(context).payloadIrrLine.isNotEmpty){
          irrigationFlag = getIrrigationPauseFlag(crrIrrLine.id, Provider.of<MqttPayloadProvider>(context).payloadIrrLine);
        }

        return Column(
          children: [
            irrigationFlag !=0? Padding(
              padding: const EdgeInsets.only(left: 3, right: 3),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade300,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(4),topLeft: Radius.circular(4)),
                ),
                width: MediaQuery.sizeOf(context).width,
                height: 20,
                child: Center(
                  child: Text(getContentByCode(irrigationFlag!).toUpperCase(),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),),
                ),
              ),
            ):
            const SizedBox(),
            provider.liveSync? stoppedAnimation(): const SizedBox(),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildWideLayout(provider, irrigationFlag!),
                    filteredCurrentSchedule.isNotEmpty? CurrentSchedule(siteData: widget.siteData, userId: widget.userId, currentSchedule: filteredCurrentSchedule,):
                    const SizedBox(),
                    filteredProgramsQueue.isNotEmpty? NextSchedule(siteData: widget.siteData, userID: widget.userId, customerID: widget.siteData.customerId, programQueue: filteredProgramsQueue,):
                    const SizedBox(),
                    filteredScheduledPrograms.isNotEmpty? ScheduledProgramList(siteData: widget.siteData, userId: widget.userId, scheduledPrograms: filteredScheduledPrograms, masterInx: widget.masterInx,):
                    const SizedBox(),
                    const SizedBox(height: 8,),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    }
    else{
      return const Center(child: Text('Site not configure'));
    }
  }

  void updateSensorValues(List<SensorModel> sensors, Map<int, dynamic> sensorStatusMap) {
    for (var sensor in sensors) {
      if (sensorStatusMap.containsKey(sensor.sNo)) {
        var value = sensorStatusMap[sensor.sNo];
        sensor.value = value ?? '0';
      }
    }
  }

  Widget stoppedAnimation() {
    return Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: LinearProgressIndicator(
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        backgroundColor: Colors.grey[200],
        minHeight: 4,
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }

  Widget buildWideLayout(MqttPayloadProvider provider, int irrigationFlag) {

    if(provider.centralFertilizer.isEmpty && provider.localFertilizer.isEmpty){

      List<Map<String, dynamic>> filteredSrcPumps = provider.sourcePump
          .where((pump) => crrIrrLine.id == 'all' || pump.location.contains(crrIrrLine.id))
          .toList()
          .cast<Map<String, dynamic>>();

      List<Map<String, dynamic>> filteredIrrPumps = provider.irrigationPump
          .where((pump) => crrIrrLine.id == 'all' || pump.location.contains(crrIrrLine.id))
          .toList()
          .cast<Map<String, dynamic>>();

      List<Map<String, dynamic>> filteredCentralFilter = provider.centralFilter
          .where((pump) => crrIrrLine.id == 'all' || pump['Location'].contains(crrIrrLine.id))
          .toList()
          .cast<Map<String, dynamic>>();

      int filtersCount = 0;
      if(filteredCentralFilter.isNotEmpty){
        filtersCount  = filteredCentralFilter[0]['FilterStatus'].length;
      }

      int rdWidth = 0;
      if(irrigationFlag !=2){
        if(filtersCount>0&&filteredCentralFilter[0]['PrsIn']!='-'){
          rdWidth = ((filteredSrcPumps.length+filteredIrrPumps.length+filtersCount+3)*70)+170;
        }else{
          rdWidth = ((filteredSrcPumps.length+filteredIrrPumps.length+filtersCount+1)*70)+170;
        }
      }else{
        rdWidth = ((filteredSrcPumps.length+filteredIrrPumps.length+filteredCentralFilter.length+1)*70);
      }

      final line = provider.payloadIrrLine.firstWhere(
            (line) => line.line == crrIrrLine.id,
        orElse: () => IrrigationLinePLD(level: [], sNo: 0, line: '', swName: '', prsIn: '', prsOut: '', dpValue: '', waterMeter: '', irrigationPauseFlag: 0, dosingPauseFlag: 0), // Provide a valid fallback instance
      );

      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 9, left: 5, right: 5),
            child: provider.irrigationPump.isNotEmpty? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                provider.sourcePump.isNotEmpty? Padding(
                  padding: EdgeInsets.only(top: provider.localFertilizer.isNotEmpty || provider.localFertilizer.isNotEmpty? 38.4:0),
                  child: DisplaySourcePump(deviceId: widget.siteData.master[widget.masterInx].deviceId, currentLineId: crrIrrLine.id, spList: provider.sourcePump, userId: widget.userId, controllerId: widget.siteData.master[widget.masterInx].controllerId, customerId: widget.siteData.customerId,),
                ):
                const SizedBox(),

                provider.irrigationPump.isNotEmpty? Padding(
                  padding: EdgeInsets.only(top: provider.localFertilizer.isNotEmpty || provider.localFertilizer.isNotEmpty? 38.4:0),
                  child: InkWell(
                    onTap: line.level.length>1?() {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {

                          return AlertDialog(
                            title: const Text('Level List'),
                            content: line.level.isNotEmpty
                                ? SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: line.level.map((levelItem) {
                                  return ListTile(
                                    leading: Image.asset(
                                      'assets/images/level_sensor.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    title: Text(
                                      levelItem.swName.isNotEmpty == true
                                          ? levelItem.swName
                                          : levelItem.name ?? 'No Name',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    trailing: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            text: 'Percent: ', // Regular text
                                            style: const TextStyle(fontSize: 12),
                                            children: [
                                              TextSpan(
                                                text: '${levelItem.levelPercent}%',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            text: 'Level: ', // Regular text
                                            style: const TextStyle(fontSize: 12),
                                            children: [
                                              TextSpan(
                                                text: getUnitByParameter(context, 'Level Sensor', levelItem.value) ?? '',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                                : const Text('No level available'), // Display if levels are empty or no line found
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    }:null,
                    child: SizedBox(
                      width: 52.50,
                      height: 100,
                      child: Stack(
                        children: [
                          isPumpAvailable(crrIrrLine.id, provider.sourcePump)
                              ? Image.asset('assets/images/dp_sump_src.png')
                              : Image.asset('assets/images/dp_sump.png'),

                          line.level.length==1? Positioned(
                            top: 12,
                            left: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: const BorderRadius.all(Radius.circular(2)),
                                border: Border.all(color: Colors.grey, width: .50),
                              ),
                              width: 52,
                              height: 30,
                              child: Center(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Level",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      getUnitByParameter(
                                        context,
                                        'Level Sensor',
                                        line.level[0].value,
                                      ) ??
                                          '',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ):
                          const SizedBox(),

                          line.level.length==1? Positioned(
                            top: 43,
                            left: 12,
                            child: Center(
                              child: Text(
                                '${line.level[0].levelPercent}%',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ):
                          const SizedBox(),

                          line.level.length==1? Positioned(
                            top: 64,
                            left: 5,
                            child: Center(
                              child: Text(
                                line.level[0].swName ?? line.level[0].name,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ):
                          const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ):
                const SizedBox(),

                provider.irrigationPump.isNotEmpty? Padding(
                  padding: EdgeInsets.only(top: provider.localFertilizer.isNotEmpty || provider.localFertilizer.isNotEmpty? 38.4:0),
                  child: DisplayIrrigationPump(currentLineId: crrIrrLine.id, deviceId: widget.siteData.master[widget.masterInx].deviceId, ipList: provider.irrigationPump, userId: widget.userId, controllerId: widget.siteData.master[widget.masterInx].controllerId,),
                ):
                const SizedBox(),

                provider.centralFilter.isNotEmpty?
                DisplayFilter(currentLineId: crrIrrLine.id, filtersSites: provider.centralFilter,):
                const SizedBox(),

                Expanded(
                  child: Column(
                    children: [
                      Divider(height: 5, color: Colors.grey.shade300),
                      Container(height: 3, color: Colors.white24),
                      Divider(height: 0, color: Colors.grey.shade300),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: DisplayIrrigationLine(irrigationLine: crrIrrLine, currentLineId: crrIrrLine.id, currentMaster: widget.siteData.master[widget.masterInx],
                            rWidth: rdWidth, customerId: widget.customerId,),),
                          irrigationFlag !=2 ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextButton(
                              onPressed: () {
                                int prFlag = 0;
                                List<dynamic> records = provider.payloadIrrLine;
                                int sNoToCheck = crrIrrLine.sNo;
                                var record = records.firstWhere(
                                      (record) => record['S_No'] == sNoToCheck,
                                  orElse: () => null,
                                );
                                if (record != null) {
                                  bool isIrrigationPauseFlagZero = record['IrrigationPauseFlag'] == 0;
                                  if (isIrrigationPauseFlagZero) {
                                    prFlag = 1;
                                  } else {
                                    prFlag = 0;
                                  }
                                  String payLoadFinal = jsonEncode({
                                    "4900": [{
                                      "4901": "$sNoToCheck, $prFlag",
                                    }
                                    ]
                                  });
                                  MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.siteData.master[widget.masterInx].deviceId}');
                                  if(irrigationFlag == 1){
                                    sentToServer('Resumed the ${crrIrrLine.name}', payLoadFinal);
                                  }else{
                                    sentToServer('Paused the ${crrIrrLine.name}', payLoadFinal);
                                  }
                                } else {
                                  const GlobalSnackBar(code: 200, message: 'Controller connection lost...');
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(irrigationFlag == 1 ? Colors.green : Colors.orange),
                                shape: WidgetStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  irrigationFlag == 1
                                      ? const Icon(Icons.play_arrow_outlined, color: Colors.white)
                                      : const Icon(Icons.pause, color: Colors.white),
                                  const SizedBox(width: 5),
                                  Text(
                                    irrigationFlag == 1 ? 'RESUME THE LINE' : 'PAUSE THE LINE',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ):
                          const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ):
            const SizedBox(height: 20),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black26,
            width: 0.5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PumpLineCentral(currentSiteData: widget.siteData, crrIrrLine:crrIrrLine, masterIdx: widget.masterInx, provider: provider, userId: widget.userId,),
            Divider(height: 0, color: Colors.grey.shade300),
            Container(height: 4, color: Colors.white24),
            Divider(height: 0, color: Colors.grey.shade300),
            DisplayIrrigationLine(irrigationLine: crrIrrLine, currentLineId: crrIrrLine.id, currentMaster: widget.siteData.master[widget.masterInx], rWidth: 0, customerId: widget.customerId,),
          ],
        ),
      ),
    );
  }

  bool isPumpAvailable(String location, List<PumpData> pumps) {
    return pumps.any((pump) => pump.location == location);
  }

  String getCurrentDateAndTime() {
    var nowDT = DateTime.now();
    return '${DateFormat('MMMM dd, yyyy').format(nowDT)}-${DateFormat('hh:mm:ss').format(nowDT)}';
  }

  int getNodePosition(int mIndex, String decId) {
    return widget.siteData.master[mIndex].gemLive[0].nodeList
        .indexWhere((node) => node.deviceId == decId);
  }

  int getNodePositionInNodeList(int mIndex, String decId) {
    for (int i = 0; i < widget.siteData.master[mIndex].gemLive[0].nodeList.length; i++) {
      if (widget.siteData.master[mIndex].gemLive[0].nodeList[i].deviceId == decId) {
        return i;
      }
    }
    return -1;
  }

  List<ScheduledProgram> filterProgramsByCategory(List<ScheduledProgram> prg, String cat) {
    return prg.where((prg) => prg.progCategory.contains(cat)).toList();
  }

  List<ProgramQueue> filterProgramsQueueByCategory(List<ProgramQueue> prQ, String cat) {
    return prQ.where((prQ) => prQ.programCategory.contains(cat)).toList();
  }

  List<CurrentScheduleModel> filterCurrentScheduleByCategory(List<CurrentScheduleModel> cs, String category) {
    return cs.where((cs) => cs.programCategory.contains(category)).toList();
  }

  List<CurrentScheduleModel> filterCurrentScheduleByProgramName(List<CurrentScheduleModel> cs, String category) {
    return cs.where((cs) => cs.programName.contains(category)).toList();
  }

  void sentToServer(String msg, String payLoad) async
  {
    Map<String, Object> body = {"userId": widget.siteData.customerId, "controllerId": widget.siteData.master[widget.masterInx].deviceId, "messageStatus": msg, "hardware": jsonDecode(payLoad), "createUser": widget.userId};
    final response = await HttpService().postRequest("createUserSentAndReceivedMessageManually", body);
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class DisplayIrrigationLine extends StatefulWidget {
  const DisplayIrrigationLine({Key? key, required this.irrigationLine, required this.currentLineId, required this.currentMaster, required this.rWidth, required this.customerId}) : super(key: key);
  final MasterData currentMaster;
  final IrrigationLine irrigationLine;
  final String currentLineId;
  final int rWidth, customerId;

  @override
  State<DisplayIrrigationLine> createState() => _DisplayIrrigationLineState();
}

class _DisplayIrrigationLineState extends State<DisplayIrrigationLine> {

  DateTime selectedDate = DateTime.now();
  List<AllMySensor> sensors = [];

  @override
  void initState() {
    super.initState();
    getSensorHourlyLogs(widget.customerId, widget.currentMaster.controllerId, selectedDate);
  }

  Future<void> getSensorHourlyLogs(customerId, controllerId, selectedDate) async
  {
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    Map<String, Object> body = {
      "userId": customerId,
      "controllerId": controllerId,
      "fromDate": date,
      "toDate": date
    };
    final response = await HttpService().postRequest("getUserSensorHourlyLog", body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["code"] == 200) {
        try {
          sensors = (data['data'] as List).map((item) {
            final Map<String, List<SensorHourlyData>> sensorData = {};
            item['data'].forEach((hour, values) {
              sensorData[hour] = (values as List)
                  .map((sensorItem) => SensorHourlyData.fromJson({
                ...sensorItem,
                'hour': hour,
              })).toList();
            });
            return AllMySensor(name: item['name'], data: sensorData);
          }).toList();
          setState(() {
          });
        } catch (e) {
          print('Error: $e');
        }
      }
    }

  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width-widget.rWidth;
    final List<Widget> valveWidgets;

    MqttPayloadProvider provider = Provider.of<MqttPayloadProvider>(context, listen: false);

    if(widget.currentLineId=='all'){
      valveWidgets = [

        for (var line in widget.currentMaster.irrigationLine) ...[
          ...line.pressureSwitch.map((psw) => SensorWidget(sensor: psw,
            sensorType: 'Pressure Switch',
            imagePath: 'assets/images/pressure_switch.png',
            sensorData: sensors.isNotEmpty? sensors.firstWhere(
                  (sensor) => sensor.name == 'Pressure Switch',
              orElse: () => AllMySensor(name: '', data: {}),
            ).data : {},
          )).toList(),
          ...line.pressureSensor.map((ps) => SensorWidget(
            sensor: ps,
            sensorType: 'Pressure Sensor',
            imagePath: 'assets/images/pressure_sensor.png',
            sensorData: sensors.isNotEmpty? sensors.firstWhere(
                  (sensor) => sensor.name == 'Pressure Sensor',
              orElse: () => AllMySensor(name: '', data: {}),
            ).data : {},
          )).toList(),
          ...line.waterMeter.map((wm) => SensorWidget(
            sensor: wm,
            sensorType: 'Water Meter',
            imagePath: 'assets/images/water_meter.png',
            sensorData: sensors.isNotEmpty? sensors.firstWhere(
                  (sensor) => sensor.name == 'Water Meter',
              orElse: () => AllMySensor(name: '', data: {}),
            ).data : {},
          )).toList(),
          ...line.mainValve.map((mv) => MainValveWidget(mv: mv, status: mv.status)).toList(),
          ...line.valve.map((vl) => ValveWidget(vl: vl, status: vl.status,
            moistureSensor: line.moistureSensor.where((ms) {
              return (ms.valve as String).split('_').contains(vl.id);
            }).toList(),
            userId: widget.customerId,
            controllerId: widget.currentMaster.controllerId,
            sensorData: sensors.isNotEmpty? sensors.firstWhere(
                  (sensor) => sensor.name == 'Moisture Sensor',
              orElse: () => AllMySensor(name: '', data: {}),
            ).data : {},
          )).toList(),
          ...line.agitator.map((ag) => AgitatorWidget(ag: ag, status: ag.status)).toList(),
          /*...line.levelSensor.map((ls) => SensorWidget(
            sensor: ls,
            sensorType: 'Level Sensor',
            imagePath: 'assets/images/level_sensor.png',
            sensorData: sensors.isNotEmpty? sensors.firstWhere(
                  (sensor) => sensor.name == 'Level Sensor',
              orElse: () => AllMySensor(name: '', data: {}),
            ).data : {},
          )).toList(),*/
        ]
      ];
    }
    else{
      valveWidgets = [
        ...widget.irrigationLine.pressureSwitch.map((psw) => SensorWidget(sensor: psw, sensorType: 'Pressure Switch', imagePath: 'assets/images/pressure_switch.png',
          sensorData: sensors.isNotEmpty? sensors.firstWhere(
                (sensor) => sensor.name == 'Pressure Switch',
            orElse: () => AllMySensor(name: '', data: {}),
          ).data : {},
        )).toList(),
        ...widget.irrigationLine.pressureSensor.map((ps) => SensorWidget(sensor: ps, sensorType: 'Pressure Sensor', imagePath: 'assets/images/pressure_sensor.png',
          sensorData: sensors.isNotEmpty? sensors.firstWhere(
                (sensor) => sensor.name == 'Pressure Sensor',
            orElse: () => AllMySensor(name: '', data: {}),
          ).data : {},
        )).toList(),
        ...widget.irrigationLine.waterMeter.map((wm) => SensorWidget(sensor: wm, sensorType: 'Water Meter', imagePath: 'assets/images/water_meter.png',
          sensorData: sensors.isNotEmpty? sensors.firstWhere(
                (sensor) => sensor.name == 'Water Meter',
            orElse: () => AllMySensor(name: '', data: {}),
          ).data : {},
        )).toList(),
        ...widget.irrigationLine.mainValve.map((mv) => MainValveWidget(mv: mv, status: mv.status,)).toList(),
        ...widget.irrigationLine.valve.map((vl) => ValveWidget(vl: vl, status: vl.status,
          moistureSensor: widget.irrigationLine.moistureSensor.where((ms) {
            return (ms.valve as String).split('_').contains(vl.id);
          }).toList(), userId: widget.customerId, controllerId: widget.currentMaster.controllerId,
          sensorData: sensors.isNotEmpty? sensors.firstWhere(
                (sensor) => sensor.name == 'Moisture Sensor',
            orElse: () => AllMySensor(name: '', data: {}),
          ).data : {},
        )).toList(),
        ...widget.irrigationLine.agitator.map((ag) => AgitatorWidget(ag: ag, status: ag.status)).toList(),
        /*...widget.irrigationLine.levelSensor.map((ls) => SensorWidget(sensor: ls, sensorType: 'Level Sensor', imagePath: 'assets/images/level_sensor.png',
          sensorData: sensors.isNotEmpty? sensors.firstWhere(
                (sensor) => sensor.name == 'Level Sensor',
            orElse: () => AllMySensor(name: '', data: {}),
          ).data : {},
        )).toList(),*/
      ];
    }

    int crossAxisCount = (screenWidth / 105).floor().clamp(1, double.infinity).toInt();
    int rowCount = (valveWidgets.length / crossAxisCount).ceil();
    double itemHeight = 72;
    double gridHeight = rowCount * (itemHeight + 5);

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: gridHeight,
      child: Padding(
        padding: const EdgeInsets.only(left: 3, right: 3),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.32,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
          ),
          itemCount: valveWidgets.length,
          itemBuilder: (context, index) {
            return Container(color: Colors.white, child: valveWidgets[index]);
          },
        ),
      ),
    );
  }
}

class IrrigationPumpWidget extends StatelessWidget {
  final Valve vl;
  final int status;
  const IrrigationPumpWidget({super.key, required this.vl, required this.status});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      width: 150,
      margin: const EdgeInsets.only(left: 2, right: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          screenWidth>600? const SizedBox(
            width: 150,
            height: 15,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VerticalDivider(width: 0,),
                SizedBox(width: 4,),
                VerticalDivider(width: 0,),
              ],
            ),
          ):
          const SizedBox(),
          Image.asset(
            width: 35,
            height: 35,
            status == 0? 'assets/images/valve_gray.png':
            status == 1? 'assets/images/valve_green.png':
            status == 2? 'assets/images/valve_orange.png':
            'assets/images/valve_red.png',
          ),
          const SizedBox(height: 4),
          Text(vl.name.isNotEmpty? vl.name:vl.id, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.black54),),
        ],
      ),
    );
  }
}

class MainValveWidget extends StatelessWidget {
  final MainValve mv;
  final int status;
  const MainValveWidget({super.key, required this.mv, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(left: 4, right: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 150,
            height: 13.5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VerticalDivider(width: 0,),
                SizedBox(width: 4,),
                VerticalDivider(width: 0,),
              ],
            ),
          ),
          Image.asset(
            width: 35,
            height: 35,
            status == 0 ? 'assets/images/dp_main_valve_not_open.png':
            status == 1? 'assets/images/dp_main_valve_open.png':
            status == 2? 'assets/images/dp_main_valve_wait.png':
            'assets/images/dp_main_valve_closed.png',
          ),
          const SizedBox(height: 5),
          Text(mv.name.isNotEmpty? mv.name:mv.id, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.black54),),
        ],
      ),
    );
  }
}

class ValveWidget extends StatelessWidget {
  final Valve vl;
  final int status, userId, controllerId;
  final List<SensorModel> moistureSensor;
  final Map<String, List<SensorHourlyData>> sensorData;
  const ValveWidget({super.key, required this.vl, required this.status, required this.moistureSensor, required this.userId, required this.controllerId, required this.sensorData});

  @override
  Widget build(BuildContext context) {
    bool hasMoisture = moistureSensor.isNotEmpty;
    return Stack(
      children: [
        Container(
          width: 150,
          margin: const EdgeInsets.only(left: 2, right: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 150,
                height: 15,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VerticalDivider(width: 0),
                    SizedBox(width: 4),
                    VerticalDivider(width: 0),
                  ],
                ),
              ),
              Image.asset(
                width: 35,
                height: 35,
                status == 0
                    ? 'assets/images/valve_gray.png'
                    : status == 1
                    ? 'assets/images/valve_green.png'
                    : status == 2
                    ? 'assets/images/valve_orange.png'
                    : 'assets/images/valve_red.png',
              ),
              const SizedBox(height: 4),
              Text(
                vl.name.isNotEmpty ? vl.name : vl.id,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ],
          ),
        ),
        if (hasMoisture)
          Positioned(
            top: 2,
            right: 15,
            child: TextButton(
              onPressed: () {
                showPopover(
                  context: context,
                  bodyBuilder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: moistureSensor.map((ms) {

                        Map<String, dynamic> jsonData = jsonDecode(jsonEncode(sensorData));
                        Map<String, List<Map<String, dynamic>>> filteredData = {};

                        jsonData.forEach((key, value) {
                          var filteredList = (value as List)
                              .where((item) => item['sNo']==ms.sNo)
                              .toList();
                          if (filteredList.isNotEmpty) {
                            filteredData[key] = List<Map<String, dynamic>>.from(filteredList);
                          }
                        });

                        return Row(
                          children: [
                            SizedBox(
                              width: 450,
                              height: 175,
                              child: buildLineChart(context, filteredData, 'Moisture Sensor', ms.name, ms.moistureType!),
                            ),
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 200,
                                    pointers: <GaugePointer>[
                                      NeedlePointer(
                                          value: double.parse(ms.value),
                                          needleEndWidth: 3, needleColor: Colors.black54),
                                       RangePointer(
                                        value: 200.0,
                                        width: 0.30,
                                        sizeUnit: GaugeSizeUnit.factor,
                                        color: Color(0xFF494CA2),
                                        animationDuration: 1000,
                                        // animationType: AnimationType.easeOutBack,
                                        gradient: SweepGradient(
                                          colors: <Color>[
                                            Colors.greenAccent,
                                            Colors.orangeAccent,
                                            Colors.redAccent,
                                            Colors.redAccent
                                          ],
                                          stops: <double>[0.15, 0.50, 0.70, 1.00],
                                        ),
                                        enableAnimation: true,
                                      ),
                                    ],
                                    showFirstLabel: false,
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        widget: Text(
                                          '${ms.value} CB',
                                          style: const TextStyle(
                                              fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                        angle: 90,
                                        positionFactor: 0.8,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                  onPop: () => print('Popover was popped!'),
                  direction: PopoverDirection.bottom,
                  width: 550,
                  height: moistureSensor.length * 175,
                  arrowHeight: 15,
                  arrowWidth: 30,
                  barrierColor: Colors.black54,
                  arrowDxOffset: 20,
                  arrowDyOffset: -43,
                );
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                minimumSize: WidgetStateProperty.all(Size.zero),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
              ),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: _getMoistureColor(moistureSensor
                    .map((sensor) => {'name': sensor.name, 'value': sensor.value})
                    .toList()),
                child: Image.asset(
                  'assets/images/moisture_sensor.png',
                  width: 25,
                  height: 25,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Color _getMoistureColor(List<Map<String, dynamic>> sensors) {
    if (sensors.isEmpty) return Colors.grey;

    final values = sensors
        .map((ms) => double.tryParse(ms['value'] ?? '0') ?? 0.0)
        .toList();

    final averageValue = values.reduce((a, b) => a + b) / values.length;

    if (averageValue < 20) {
      return Colors.green.shade200;
    } else if (averageValue <= 60) {
      return Colors.orange.shade200;
    } else {
      return Colors.red.shade200;
    }
  }
}

class AgitatorWidget extends StatelessWidget {
  final LineAgitator ag;
  final int status;
  const AgitatorWidget({super.key, required this.ag, required this.status});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      width: 150,
      margin: const EdgeInsets.only(left: 2, right: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          screenWidth>600? const SizedBox(
            width: 150,
            height: 15,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VerticalDivider(width: 0,),
                SizedBox(width: 4,),
                VerticalDivider(width: 0,),
              ],
            ),
          ):
          const SizedBox(),
          const SizedBox(height: 4),
          Image.asset(
            width: 59,
            height: 34,
            status == 0? 'assets/images/dp_agitator_right.png':
            status == 1? 'assets/images/dp_agitator_right_g.png':
            status == 2? 'assets/images/dp_agitator_right_y.png':
            'assets/images/dp_agitator_right_r.png',
          ),
          Text(ag.name.isNotEmpty? ag.name:ag.id, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10),),
        ],
      ),
    );
  }
}

class SensorWidget extends StatelessWidget {
  final SensorModel sensor;
  final String sensorType;
  final String imagePath;
  final Map<String, List<SensorHourlyData>> sensorData;

  const SensorWidget({
    super.key,
    required this.sensor,
    required this.sensorType,
    required this.imagePath,
    required this.sensorData,
  });

  @override
  Widget build(BuildContext context) {
    if(sensorType != 'Pressure Switch'){
      return Container(
        width: 150,
        margin: const EdgeInsets.only(left: 4, right: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 10,
              height: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VerticalDivider(width: 0),
                  SizedBox(width: 4),
                  VerticalDivider(width: 0),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                width: 150,
                height: 17,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: const BorderRadius.all(Radius.circular(2)),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    getUnitByParameter(context, sensorType, sensor.value.toString()) ?? '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                showPopover(
                  context: context,
                  bodyBuilder: (context) {
                    Map<String, dynamic> jsonData = jsonDecode(jsonEncode(sensorData));
                    Map<String, List<Map<String, dynamic>>> filteredData = {};

                    jsonData.forEach((key, value) {
                      var filteredList = (value as List)
                          .where((item) => item['sNo']==sensor.sNo)
                          .toList();
                      if (filteredList.isNotEmpty) {
                        filteredData[key] = List<Map<String, dynamic>>.from(filteredList);
                      }
                    });

                    String input = getUnitByParameter(context, sensorType, sensor.value.toString()) ?? '';
                    String numericValue = extractNumber(input);

                    return Row(
                      children: [
                        SizedBox(
                          width: 450,
                          height: 175,
                          child: buildLineChart(context, filteredData, sensorType, sensor.name, sensor.moistureType!),
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: SfRadialGauge(
                            axes: <RadialAxis>[
                              RadialAxis(
                                minimum: 0,
                                maximum: sensorType=='Moisture Sensor'?200:sensorType=='Pressure Sensor'?12:100,
                                pointers: <GaugePointer>[
                                  NeedlePointer(
                                      value: double.parse(numericValue),
                                      needleEndWidth: 3, needleColor: Colors.black54),
                                  RangePointer(
                                    value: sensorType=='Moisture Sensor'?200.0:100.0,
                                    width: 0.30,
                                    sizeUnit: GaugeSizeUnit.factor,
                                    color: const Color(0xFF494CA2),
                                    animationDuration: 1000,
                                    // animationType: AnimationType.easeOutBack,
                                    gradient: SweepGradient(
                                      colors: sensorType == "Water Meter" ? <Color>[
                                        Colors.teal.shade300,
                                        Colors.teal.shade400,
                                        Colors.teal.shade500,
                                        Colors.teal.shade600
                                      ]:
                                      <Color>[
                                        Colors.tealAccent,
                                        Colors.orangeAccent,
                                        Colors.redAccent,
                                        Colors.redAccent
                                      ],
                                      stops: const <double>[0.15, 0.50, 0.70, 1.00],
                                    ),
                                    enableAnimation: true,
                                  ),
                                ],
                                showFirstLabel: false,
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                    widget: Text(
                                      numericValue,
                                      style: const TextStyle(
                                          fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                    angle: 90,
                                    positionFactor: 0.8,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  onPop: () => print('Popover was popped!'),
                  direction: PopoverDirection.bottom,
                  width: 550,
                  height: 175,
                  arrowHeight: 15,
                  arrowWidth: 30,
                  barrierColor: Colors.black54,
                  arrowDyOffset: -20,
                );
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                minimumSize: WidgetStateProperty.all(Size.zero),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
              ),
              child: Image.asset(
                imagePath,
                width: 35,
                height: 35,
              ),
            ),
            Text(
              sensor.name.isNotEmpty ? sensor.name : sensor.id,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ],
        ),
      );
    }
    return Container(
      width: 150,
      margin: const EdgeInsets.only(left: 4, right: 4),
      child: Column(
        children: [
          SizedBox(
            width: 150,
            height: 50,
            child: Stack(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 32),
                  child: SizedBox(
                    width: 10,
                    height: 17,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        VerticalDivider(width: 0),
                        SizedBox(width: 3),
                        VerticalDivider(width: 0),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 30,
                  child: Image.asset(
                    imagePath,
                    width: 35,
                    height: 35,
                  ),
                ),
                Positioned(
                  top: 3,
                  left: 43,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.black45,
                    child: CircleAvatar(radius: 6, backgroundColor:sensor.value == '1'? Colors.redAccent:Colors.lightGreenAccent,),
                  ),
                ),
              ],
            ),
          ),
          Text(
            sensor.name.isNotEmpty ? sensor.name : sensor.id,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          )
        ],
      ),
      /*child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 10,
            height: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VerticalDivider(width: 0),
                SizedBox(width: 4),
                VerticalDivider(width: 0),
              ],
            ),
          ),
          CircleAvatar(
            radius: 9,
            backgroundColor: Colors.black45,
            child: CircleAvatar(radius: 6, backgroundColor:sensor.value == '1'? Colors.redAccent:Colors.greenAccent,),
          ),
          Image.asset(
            imagePath,
            width: 35,
            height: 35,
          ),
          Text(
            sensor.name.isNotEmpty ? sensor.name : sensor.id,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
        ],
      ),*/
    );
  }

  String extractNumber(String input) {
    RegExp regex = RegExp(r'\d+\.?\d*');
    Match? match = regex.firstMatch(input);
    return match?.group(0) ?? '';
  }
}

Row buildLineChart(BuildContext context, Map<String, List<Map<String, dynamic>>> sensorData, String sensorCategory, String sensorName, String sensorType,)
{

  // Collect all hours
  final Set<String> allHours = {};
  sensorData.values.expand((hourlyData) => hourlyData).forEach((data) {
    allHours.add(data['hour']);
  });

  // Sort hours
  final List<String> sortedHours = allHours.toList()..sort();
  // Group data by sensor name
  final Map<String, List<SensorHourlyData>> groupedByName = {};
  sensorData.values.expand((hourlyData) => hourlyData).forEach((data) {
    groupedByName.putIfAbsent(sensorName, () => []).add(SensorHourlyData(
      id: data['Id'],
      value: data['Value'].toDouble(),
      hour: data['hour'],
      name: sensorName, sNo: data['sNo'],
    ));
  });

  // Build series
  final List<LineSeries<SensorHourlyData, String>> series = [];
  groupedByName.forEach((sensorName, sensorValues) {
    final dataPoints = sortedHours.map((hour) {
      final data = sensorValues.firstWhere(
            (d) => d.hour == hour,
        orElse: () => SensorHourlyData(
          id: '',
          value: 0.0,
          hour: hour,
          name: sensorName, sNo: 0,
        ),
      );
      return data;
    }).toList();

    // Add line series
    series.add(LineSeries<SensorHourlyData, String>(
      name: sensorName,
      dataSource: dataPoints,
      xValueMapper: (SensorHourlyData data, _) => data.hour,
      yValueMapper: (SensorHourlyData data, _) {
        if(sensorCategory=='EC Sensor' || sensorCategory=='PH Sensor'){
          return data.value;
        }else{
          String? result = getUnitByParameter(context, sensorCategory, data.value.toString());
          String? numericString = result?.replaceAll(RegExp(r'[^\d.]+'), '');
          double? value = double.tryParse(numericString!);
          return value ?? 0.0;
        }
      },
      dataLabelSettings: const DataLabelSettings(
        isVisible: true,
        textStyle: TextStyle(
          fontSize: 10,  // Set the desired font size here
          color: Colors.black,  // Optional: You can also set the text color
        ),
      ),

      color: Colors.teal,
      dataLabelMapper: (SensorHourlyData data, _) {

        if(sensorCategory=='EC Sensor' || sensorCategory=='PH Sensor'){
          return data.value.toString();
        }else{
          String? result = getUnitByParameter(context, sensorCategory, data.value.toString());
          String? numericString = result?.replaceAll(RegExp(r'[^\d.]+'), '');
          return '$numericString';
        }

      },
      //dataLabelMapper: (SensorHourlyData data, _) => data.value.toStringAsFixed(1),
      markerSettings: const MarkerSettings(isVisible: true),
      dashArray: [4, 4],
      width: 1.5,
      emptyPointSettings: EmptyPointSettings(
        mode: EmptyPointMode.gap,
      ),
    ));
  });



  return Row(
    children: [
      Expanded(
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            title: AxisTitle(text: sensorCategory=='Moisture Sensor'?'$sensorName($sensorType) - Hours':'$sensorName - Hours', textStyle: const TextStyle(fontSize: 12)),
            majorGridLines: const MajorGridLines(width: 0),
            axisLine: const AxisLine(width: 0),
            labelStyle: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
          primaryYAxis: NumericAxis(
            labelStyle: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),

          tooltipBehavior: TooltipBehavior(enable: true),
          series: series,
        ),
      ),
    ],
  );
}
