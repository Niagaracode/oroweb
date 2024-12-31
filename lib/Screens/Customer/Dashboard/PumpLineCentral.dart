import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/constants/theme.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

import '../../../Models/Customer/Dashboard/DashboardNode.dart';
import '../../../constants/AppImages.dart';
import '../../../constants/MQTTManager.dart';
import '../../../constants/MyFunction.dart';
import '../../../constants/http_service.dart';
import '../../../constants/snack_bar.dart';
import '../../../state_management/DurationNotifier.dart';
import '../../../state_management/MqttPayloadProvider.dart';


class PumpLineCentral extends StatefulWidget {
  const PumpLineCentral({Key? key, required this.currentSiteData, required this.crrIrrLine, required this.masterIdx, required this.provider, required this.userId}) : super(key: key);
  final DashboardModel currentSiteData;
  final IrrigationLine crrIrrLine;
  final int masterIdx, userId;
  final MqttPayloadProvider provider;

  @override
  State<PumpLineCentral> createState() => _PumpLineCentralState();
}

class _PumpLineCentralState extends State<PumpLineCentral> {

  int? getIrrigationPauseFlag(String line, List<IrrigationLinePLD> payload2408) {
    for (var data in payload2408) {
      if (data.line== line) {
        return data.irrigationPauseFlag;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    int? irrigationPauseFlag = getIrrigationPauseFlag(widget.crrIrrLine.id, widget.provider.payloadIrrLine);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior(),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(top: 9, left: 5, right: 5),
                child: widget.provider.irrigationPump.isNotEmpty? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.provider.sourcePump.isNotEmpty? Padding(
                      padding: EdgeInsets.only(top: widget.provider.centralFertilizer.isNotEmpty || widget.provider.localFertilizer.isNotEmpty? 38.4:0),
                      child: DisplaySourcePump(deviceId: widget.currentSiteData.master[widget.masterIdx].deviceId, currentLineId: widget.crrIrrLine.id, spList:  widget.provider.sourcePump, userId: widget.userId, controllerId: widget.currentSiteData.master[widget.masterIdx].controllerId, customerId: widget.currentSiteData.customerId,),
                    ):
                    const SizedBox(),

                    widget.provider.irrigationPump.isNotEmpty? Padding(
                      padding: EdgeInsets.only(top: widget.provider.centralFertilizer.isNotEmpty || widget.provider.localFertilizer.isNotEmpty? 38.4:0),
                      child: InkWell(
                        onTap: () {

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final line = widget.provider.payloadIrrLine.firstWhere(
                                    (line) => line.line == widget.crrIrrLine.id,
                                orElse: () => IrrigationLinePLD(level: [], sNo: 0, line: '', swName: '', prsIn: '', prsOut: '', dpValue: '', waterMeter: '', irrigationPauseFlag: 0, dosingPauseFlag: 0), // Provide a valid fallback instance
                              );
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
                        },
                        child: SizedBox(
                          width: 52.50,
                          height: 70,
                          child: Stack(
                            children: [
                              widget.provider.sourcePump.isNotEmpty
                                  ? Image.asset('assets/images/dp_sump_src.png')
                                  : Image.asset('assets/images/dp_sump.png'),
                            ],
                          ),
                        ),
                      ),
                    ):
                    const SizedBox(),

                    widget.provider.irrigationPump.isNotEmpty? Padding(
                      padding: EdgeInsets.only(top: widget.provider.centralFertilizer.isNotEmpty || widget.provider.localFertilizer.isNotEmpty? 38.4:0),
                      child: DisplayIrrigationPump(currentLineId: widget.crrIrrLine.id, deviceId: widget.currentSiteData.master[widget.masterIdx].deviceId, ipList: widget.provider.irrigationPump, userId: widget.userId, controllerId: widget.currentSiteData.master[widget.masterIdx].controllerId,),
                    ):
                    const SizedBox(),

                    widget.provider.centralFilter.isEmpty && widget.provider.centralFertilizer.isEmpty &&
                        widget.provider.localFilter.isEmpty && widget.provider.localFertilizer.isEmpty ? SizedBox(
                      width: 4.5,
                      height: 100,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                          ),
                          const SizedBox(width: 4.5,),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                          ),
                        ],
                      ),
                    ):
                    const SizedBox(),

                    widget.provider.centralFilter.isNotEmpty? Padding(
                      padding: EdgeInsets.only(top: widget.provider.centralFertilizer.isNotEmpty || widget.provider.localFertilizer.isNotEmpty? 38.4:0),
                      child: DisplayFilter(currentLineId: widget.crrIrrLine.id, filtersSites: widget.provider.centralFilter,),
                    ): const SizedBox(),

                    (widget.provider.localFertilizer.isEmpty && widget.provider.centralFertilizer.isEmpty) &&
                        (widget.provider.centralFilter.isNotEmpty || widget.provider.localFilter.isNotEmpty) ? SizedBox(
                      width: 4.5,
                      height: 120,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                          ),
                          const SizedBox(width: 4.5,),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                          ),
                        ],
                      ),
                    ):
                    const SizedBox(),

                    widget.provider.centralFertilizer.isNotEmpty? DisplayCentralFertilizer(currentLineId: widget.crrIrrLine.id,):
                    const SizedBox(),

                    //local
                    widget.provider.irrigationPump.isNotEmpty? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (widget.provider.centralFertilizer.isNotEmpty || widget.provider.centralFilter.isNotEmpty) && widget.provider.localFertilizer.isNotEmpty?
                            SizedBox(
                              width: 4.5,
                              height: 150,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 42),
                                    child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                                  ),
                                  const SizedBox(width: 4.5,),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 45),
                                    child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                                  ),
                                ],
                              ),
                            ):
                            const SizedBox(),

                            widget.provider.localFilter.isNotEmpty? Padding(
                              padding: EdgeInsets.only(top: widget.provider.localFilter.isNotEmpty?38.4:0),
                              child: LocalFilter(currentLineId: widget.crrIrrLine.id, filtersSites: widget.provider.localFilter,),
                            ):
                            const SizedBox(),

                            widget.provider.localFertilizer.isNotEmpty? DisplayLocalFertilizer(currentLineId: widget.crrIrrLine.id,):
                            const SizedBox(),
                          ],
                        ),
                      ],
                    ):
                    const SizedBox(height: 20)
                  ],
                ):
                const SizedBox(height: 20),
              ),
            ),
          ),
        ),
        irrigationPauseFlag !=2 ? Padding(
          padding: const EdgeInsets.all(8),
          child: TextButton(
            onPressed: () {
              List<dynamic> records = widget.provider.payloadIrrLine;
              var record = records.firstWhere((record) => record['S_No'] == widget.crrIrrLine.sNo,
                orElse: () => null,
              );
              if (record != null) {
                String payLoadFinal = jsonEncode({
                  "4900": [{
                    "4901": "${widget.crrIrrLine.sNo}, ${record['IrrigationPauseFlag'] == 0?1:0}",
                  }
                  ]
                });
                MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.currentSiteData.master[widget.masterIdx].deviceId}');
                if(irrigationPauseFlag == 1){
                  sentToServer('Resumed the ${widget.crrIrrLine.name}', payLoadFinal);
                }else{
                  sentToServer('Paused the ${widget.crrIrrLine.name}', payLoadFinal);
                }

              } else {
                const GlobalSnackBar(code: 200, message: 'Controller connection lost...');
              }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(irrigationPauseFlag == 1 ? Colors.green : Colors.orange),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                irrigationPauseFlag == 1
                    ? const Icon(Icons.play_arrow_outlined, color: Colors.white)
                    : const Icon(Icons.pause, color: Colors.white),
                const SizedBox(width: 5),
                Text(
                  irrigationPauseFlag == 1 ? 'RESUME THE LINE' : 'PAUSE THE LINE',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ):
        const SizedBox(),
      ],
    );

  }

  void sentToServer(String msg, String payLoad) async
  {
    Map<String, Object> body = {"userId": widget.userId, "controllerId": widget.currentSiteData.master[widget.masterIdx].controllerId, "messageStatus": msg, "hardware": jsonDecode(payLoad), "createUser": widget.userId};
    final response = await HttpService().postRequest("createUserSentAndReceivedMessageManually", body);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

}


class DisplaySourcePump extends StatefulWidget {
  const DisplaySourcePump({Key? key, required this.deviceId, required this.currentLineId, required this.spList, required this.userId, required this.controllerId, required this.customerId}) : super(key: key);
  final String deviceId;
  final String currentLineId;
  final List<PumpData> spList;
  final int userId, customerId, controllerId;

  @override
  State<DisplaySourcePump> createState() => _DisplaySourcePumpState();
}

class _DisplaySourcePumpState extends State<DisplaySourcePump> {

  Timer? timer;
  final ValueNotifier<int> _popoverUpdateNotifier = ValueNotifier<int>(0);

  static const excludedReasons = [
    '3', '4', '5', '6', '21', '22', '23', '24',
    '25', '26', '27', '28', '29', '30', '31'
  ];

  @override
  void initState() {
    super.initState();
    for (var sp in widget.spList) {
      if (sp.onDelayLeft != '00:00:00' || sp.setValue != '00:00:00') {
        updatePumpOnDelayTime();
      }else{
        timer?.cancel();
      }
    }
  }

