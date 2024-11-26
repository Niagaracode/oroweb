// import 'package:flutter/material.dart';
// import 'package:oro_irrigation_new/constants/theme.dart';
// import 'package:provider/provider.dart';
// import '../../state_management/constant_provider.dart';
// import '../../state_management/overall_use.dart';
// import '../state_management/GlobalFertLimitProvider.dart';
// import 'my_number_picker.dart';
//
// class CustomTimePickerSiva extends StatefulWidget {
//   final String purpose;
//   String additional;
//   final String value;
//   final int index;
//   final bool displayHours;
//   final bool displayMins;
//   final bool displaySecs;
//   final bool displayAM_PM;
//   final bool displayCustom;
//   final String CustomString;
//   final List<int> CustomList;
//   CustomTimePickerSiva({super.key, required this.purpose, required this.index, required this.value, required this.displayHours, required this.displayMins, required this.displaySecs, required this.displayCustom, required this.CustomString, required this.CustomList, required this.displayAM_PM, this.additional = '',});
//
//   @override
//   _CustomTimePickerSivaState createState() => _CustomTimePickerSivaState();
// }
//
// class _CustomTimePickerSivaState extends State<CustomTimePickerSiva> {
//   late ValueNotifier<String> selectedTime;
//   GlobalKey widgetKey = GlobalKey();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var constantPvd = Provider.of<ConstantProvider>(context,listen: true);
//     var overAllPvd = Provider.of<OverAllUse>(context,listen: true);
//     var gfertpvd = Provider.of<GlobalFertLimitProvider>(context, listen: true);
//
//     return GestureDetector(
//       onTap: () {
//         _showTimePicker(context,constantPvd,overAllPvd,gfertpvd);
//       },
//       child: Text(widget.value,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: myTheme.primaryColor),),
//     );
//   }
//
//   void _showTimePicker(BuildContext context,ConstantProvider constantPvd,OverAllUse overAllPvd,GlobalFertLimitProvider gfertpvd) async {
//     overAllPvd.editTimeAll();
//     final result = await showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Column(
//             children: [
//               Text(
//                 'Select time',style: TextStyle(color: Colors.black),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//           content: MyTimePicker(displayHours: widget.displayHours,hourString: 'hr', displayMins: widget.displayMins, displaySecs: widget.displaySecs, displayCustom: widget.displayCustom, CustomString: widget.CustomString, CustomList: widget.CustomList, displayAM_PM: widget.displayAM_PM,),
//           actionsAlignment: MainAxisAlignment.end,
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
//             ),
//             TextButton(
//               onPressed: () {
//                 if(widget.purpose == 'general/resetTime'){
//                   print('${overAllPvd.hrs}  ${overAllPvd.min} ${overAllPvd.sec}');
//                   constantPvd.generalFunctionality(widget.index,'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}');
//                 }else if(widget.purpose == 'general/leakageLimit'){
//                   constantPvd.generalFunctionality(widget.index,'${overAllPvd.other}');
//                 }else if(widget.purpose == 'general/runList'){
//                   constantPvd.generalFunctionality(widget.index,'${overAllPvd.other}');
//                 }else if(widget.purpose == 'general/currentDay'){
//                   constantPvd.generalFunctionality(widget.index,'${overAllPvd.other}');
//                 }else if(widget.purpose == 'general/noPressureDelay'){
//                   constantPvd.generalFunctionality(widget.index,'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}');
//                 }else if(widget.purpose == 'general/dosingCoefficient'){
//                   constantPvd.generalFunctionality(widget.index,'${overAllPvd.other}');
//                 }else if(widget.purpose == 'line/lowFlowDelay'){
//                   constantPvd.irrigationLineFunctionality(['line/lowFlowDelay',widget.index,'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}']);
//                 }else if(widget.purpose == 'line/highFlowDelay'){
//                   constantPvd.irrigationLineFunctionality(['line/highFlowDelay',widget.index,'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}']);
//                 }else if(widget.purpose == 'line/leakageLimit'){
//                   constantPvd.irrigationLineFunctionality(['line/leakageLimit',widget.index,'${overAllPvd.other}']);
//                 }else if(widget.purpose == 'mainvalve/delay'){
//                   constantPvd.mainValveFunctionality(['mainvalve/delay',widget.index,'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}']);
//                 }else if(widget.purpose == 'filter_dp_delay'){
//                   constantPvd.filterFunctionality(['filter_dp_delay',widget.index,'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}']);
//                 }else if(widget.purpose == 'filter_looping_limit'){
//                   constantPvd.filterFunctionality(['filter_looping_limit',widget.index,'${overAllPvd.other}']);
//                 }else if(widget.additional == 'split'){
//                   var split = widget.purpose.split('/');
//                   if(split[0] == 'valve_defaultDosage'){
//                     constantPvd.valveFunctionality([split[0],int.parse(split[1]),int.parse(split[2]),'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}']);
//                   }else if(split[0] == 'valve_fillUpDelay'){
//                     constantPvd.valveFunctionality([split[0],int.parse(split[1]),int.parse(split[2]),'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}']);
//                   }else if(split[0] == 'fertilizer_shortestPulse'){
//                     constantPvd.fertilizerFunctionality([split[0],int.parse(split[1]),split[2],int.parse(split[3]),'${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}']);
//                   }else if(split[0] == 'alarm_scanTime'){
//                     constantPvd.alarmFunctionality([split[0],int.parse(split[1]),int.parse(split[2]),'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}']);
//                   }else if(split[0] == 'alarm_auto_reset'){
//                     constantPvd.alarmFunctionality([split[0],int.parse(split[1]),int.parse(split[2]),'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}']);
//                   }else if(split[0] == 'critical_alarm_scanTime'){
//                     constantPvd.criticalAlarmFunctionality([split[0],int.parse(split[1]),int.parse(split[2]),'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}']);
//                   }else if(split[0] == 'critical_alarm_auto_reset'){
//                     constantPvd.criticalAlarmFunctionality([split[0],int.parse(split[1]),int.parse(split[2]),'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}']);
//                   }else if(split[0] == 'ecPhControlCycle'){
//                     constantPvd.ecPhFunctionality([split[0],int.parse(split[1]),split[2],int.parse(split[3]),'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}']);
//                   }else if(split[0] == 'ecPhInteg'){
//                     constantPvd.ecPhFunctionality([split[0],int.parse(split[1]),split[2],int.parse(split[3]),'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}']);
//                   }else if(split[0] == 'fertilizer_minimalOnTime'){
//                     constantPvd.fertilizerFunctionality([split[0],int.parse(split[1]),'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}']);
//                   }else if(split[0] == 'fertilizer_minimalOffTime'){
//                     constantPvd.fertilizerFunctionality([split[0],int.parse(split[1]),'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}']);
//                   }else if(split[0] == 'fertilizer_waterFlowStabilityTime'){
//                     constantPvd.fertilizerFunctionality([split[0],int.parse(split[1]),'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}']);
//                   }else if(split[0] == 'fertilizer_boosterOffDelay'){
//                     constantPvd.fertilizerFunctionality([split[0],int.parse(split[1]),'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}']);
//                   }else if(split[0] == 'time'){
//                     gfertpvd.editGfert('time',int.parse(split[1]),int.parse(split[2]),split[3],'${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}');
//                   }
//                 }
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK',style: TextStyle(color: myTheme.primaryColor,fontWeight: FontWeight.bold)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
