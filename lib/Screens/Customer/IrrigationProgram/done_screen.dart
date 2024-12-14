import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oro_irrigation_new/Screens/Customer/IrrigationProgram/preview_screen.dart';
import 'package:oro_irrigation_new/Screens/Customer/IrrigationProgram/program_library.dart';
import 'package:oro_irrigation_new/Screens/Customer/IrrigationProgram/schedule_screen.dart';
import 'package:oro_irrigation_new/state_management/irrigation_program_main_provider.dart';
import 'package:provider/provider.dart';

import '../../../Widgets/SCustomWidgets/custom_snack_bar.dart';
import '../../../constants/http_service.dart';
import '../../../state_management/MqttPayloadProvider.dart';
import '../../../widgets/SCustomWidgets/custom_alert_dialog.dart';
import '../../../widgets/SCustomWidgets/custom_native_time_picker.dart';
import '../ProgramSchedule.dart';
import 'conditions_screen.dart';

class AdditionalDataScreen extends StatefulWidget {
  final int serialNumber;
  final int userId;
  final int controllerId;
  final String deviceId;
  final bool toDashboard;
  final String? programType;
  final bool? conditionsLibraryIsNotEmpty;
  final bool isIrrigationProgram;
  const AdditionalDataScreen({super.key, required this.serialNumber, required this.isIrrigationProgram, required this.userId, required this.controllerId, required this.deviceId, required this.toDashboard, this.programType, this.conditionsLibraryIsNotEmpty});

  @override
  State<AdditionalDataScreen> createState() => _AdditionalDataScreenState();
}