  void updatePumpOnDelayTime() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        for (var sp in widget.spList) {
          if (sp.onDelayLeft != '00:00:00') {
            sp.onDelayLeft = decrementTime(sp.onDelayLeft);
          }
          if (isTimeFormat(sp.setValue) && sp.setValue != '00:00:00') {
            sp.setValue = decrementTime(sp.setValue);
            if (sp.status == 1) {
              sp.actualValue = decrementTime(sp.actualValue);
            }
          }
        }
      });
    });
  }

  String decrementTime(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    if (seconds > 0) {
      seconds--;
    } else {
      if (minutes > 0) {
        minutes--;
        seconds = 59;
      } else {
        if (hours > 0) {
          hours--;
          minutes = 59;
          seconds = 59;
        }
      }
    }

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool isTimeFormat(String value) {
    final timeRegExp = RegExp(r'^([0-1]?\d|2[0-3]):[0-5]\d:[0-5]\d$');
    return timeRegExp.hasMatch(value);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    List<PumpData> filteredPumps = filterPumpsByLocation(widget.spList, widget.currentLineId);

    return SizedBox(
      width: filteredPumps.length * 70,
      height: 100,
      child: Row(
        children: List.generate(filteredPumps.length, (index) {
          final pump = filteredPumps[index];
          return Column(
            children: [
              Stack(
                children: [
                  Tooltip(
                    message: 'View more details',
                    child: TextButton(
                      onPressed: () {
                        final RenderBox button = context.findRenderObject() as RenderBox;
                        final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                        final position = button.localToGlobal(Offset.zero, ancestor: overlay);

                        //_popoverUpdateNotifier.value++;

                        bool voltKeyExists = filteredPumps[index].voltage.isNotEmpty;
                        int signalStrength = voltKeyExists? int.parse(filteredPumps[index].signalStrength):0;
                        int batteryVolt = voltKeyExists? int.parse(filteredPumps[index].battery):0;
                        List<String> voltages = voltKeyExists? filteredPumps[index].voltage.split(','):[];
                        List<String> currents = voltKeyExists? filteredPumps[index].current.split(','):[];

                        List<String> icEnergy = voltKeyExists? filteredPumps[index].icEnergy.split(','):[];
                        List<String> icPwrFactor = voltKeyExists? filteredPumps[index].pwrFactor.split(','):[];
                        List<String> icPwr = voltKeyExists? filteredPumps[index].pwr.split(','):[];

                        List<dynamic> pumpLevel = voltKeyExists? filteredPumps[index].level:[];

                        List<String> columns = ['-', '-', '-'];

                        if (voltKeyExists) {
                          for (var pair in currents) {
                            String sanitizedPair = pair.trim().replaceAll(RegExp(r'^"|"$'), '');
                            List<String> parts = sanitizedPair.split(':');
                            if (parts.length != 2) {
                              print('Error: Pair "$sanitizedPair" does not have the expected format');
                              continue;
                            }

                            try {
                              int columnIndex = int.parse(parts[0].trim()) - 1;
                              if (columnIndex >= 0 && columnIndex < columns.length) {
                                columns[columnIndex] = parts[1].trim();
                              } else {
                                print('Error: Column index $columnIndex is out of bounds');
                              }
                            } catch (e) {
                              print('Error parsing column index from "$sanitizedPair": $e');
                            }
                          }
                        }

                        showPopover(
                          context: context,
                          bodyBuilder: (context) {
                            MqttPayloadProvider provider = Provider.of<MqttPayloadProvider>(context, listen: true);
                            Future.delayed(const Duration(seconds: 2));
                            _popoverUpdateNotifier.value++;

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ValueListenableBuilder<int>(
                                  valueListenable: _popoverUpdateNotifier,
                                  builder: (BuildContext context, int value, Widget? child) {

                                    return Material(
                                      child: voltKeyExists && pumpLevel.isNotEmpty?
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 412,
                                            height: 35,
                                            color: Colors.teal.shade50,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(width: 8,),
                                                Text('Version: ${filteredPumps[index].version}'),
                                                const Spacer(),
                                                Icon(signalStrength == 0 ? Icons.wifi_off :
                                                signalStrength >= 1 && signalStrength <= 20 ?
                                                Icons.network_wifi_1_bar_outlined :
                                                signalStrength >= 21 && signalStrength <= 40 ?
                                                Icons.network_wifi_2_bar_outlined :
                                                signalStrength >= 41 && signalStrength <= 60 ?
                                                Icons.network_wifi_3_bar_outlined :
                                                signalStrength >= 61 && signalStrength <= 80 ?
                                                Icons.network_wifi_3_bar_outlined :
                                                Icons.wifi, color: Colors.black,),
                                                const SizedBox(width: 5,),
                                                Text('$signalStrength%'),

                                                const SizedBox(width: 5,),
                                                batteryVolt==0?const Icon(Icons.battery_0_bar):
                                                batteryVolt>0&&batteryVolt<=10?const Icon(Icons.battery_1_bar_rounded):
                                                batteryVolt>10&&batteryVolt<=30?const Icon(Icons.battery_2_bar_rounded):
                                                batteryVolt>30&&batteryVolt<=50?const Icon(Icons.battery_3_bar_rounded):
                                                batteryVolt>50&&batteryVolt<=70?const Icon(Icons.battery_4_bar_rounded):
                                                batteryVolt>70&&batteryVolt<=90?const Icon(Icons.battery_5_bar_rounded):
                                                const Icon(Icons.battery_6_bar_rounded),
                                                Text('$batteryVolt%'),

                                                const SizedBox(width: 8,),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 5,),
                                          SizedBox(
                                            width: 412,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 352,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 340,
                                                        height: 25,
                                                        color: Colors.transparent,
                                                        child: Row(
                                                          children: [
                                                            const SizedBox(width:100, child: Text('Phase', style: TextStyle(color: Colors.black54),),),
                                                            const Spacer(),
                                                            CircleAvatar(radius: 7, backgroundColor: int.parse(filteredPumps[index].phase)>0? Colors.green: Colors.red.shade100,),
                                                            const VerticalDivider(color: Colors.transparent,),
                                                            CircleAvatar(radius: 7, backgroundColor: int.parse(filteredPumps[index].phase)>1? Colors.green: Colors.red.shade100,),
                                                            const VerticalDivider(color: Colors.transparent,),
                                                            CircleAvatar(radius: 7, backgroundColor: int.parse(filteredPumps[index].phase)>2? Colors.green: Colors.red.shade100,),
                                                          ],
                                                        ),
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets.only(left: 8),
                                                        child: Divider(height: 6,color: Colors.black12),
                                                      ),
                                                      Container(
                                                        width: 340,
                                                        height: 25,
                                                        color: Colors.transparent,
                                                        child: Row(
                                                          children: [
                                                            const SizedBox(width:80, child: Text('Voltage', style: TextStyle(color: Colors.black54),),),
                                                            const Padding(
                                                              padding: EdgeInsets.only(bottom: 2,top: 2),
                                                              child: VerticalDivider(color: Colors.red, thickness: 1.5,),
                                                            ),
                                                            SizedBox(width: 70, child: Text('RY : ${voltages[0]}'),),
                                                            const Padding(
                                                              padding: EdgeInsets.only(bottom: 2,top: 2),
                                                              child: VerticalDivider(color: Colors.yellow,thickness: 1.5,),
                                                            ),
                                                            SizedBox(width: 70, child: Text('YB : ${voltages[1]}'),),
                                                            const Padding(
                                                              padding: EdgeInsets.only(bottom: 2,top: 2),
                                                              child: VerticalDivider(color: Colors.blue,thickness: 1.5,),
                                                            ),
                                                            SizedBox(width: 70, child: Text('BR : ${voltages[2]}'),),
                                                          ],
                                                        ),
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets.only(left: 8),
                                                        child: Divider(height: 6,color: Colors.black12),
                                                      ),
                                                      Container(
                                                        width: 340,
                                                        height: 25,
                                                        color: Colors.transparent,
                                                        child: Row(
                                                          children: [
                                                            const SizedBox(width:80, child: Text('Current', style: TextStyle(color: Colors.black54),),),
                                                            const Padding(
                                                              padding: EdgeInsets.only(bottom: 2,top: 2),
                                                              child: VerticalDivider(color: Colors.transparent,),
                                                            ),
                                                            SizedBox(width: 60, child: Center(child: Text('CY : ${columns[0]}')),),
                                                            const Padding(
                                                              padding: EdgeInsets.only(bottom: 2,top: 2),
                                                              child: VerticalDivider(color: Colors.transparent,),
                                                            ),
                                                            SizedBox(width: 65, child: Center(child: Text('CB : ${columns[1]}')),),
                                                            const Padding(
                                                              padding: EdgeInsets.only(bottom: 2,top: 2),
                                                              child: VerticalDivider(color: Colors.transparent,),
                                                            ),
                                                            SizedBox(width: 65, child: Center(child: Text('CR : ${columns[2]}')),),
                                                          ],
                                                        ),
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets.only(left: 8),
                                                        child: Divider(height: 6,color: Colors.black12),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          MaterialButton(
                                                            color: Colors.green,
                                                            textColor: Colors.white,
                                                            onPressed: () {
                                                              if(getPermissionStatusBySNo(context, 4)){
                                                                String payload = '${filteredPumps[index].sNo},1,1';
                                                                String payLoadFinal = jsonEncode({
                                                                  "6200": [{"6201": payload}]
                                                                });
                                                                MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.deviceId}');
                                                                sentUserOperationToServer('${pump.swName?? pump.name} Start Manually', payLoadFinal);
                                                                showSnakeBar('Pump of comment sent successfully');
                                                                Navigator.pop(context);
                                                              }else{
                                                                Navigator.pop(context);
                                                                GlobalSnackBar.show(context, 'Permission denied', 400);
                                                              }
                                                            },
                                                            child: const Text('Start Manually',
                                                              style: TextStyle(color: Colors.white),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 16,),
                                                          MaterialButton(
                                                            color: Colors.redAccent,
                                                            textColor: Colors.white,
                                                            onPressed: () {
                                                              if(getPermissionStatusBySNo(context, 4)){
                                                                String payload = '${filteredPumps[index].sNo},0,1';
                                                                String payLoadFinal = jsonEncode({
                                                                  "6200": [{"6201": payload}]
                                                                });
                                                                MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.deviceId}');
                                                                sentUserOperationToServer('${pump.swName ?? pump.name} Stop Manually', payLoadFinal);
                                                                showSnakeBar('Pump of comment sent successfully');
                                                                Navigator.pop(context);
                                                              }else{
                                                                Navigator.pop(context);
                                                                GlobalSnackBar.show(context, 'Permission denied', 400);
                                                              }
                                                            },
                                                            child: const Text('Stop Manually',
                                                              style: TextStyle(color: Colors.white),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 16,),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5,),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 0.5,
                                                  height: 125,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(
                                                  width: 59,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(3.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text('${getUnitByParameter(context, 'Level Sensor', pumpLevel[0]['Value'])}',style: const TextStyle(fontSize: 10),),
                                                        const SizedBox(height: 5,),
                                                        Container(
                                                          width: 50,
                                                          height: 75,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: Colors.grey, width: 1),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Stack(
                                                            alignment: Alignment.bottomCenter,
                                                            children: [
                                                              FractionallySizedBox(
                                                                heightFactor: pumpLevel[0]['LevelPercent']/75,
                                                                alignment: Alignment.bottomCenter,
                                                                child: Container(
                                                                  decoration: const BoxDecoration(
                                                                    color: Colors.blue, // Filled color
                                                                    borderRadius: BorderRadius.vertical(
                                                                      bottom: Radius.circular(6),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Text(
                                                                  '${(pumpLevel[0]['LevelPercent'] * 75).toStringAsFixed(0)}%',
                                                                  style: const TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(height: 5,),
                                                        Text(pumpLevel[0]['SW_Name'], style: const TextStyle(fontSize: 10),textAlign: TextAlign.center,),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ):
                                      voltKeyExists?Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: voltKeyExists && pumpLevel.isNotEmpty?392:315,
                                            height: 35,
                                            color: Colors.teal,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(width: 8,),
                                                Text.rich(
                                                  TextSpan(
                                                    text: 'Version : ',
                                                    style: const TextStyle(color: Colors.white54),
                                                    children: [
                                                      TextSpan(
                                                        text: filteredPumps[index].version,
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.bold, color: Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                                Icon(signalStrength == 0 ? Icons.wifi_off :
                                                signalStrength >= 1 && signalStrength <= 20 ?
                                                Icons.network_wifi_1_bar_outlined :
                                                signalStrength >= 21 && signalStrength <= 40 ?
                                                Icons.network_wifi_2_bar_outlined :
                                                signalStrength >= 41 && signalStrength <= 60 ?
                                                Icons.network_wifi_3_bar_outlined :
                                                signalStrength >= 61 && signalStrength <= 80 ?
                                                Icons.network_wifi_3_bar_outlined :
                                                Icons.wifi, color: signalStrength == 0?Colors.white54:Colors.white,),
                                                const SizedBox(width: 5,),
                                                Text('$signalStrength%', style: const TextStyle(color: Colors.white),),

                                                const SizedBox(width: 5,),
                                                batteryVolt==0?const Icon(Icons.battery_0_bar, color: Colors.white54,):
                                                batteryVolt>0&&batteryVolt<=10?const Icon(Icons.battery_1_bar_rounded, color: Colors.white,):
                                                batteryVolt>10&&batteryVolt<=30?const Icon(Icons.battery_2_bar_rounded, color: Colors.white,):
                                                batteryVolt>30&&batteryVolt<=50?const Icon(Icons.battery_3_bar_rounded, color: Colors.white,):
                                                batteryVolt>50&&batteryVolt<=70?const Icon(Icons.battery_4_bar_rounded, color: Colors.white,):
                                                batteryVolt>70&&batteryVolt<=90?const Icon(Icons.battery_5_bar_rounded, color: Colors.white,):
                                                const Icon(Icons.battery_full, color: Colors.white,),
                                                Text('$batteryVolt%', style: const TextStyle(color: Colors.white),),

                                                const SizedBox(width: 8,),
                                              ],
                                            ),
                                          ),
                                          int.parse(filteredPumps[index].reason)>0 ? Container(
                                            width: 315,
                                            height: 30,
                                            color: Colors.green.shade50,
                                            child: Row(
                                              children: [
                                                Expanded(child: Padding(
                                                  padding: const EdgeInsets.only(left: 5),
                                                  child: Text(getContentByCode(int.parse(filteredPumps[index].reason)), style: const TextStyle(fontSize: 11, color: Colors.black54)),
                                                )),
                                                (!excludedReasons.contains(filteredPumps[index].reason)) ? SizedBox(
                                                  height:20,
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: Colors.redAccent.shade200,
                                                      textStyle: const TextStyle(color: Colors.white),
                                                    ),
                                                    onPressed: () {
                                                      if(getPermissionStatusBySNo(context, 4)){
                                                        String payload = '${filteredPumps[index].sNo},1';
                                                        String payLoadFinal = jsonEncode({
                                                          "6300": [{"6301": payload}]
                                                        });
                                                        MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.deviceId}');
                                                        sentUserOperationToServer('${pump.swName ?? pump.name} Reset Manually', payLoadFinal);
                                                        showSnakeBar('Reset comment sent successfully');
                                                        Navigator.pop(context);
                                                      }else{
                                                        Navigator.pop(context);
                                                        GlobalSnackBar.show(context, 'Permission denied', 400);
                                                      }
                                                    },
                                                    child: const Text('Reset', style: TextStyle(fontSize: 11, color: Colors.white),),
                                                  ),
                                                ):const SizedBox(),
                                                const SizedBox(width: 5,),
                                              ],
                                            ),
                                          ):
                                          const SizedBox(),
                                          Container(
                                            width: 300,
                                            height: 25,
                                            color: Colors.transparent,
                                            child: Row(
                                              children: [
                                                const SizedBox(width:100, child: Text('Phase', style: TextStyle(color: Colors.black54),),),
                                                const Spacer(),
                                                CircleAvatar(radius: 7, backgroundColor: int.parse(filteredPumps[index].phase)>0? Colors.green: Colors.red.shade100,),
                                                const VerticalDivider(color: Colors.transparent,),
                                                CircleAvatar(radius: 7, backgroundColor: int.parse(filteredPumps[index].phase)>1? Colors.green: Colors.red.shade100,),
                                                const VerticalDivider(color: Colors.transparent,),
                                                CircleAvatar(radius: 7, backgroundColor: int.parse(filteredPumps[index].phase)>2? Colors.green: Colors.red.shade100,),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 5,),
                                          Container(
                                            width: 300,
                                            height: 25,
                                            color: Colors.transparent,
                                            child: Row(
                                              children: [
                                                const SizedBox(width:85, child: Text('Voltage', style: TextStyle(color: Colors.black54),),),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.shade50,
                                                    border: Border.all(
                                                      color: Colors.red.shade200,
                                                      width: 0.7,
                                                    ),
                                                    borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                  ),
                                                  width: 65,
                                                  height: 40,
                                                  child: Center( // Center widget aligns the child in the center
                                                    child: Text(
                                                      'RY : ${voltages[0]}',
                                                      style: const TextStyle(fontSize: 11),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 7,),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.yellow.shade50,
                                                    border: Border.all(
                                                      color: Colors.yellow.shade500,
                                                      width: 0.7,
                                                    ),
                                                    borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                  ),
                                                  width: 65,
                                                  height: 40,
                                                  child: Center(
                                                    child: Text(
                                                      'YB : ${voltages[1]}',
                                                      style: const TextStyle(fontSize: 11),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 7,),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue.shade50,
                                                    border: Border.all(
                                                      color: Colors.blue.shade300,
                                                      width: 0.7,
                                                    ),
                                                    borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                  ),
                                                  width: 65,
                                                  height: 40,
                                                  child: Center(
                                                    child: Text(
                                                      'BR : ${voltages[2]}',
                                                      style: const TextStyle(fontSize: 11),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 7,),
                                          Container(
                                            width: 300,
                                            height: 25,
                                            color: Colors.transparent,
                                            child: Row(
                                              children: [
                                                const SizedBox(width:85, child: Text('Current', style: TextStyle(color: Colors.black54),),),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.shade50,
                                                    border: Border.all(
                                                      color: Colors.red.shade200,
                                                      width: 0.7,
                                                    ),
                                                    borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                  ),
                                                  width: 65,
                                                  height: 40,
                                                  child: Center( // Center widget aligns the child in the center
                                                    child: Text(
                                                      'YC : ${columns[0]}',
                                                      style: const TextStyle(fontSize: 11),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 7,),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.yellow.shade50,
                                                    border: Border.all(
                                                      color: Colors.yellow.shade500,
                                                      width: 0.7,
                                                    ),
                                                    borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                  ),
                                                  width: 65,
                                                  height: 40,
                                                  child: Center(
                                                    child: Text(
                                                      'BC : ${columns[1]}',
                                                      style: const TextStyle(fontSize: 11),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 7,),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue.shade50,
                                                    border: Border.all(
                                                      color: Colors.blue.shade300,
                                                      width: 0.7,
                                                    ),
                                                    borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                  ),
                                                  width: 65,
                                                  height: 40,
                                                  child: Center(
                                                    child: Text(
                                                      'RC : ${columns[2]}',
                                                      style: const TextStyle(fontSize: 11),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 7,),
                                          icEnergy.length>1?Padding(
                                            padding: const EdgeInsets.only(bottom: 7),
                                            child: Container(
                                              width: 300,
                                              height: 25,
                                              color: Colors.transparent,
                                              child: Row(
                                                children: [
                                                  const SizedBox(width:229, child: Text('Instant Energy : ', style: TextStyle(color: Colors.black54),),),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.shade200,
                                                      border: Border.all(
                                                        color: Colors.grey.shade300,
                                                        width: 0.7,
                                                      ),
                                                      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                    ),
                                                    width: 65,
                                                    height: 40,
                                                    child: Center(
                                                      child: Text(
                                                        icEnergy[0],
                                                        style: const TextStyle(fontSize: 12),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ):
                                          const SizedBox(),
                                          icEnergy.length>1?Padding(
                                            padding: const EdgeInsets.only(bottom: 7),
                                            child: Container(
                                              width: 300,
                                              height: 25,
                                              color: Colors.transparent,
                                              child: Row(
                                                children: [
                                                  const SizedBox(width:229, child: Text('Cumulative Energy : ', style: TextStyle(color: Colors.black54),),),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.shade200,
                                                      border: Border.all(
                                                        color: Colors.grey.shade300,
                                                        width: 0.7,
                                                      ),
                                                      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                    ),
                                                    width: 65,
                                                    height: 40,
                                                    child: Center(
                                                      child: Text(
                                                        icEnergy[1],
                                                        style: const TextStyle(fontSize: 12),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ):
                                          const SizedBox(),
                                          icPwrFactor.length>1?Padding(
                                            padding: const EdgeInsets.only(bottom: 7),
                                            child: Container(
                                              width: 300,
                                              height: 25,
                                              color: Colors.transparent,
                                              child: Row(
                                                children: [
                                                  const SizedBox(width:90, child: Text('Power Factor', style: TextStyle(color: Colors.black54),),),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.red.shade50,
                                                      border: Border.all(
                                                        color: Colors.red.shade200,
                                                        width: 0.7,
                                                      ),
                                                      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                    ),
                                                    width: 65,
                                                    height: 40,
                                                    child: Center( // Center widget aligns the child in the center
                                                      child: Text(
                                                        'RPF : ${icPwrFactor[0]}',
                                                        style: const TextStyle(fontSize: 11),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 7,),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.yellow.shade50,
                                                      border: Border.all(
                                                        color: Colors.yellow.shade200,
                                                        width: 0.7,
                                                      ),
                                                      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                    ),
                                                    width: 65,
                                                    height: 40,
                                                    child: Center(
                                                      child: Text(
                                                        'YPF : ${icPwrFactor[1]}',
                                                        style: const TextStyle(fontSize: 11),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 7,),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue.shade50,
                                                      border: Border.all(
                                                        color: Colors.blue.shade200,
                                                        width: 0.7,
                                                      ),
                                                      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                    ),
                                                    width: 65,
                                                    height: 40,
                                                    child: Center(
                                                      child: Text(
                                                        'BPF : ${icPwrFactor[2]}',
                                                        style: const TextStyle(fontSize: 11),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ):
                                          const SizedBox(),
                                          icPwr.length>1?Padding(
                                            padding: const EdgeInsets.only(bottom: 5),
                                            child: Container(
                                              width: 300,
                                              height: 25,
                                              color: Colors.transparent,
                                              child: Row(
                                                children: [
                                                  const SizedBox(width:90, child: Text('Power', style: TextStyle(color: Colors.black54),),),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.red.shade50,
                                                      border: Border.all(
                                                        color: Colors.red.shade200,
                                                        width: 0.7,
                                                      ),
                                                      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                    ),
                                                    width: 65,
                                                    height: 40,
                                                    child: Center( // Center widget aligns the child in the center
                                                      child: Text(
                                                        'RP : ${icPwr[0]}',
                                                        style: const TextStyle(fontSize: 11),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 7,),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.yellow.shade50,
                                                      border: Border.all(
                                                        color: Colors.yellow.shade200,
                                                        width: 0.7,
                                                      ),
                                                      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                    ),
                                                    width: 65,
                                                    height: 40,
                                                    child: Center(
                                                      child: Text(
                                                        'YP : ${icPwr[1]}',
                                                        style: const TextStyle(fontSize: 11),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 7,),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue.shade50,
                                                      border: Border.all(
                                                        color: Colors.blue.shade200,
                                                        width: 0.7,
                                                      ),
                                                      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                    ),
                                                    width: 65,
                                                    height: 40,
                                                    child: Center(
                                                      child: Text(
                                                        'BP : ${icPwr[2]}',
                                                        style: const TextStyle(fontSize: 11),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ):
                                          const SizedBox(),
                                          int.parse(filteredPumps[index].reason)>0 && isTimeFormat(filteredPumps[index].setValue) ?
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 5),
                                            child: SizedBox(
                                              width: 300,
                                              height: 45,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text.rich(
                                                    TextSpan(
                                                      text: (filteredPumps[index].reason == '11'||filteredPumps[index].reason == '22') ? 'Cyc-Remain(hh:mm:ss)':'Set Amps : ',
                                                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                                                      children: [
                                                        TextSpan(
                                                          text: '\n${filteredPumps[index].setValue}',
                                                          style: const TextStyle(
                                                              fontWeight: FontWeight.bold, color: Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text.rich(
                                                    TextSpan(
                                                      text: (filteredPumps[index].reason == '11'||filteredPumps[index].reason == '22') ? 'Max Time(hh:mm:ss)': 'Actual Amps : ' ,
                                                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                                                      children: [
                                                        TextSpan(
                                                          text: '\n${filteredPumps[index].actualValue}',
                                                          style: const TextStyle(
                                                              fontWeight: FontWeight.bold, color: Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ):
                                          const SizedBox(),

                                          filteredPumps[index].topTankHigh.isNotEmpty?
                                          Padding(
                                            padding: const EdgeInsets.only(left:5, bottom: 5, top: 5),
                                            child: Column(
                                              children: filteredPumps[index].topTankHigh.map((item) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: 300,
                                                      height: 25,
                                                      color: Colors.transparent,
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width:235, child: Text(item['SW_Name']!=null?' ${item['SW_Name']} : ':
                                                          '${item['Name']} : ', style: const TextStyle(color: Colors.black54),),),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.grey.shade200,
                                                              border: Border.all(
                                                                color: Colors.grey.shade300,
                                                                width: 0.7,
                                                              ),
                                                              borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                            ),
                                                            width: 65,
                                                            height: 40,
                                                            child: Center(
                                                              child: Text(
                                                                item['Value'],
                                                                style: const TextStyle(fontSize: 12),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ):
                                          const SizedBox(),

                                          filteredPumps[index].topTankLow.isNotEmpty?
                                          Padding(
                                            padding: const EdgeInsets.only(left:5, bottom: 5, top: 5),
                                            child: Column(
                                              children: filteredPumps[index].topTankLow.map((item) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: 300,
                                                      height: 25,
                                                      color: Colors.transparent,
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width:235, child: Text(item['SW_Name']!=null?' ${item['SW_Name']} : ':
                                                          '${item['Name']} : ', style: const TextStyle(color: Colors.black54),),),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.grey.shade200,
                                                              border: Border.all(
                                                                color: Colors.grey.shade300,
                                                                width: 0.7,
                                                              ),
                                                              borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                            ),
                                                            width: 65,
                                                            height: 40,
                                                            child: Center(
                                                              child: Text(
                                                                item['Value'],
                                                                style: const TextStyle(fontSize: 12),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ):
                                          const SizedBox(),

                                          filteredPumps[index].sumpTankHigh.isNotEmpty?
                                          Padding(
                                            padding: const EdgeInsets.only(left:5, bottom: 5, top: 5),
                                            child: Column(
                                              children: filteredPumps[index].sumpTankHigh.map((item) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: 300,
                                                      height: 25,
                                                      color: Colors.transparent,
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width:235, child: Text(item['SW_Name']!=null?' ${item['SW_Name']} : ':
                                                          '${item['Name']} : ', style: const TextStyle(color: Colors.black54),),),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.grey.shade200,
                                                              border: Border.all(
                                                                color: Colors.grey.shade300,
                                                                width: 0.7,
                                                              ),
                                                              borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                            ),
                                                            width: 65,
                                                            height: 40,
                                                            child: Center(
                                                              child: Text(
                                                                item['Value'],
                                                                style: const TextStyle(fontSize: 12),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ):
                                          const SizedBox(),

                                          filteredPumps[index].sumpTankLow.isNotEmpty?
                                          Padding(
                                            padding: const EdgeInsets.only(left:5, bottom: 5, top: 5),
                                            child: Column(
                                              children: filteredPumps[index].sumpTankLow.map((item) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: 300,
                                                      height: 25,
                                                      color: Colors.transparent,
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width:235, child: Text(item['SW_Name']!=null?' ${item['SW_Name']} : ':
                                                          '${item['Name']} : ', style: const TextStyle(color: Colors.black54),),),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.grey.shade200,
                                                              border: Border.all(
                                                                color: Colors.grey.shade300,
                                                                width: 0.7,
                                                              ),
                                                              borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                                            ),
                                                            width: 65,
                                                            height: 40,
                                                            child: Center(
                                                              child: Text(
                                                                item['Value'],
                                                                style: const TextStyle(fontSize: 12),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ):
                                          const SizedBox(),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              MaterialButton(
                                                color: Colors.green,
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  if(getPermissionStatusBySNo(context, 4)){
                                                    String payload = '${filteredPumps[index].sNo},1,1';
                                                    String payLoadFinal = jsonEncode({
                                                      "6200": [{"6201": payload}]
                                                    });
                                                    MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.deviceId}');
                                                    sentUserOperationToServer('${pump.swName?? pump.name} Start Manually', payLoadFinal);
                                                    showSnakeBar('Pump of comment sent successfully');
                                                    Navigator.pop(context);
                                                  }else{
                                                    Navigator.pop(context);
                                                    GlobalSnackBar.show(context, 'Permission denied', 400);
                                                  }
                                                },
                                                child: const Text('Start Manually',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              const SizedBox(width: 16,),
                                              MaterialButton(
                                                color: Colors.redAccent,
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  if(getPermissionStatusBySNo(context, 4)){
                                                    String payload = '${filteredPumps[index].sNo},0,1';
                                                    String payLoadFinal = jsonEncode({
                                                      "6200": [{"6201": payload}]
                                                    });
                                                    MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.deviceId}');
                                                    sentUserOperationToServer('${pump.swName ?? pump.name} Stop Manually', payLoadFinal);
                                                    showSnakeBar('Pump of comment sent successfully');
                                                    Navigator.pop(context);
                                                  }else{
                                                    Navigator.pop(context);
                                                    GlobalSnackBar.show(context, 'Permission denied', 400);
                                                  }
                                                },
                                                child: const Text('Stop Manually',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              const SizedBox(width: 16,),
                                            ],
                                          ),
                                          const SizedBox(height: 7,),
                                        ],
                                      ):Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(height: 8,),
                                              MaterialButton(
                                                color: Colors.green,
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  if(getPermissionStatusBySNo(context, 4)){
                                                    String payload = '${filteredPumps[index].sNo},1,1';
                                                    String payLoadFinal = jsonEncode({
                                                      "6200": [{"6201": payload}]
                                                    });
                                                    MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.deviceId}');
                                                    sentUserOperationToServer('${pump.swName ?? pump.name} Start Manually', payLoadFinal);
                                                    showSnakeBar('Pump of comment sent successfully');
                                                    Navigator.pop(context);
                                                  }else{
                                                    Navigator.pop(context);
                                                    GlobalSnackBar.show(context, 'Permission denied', 400);
                                                  }
                                                },
                                                child: const Text('Start Manually',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              const SizedBox(height: 8,),
                                              MaterialButton(
                                                color: Colors.redAccent,
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  if(getPermissionStatusBySNo(context, 4)){
                                                    String payload = '${filteredPumps[index].sNo},0,1';
                                                    String payLoadFinal = jsonEncode({
                                                      "6200": [{"6201": payload}]
                                                    });
                                                    MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.deviceId}');
                                                    sentUserOperationToServer('${pump.swName ?? pump.name} Stop Manually', payLoadFinal);
                                                    showSnakeBar('Pump of comment sent successfully');
                                                    Navigator.pop(context);
                                                  }else{
                                                    Navigator.pop(context);
                                                    GlobalSnackBar.show(context, 'Permission denied', 400);
                                                  }

                                                },
                                                child: const Text('Stop Manually',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              const SizedBox(height: 8,),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                          onPop: () => print('Popover was popped!'),
                          direction: PopoverDirection.right,
                          width: voltKeyExists && pumpLevel.isNotEmpty?400:voltKeyExists?300:140,
                          arrowHeight: 15,
                          arrowWidth: 30,
                          barrierColor: Colors.black54,
                          arrowDxOffset: filteredPumps.length==1?(position.dx+25)+(index*70)-140:
                          filteredPumps.length==2?(position.dx+25)+(index*70)-210:
                          filteredPumps.length==3?(position.dx+25)+(index*70)-280:
                          filteredPumps.length==4?(position.dx+25)+(index*70)-350:
                          filteredPumps.length==5?(position.dx+25)+(index*70)-420:
                          filteredPumps.length==6?(position.dx+25)+(index*70)-490:
                          filteredPumps.length==7?(position.dx+25)+(index*70)-560:
                          filteredPumps.length==8?(position.dx+25)+(index*70)-630:
                          filteredPumps.length==9?(position.dx+25)+(index*70)-700:
                          filteredPumps.length==10?(position.dx+25)+(index*70)-770:
                          filteredPumps.length==11?(position.dx+25)+(index*70)-840:
                          filteredPumps.length==12?(position.dx+25)+(index*70)-910:
                          (position.dx+25)+(index*70)-280,
                        );
                      },
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                        minimumSize: WidgetStateProperty.all(Size.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: WidgetStateProperty.all(Colors.transparent),
                      ),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: AppImages.getAsset('irrigationPump', pump.status, ''),
                      ),
                    ),
                  ),
                  pump.onDelayLeft != '00:00:00'? Positioned(
                    top: 30,
                    left: 7.5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: const BorderRadius.all(Radius.circular(2)),
                        border: Border.all(color: Colors.green, width: .50),
                      ),
                      width: 55,
                      child: Center(
                        child: Column(
                          children: [
                            const Text(
                              "On delay",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 3, right: 3),
                              child: Divider(
                                height: 0,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              pump.onDelayLeft,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ):
                  const SizedBox(),

                  int.tryParse(pump.reason) != null && int.parse(pump.reason) > 0
                      ? Positioned(
                    top: 1,
                    left: 37.5,
                    child: Tooltip(
                      message: getContentByCode(int.parse(filteredPumps[index].reason)),
                      textStyle: const TextStyle(color: Colors.black54),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const CircleAvatar(
                        radius: 11,
                        backgroundColor: Colors.deepOrangeAccent,
                        child: Icon(
                          Icons.info_outline,
                          size: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ):const SizedBox(),

                  (filteredPumps[index].reason == '11'||filteredPumps[index].reason == '22')?
                  Positioned(
                    top: 40,
                    left: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: pump.status==1?Colors.greenAccent:Colors.yellowAccent,
                        borderRadius: const BorderRadius.all(Radius.circular(2)),
                        border: Border.all(color: Colors.grey, width: .50),
                      ),
                      width: 67,
                      child: Center(
                        child: ValueListenableBuilder<String>(
                          valueListenable: Provider.of<DurationNotifier>(context).onDelayLeft,
                          builder: (context, value, child) {
                            return Column(
                              children: [
                                Text(
                                  'Max: ${pump.actualValue}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 3, right: 3),
                                  child: Divider(
                                    height: 0,
                                    color: Colors.grey,
                                    thickness: 0.5,
                                  ),
                                ),
                                Text(
                                  pump.status==1?'cRm: ${pump.setValue}':'Brk: ${pump.setValue}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ):const SizedBox(),
                ],
              ),
              SizedBox(
                width: 67,
                height: 30,
                child: Text(
                  pump.swName ?? pump.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  List<PumpData> filterPumpsByLocation(List<PumpData> pumps, String currentLocation) {
    if (currentLocation == 'all') {
      return pumps;
    } else {
      return pumps.where((pump) => pump.location.contains(currentLocation)).toList();
    }
  }

  double calculateArrowDxOffset(int pumpCount, double dx, int index) {
    print(pumpCount);
    if (pumpCount == 1) {
      return dx - 25;
    } else {
      print(dx + (index * 70) - 35);
      return dx + (index * 70) - 35;
    }
  }

  void showSnakeBar(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void sentUserOperationToServer(String msg, String data) async
  {
    Map<String, Object> body = {"userId": widget.customerId, "controllerId": widget.controllerId, "messageStatus": msg, "hardware": jsonDecode(data), "createUser": widget.userId};
    final response = await HttpService().postRequest("createUserSentAndReceivedMessageManually", body);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  String getContentByCode(int code) {
    return PumpReasonCode.fromCode(code).content;
  }

}

class DisplayIrrigationPump extends StatefulWidget {
  const DisplayIrrigationPump({Key? key, required this.currentLineId, required this.deviceId, required this.ipList, required this.userId, required this.controllerId}) : super(key: key);
  final String currentLineId;
  final String deviceId;
  final List<PumpData> ipList;
  final int userId, controllerId;

  @override
  State<DisplayIrrigationPump> createState() => _DisplayIrrigationPumpState();
}

class _DisplayIrrigationPumpState extends State<DisplayIrrigationPump> {

  Timer? timer;

  @override
  void initState() {
    super.initState();
    for (var ip in widget.ipList) {
      if (ip.onDelayLeft != '00:00:00') {
        updatePumpOnDelayTime();
      }else{
        timer?.cancel();
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void updatePumpOnDelayTime() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      try{
        for (var ip in widget.ipList) {
          if (ip.onDelayLeft!='00:00:00') {
            List<String> parts = ip.onDelayLeft.split(':');
            int hours = int.parse(parts[0]);
            int minutes = int.parse(parts[1]);
            int seconds = int.parse(parts[2]);

            if (seconds > 0) {
              seconds--;
            } else {
              if (minutes > 0) {
                minutes--;
                seconds = 59;
              } else {
                if (hours > 0) {
                  hours--;
                  minutes = 59;
                  seconds = 59;
                }
              }
            }

            String updatedDurationQtyLeft = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
            if (ip.onDelayLeft != '00:00:00') {
              setState(() {
                ip.onDelayLeft = updatedDurationQtyLeft;
              });
            }
          }
        }
      }
      catch(e){
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    List<PumpData> filteredPumps = filterPumpsByLocation(widget.ipList, widget.currentLineId);

    return SizedBox(
      width: filteredPumps.length * 70,
      height: 100,
      child: Row(
        children: List.generate(filteredPumps.length, (index) {
          final pump = filteredPumps[index];
          return Column(
            children: [
              Stack(
                children: [
                  Tooltip(
                    message: 'View more details',
                    child: TextButton(
                      onPressed: () {

                        final RenderBox button = context.findRenderObject() as RenderBox;
                        final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                        final position = button.localToGlobal(Offset.zero, ancestor: overlay);

                        bool voltKeyExists = filteredPumps[index].voltage.isNotEmpty;
                        int signalStrength = voltKeyExists? int.parse(filteredPumps[index].signalStrength):0;
                        int batteryVolt = voltKeyExists? int.parse(filteredPumps[index].battery):0;
                        List<String> voltages = voltKeyExists? filteredPumps[index].voltage.split(','):[];
                        List<String> currents = voltKeyExists? filteredPumps[index].current.split(','):[];

                        List<String> columns = ['-', '-', '-'];

                        if (voltKeyExists) {
                          for (var pair in currents) {
                            String sanitizedPair = pair.trim().replaceAll(RegExp(r'^"|"$'), '');
                            List<String> parts = sanitizedPair.split(':');
                            if (parts.length != 2) {
                              print('Error: Pair "$sanitizedPair" does not have the expected format');
                              continue;
                            }

                            try {
                              int columnIndex = int.parse(parts[0].trim()) - 1;
                              if (columnIndex >= 0 && columnIndex < columns.length) {
                                columns[columnIndex] = parts[1].trim();
                              } else {
                                print('Error: Column index $columnIndex is out of bounds');
                              }
                            } catch (e) {
                              print('Error parsing column index from "$sanitizedPair": $e');
                            }
                          }
                        }

                        int srcCount = 0;
                        int irgCount = 0;
                        if (widget.currentLineId == 'all') {
                          srcCount = Provider.of<MqttPayloadProvider>(context, listen: false).sourcePump.length;
                          irgCount = Provider.of<MqttPayloadProvider>(context, listen: false).irrigationPump.length;
                        }else{
                          srcCount = Provider.of<MqttPayloadProvider>(context, listen: false).sourcePump
                              .where((pump) => pump.location.contains(widget.currentLineId)).toList()
                              .cast<Map<String, dynamic>>().length;

                          irgCount = Provider.of<MqttPayloadProvider>(context, listen: false).irrigationPump
                              .where((pump) => pump.location.contains(widget.currentLineId)).toList()
                              .cast<Map<String, dynamic>>().length;
                        }

                        showPopover(
                          context: context,
                          bodyBuilder: (context) => voltKeyExists?Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 315,
                                height: 35,
                                color: Colors.teal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(width: 8,),
                                    Text.rich(
                                      TextSpan(
                                        text: 'Version : ',
                                        style: const TextStyle(color: Colors.white54),
                                        children: [
                                          TextSpan(
                                            text: filteredPumps[index].version,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(signalStrength == 0 ? Icons.wifi_off :
                                    signalStrength >= 1 && signalStrength <= 20 ?
                                    Icons.network_wifi_1_bar_outlined :
                                    signalStrength >= 21 && signalStrength <= 40 ?
                                    Icons.network_wifi_2_bar_outlined :
                                    signalStrength >= 41 && signalStrength <= 60 ?
                                    Icons.network_wifi_3_bar_outlined :
                                    signalStrength >= 61 && signalStrength <= 80 ?
                                    Icons.network_wifi_3_bar_outlined :
                                    Icons.wifi, color: signalStrength == 0?Colors.white54:Colors.white,),
                                    const SizedBox(width: 5,),
                                    Text('$signalStrength%', style: const TextStyle(color: Colors.white),),

                                    const SizedBox(width: 5,),
                                    batteryVolt==0?const Icon(Icons.battery_0_bar, color: Colors.white54,):
                                    batteryVolt>0&&batteryVolt<=10?const Icon(Icons.battery_1_bar_rounded, color: Colors.white,):
                                    batteryVolt>10&&batteryVolt<=30?const Icon(Icons.battery_2_bar_rounded, color: Colors.white,):
                                    batteryVolt>30&&batteryVolt<=50?const Icon(Icons.battery_3_bar_rounded, color: Colors.white,):
                                    batteryVolt>50&&batteryVolt<=70?const Icon(Icons.battery_4_bar_rounded, color: Colors.white,):
                                    batteryVolt>70&&batteryVolt<=90?const Icon(Icons.battery_5_bar_rounded, color: Colors.white,):
                                    const Icon(Icons.battery_full, color: Colors.white,),
                                    Text('$batteryVolt%', style: const TextStyle(color: Colors.white),),

                                    const SizedBox(width: 8,),
                                  ],
                                ),
                              ),
                              int.parse(filteredPumps[index].reason)>0 ? Container(
                                width: 305,
                                height: 45,
                                color: Colors.red.shade100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 8,),
                                    Expanded(
                                      child:
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          int.parse(filteredPumps[index].reason)==8 || int.parse(filteredPumps[index].reason)==9 ?
                                          Text('Reason (Set : ${filteredPumps[index].setValue}. Actual : ${filteredPumps[index].actualValue})',style: const TextStyle(fontSize: 13,),): const Text('Reason',style: TextStyle(fontSize: 13,),),
                                          Text(getContentByCode(int.parse(filteredPumps[index].reason)), style: const TextStyle(fontSize: 11,)),
                                        ],
                                      ),
                                    ),
                                    int.parse(filteredPumps[index].reason)==8 || int.parse(filteredPumps[index].reason)==9?
                                    MaterialButton(
                                      color: Colors.orange,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        String payload = '${filteredPumps[index].sNo},1';
                                        String payLoadFinal = jsonEncode({
                                          "6300": [{"6301": payload}]
                                        });
                                        MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.deviceId}');
                                        sentUserOperationToServer('${pump.swName ?? pump.name} Reset Manually', payLoadFinal);
                                        showSnakeBar('Reset comment sent successfully');
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Reset',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ): const SizedBox(),
                                    const SizedBox(width: 5,),
                                  ],
                                ),
                              ):
                              const SizedBox(),
                              const SizedBox(height: 5,),
                              Container(
                                width: 300,
                                height: 25,
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    const SizedBox(width:100, child: Text('Phase', style: TextStyle(color: Colors.black54),),),
                                    const Spacer(),
                                    CircleAvatar(radius: 7, backgroundColor: int.parse(filteredPumps[index].phase)>0? Colors.green: Colors.red.shade100,),
                                    const VerticalDivider(color: Colors.transparent,),
                                    CircleAvatar(radius: 7, backgroundColor: int.parse(filteredPumps[index].phase)>1? Colors.green: Colors.red.shade100,),
                                    const VerticalDivider(color: Colors.transparent,),
                                    CircleAvatar(radius: 7, backgroundColor: int.parse(filteredPumps[index].phase)>2? Colors.green: Colors.red.shade100,),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Container(
                                width: 300,
                                height: 25,
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    const SizedBox(width:85, child: Text('Voltage', style: TextStyle(color: Colors.black54),),),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        border: Border.all(
                                          color: Colors.red.shade200,
                                          width: 0.7,
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                      ),
                                      width: 65,
                                      height: 40,
                                      child: Center( // Center widget aligns the child in the center
                                        child: Text(
                                          'RY : ${voltages[0]}',
                                          style: const TextStyle(fontSize: 11),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 7,),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.yellow.shade50,
                                        border: Border.all(
                                          color: Colors.yellow.shade500,
                                          width: 0.7,
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                      ),
                                      width: 65,
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          'YB : ${voltages[1]}',
                                          style: const TextStyle(fontSize: 11),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 7,),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        border: Border.all(
                                          color: Colors.blue.shade300,
                                          width: 0.7,
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                      ),
                                      width: 65,
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          'BR : ${voltages[2]}',
                                          style: const TextStyle(fontSize: 11),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 7,),
                              Container(
                                width: 300,
                                height: 25,
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    const SizedBox(width:85, child: Text('Current', style: TextStyle(color: Colors.black54),),),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        border: Border.all(
                                          color: Colors.red.shade200,
                                          width: 0.7,
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                      ),
                                      width: 65,
                                      height: 40,
                                      child: Center( // Center widget aligns the child in the center
                                        child: Text(
                                          'YC : ${columns[0]}',
                                          style: const TextStyle(fontSize: 11),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 7,),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.yellow.shade50,
                                        border: Border.all(
                                          color: Colors.yellow.shade500,
                                          width: 0.7,
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                      ),
                                      width: 65,
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          'BC : ${columns[1]}',
                                          style: const TextStyle(fontSize: 11),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 7,),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        border: Border.all(
                                          color: Colors.blue.shade300,
                                          width: 0.7,
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                      ),
                                      width: 65,
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          'RC : ${columns[2]}',
                                          style: const TextStyle(fontSize: 11),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 7,),
                            ],
                          ):
                          const Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('No more data'),
                              )
                            ],
                          ),
                          onPop: () => print('Popover was popped!'),
                          direction: PopoverDirection.right,
                          width: voltKeyExists?315:125,
                          arrowHeight: 15,
                          arrowWidth: 30,
                          barrierColor: Colors.black54,
                          arrowDxOffset:
                          (position.dx + 45) + (index * 70) - calculateOffset(srcCount, irgCount) ??
                              ((position.dy - position.dx) + 12) + (index * 70) - 70,
                        );
                      },
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                        minimumSize: WidgetStateProperty.all(Size.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: WidgetStateProperty.all(Colors.transparent),
                      ),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: AppImages.getAsset('irrigationPump', pump.status, ''),
                      ),
                    ),
                  ),
                  pump.onDelayLeft != '00:00:00'? Positioned(
                    top: 30,
                    left: 7.5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: const BorderRadius.all(Radius.circular(2)),
                        border: Border.all(color: Colors.green, width: .50),
                      ),
                      width: 55,
                      child: Center(
                        child: Column(
                          children: [
                            const Text(
                              "On delay",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 3, right: 3),
                              child: Divider(
                                height: 0,
                                color: Colors.grey,
                              ),
                            ),
                            Text(pump.onDelayLeft,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                      : const SizedBox(),
                  int.tryParse(pump.reason) != null && int.parse(pump.reason) > 0
                      ? const Positioned(
                    top: 10,
                    left: 37.5,
                    child: CircleAvatar(
                      radius: 11,
                      backgroundColor: Colors.orange,
                      child: Icon(
                        Icons.running_with_errors,
                        size: 17,
                        color: Colors.white,
                      ),
                    ),
                  )
                      : const SizedBox(),
                ],
              ),
              SizedBox(
                width: 70,
                height: 30,
                child: Text(
                  pump.swName ?? pump.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  int calculateOffset(int srcCount, int irgCount) {
    const baseOffset = 210;

    int irgOffset = (irgCount - 1) * 70;
    int srcOffset = srcCount * 70;

    return baseOffset + irgOffset + srcOffset;
  }

  List<PumpData> filterPumpsByLocation(List<PumpData> pumps, String currentLocation) {
    if (currentLocation == 'all') {
      return pumps;
    } else {
      return pumps.where((pump) => pump.location.contains(currentLocation)).toList();
    }
  }

  String getContentByCode(int code) {
    return PumpReasonCode.fromCode(code).content;
  }

  void showSnakeBar(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void sentUserOperationToServer(String msg, String data) async
  {
    Map<String, Object> body = {"userId": widget.userId, "controllerId": widget.controllerId, "messageStatus": msg, "data": data, "hardware": data, "createUser": widget.userId};
    final response = await HttpService().postRequest("createUserSentAndReceivedMessageManually", body);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

}

class DisplaySensor extends StatelessWidget {
  const DisplaySensor({Key? key, required this.payload2408, required this.index,}) : super(key: key);
  final List<dynamic> payload2408;
  final int index;

  @override
  Widget build(BuildContext context) {
    double totalWidth = 0;

    var data = payload2408[index];
    IrrigationLinePLD payload;

    if (data is Map<String, dynamic>) {
      payload = IrrigationLinePLD.fromJson(data);
    } else if (data is IrrigationLinePLD) {
      payload = data;
    } else {
      return const SizedBox();
    }

    if (payload.prsIn != '-') {
      totalWidth += 70;
    }

    if (payload.prsOut != '-') {
      totalWidth += 70;
    }

    if (payload.waterMeter != '-') {
      totalWidth += 70;
    }


    return SizedBox(
      width: totalWidth,
      height: 85,
      child: (payload.prsIn != '-' || payload.prsOut != '-' || payload.waterMeter != '-')
          ? ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (payload.prsIn != '-')
            buildSensorWidget('${getUnitByParameter(context, 'Pressure Sensor', payload.waterMeter)}', 'assets/images/dp_prs_sensor.png'),

          if (payload.prsOut != '-')
            buildSensorWidget('${getUnitByParameter(context, 'Pressure Sensor', payload.waterMeter)}', 'assets/images/dp_prs_sensor.png'),

          if (payload.waterMeter != '-')
            buildSensorWidget('${getUnitByParameter(context, 'Water Meter', payload.waterMeter)}', 'assets/images/dp_flowmeter.png'),
        ],
      ) : const SizedBox(),
    );
  }

  Widget buildSensorWidget(String value, String imagePath) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: Image.asset(imagePath),
            ),
            Positioned(
              top: 42,
              left: 1,
              child: Container(
                width: 68,
                height: 17,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: const BorderRadius.all(Radius.circular(2)),
                  border: Border.all(
                    color: Colors.grey,
                    width: .50,
                  ),
                ),
                child: Center(
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class DisplayFilter extends StatefulWidget {
  const DisplayFilter({Key? key, required this.currentLineId, required this.filtersSites}) : super(key: key);
  final String currentLineId;
  final List<dynamic> filtersSites;

  @override
  State<DisplayFilter> createState() => _DisplayFilterState();
}

class _DisplayFilterState extends State<DisplayFilter> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    for (var site in widget.filtersSites) {
      if (site['DurationLeft'] != '00:00:00') {
        durationUpdatingFunction();
      }else{
        timer?.cancel();
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> filteredCentralFilter = widget.filtersSites
        .where((pump) => widget.currentLineId== 'all' || pump['Location'].contains(widget.currentLineId))
        .toList()
        .cast<Map<String, dynamic>>();

    return widget.currentLineId=='all' ?Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for(int i=0; i<filteredCentralFilter.length; i++)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      filteredCentralFilter[i]['PrsIn']!='-'?
                      SizedBox(
                        width: 70,
                        height: 70,
                        child : Stack(
                          children: [
                            Image.asset('assets/images/dp_prs_sensor.png',),
                            Positioned(
                              top: 42,
                              left: 5,
                              child: Container(
                                width: 60,
                                height: 17,
                                decoration: BoxDecoration(
                                  color:Colors.yellow,
                                  borderRadius: const BorderRadius.all(Radius.circular(2)),
                                  border: Border.all(color: Colors.grey, width: .50,),
                                ),
                                child: Center(
                                  child: Text('${double.parse(filteredCentralFilter[i]['PrsIn']).toStringAsFixed(2)} bar', style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ):
                      const SizedBox(),
                      SizedBox(
                        height: 90,
                        width: filteredCentralFilter[i]['FilterStatus'].length * 70,
                        child: ListView.builder(
                          itemCount: filteredCentralFilter[i]['FilterStatus'].length,
                          scrollDirection: Axis.horizontal,
                          //reverse: true,
                          itemBuilder: (BuildContext context, int flIndex) {
                            return Column(
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: AppImages.getAsset('filter', filteredCentralFilter[i]['FilterStatus'][flIndex]['Status'],''),
                                    ),
                                    Positioned(
                                      top: 55,
                                      left: 7.5,
                                      child: filteredCentralFilter[i]['DurationLeft']!='00:00:00'? filteredCentralFilter[i]['Status'] == (flIndex+1) ?
                                      Container(
                                        decoration: BoxDecoration(
                                          color:Colors.greenAccent,
                                          borderRadius: const BorderRadius.all(Radius.circular(2)),
                                          border: Border.all(color: Colors.grey, width: .50,),
                                        ),
                                        width: 55,
                                        child: Center(
                                          child: Text(filteredCentralFilter[i]['DurationLeft'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ) :
                                      const SizedBox(): const SizedBox(),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 45,
                                      child: filteredCentralFilter[i]['PrsIn']!='-' && filteredCentralFilter[i]['FilterStatus'].length-1==flIndex? Container(
                                        width:25,
                                        decoration: BoxDecoration(
                                          color:Colors.yellow,
                                          borderRadius: const BorderRadius.all(Radius.circular(2)),
                                          border: Border.all(color: Colors.grey, width: .50,),
                                        ),
                                        child: Center(
                                          child: Text('${filteredCentralFilter[i]['DpValue']}', style: const TextStyle(fontSize: 10),),
                                        ),

                                      ) :
                                      const SizedBox(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 70,
                                  height: 20,
                                  child: Center(
                                    child: Text(filteredCentralFilter[i]['FilterStatus'][flIndex]['SW_Name'] ?? filteredCentralFilter[i]['FilterStatus'][flIndex]['Name'], style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      filteredCentralFilter[i]['PrsOut'] != '-'?
                      SizedBox(
                        width: 70,
                        height: 70,
                        child : Stack(
                          children: [
                            Image.asset('assets/images/dp_prs_sensor.png',),
                            Positioned(
                              top: 42,
                              left: 5,
                              child: Container(
                                width: 60,
                                height: 17,
                                decoration: BoxDecoration(
                                  color:Colors.yellow,
                                  borderRadius: const BorderRadius.all(Radius.circular(2)),
                                  border: Border.all(color: Colors.grey, width: .50,),
                                ),
                                child: Center(
                                  child: Text('${double.parse(filteredCentralFilter[i]['PrsOut']).toStringAsFixed(2)} bar', style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ) :
                      const SizedBox(),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    width: filteredCentralFilter[i]['PrsIn']!='-'? filteredCentralFilter[i]['FilterStatus'].length * 70+70:
                    filteredCentralFilter[i]['FilterStatus'].length * 70,
                    height: 20,
                    child: Center(
                      child: Text(filteredCentralFilter[i]['SW_Name'] ?? filteredCentralFilter[i]['FilterSite'], style: const TextStyle(color: primaryColorDark, fontSize: 11),),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    ):
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for(int i=0; i<filteredCentralFilter.length; i++)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  filteredCentralFilter[i]['PrsIn']!='-'?
                  SizedBox(
                    width: 70,
                    height: 70,
                    child : Stack(
                      children: [
                        Image.asset('assets/images/dp_prs_sensor.png',),
                        Positioned(
                          top: 42,
                          left: 5,
                          child: Container(
                            width: 60,
                            height: 17,
                            decoration: BoxDecoration(
                              color:Colors.yellow,
                              borderRadius: const BorderRadius.all(Radius.circular(2)),
                              border: Border.all(color: Colors.grey, width: .50,),
                            ),
                            child: Center(
                              child: Text('${double.parse(filteredCentralFilter[i]['PrsIn']).toStringAsFixed(2)} bar', style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ):
                  const SizedBox(),
                  SizedBox(
                    height: 90,
                    width: filteredCentralFilter[i]['FilterStatus'].length * 70,
                    child: ListView.builder(
                      itemCount: filteredCentralFilter[i]['FilterStatus'].length,
                      scrollDirection: Axis.horizontal,
                      //reverse: true,
                      itemBuilder: (BuildContext context, int flIndex) {
                        return Column(
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: AppImages.getAsset('filter', filteredCentralFilter[i]['FilterStatus'][flIndex]['Status'],''),
                                ),
                                Positioned(
                                  top: 45,
                                  left: 7.5,
                                  child: filteredCentralFilter[i]['DurationLeft']!='00:00:00'? filteredCentralFilter[i]['Status'] == (flIndex+1) ? Container(
                                    color: Colors.greenAccent,
                                    width: 55,
                                    child: Center(
                                      child: Text(filteredCentralFilter[i]['DurationLeft'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ) :
                                  const SizedBox(): const SizedBox(),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 45,
                                  child: filteredCentralFilter[i]['PrsIn']!='-' && filteredCentralFilter[i]['FilterStatus'].length-1==flIndex? Container(
                                    width:25,
                                    decoration: BoxDecoration(
                                      color:Colors.yellow,
                                      borderRadius: const BorderRadius.all(Radius.circular(2)),
                                      border: Border.all(color: Colors.grey, width: .50,),
                                    ),
                                    child: Center(
                                      child: Text('${filteredCentralFilter[i]['DpValue']}', style: const TextStyle(fontSize: 10),),
                                    ),

                                  ) :
                                  const SizedBox(),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 70,
                              height: 20,
                              child: Center(
                                child: Text(filteredCentralFilter[i]['FilterStatus'][flIndex]['SW_Name'] ?? filteredCentralFilter[i]['FilterStatus'][flIndex]['Name'], style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  filteredCentralFilter[i]['PrsOut'] != '-'?
                  SizedBox(
                    width: 70,
                    height: 70,
                    child : Stack(
                      children: [
                        Image.asset('assets/images/dp_prs_sensor.png',),
                        Positioned(
                          top: 42,
                          left: 5,
                          child: Container(
                            width: 60,
                            height: 17,
                            decoration: BoxDecoration(
                              color:Colors.yellow,
                              borderRadius: const BorderRadius.all(Radius.circular(2)),
                              border: Border.all(color: Colors.grey, width: .50,),
                            ),
                            child: Center(
                              child: Text('${double.parse(filteredCentralFilter[i]['PrsOut']).toStringAsFixed(2)} bar', style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) :
                  const SizedBox(),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(3),
                ),
                width: filteredCentralFilter[i]['PrsIn']!='-'? filteredCentralFilter[i]['FilterStatus'].length * 70+70:
                filteredCentralFilter[i]['FilterStatus'].length * 70,
                height: 20,
                child: Center(
                  child: Text(filteredCentralFilter[0]['SW_Name'] ?? filteredCentralFilter[0]['FilterSite'], style: const TextStyle(color: primaryColorDark, fontSize: 11),),
                ),
              ),
            ],
          ),
      ],
    );

  }

  void durationUpdatingFunction() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      try{
        for (var site in widget.filtersSites) {
          if(site['DurationLeft']!='00:00:00'){
            for (var filters in site['FilterStatus']) {
              if(filters['Status']==1){
                List<String> parts = site['DurationLeft'].split(':');
                int hours = int.parse(parts[0]);
                int minutes = int.parse(parts[1]);
                int seconds = int.parse(parts[2]);

                if (seconds > 0) {
                  seconds--;
                } else {
                  if (minutes > 0) {
                    minutes--;
                    seconds = 59;
                  } else {
                    if (hours > 0) {
                      hours--;
                      minutes = 59;
                      seconds = 59;
                    }
                  }
                }

                String updatedDurationQtyLeft = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                if(updatedDurationQtyLeft!='00:00:00'){
                  setState(() {
                    site['DurationLeft'] = updatedDurationQtyLeft;
                  });
                }
              }
            }
          }
        }
      }
      catch(e){
        print(e);
      }
    });
  }

}

class DisplayCentralFertilizer extends StatefulWidget {
  const DisplayCentralFertilizer({Key? key, required this.currentLineId}) : super(key: key);
  final String currentLineId;

  @override
  State<DisplayCentralFertilizer> createState() => _DisplayCentralFertilizerState();
}

class _DisplayCentralFertilizerState extends State<DisplayCentralFertilizer> {

  Timer? timer;

  @override
  void initState() {
    super.initState();
    durationUpdatingFunction();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overallFrtCentral = Provider.of<MqttPayloadProvider>(context).centralFertilizer;

    List<Map<String, dynamic>> fertilizerCentral = overallFrtCentral
        .where((pump) => widget.currentLineId== 'all' || pump['Location'].contains(widget.currentLineId))
        .toList()
        .cast<Map<String, dynamic>>();

    durationUpdatingFunction();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for(int fIndex=0; fIndex<fertilizerCentral.length; fIndex++)
          SizedBox(
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if(fIndex!=0)
                        SizedBox(
                          width: 4.5,
                          height: 120,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 42),
                                child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                              ),
                              const SizedBox(width: 4.5,),
                              Padding(
                                padding: const EdgeInsets.only(top: 45),
                                child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                          width: 70,
                          height: 120,
                          child : Stack(
                            children: [
                              AppImages.getAsset('booster', fertilizerCentral[fIndex]['Booster'][0]['Status'],''),
                              Positioned(
                                top: 70,
                                left: 15,
                                child: fertilizerCentral[fIndex]['FertilizerTankSelector'].isNotEmpty ? const SizedBox(
                                  width: 50,
                                  child: Center(
                                    child: Text('Selector' , style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    ),
                                  ),
                                ) :
                                const SizedBox(),
                              ),
                              Positioned(
                                top: 85,
                                left: 18,
                                child: fertilizerCentral[fIndex]['FertilizerTankSelector'].isNotEmpty ? Container(
                                  decoration: BoxDecoration(
                                    color: fertilizerCentral[fIndex]['FertilizerTankSelector'][0]['Status']==0? Colors.grey.shade300:
                                    fertilizerCentral[fIndex]['FertilizerTankSelector'][0]['Status']==1? Colors.greenAccent:
                                    fertilizerCentral[fIndex]['FertilizerTankSelector'][0]['Status']==2? Colors.orangeAccent:Colors.redAccent,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  width: 45,
                                  height: 22,
                                  child: Center(
                                    child: Text(fertilizerCentral[fIndex]['FertilizerTankSelector'][0]['Status']!=0?
                                    fertilizerCentral[fIndex]['FertilizerTankSelector'][0]['Name'] : '--' , style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                ) :
                                const SizedBox(),
                              ),
                              Positioned(
                                top: 115,
                                left: 8.3,
                                child: Image.asset('assets/images/dp_fert_vertical_pipe.png', width: 9.5, height: 37,),
                              ),
                            ],
                          )
                      ),
                      SizedBox(
                        width: fertilizerCentral[fIndex]['Fertilizer'].length * 70,
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: fertilizerCentral[fIndex]['Fertilizer'].length,
                          itemBuilder: (BuildContext context, int index) {
                            var fertilizer = fertilizerCentral[fIndex]['Fertilizer'][index];
                            double fertilizerQty = 0.0;
                            var qtyValue = fertilizer['Qty'];
                            if(qtyValue != null) {
                              if(fertilizer['Qty'] is String){
                                fertilizerQty = double.parse(fertilizer['Qty']);
                              }else if(fertilizer['Qty'] is int){
                                fertilizerQty = fertilizer['Qty'].toDouble();
                              }else{
                                fertilizerQty = fertilizer['Qty'];
                              }
                            }

                            var fertilizerLeftVal = fertilizer['QtyLeft'];
                            if (fertilizerLeftVal != null) {
                              if(fertilizerLeftVal is String){
                                fertilizer['QtyLeft'] = double.parse(fertilizer['QtyLeft']);
                              }else if(fertilizer['Qty'] is int){
                                fertilizer['QtyLeft'] = fertilizer['QtyLeft'].toDouble();
                              }else{
                                fertilizer['QtyLeft'] = fertilizer['QtyLeft'];
                              }
                            }

                            return SizedBox(
                              width: 70,
                              height: 120,
                              child: Stack(
                                children: [
                                  buildFertilizerImage(index, fertilizer['Status'], fertilizerCentral[fIndex]['Fertilizer'].length, fertilizerCentral[fIndex]['Agitator']),
                                  Positioned(
                                    top: 52,
                                    left: 6,
                                    child: CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.teal.shade100,
                                      child: Text('${index+1}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                  Positioned(
                                    top: 50,
                                    left: 18,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      width: 60,
                                      child: Center(
                                        child: Text(fertilizer['FertMethod']=='1' || fertilizer['FertMethod']=='3'? fertilizer['Duration'] :
                                        '${fertilizerQty.toStringAsFixed(2)} L', style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 65,
                                    left: 18,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      width: 60,
                                      child: Center(
                                        child: Text('${fertilizer['FlowRate_LpH']}-lph', style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 103,
                                    left: 0,
                                    child: fertilizer['Status'] !=0
                                        &&
                                        fertilizer['FertSelection'] !='_'
                                        &&
                                        fertilizer['DurationLeft'] !='00:00:00'
                                        ?
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      width: 50,
                                      child: Center(
                                        child: Text(fertilizer['FertMethod']=='1' || fertilizer['FertMethod']=='3'
                                            ? fertilizer['DurationLeft']
                                            : fertilizer['QtyLeft'] != null ? '${fertilizer['QtyLeft'].toStringAsFixed(2)} L' :'00.0 L' , style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        ),
                                      ),
                                    ) :
                                    const SizedBox(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      fertilizerCentral[fIndex]['Agitator'].isNotEmpty
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: fertilizerCentral[fIndex]['Agitator'].map<Widget>((agitator) {
                          return Column(
                            children: [
                              SizedBox(
                                width: 59,
                                height: 34,
                                child: AppImages.getAsset('agitator', agitator['Status'], '',),
                              ),
                              Center(child: Text(agitator['Name'], style: const TextStyle(fontSize: 10, color: Colors.black54),)),
                            ],
                          );
                        }).toList(), // Convert the map result to a list of widgets
                      )
                          : const SizedBox(),

                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: fertilizerCentral[fIndex]['Fertilizer'].length * 75,
                  child: Row(
                    children: [
                      if(fIndex!=0)
                        Row(
                          children: [
                            VerticalDivider(width: 0,color: Colors.grey.shade300,),
                            const SizedBox(width: 4.0,),
                            VerticalDivider(width: 0,color: Colors.grey.shade300,),
                          ],
                        ),
                      Row(
                        children: [
                          const SizedBox(width: 10.5,),
                          VerticalDivider(width: 0,color: Colors.grey.shade300,),
                          const SizedBox(width: 4.0,),
                          VerticalDivider(width: 0,color: Colors.grey.shade300,),
                          const SizedBox(width: 5.0,),

                          fertilizerCentral[fIndex]['Ec'].isNotEmpty || fertilizerCentral[fIndex]['Ph'].isNotEmpty
                              ? SizedBox(
                            width: fertilizerCentral[fIndex]['Ec'].length > 1 ? 130 : 70,
                            height: 30,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Display Ec values if available
                                fertilizerCentral[fIndex]['Ec'].isNotEmpty
                                    ? SizedBox(
                                  height: 15,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: fertilizerCentral[fIndex]['Ec'].length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Center(
                                              child: Text(
                                                'Ec : ',
                                                style: TextStyle(
                                                    fontSize: 11, fontWeight: FontWeight.normal),
                                              )),
                                          Center(
                                            child: Text(
                                              double.parse(
                                                  '${fertilizerCentral[fIndex]['Ec'][index]['Status']}')
                                                  .toStringAsFixed(2),
                                              style: const TextStyle(fontSize: 11),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                                    : const SizedBox(),
                                // Display Ph values if available
                                fertilizerCentral[fIndex]['Ph'].isNotEmpty
                                    ? SizedBox(
                                  height: 15,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: fertilizerCentral[fIndex]['Ph'].length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Row(
                                        children: [
                                          const Center(
                                              child: Text(
                                                'pH : ',
                                                style: TextStyle(
                                                    fontSize: 11, fontWeight: FontWeight.normal),
                                              )),
                                          Center(
                                            child: Text(
                                              double.parse(
                                                  '${fertilizerCentral[fIndex]['Ph'][index]['Status']}')
                                                  .toStringAsFixed(2),
                                              style: const TextStyle(fontSize: 11),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                                    : const SizedBox(),
                              ],
                            ),
                          ):
                          const SizedBox(),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            width: (fertilizerCentral[fIndex]['Fertilizer'].length * 67) - (fertilizerCentral[fIndex]['Ec'].length > 0 ?
                            fertilizerCentral[fIndex]['Ec'].length * 70 : fertilizerCentral[fIndex]['Ph'].length * 70),
                            child: Center(
                              child: Text(fertilizerCentral[fIndex]['SW_Name'] ?? fertilizerCentral[fIndex]['FertilizerSite'], style: const TextStyle(color: primaryColorDark, fontSize: 11),),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void durationUpdatingFunction() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      try{
        final fertilizerCentral = Provider.of<MqttPayloadProvider>(context, listen: false).centralFertilizer;
        for (var central in fertilizerCentral) {
          central['Fertilizer'].forEach((fertilizer) {
            int ferMethod = fertilizer['FertMethod'] is int
                ? fertilizer['FertMethod']
                : int.parse(fertilizer['FertMethod']);

            if (fertilizer['Status']==1 && ferMethod == 1) {
              //fertilizer time base
              List<String> parts = fertilizer['DurationLeft'].split(':');
              String updatedDurationQtyLeft = formatDuration(parts);
              setState(() {
                fertilizer['DurationLeft'] = updatedDurationQtyLeft;
              });
            }
            else if (fertilizer['Status']==1 && ferMethod == 2) {
              //fertilizer flow base
              double qtyLeftDouble = convertQtyLeftToDouble(fertilizer['QtyLeft']);
              double flowRate = convertFlowValueToDouble(fertilizer['FlowRate']);
              qtyLeftDouble -= flowRate;
              qtyLeftDouble = qtyLeftDouble < 0 ? 0 : qtyLeftDouble;
              setState(() {
                fertilizer['QtyLeft'] = qtyLeftDouble;
              });
            }
            else if ((fertilizer['Status']==1 || fertilizer['Status']==4) && ferMethod == 3){
              //fertilizer proposal time base
              double fcOnTime = convertQtyLeftToDouble(fertilizer['OnTime']);
              double fcOffTime = convertQtyLeftToDouble(fertilizer['OffTime']);
              int fcOnTimeRd = fcOnTime.round();
              int fcOffTimeRd = fcOffTime.round();

              if (fertilizer['OriginalOnTime'] == null) {
                fertilizer['OriginalOnTime'] = fertilizer['OnTime'];
              }
              if (fertilizer['OriginalOffTime'] == null) {
                fertilizer['OriginalOffTime'] = fertilizer['OffTime'];
              }
              if (fertilizer['OriginalStatus'] == null) {
                fertilizer['OriginalStatus'] = fertilizer['Status'];
              }

              if(fcOnTimeRd>0){
                List<String> parts = fertilizer['DurationLeft'].split(':');
                String updatedDurationQtyLeft = formatDuration(parts);
                fcOnTimeRd--;
                setState(() {
                  fertilizer['OnTime'] = '$fcOnTimeRd';
                  fertilizer['Status'] = fertilizer['OriginalStatus'];
                  fertilizer['DurationLeft'] = updatedDurationQtyLeft;
                });
              }else if(fcOffTimeRd>0){
                fcOffTimeRd--;
                setState(() {
                  fertilizer['OffTime'] = '$fcOffTimeRd';
                  fertilizer['Status'] = 4;
                });

                if(fcOffTimeRd==0){
                  fertilizer['OnTime'] = fertilizer['OriginalOnTime'];
                  fertilizer['OffTime'] = fertilizer['OriginalOffTime'];
                }
              }
            }
            else if ((fertilizer['Status']==1 || fertilizer['Status']==4) && ferMethod == 4){
              //fertilizer proposal qty base
              double fcOnTime = convertQtyLeftToDouble(fertilizer['OnTime']);
              double fcOffTime = convertQtyLeftToDouble(fertilizer['OffTime']);
              int fcOnTimeRd = fcOnTime.round();
              int fcOffTimeRd = fcOffTime.round();

              if (fertilizer['OriginalOnTime'] == null) {
                fertilizer['OriginalOnTime'] = fertilizer['OnTime'];
              }
              if (fertilizer['OriginalOffTime'] == null) {
                fertilizer['OriginalOffTime'] = fertilizer['OffTime'];
              }
              if (fertilizer['OriginalStatus'] == null) {
                fertilizer['OriginalStatus'] = fertilizer['Status'];
              }

              if(fcOnTimeRd>0){
                fcOnTimeRd--;
                double qtyLeftDouble = convertQtyLeftToDouble(fertilizer['QtyLeft']);
                double flowRate = convertFlowValueToDouble(fertilizer['FlowRate']);
                qtyLeftDouble -= flowRate;
                qtyLeftDouble = qtyLeftDouble < 0 ? 0 : qtyLeftDouble;
                setState(() {
                  fertilizer['OnTime'] = '$fcOnTimeRd';
                  fertilizer['Status'] = fertilizer['OriginalStatus'];
                  fertilizer['QtyLeft'] = qtyLeftDouble;
                });
              }else if(fcOffTimeRd>0){
                fcOffTimeRd--;
                setState(() {
                  fertilizer['OffTime'] = '$fcOffTimeRd';
                  fertilizer['Status'] = 4;
                });

                if(fcOffTimeRd==0){
                  fertilizer['OnTime'] = fertilizer['OriginalOnTime'];
                  fertilizer['OffTime'] = fertilizer['OriginalOffTime'];
                }
              }
            }
            else if ((fertilizer['Status']==1 || fertilizer['Status']==4) && ferMethod == 5){
              //fertilizer pro qty per 1000 Lit
              double fcOnTime = convertQtyLeftToDouble(fertilizer['OnTime']);
              double fcOffTime = convertQtyLeftToDouble(fertilizer['OffTime']);
              int fcOnTimeRd = fcOnTime.round();
              int fcOffTimeRd = fcOffTime.round();

              if (fertilizer['OriginalOnTime'] == null) {
                fertilizer['OriginalOnTime'] = fertilizer['OnTime'];
              }
              if (fertilizer['OriginalOffTime'] == null) {
                fertilizer['OriginalOffTime'] = fertilizer['OffTime'];
              }
              if (fertilizer['OriginalStatus'] == null) {
                fertilizer['OriginalStatus'] = fertilizer['Status'];
              }

              if(fcOnTimeRd>0){
                fcOnTimeRd--;
                double qtyLeftDouble = convertQtyLeftToDouble(fertilizer['QtyLeft']);
                double flowRate = convertFlowValueToDouble(fertilizer['FlowRate']);
                qtyLeftDouble -= flowRate;
                qtyLeftDouble = qtyLeftDouble < 0 ? 0 : qtyLeftDouble;
                setState(() {
                  fertilizer['OnTime'] = '$fcOnTimeRd';
                  fertilizer['Status'] = fertilizer['OriginalStatus'];
                  fertilizer['QtyLeft'] = qtyLeftDouble;
                });
              }else if(fcOffTimeRd>0){
                fcOffTimeRd--;
                setState(() {
                  fertilizer['OffTime'] = '$fcOffTimeRd';
                  fertilizer['Status'] = 4;
                });

                if(fcOffTimeRd==0){
                  fertilizer['OnTime'] = fertilizer['OriginalOnTime'];
                  fertilizer['OffTime'] = fertilizer['OriginalOffTime'];
                }
              }
            }
            else{
              //print('ferMethod 6');
            }
          });
        }
      }
      catch(e){
        print(e);
      }

    });
  }

  String formatDuration(List<String> parts) {
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    if (seconds > 0) {
      seconds--;
    } else {
      if (minutes > 0) {
        minutes--;
        seconds = 59;
      } else {
        if (hours > 0) {
          hours--;
          minutes = 59;
          seconds = 59;
        }
      }
    }
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double convertQtyLeftToDouble(dynamic qtyLeftValue) {
    double qtyLeftDouble = 0.00;
    if (qtyLeftValue is int) {
      qtyLeftDouble = qtyLeftValue.toDouble();
    } else if (qtyLeftValue is String) {
      qtyLeftDouble = double.tryParse(qtyLeftValue) ?? 0.00;
    } else if (qtyLeftValue is double) {
      qtyLeftDouble = qtyLeftValue;
    } else {
      qtyLeftDouble = 0.00;
    }
    return qtyLeftDouble;
  }

  double convertFlowValueToDouble(dynamic flowValue) {
    double flowRate = 0.00;
    if (flowValue is int) {
      flowRate = flowValue.toDouble();
    } else if (flowValue is String) {
      flowRate = double.tryParse(flowValue) ?? 0.00;
    } else if (flowValue is double) {
      flowRate = flowValue;
    } else {
      flowRate = 0.00; // Default value in case the type is unknown
    }
    return flowRate;
  }

}

class LocalFilter extends StatefulWidget {
  const LocalFilter({Key? key, required this.currentLineId, required this.filtersSites}) : super(key: key);
  final String currentLineId;
  final List<dynamic> filtersSites;

  @override
  State<LocalFilter> createState() => _LocalFilterState();
}

class _LocalFilterState extends State<LocalFilter> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    for (var site in widget.filtersSites) {
      if (site['DurationLeft'] != '00:00:00') {
        durationUpdatingFunction();
      }else{
        timer?.cancel();
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> filteredLocalFilter = widget.filtersSites
        .where((pump) => widget.currentLineId== 'all' || pump['Location'].contains(widget.currentLineId))
        .toList()
        .cast<Map<String, dynamic>>();

    return widget.currentLineId=='all'? Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for(int i=0; i<filteredLocalFilter.length; i++)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      filteredLocalFilter[i]['PrsIn']!='-'?
                      SizedBox(
                        width: 70,
                        height: 70,
                        child : Stack(
                          children: [
                            Image.asset('assets/images/dp_prs_sensor.png',),
                            Positioned(
                              top: 42,
                              left: 5,
                              child: Container(
                                width: 60,
                                height: 17,
                                decoration: BoxDecoration(
                                  color:Colors.yellow,
                                  borderRadius: const BorderRadius.all(Radius.circular(2)),
                                  border: Border.all(color: Colors.grey, width: .50,),
                                ),
                                child: Center(
                                  child: Text('${double.parse(filteredLocalFilter[i]['PrsIn']).toStringAsFixed(2)} bar', style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ):
                      const SizedBox(),
                      SizedBox(
                        height: 90,
                        width: filteredLocalFilter[i]['FilterStatus'].length * 70,
                        child: ListView.builder(
                          itemCount: filteredLocalFilter[i]['FilterStatus'].length,
                          scrollDirection: Axis.horizontal,
                          //reverse: true,
                          itemBuilder: (BuildContext context, int flIndex) {
                            return Column(
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: AppImages.getAsset('filter', filteredLocalFilter[i]['FilterStatus'][flIndex]['Status'],''),
                                    ),
                                    Positioned(
                                      top: 55,
                                      left: 7.5,
                                      child: filteredLocalFilter[i]['DurationLeft']!='00:00:00'? filteredLocalFilter[i]['Status'] == (flIndex+1) ? Container(
                                        decoration: BoxDecoration(
                                          color:Colors.greenAccent,
                                          borderRadius: const BorderRadius.all(Radius.circular(2)),
                                          border: Border.all(color: Colors.grey, width: .50,),
                                        ),
                                        width: 55,
                                        child: Center(
                                          child: Text(filteredLocalFilter[i]['DurationLeft'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ) :
                                      const SizedBox(): const SizedBox(),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 45,
                                      child: filteredLocalFilter[i]['PrsIn']!='-' && filteredLocalFilter[i]['FilterStatus'].length-1==flIndex? Container(
                                        width:25,
                                        decoration: BoxDecoration(
                                          color:Colors.yellow,
                                          borderRadius: const BorderRadius.all(Radius.circular(2)),
                                          border: Border.all(color: Colors.grey, width: .50,),
                                        ),
                                        child: Center(
                                          child: Text('${filteredLocalFilter[i]['DpValue']}', style: const TextStyle(fontSize: 10),),
                                        ),

                                      ) :
                                      const SizedBox(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 70,
                                  height: 20,
                                  child: Center(
                                    child: Text(filteredLocalFilter[i]['FilterStatus'][flIndex]['SW_Name'] ?? filteredLocalFilter[i]['FilterStatus'][flIndex]['Name'], style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      filteredLocalFilter[i]['PrsOut'] != '-'?
                      SizedBox(
                        width: 70,
                        height: 70,
                        child : Stack(
                          children: [
                            Image.asset('assets/images/dp_prs_sensor.png',),
                            Positioned(
                              top: 42,
                              left: 5,
                              child: Container(
                                width: 60,
                                height: 17,
                                decoration: BoxDecoration(
                                  color:Colors.yellow,
                                  borderRadius: const BorderRadius.all(Radius.circular(2)),
                                  border: Border.all(color: Colors.grey, width: .50,),
                                ),
                                child: Center(
                                  child: Text('${double.parse(filteredLocalFilter[i]['PrsOut']).toStringAsFixed(2)} bar', style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ) :
                      const SizedBox(),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    width: filteredLocalFilter[i]['FilterStatus'].length * 60,
                    child: Center(
                      child: Text(filteredLocalFilter[i]['SW_Name'] ?? filteredLocalFilter[i]['FilterSite'], style: const TextStyle(color: primaryColorDark, fontSize: 11),),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    ):
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for(int i=0; i<filteredLocalFilter.length; i++)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  filteredLocalFilter[i]['PrsIn']!='-'?
                  SizedBox(
                    width: 70,
                    height: 70,
                    child : Stack(
                      children: [
                        Image.asset('assets/images/dp_prs_sensor.png',),
                        Positioned(
                          top: 42,
                          left: 5,
                          child: Container(
                            width: 60,
                            height: 17,
                            decoration: BoxDecoration(
                              color:Colors.yellow,
                              borderRadius: const BorderRadius.all(Radius.circular(2)),
                              border: Border.all(color: Colors.grey, width: .50,),
                            ),
                            child: Center(
                              child: Text('${double.parse(filteredLocalFilter[i]['PrsIn']).toStringAsFixed(2)} bar', style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ):
                  const SizedBox(),
                  SizedBox(
                    height: 90,
                    width: filteredLocalFilter[i]['FilterStatus'].length * 70,
                    child: ListView.builder(
                      itemCount: filteredLocalFilter[i]['FilterStatus'].length,
                      scrollDirection: Axis.horizontal,
                      //reverse: true,
                      itemBuilder: (BuildContext context, int flIndex) {
                        return Column(
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: AppImages.getAsset('filter', filteredLocalFilter[i]['FilterStatus'][flIndex]['Status'],''),
                                ),
                                Positioned(
                                  top: 40,
                                  left: 7.5,
                                  child: filteredLocalFilter[i]['DurationLeft']!='00:00:00'? filteredLocalFilter[i]['Status'] == (flIndex+1) ? Container(
                                    color: Colors.greenAccent,
                                    width: 55,
                                    child: Center(
                                      child: Text(filteredLocalFilter[i]['DurationLeft'], style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      ),
                                    ),
                                  ) :
                                  const SizedBox(): const SizedBox(),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 45,
                                  child: filteredLocalFilter[i]['PrsIn']!='-' && filteredLocalFilter[i]['FilterStatus'].length-1==flIndex? Container(
                                    width:25,
                                    decoration: BoxDecoration(
                                      color:Colors.yellow,
                                      borderRadius: const BorderRadius.all(Radius.circular(2)),
                                      border: Border.all(color: Colors.grey, width: .50,),
                                    ),
                                    child: Center(
                                      child: Text('${filteredLocalFilter[i]['DpValue']}', style: const TextStyle(fontSize: 10),),
                                    ),

                                  ) :
                                  const SizedBox(),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 70,
                              height: 20,
                              child: Center(
                                child: Text(filteredLocalFilter[i]['FilterStatus'][flIndex]['SW_Name'] ?? filteredLocalFilter[i]['FilterStatus'][flIndex]['Name'], style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  filteredLocalFilter[i]['PrsOut'] != '-'?
                  SizedBox(
                    width: 70,
                    height: 70,
                    child : Stack(
                      children: [
                        Image.asset('assets/images/dp_prs_sensor.png',),
                        Positioned(
                          top: 42,
                          left: 5,
                          child: Container(
                            width: 60,
                            height: 17,
                            decoration: BoxDecoration(
                              color:Colors.yellow,
                              borderRadius: const BorderRadius.all(Radius.circular(2)),
                              border: Border.all(color: Colors.grey, width: .50,),
                            ),
                            child: Center(
                              child: Text('${double.parse(filteredLocalFilter[i]['PrsOut']).toStringAsFixed(2)} bar', style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) :
                  const SizedBox(),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(3),
                ),
                width: filteredLocalFilter[i]['FilterStatus'].length * 60,
                child: Center(
                  child: Text(filteredLocalFilter[i]['SW_Name'] ?? filteredLocalFilter[i]['FilterSite'], style: const TextStyle(color: primaryColorDark, fontSize: 11),),
                ),
              ),
            ],
          ),
      ],
    );
  }



  void durationUpdatingFunction() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      try{
        for (var site in widget.filtersSites) {
          if(site['DurationLeft']!='00:00:00'){
            for (var filters in site['FilterStatus']) {
              if(filters['Status']==1){
                List<String> parts = site['DurationLeft'].split(':');
                int hours = int.parse(parts[0]);
                int minutes = int.parse(parts[1]);
                int seconds = int.parse(parts[2]);

                if (seconds > 0) {
                  seconds--;
                } else {
                  if (minutes > 0) {
                    minutes--;
                    seconds = 59;
                  } else {
                    if (hours > 0) {
                      hours--;
                      minutes = 59;
                      seconds = 59;
                    }
                  }
                }

                String updatedDurationQtyLeft = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                if(updatedDurationQtyLeft!='00:00:00'){
                  setState(() {
                    site['DurationLeft'] = updatedDurationQtyLeft;
                  });
                }
              }
            }
          }
        }
      }
      catch(e){
        print(e);
      }
    });
  }

}

class DisplayLocalFertilizer extends StatefulWidget {
  const DisplayLocalFertilizer({Key? key, required this.currentLineId}) : super(key: key);
  final String currentLineId;

  @override
  State<DisplayLocalFertilizer> createState() => _DisplayLocalFertilizerState();
}

class _DisplayLocalFertilizerState extends State<DisplayLocalFertilizer> {

  Timer? timer;

  @override
  void initState() {
    super.initState();
    durationUpdatingFunction();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final overallFrtLocal = Provider.of<MqttPayloadProvider>(context).localFertilizer;

    List<Map<String, dynamic>> fertilizerLocal =[];
    if(widget.currentLineId=='all'){
      fertilizerLocal = Provider.of<MqttPayloadProvider>(context,listen: false).localFertilizer.toList().cast<Map<String, dynamic>>();
    }else{
      fertilizerLocal = overallFrtLocal
          .where((lfr) => lfr['Location'].contains(widget.currentLineId)).toList()
          .cast<Map<String, dynamic>>();
    }

    durationUpdatingFunction();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for(int fIndex=0; fIndex<fertilizerLocal.length; fIndex++)
          SizedBox(
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if(fIndex!=0)
                        SizedBox(
                          width: 4.5,
                          height: 120,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 42),
                                child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                              ),
                              const SizedBox(width: 4.5,),
                              Padding(
                                padding: const EdgeInsets.only(top: 45),
                                child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                          width: 70,
                          height: 120,
                          child : Stack(
                            children: [
                              AppImages.getAsset('booster', fertilizerLocal[fIndex]['Booster'][0]['Status'],''),
                              Positioned(
                                top: 70,
                                left: 15,
                                child: fertilizerLocal[fIndex]['FertilizerTankSelector'].isNotEmpty ? const SizedBox(
                                  width: 50,
                                  child: Center(
                                    child: Text('Selector' , style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    ),
                                  ),
                                ):
                                const SizedBox(),
                              ),
                              Positioned(
                                top: 85,
                                left: 18,
                                child: fertilizerLocal[fIndex]['FertilizerTankSelector'].isNotEmpty ? Container(
                                  decoration: BoxDecoration(
                                    color: fertilizerLocal[fIndex]['FertilizerTankSelector'][0]['Status']==0? Colors.grey.shade300:
                                    fertilizerLocal[fIndex]['FertilizerTankSelector'][0]['Status']==1? Colors.greenAccent:
                                    fertilizerLocal[fIndex]['FertilizerTankSelector'][0]['Status']==2? Colors.orangeAccent:Colors.redAccent,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  width: 45,
                                  height: 22,
                                  child: Center(
                                    child: Text(fertilizerLocal[fIndex]['FertilizerTankSelector'][0]['Status']!=0?
                                    fertilizerLocal[fIndex]['FertilizerTankSelector'][0]['Name'] : '--' , style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                ) :
                                const SizedBox(),
                              ),
                              Positioned(
                                top: 115,
                                left: 8.3,
                                child: Image.asset('assets/images/dp_fert_vertical_pipe.png', width: 9.5, height: 37,),
                              ),
                            ],
                          )
                      ),
                      SizedBox(
                        width: fertilizerLocal[fIndex]['Fertilizer'].length * 70,
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: fertilizerLocal[fIndex]['Fertilizer'].length,
                          itemBuilder: (BuildContext context, int index) {
                            var fertilizer = fertilizerLocal[fIndex]['Fertilizer'][index];
                            double fertilizerQty = 0.0;
                            var qtyValue = fertilizer['Qty'];
                            if(qtyValue != null) {
                              if(fertilizer['Qty'] is String){
                                fertilizerQty = double.parse(fertilizer['Qty']);
                              }else if(fertilizer['Qty'] is int){
                                fertilizerQty = fertilizer['Qty'].toDouble();
                              }else{
                                fertilizerQty = fertilizer['Qty'];
                              }
                            }

                            var fertilizerLeftVal = fertilizer['QtyLeft'];
                            if (fertilizerLeftVal != null) {
                              if(fertilizerLeftVal is String){
                                fertilizer['QtyLeft'] = double.parse(fertilizer['QtyLeft']);
                              }else if(fertilizer['Qty'] is int){
                                fertilizer['QtyLeft'] = fertilizer['QtyLeft'].toDouble();
                              }else{
                                fertilizer['QtyLeft'] = fertilizer['QtyLeft'];
                              }
                            }

                            return SizedBox(
                              width: 70,
                              height: 120,
                              child: Stack(
                                children: [
                                  buildFertilizerImage(index, fertilizer['Status'], fertilizerLocal[fIndex]['Fertilizer'].length, fertilizerLocal[fIndex]['Agitator']),
                                  Positioned(
                                    top: 52,
                                    left: 6,
                                    child: CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.teal.shade100,
                                      child: Text('${index+1}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                  Positioned(
                                    top: 50,
                                    left: 18,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      width: 60,
                                      child: Center(
                                        child: Text(fertilizer['FertMethod']=='1' || fertilizer['FertMethod']=='3'? fertilizer['Duration'] :
                                        '${fertilizerQty.toStringAsFixed(2)} L', style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 65,
                                    left: 18,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      width: 60,
                                      child: Center(
                                        child: Text('${fertilizer['FlowRate_LpH']}-lph', style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 103,
                                    left: 0,
                                    child: fertilizer['Status'] !=0
                                        &&
                                        fertilizer['FertSelection'] !='_'
                                        &&
                                        fertilizer['DurationLeft'] !='00:00:00'
                                        ?
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      width: 50,
                                      child: Center(
                                        child: Text(fertilizer['FertMethod']=='1' || fertilizer['FertMethod']=='3'
                                            ? fertilizer['DurationLeft']
                                            : fertilizer['QtyLeft'] != null ? '${fertilizer['QtyLeft'].toStringAsFixed(2)} L' :'00.0 L' , style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        ),
                                      ),
                                    ) :
                                    const SizedBox(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      fertilizerLocal[fIndex]['Agitator'].isNotEmpty ? SizedBox(
                        width: 59,
                        height: 34,
                        child: AppImages.getAsset('agitator', fertilizerLocal[fIndex]['Agitator'][0]['Status'],''),
                      ) :
                      const SizedBox(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: fertilizerLocal[fIndex]['Fertilizer'].length * 75,
                  child: Row(
                    children: [
                      if(fIndex!=0)
                        Row(
                          children: [
                            VerticalDivider(width: 0,color: Colors.grey.shade300,),
                            const SizedBox(width: 4.0,),
                            VerticalDivider(width: 0,color: Colors.grey.shade300,),
                          ],
                        ),
                      Row(
                        children: [
                          const SizedBox(width: 10.5,),
                          VerticalDivider(width: 0,color: Colors.grey.shade300,),
                          const SizedBox(width: 4.0,),
                          VerticalDivider(width: 0,color: Colors.grey.shade300,),
                          const SizedBox(width: 5.0,),
                          fertilizerLocal[fIndex]['Ec'].length!=0?SizedBox(
                            width: fertilizerLocal[fIndex]['Ec'].length>1? 130 : 70,
                            height: 30,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                fertilizerLocal[fIndex]['Ec'].isNotEmpty ? SizedBox(
                                  height: 15,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: fertilizerLocal[fIndex]['Ec'].length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Center(child: Text('Ec : ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal))),
                                          Center(
                                            child: Text(
                                              double.parse('${fertilizerLocal[fIndex]['Ec'][index]['Status']}')
                                                  .toStringAsFixed(2),
                                              style: const TextStyle(fontSize: 11),
                                            ),
                                          ),
                                          const SizedBox(width: 5,),
                                        ],
                                      );
                                    },
                                  ),
                                ) :
                                const SizedBox(),
                                fertilizerLocal[fIndex]['Ph'].isNotEmpty ? SizedBox(
                                  height: 15,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: fertilizerLocal[fIndex]['Ph'].length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Row(
                                        children: [
                                          const Center(child: Text('pH : ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),)),
                                          Center(
                                            child: Text(
                                              double.parse('${fertilizerLocal[fIndex]['Ph'][index]['Status']}')
                                                  .toStringAsFixed(2),
                                              style: const TextStyle(fontSize: 11),
                                            ),
                                          ),
                                          const SizedBox(width: 5,),
                                        ],
                                      );
                                    },
                                  ),
                                ) :
                                const SizedBox(),
                              ],
                            ),
                          ):
                          const SizedBox(),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            width: (fertilizerLocal[fIndex]['Fertilizer'].length * 67) - (fertilizerLocal[fIndex]['Ec'].length * 70),
                            child: Center(
                              child: Text(fertilizerLocal[0]['SW_Name']?? fertilizerLocal[0]['FertilizerSite'], style: const TextStyle(color: primaryColorDark, fontSize: 11),),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void durationUpdatingFunction() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      try{
        final fertilizerLocal = Provider.of<MqttPayloadProvider>(context, listen: false).localFertilizer;
        for (var localFer in fertilizerLocal) {
          localFer['Fertilizer'].forEach((fertilizer) {
            int ferMethod = fertilizer['FertMethod'] is int
                ? fertilizer['FertMethod']
                : int.parse(fertilizer['FertMethod']);

            if (fertilizer['Status']==1 && ferMethod == 1) {
              //fertilizer time base
              List<String> parts = fertilizer['DurationLeft'].split(':');
              String updatedDurationQtyLeft = formatDuration(parts);
              setState(() {
                fertilizer['DurationLeft'] = updatedDurationQtyLeft;
              });
            }
            else if (fertilizer['Status']==1 && ferMethod == 2) {
              //fertilizer flow base
              double qtyLeftDouble = convertQtyLeftToDouble(fertilizer['QtyLeft']);
              double flowRate = convertFlowValueToDouble(fertilizer['FlowRate']);
              qtyLeftDouble -= flowRate;
              qtyLeftDouble = qtyLeftDouble < 0 ? 0 : qtyLeftDouble;
              setState(() {
                fertilizer['QtyLeft'] = qtyLeftDouble;
              });
            }
            else if ((fertilizer['Status']==1 || fertilizer['Status']==4) && ferMethod == 3){
              //fertilizer proposal time base
              double fcOnTime = convertQtyLeftToDouble(fertilizer['OnTime']);
              double fcOffTime = convertQtyLeftToDouble(fertilizer['OffTime']);
              int fcOnTimeRd = fcOnTime.round();
              int fcOffTimeRd = fcOffTime.round();

              if (fertilizer['OriginalOnTime'] == null) {
                fertilizer['OriginalOnTime'] = fertilizer['OnTime'];
              }
              if (fertilizer['OriginalOffTime'] == null) {
                fertilizer['OriginalOffTime'] = fertilizer['OffTime'];
              }
              if (fertilizer['OriginalStatus'] == null) {
                fertilizer['OriginalStatus'] = fertilizer['Status'];
              }

              if(fcOnTimeRd>0){
                List<String> parts = fertilizer['DurationLeft'].split(':');
                String updatedDurationQtyLeft = formatDuration(parts);
                fcOnTimeRd--;
                setState(() {
                  fertilizer['OnTime'] = '$fcOnTimeRd';
                  fertilizer['Status'] = fertilizer['OriginalStatus'];
                  fertilizer['DurationLeft'] = updatedDurationQtyLeft;
                });
              }else if(fcOffTimeRd>0){
                fcOffTimeRd--;
                setState(() {
                  fertilizer['OffTime'] = '$fcOffTimeRd';
                  fertilizer['Status'] = 4;
                });

                if(fcOffTimeRd==0){
                  fertilizer['OnTime'] = fertilizer['OriginalOnTime'];
                  fertilizer['OffTime'] = fertilizer['OriginalOffTime'];
                }
              }
            }
            else if ((fertilizer['Status']==1 || fertilizer['Status']==4) && ferMethod == 4){
              //fertilizer proposal qty base
              double fcOnTime = convertQtyLeftToDouble(fertilizer['OnTime']);
              double fcOffTime = convertQtyLeftToDouble(fertilizer['OffTime']);
              int fcOnTimeRd = fcOnTime.round();
              int fcOffTimeRd = fcOffTime.round();

              if (fertilizer['OriginalOnTime'] == null) {
                fertilizer['OriginalOnTime'] = fertilizer['OnTime'];
              }
              if (fertilizer['OriginalOffTime'] == null) {
                fertilizer['OriginalOffTime'] = fertilizer['OffTime'];
              }
              if (fertilizer['OriginalStatus'] == null) {
                fertilizer['OriginalStatus'] = fertilizer['Status'];
              }

              if(fcOnTimeRd>0){
                fcOnTimeRd--;
                double qtyLeftDouble = convertQtyLeftToDouble(fertilizer['QtyLeft']);
                double flowRate = convertFlowValueToDouble(fertilizer['FlowRate']);
                qtyLeftDouble -= flowRate;
                qtyLeftDouble = qtyLeftDouble < 0 ? 0 : qtyLeftDouble;
                setState(() {
                  fertilizer['OnTime'] = '$fcOnTimeRd';
                  fertilizer['Status'] = fertilizer['OriginalStatus'];
                  fertilizer['QtyLeft'] = qtyLeftDouble;
                });
              }else if(fcOffTimeRd>0){
                fcOffTimeRd--;
                setState(() {
                  fertilizer['OffTime'] = '$fcOffTimeRd';
                  fertilizer['Status'] = 4;
                });

                if(fcOffTimeRd==0){
                  fertilizer['OnTime'] = fertilizer['OriginalOnTime'];
                  fertilizer['OffTime'] = fertilizer['OriginalOffTime'];
                }
              }
            }
            else if ((fertilizer['Status']==1 || fertilizer['Status']==4) && ferMethod == 5){
              //fertilizer pro qty per 1000 Lit
              double fcOnTime = convertQtyLeftToDouble(fertilizer['OnTime']);
              double fcOffTime = convertQtyLeftToDouble(fertilizer['OffTime']);
              int fcOnTimeRd = fcOnTime.round();
              int fcOffTimeRd = fcOffTime.round();

              if (fertilizer['OriginalOnTime'] == null) {
                fertilizer['OriginalOnTime'] = fertilizer['OnTime'];
              }
              if (fertilizer['OriginalOffTime'] == null) {
                fertilizer['OriginalOffTime'] = fertilizer['OffTime'];
              }
              if (fertilizer['OriginalStatus'] == null) {
                fertilizer['OriginalStatus'] = fertilizer['Status'];
              }

              if(fcOnTimeRd>0){
                fcOnTimeRd--;
                double qtyLeftDouble = convertQtyLeftToDouble(fertilizer['QtyLeft']);
                double flowRate = convertFlowValueToDouble(fertilizer['FlowRate']);
                qtyLeftDouble -= flowRate;
                qtyLeftDouble = qtyLeftDouble < 0 ? 0 : qtyLeftDouble;
                setState(() {
                  fertilizer['OnTime'] = '$fcOnTimeRd';
                  fertilizer['Status'] = fertilizer['OriginalStatus'];
                  fertilizer['QtyLeft'] = qtyLeftDouble;
                });
              }else if(fcOffTimeRd>0){
                fcOffTimeRd--;
                setState(() {
                  fertilizer['OffTime'] = '$fcOffTimeRd';
                  fertilizer['Status'] = 4;
                });

                if(fcOffTimeRd==0){
                  fertilizer['OnTime'] = fertilizer['OriginalOnTime'];
                  fertilizer['OffTime'] = fertilizer['OriginalOffTime'];
                }
              }
            }
            else{
              //print('ferMethod 6');
            }
          });
        }
      }
      catch(e){
        print(e);
      }

    });
  }


  String formatDuration(List<String> parts) {
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    if (seconds > 0) {
      seconds--;
    } else {
      if (minutes > 0) {
        minutes--;
        seconds = 59;
      } else {
        if (hours > 0) {
          hours--;
          minutes = 59;
          seconds = 59;
        }
      }
    }
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double convertQtyLeftToDouble(dynamic qtyLeftValue) {
    double qtyLeftDouble = 0.00;
    if (qtyLeftValue is int) {
      qtyLeftDouble = qtyLeftValue.toDouble();
    } else if (qtyLeftValue is String) {
      qtyLeftDouble = double.tryParse(qtyLeftValue) ?? 0.00;
    } else if (qtyLeftValue is double) {
      qtyLeftDouble = qtyLeftValue;
    } else {
      qtyLeftDouble = 0.00;
    }
    return qtyLeftDouble;
  }

  double convertFlowValueToDouble(dynamic flowValue) {
    double flowRate = 0.00;
    if (flowValue is int) {
      flowRate = flowValue.toDouble();
    } else if (flowValue is String) {
      flowRate = double.tryParse(flowValue) ?? 0.00;
    } else if (flowValue is double) {
      flowRate = flowValue;
    } else {
      flowRate = 0.00;
    }
    return flowRate;
  }

}

class ListItems extends StatelessWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          InkWell(
            onTap: () {

            },
            child: Container(
              height: 50,
              color: Colors.amber[100],
              child: const Center(child: Text('Entry A')),
            ),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[200],
            child: const Center(child: Text('Entry B')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[300],
            child: const Center(child: Text('Entry C')),
          ),
        ],
      ),
    );
  }
}