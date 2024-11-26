// import 'package:flutter/material.dart';
// import 'package:oro_irrigation_new/Screens/Customer/IrrigationProgram/schedule_screen.dart';
// import 'package:oro_irrigation_new/state_management/irrigation_program_main_provider.dart';
// import 'package:provider/provider.dart';
//
// import '../ScheduleView.dart';
// import '../ScheduleView.dart';
//
// class NewAlarmScreen2 extends StatefulWidget {
//   const NewAlarmScreen2({super.key});
//
//   @override
//   State<NewAlarmScreen2> createState() => _NewAlarmScreen2State();
// }
//
// class _NewAlarmScreen2State extends State<NewAlarmScreen2> {
//   @override
//   Widget build(BuildContext context) {
//
//     return Consumer<IrrigationProgramProvider>(
//         builder: (context, alarmProvider, _) {
//           return LayoutBuilder(
//               builder: (BuildContext context, BoxConstraints constraints){
//                 return Container(
//                   margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.025),
//                   child: ListView.builder(
//                       itemCount: alarmProvider.newAlarmList!.alarmList.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         final item = alarmProvider.newAlarmList!.alarmList[index];
//                         return Container(
//                           margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: 5),
//                           child: Column(
//                             children: [
//                               buildCustomListTile(
//                                   context: context,
//                                   padding: const EdgeInsets.symmetric(vertical: 8),
//                                   title: item.name,
//                                   icon: Icons.alarm,
//                                   isSwitch: true,
//                                   switchValue: item.value,
//                                   onSwitchChanged: (newValue) {
//                                     setState(() {
//                                       item.value = newValue;
//                                     });
//                                   }
//                               ),
//                               const SizedBox(height: 10,)
//                             ],
//                           ),
//                         );
//                       }
//                   ),
//                 );
//               }
//           );
//         }
//     );
//   }
// }