class _AdditionalDataScreenState extends State<AdditionalDataScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  String tempProgramName = '';
  late MqttPayloadProvider mqttPayloadProvider;

  @override
  void initState() {
    // TODO: implement initState
    mqttPayloadProvider =  Provider.of<MqttPayloadProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final doneProvider = Provider.of<IrrigationProgramProvider>(context);
    mqttPayloadProvider =  Provider.of<MqttPayloadProvider>(context);
    String programName = doneProvider.programName == ''? "Program ${doneProvider.programCount}" : doneProvider.programName;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.width * 0.025),
                  child: ListView(
                    children: [
                      for(var index = 0; index < (widget.isIrrigationProgram ? 4 : 3); index++)
                        Column(
                          children: [
                            buildListTile(
                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width > 1200 ? 8 : 0),
                              context: context,
                              title: ['Program Name', 'Priority', 'Valve Off Delay', 'scale factor'][index].toUpperCase(),
                              subTitle: [tempProgramName != '' ? tempProgramName : widget.serialNumber == 0
                                  ? "Program ${doneProvider.programCount}"
                                  : doneProvider.programDetails!.programName.isNotEmpty ? programName : doneProvider.programDetails!.defaultProgramName,
                                'Prioritize the program to run', 'Set valve off delay', 'Adjust duration or flow'][index],
                              textColor: Colors.black,
                              icon: [Icons.drive_file_rename_outline_rounded, Icons.priority_high, Icons.timer_outlined, Icons.safety_check][index],
                              trailing: [
                                InkWell(
                                  child: Icon(Icons.drive_file_rename_outline_rounded, color: Theme.of(context).primaryColor,),
                                  onTap: () {
                                    _textEditingController.text = widget.serialNumber == 0
                                        ? "Program ${doneProvider.programCount}"
                                        : doneProvider.programDetails!.programName.isNotEmpty ? programName : doneProvider.programDetails!.defaultProgramName;
                                    _textEditingController.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset: _textEditingController.text.length,
                                    );
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text("Edit program name"),
                                        content: TextFormField(
                                          autofocus: true,
                                          controller: _textEditingController,
                                          onChanged: (newValue) => tempProgramName = newValue,
                                          inputFormatters: [LengthLimitingTextInputFormatter(20), FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.of(ctx).pop(),
                                            child: const Text("CANCEL", style: TextStyle(color: Colors.red),),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                              doneProvider.updateProgramName(tempProgramName, 'programName');
                                            },
                                            child: const Text("OKAY", style: TextStyle(color: Colors.green),),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                buildPopUpMenuButton(
                                    context: context,
                                    dataList: doneProvider.priorityList.map((item) => item).toList(),
                                    onSelected: (newValue) => doneProvider.updateProgramName(newValue, 'priority'),
                                    selected: doneProvider.priority,
                                    child: Text(doneProvider.priority, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),)
                                ),
                                CustomNativeTimePicker(
                                  initialValue: doneProvider.delayBetweenZones != "" ? doneProvider.delayBetweenZones : "00:00:00",
                                  is24HourMode: false,
                                  style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
                                  onChanged: (newTime){
                                    doneProvider.updateProgramName(newTime, 'delayBetweenZones');
                                  },
                                ),
                                SizedBox(
                                  width: 65,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 50 ,
                                        child: TextFormField(
                                          initialValue: (doneProvider.adjustPercentage != "" && doneProvider.adjustPercentage != "0") ? doneProvider.adjustPercentage : "100",
                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(RegExp('[^0-9]')),
                                            LengthLimitingTextInputFormatter(5),
                                          ],
                                          onChanged: (newValue){
                                            doneProvider.updateProgramName(newValue, 'adjustPercentage');
                                          },
                                        ),
                                      ),
                                      Text("%", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),)
                                    ],
                                  ),
                                )
                              ][index],
                            ),
                            const SizedBox(height: 45,)
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              if(!(widget.isIrrigationProgram))
                SlidingSendButton(
                  onSend: (){
                    doneProvider.programLibraryData(widget.userId, widget.controllerId);
                    sendFunction();
                  },
                ),
              if(!(widget.isIrrigationProgram))
                const SizedBox(height: 50,)
            ],
          );
        }
    );
  }

  void sendFunction() async{
    final mainProvider = Provider.of<IrrigationProgramProvider>(context, listen: false);
    Map<String, dynamic> dataToMqtt = {};
    dataToMqtt = mainProvider.dataToMqtt(widget.serialNumber == 0 ? mainProvider.serialNumberCreation : widget.serialNumber, widget.programType);
    var userData = {
      "defaultProgramName": mainProvider.defaultProgramName,
      "userId": widget.userId,
      "controllerId": widget.controllerId,
      "createUser": widget.userId,
      "serialNumber": widget.serialNumber == 0 ? mainProvider.serialNumberCreation : widget.serialNumber,
    };
    if(mainProvider.irrigationLine!.sequence.isNotEmpty) {
      // print(mainProvider.selectionModel.data!.toJson());
      var dataToSend = {
        "sequence": mainProvider.irrigationLine!.sequence,
        "schedule": mainProvider.sampleScheduleModel!.toJson(),
        "conditions": mainProvider.sampleConditions!.toJson(),
        "waterAndFert": mainProvider.sequenceData,
        "selection": mainProvider.selectionModel!.data.toJson(),
        "alarm": mainProvider.newAlarmList!.toJson(),
        "programName": mainProvider.programName,
        "priority": mainProvider.priority,
        "delayBetweenZones": mainProvider.programDetails!.delayBetweenZones,
        "adjustPercentage": mainProvider.programDetails!.adjustPercentage,
        "incompleteRestart": mainProvider.isCompletionEnabled ? "1" : "0",
        "controllerReadStatus": 0,
        "programType": mainProvider.selectedProgramType,
        "hardware": dataToMqtt
      };
      userData.addAll(dataToSend);
      // print(dataToMqtt);
      try {
        await validatePayloadSent(
            dialogContext: context,
            context: context,
            mqttPayloadProvider: mqttPayloadProvider,
            acknowledgedFunction: () {
              setState(() {
                userData['controllerReadStatus'] = "1";
              });
              // showSnackBar(message: "${mqttPayloadProvider.messageFromHw['Name']} from controller", context: context);
            },
            payload: dataToMqtt,
            payloadCode: "2500",
            deviceId: widget.deviceId
        );
        await Future.delayed(const Duration(milliseconds: 300), () async {
          // print("userData['controllerReadStatus'] ==> ${userData['controllerReadStatus']}");
          final createUserProgram = await HttpService().postRequest('createUserProgram', userData);
          final response = jsonDecode(createUserProgram.body);
          if(createUserProgram.statusCode == 200) {
            await mainProvider.programLibraryData(widget.userId, widget.controllerId);
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(message: response['message']));
            if(widget.toDashboard) {
              Navigator.of(context).pop();
            } else {
              // Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProgramSchedule(customerID: widget.userId, controllerID: widget.controllerId, siteName: "", imeiNumber: widget.deviceId, userId: widget.userId,))
              );
            }
          }
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(message: 'Failed to update because of $error'));
        print("Error: $error");
      }
      // print(mainProvider.selectionModel.data!.localFertilizerSet!.map((e) => e.toJson()));
    }
    else {
      showAdaptiveDialog<Future>(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Warning',
            content: "Select valves to be sequence for Irrigation Program",
            actions: [
              TextButton(child: const Text("OK"), onPressed: () => Navigator.of(context).pop(),),
            ],
          );
        },
      );
    }
  }
}