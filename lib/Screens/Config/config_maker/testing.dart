// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:oro_irrigation_new/constants/theme.dart';
// import 'package:oro_irrigation_new/widgets/HoursMinutesSeconds.dart';
// import 'package:provider/provider.dart';
//
// import '../../constants/http_service.dart';
// import '../../state_management/GlobalFertLimitProvider.dart';
// import '../../state_management/overall_use.dart';
// import '../../widgets/SCustomWidgets/custom_date_picker.dart';
// import '../../widgets/TextFieldForGlobalFert.dart';
// import '../../widgets/time_picker.dart';
//
// class GlobalFertilizerLimit extends StatefulWidget {
//   const GlobalFertilizerLimit({Key? key, required this.userId, required this.controllerId, required this.customerId, required this.deviceId});
//   final userId, controllerId,customerId;
//   final String deviceId;
//
//   @override
//   State<GlobalFertilizerLimit> createState() => _GlobalFertilizerLimitState();
// }
//
// class _GlobalFertilizerLimitState extends State<GlobalFertilizerLimit> {
//   int selectedLine = 0;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if (mounted) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         getUserPlanningGlobalFertilizerLimit();
//       });
//     }
//   }
//   Future<void> getUserPlanningGlobalFertilizerLimit() async {
//     print('userid : ${widget.userId}');
//     print('controllerId : ${widget.controllerId}');
//     var gfertpvd = Provider.of<GlobalFertLimitProvider>(context, listen: false);
//     HttpService service = HttpService();
//     try{
//       var response = await service.postRequest('getUserPlanningGlobalFertilizerLimit', {'userId' : widget.userId,'controllerId' : widget.controllerId});
//       var jsonData = jsonDecode(response.body);
//       gfertpvd.editGlobalFert(jsonData['data']);
//     }catch(e){
//       print(e.toString());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var gfertpvd = Provider.of<GlobalFertLimitProvider>(context, listen: true);
//     var overAllPvd = Provider.of<OverAllUse>(context,listen: true);
//     return LayoutBuilder(builder: (context,constraint){
//       return Scaffold(
//         body: Container(
//           width: constraint.maxWidth,
//           padding: EdgeInsets.all(10),
//           color: const Color(0xffeefcfe),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               listOfSequence(
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       for(var line = 0;line < gfertpvd.globalFert.length;line++)
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             sequenceWidget(top: line == 0 ? false : true, bottom: (line == gfertpvd.globalFert.length - 1) ? false : true, line: line,gfertpvd: gfertpvd),
//                             if(line != gfertpvd.globalFert.length - 1)
//                               SizedBox(
//                                 height: 20,
//                                 child: VerticalDivider(
//                                   width: 1,
//                                   thickness: 1,
//                                   color: violetBorder,
//                                 ),
//                               )
//                           ],
//                         )
//                     ],
//                   ),
//                   constraint
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.white,
//                 ),
//                 height: constraint.maxHeight,
//                 width: 100+100+160+gfertpvd.central * 62.5 + (gfertpvd.central == 1 || gfertpvd.central == 2 ? 100 : 0)+gfertpvd.local * 62.5 + (gfertpvd.local == 1 || gfertpvd.local == 2  ? 100 : 0) + 20,
//                 child: Row(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                           color:const Color(0xff1D808E),
//                           borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
//                       ),
//
//                       width: 100+100+160+gfertpvd.central * 62.5 + (gfertpvd.central == 1 || gfertpvd.central == 2 ? 100 : 0)+gfertpvd.local * 62.5 + (gfertpvd.local == 1 || gfertpvd.local == 2  ? 100 : 0) + 20,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [getColumn(width: 200, title: 'Valve Name')
//                           ,
//                           Container(
//                             width: 160,
//                             height: 60,
//                             color: const Color(0xff1D808E),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 SizedBox(
//                                   width : 150,
//                                     height: 30,
//                                     child: Center(child: Text('Irrigation',style: TextStyle(color: Colors.white),))
//                                 ),
//                                 Row(
//                                   children: [
//                                     returnChannel('Time',Colors.blue.shade200),
//                                     returnChannel('Quantity',Colors.blue.shade200,false),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                           Container(
//                             width: gfertpvd.central * 62.5 + (gfertpvd.central == 1 || gfertpvd.central == 2 ? 100 : 0),
//                             height: 60,
//                             color: const Color(0xff1D808E),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 SizedBox(
//                                   width: gfertpvd.central * 62.5 + (gfertpvd.central == 1 || gfertpvd.central == 2 ? 100 : 0),
//                                     height: 30,
//                                     child: Center(child: Text('Central Fertilization',style: TextStyle(color: Colors.white),))
//                                 ),
//                                 Row(
//                                   children: [
//                                     if(gfertpvd.central >= 1)
//                                       returnChannel('CH1',Colors.blueGrey.shade200),
//                                     if(gfertpvd.central >= 2)
//                                       returnChannel('CH2',Colors.blueGrey.shade200),
//                                     if(gfertpvd.central >= 3)
//                                       returnChannel('CH3',Colors.blueGrey.shade200),
//                                     if(gfertpvd.central >= 4)
//                                       returnChannel('CH4',Colors.blueGrey.shade200),
//                                     if(gfertpvd.central >= 5)
//                                       returnChannel('CH5',Colors.blueGrey.shade200),
//                                     if(gfertpvd.central >= 6)
//                                       returnChannel('CH6',Colors.blueGrey.shade200),
//                                     if(gfertpvd.central >= 7)
//                                       returnChannel('CH7',Colors.blueGrey.shade200),
//                                     if(gfertpvd.central >= 8)
//                                       returnChannel('CH8',Colors.blueGrey.shade200,false),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                           Container(
//                             width: gfertpvd.local * 62.5 + (gfertpvd.local == 1 || gfertpvd.local == 2  ? 100 : 0),
//                             height: 60,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 SizedBox(
//                                     width: gfertpvd.local * 62.5 + (gfertpvd.local == 1 || gfertpvd.local == 2  ? 100 : 0),
//                                   height: 30,
//                                     child: const Center(child: Text('Local Fertilization',style: TextStyle(color: Colors.white),)),
//                                 ),
//                                 Row(
//                                   children: [
//                                     if(gfertpvd.local >= 1)
//                                       returnChannel('CH1',Colors.orange.shade200),
//                                     if(gfertpvd.local >= 2)
//                                       returnChannel('CH2',Colors.orange.shade200),
//                                     if(gfertpvd.local >= 3)
//                                       returnChannel('CH3',Colors.orange.shade200),
//                                     if(gfertpvd.local >= 4)
//                                       returnChannel('CH4',Colors.orange.shade200),
//                                     if(gfertpvd.local >= 5)
//                                       returnChannel('CH5',Colors.orange.shade200),
//                                     if(gfertpvd.local >= 6)
//                                       returnChannel('CH6',Colors.orange.shade200),
//                                     if(gfertpvd.local >= 7)
//                                       returnChannel('CH7',Colors.orange.shade200),
//                                     if(gfertpvd.local >= 8)
//                                       returnChannel('CH8',Colors.orange.shade200,false),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: SizedBox(
//                         width: 100+100+160+gfertpvd.central * 62.5 + (gfertpvd.central == 1 || gfertpvd.central == 2 ? 100 : 0)+gfertpvd.local * 62.5 + (gfertpvd.local == 1 || gfertpvd.local == 2  ? 100 : 0) + 20,
//                         child: SingleChildScrollView(
//                           child: Column(
//                             children: [
//                               if(gfertpvd.globalFert.length != 0)
//                                 for(var index = 0;index < gfertpvd.globalFert[selectedLine]['valve'].length;index++)
//                                   Container(
//                                     margin: EdgeInsets.symmetric(horizontal: 10),
//                                     width: double.infinity,
//                                     height: 60,
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                             bottom: BorderSide(width: 0.5)
//                                         )
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         SizedBox(
//                                           width: 200,
//                                           height: 60,
//                                           child: Center(
//                                             child: Text('${gfertpvd.globalFert[selectedLine]['valve'][index]['name']}',style: TextStyle(color: Colors.black),),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 60,
//                                           width: 160,
//                                           child: Row(
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
//                                               Expanded(
//                                                   child: SizedBox(
//                                                     width: double.infinity,
//                                                     height: 60,
//                                                     child: Center(
//                                                       child: waterTime(context, overAllPvd, gfertpvd, index),
//                                                     ),
//                                                   )
//                                               ),
//                                               Expanded(
//                                                   child: SizedBox(
//                                                     width: double.infinity,
//                                                     height: 60,
//                                                     child: Center(
//                                                       child: TextFieldForGlobalFert(purpose: 'quantity/$selectedLine/$index/quantity', initialValue: '${gfertpvd.globalFert[selectedLine]['valve'][index]['quantity']}', index: index),
//                                                     ),
//                                                   )
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Container(
//                                           height: 60,
//                                           width: gfertpvd.central * 62.5 + (gfertpvd.central == 1 || gfertpvd.central == 2 ? 100 : 0),
//                                           child: Center(
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               children: [
//                                                 if(gfertpvd.central >= 1)
//                                                   getDosingRow(gfertpvd, index, 'central1'),
//                                                 if(gfertpvd.central >= 2)
//                                                   getDosingRow(gfertpvd, index, 'central2'),
//                                                 if(gfertpvd.central >= 3)
//                                                   getDosingRow(gfertpvd, index, 'central3'),
//                                                 if(gfertpvd.central >= 4)
//                                                   getDosingRow(gfertpvd, index, 'central4'),
//                                                 if(gfertpvd.central >= 5)
//                                                   getDosingRow(gfertpvd, index, 'central5'),
//                                                 if(gfertpvd.central >= 6)
//                                                   getDosingRow(gfertpvd, index, 'central6'),
//                                                 if(gfertpvd.central >= 7)
//                                                   getDosingRow(gfertpvd, index, 'central7'),
//                                                 if(gfertpvd.central >= 8)
//                                                   getDosingRow(gfertpvd, index, 'central8'),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Container(
//                                           height: 60,
//                                           width: gfertpvd.local * 62.5 + (gfertpvd.local == 1 || gfertpvd.local == 2 ? 100 : 0),
//                                           child: Center(
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               children: [
//                                                 if(gfertpvd.local >= 1)
//                                                   getDosingRow(gfertpvd, index, 'local1'),
//                                                 if(gfertpvd.local >= 2)
//                                                   getDosingRow(gfertpvd, index, 'local2'),
//                                                 if(gfertpvd.local >= 3)
//                                                   getDosingRow(gfertpvd, index, 'local3'),
//                                                 if(gfertpvd.local >= 4)
//                                                   getDosingRow(gfertpvd, index, 'local4'),
//                                                 if(gfertpvd.local >= 5)
//                                                   getDosingRow(gfertpvd, index, 'local5'),
//                                                 if(gfertpvd.local >= 6)
//                                                   getDosingRow(gfertpvd, index, 'local6'),
//                                                 if(gfertpvd.local >= 7)
//                                                   getDosingRow(gfertpvd, index, 'local7'),
//                                                 if(gfertpvd.local >= 8)
//                                                   getDosingRow(gfertpvd, index, 'local8'),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                               SizedBox(height: 100,)
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//
//             ],
//           ),
//         ),
//       );
//     });
//
//   }
//   Widget sequenceWidget({required bool top,required bool bottom,required int line,required GlobalFertLimitProvider gfertpvd}){
//     return  SizedBox(
//       width: 150,
//       height: 50,
//       child: Stack(
//         children: [
//           Center(
//             child: InkWell(
//               onTap: (){
//                 setState(() {
//                   selectedLine = line;
//                 });
//               },
//               child: Container(
//                 width: 150,
//                 height: 40,
//                 decoration: BoxDecoration(
//                     border: Border.all(width: 1,color: violetBorder),
//                     borderRadius: BorderRadius.circular(10),
//                     color: line == selectedLine ? liteViolet : null
//                 ),
//                 child: Center(child: Text('${gfertpvd.globalFert[line]['name']}',style: TextStyle(fontWeight: fw200),)),
//               ),
//             ),
//           ),
//           if(top == true)
//             Positioned(
//                 bottom: 40,
//                 left: 70,
//                 child: Container(
//                   width: 10,
//                   height: 10,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.white,
//                       border: Border.all(color: violetBorder)
//                   ),
//                 )
//             ),
//
//           if(bottom == true)
//             Positioned(
//                 top: 40,
//                 left: 70,
//                 child: Container(
//                   width: 10,
//                   height: 10,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.white,
//                       border: Border.all(color: violetBorder)
//                   ),
//                 )
//             ),
//         ],
//       ),
//     );
//   }
//   Widget returnChannel(String title,Color color,[bool? lastone]){
//     return Expanded(
//       child: SizedBox(
//         width: double.infinity,
//         height: 30,
//         child: Center(child: Text(title,style: TextStyle(color: Colors.white),)),
//       ),
//     );
//   }
//   Widget getColumn({required double width,required String title}){
//     return Container(
//       width: width,
//       height: 60,
//       child: Center(child: Text(title,style: TextStyle(color: Colors.white),)),
//     );
//   }
//   Widget waterTime(BuildContext context,overAllPvd,GlobalFertLimitProvider gfertpvd,int valveIndex){
//     return TextButton(
//         style: ButtonStyle(
//             backgroundColor: MaterialStateProperty.all(Colors.transparent)
//         ),
//         onPressed: ()async{
//           showDialog(context: context, builder: (context){
//             return AlertDialog(
//               content: SizedBox(
//                 width: 300,
//                 child: HoursMinutesSeconds(
//                   initialTime: '${gfertpvd.globalFert[selectedLine]['valve'][valveIndex]['time']}',
//                   onPressed: (){
//                     gfertpvd.editGfert('time',selectedLine,valveIndex,'time','${overAllPvd.hrs < 10 ? '0' :''}${overAllPvd.hrs}:${overAllPvd.min < 10 ? '0' :''}${overAllPvd.min}:${overAllPvd.sec < 10 ? '0' :''}${overAllPvd.sec}');
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//             );
//           });
//         },
//         child: Text('${gfertpvd.globalFert[selectedLine]['valve'][valveIndex]['time']}',style: TextStyle(color: Colors.black87,fontSize: 12),)
//     );
//   }
//
//   Widget getDosingRow(GlobalFertLimitProvider gfertpvd,int index,String title){
//     return Expanded(
//         child: SizedBox(
//           width: double.infinity,
//           height: 60,
//           child: Center(
//               child: gfertpvd.globalFert[selectedLine]['valve'][index][title]['value'] == null ? Center(child: Text('N/A')) : Center(child: TextFieldForGlobalFert(purpose: 'central_local/$selectedLine/$index/$title', initialValue: '${gfertpvd.globalFert[selectedLine]['valve'][index][title]['value']}', index: index))
//           ),
//         )
//     );
//   }
//
//
// }
//
//
// Widget listOfSequence(Widget myWidget,BoxConstraints constraints){
//   return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.white
//       ),
//       padding: EdgeInsets.all(10),
//       height: constraints.maxHeight - 20,
//       width: 180,
//       child: SingleChildScrollView(child: myWidget)
//   );
//
// }
//
//
//
//
