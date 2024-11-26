import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/constants/theme.dart';
import 'package:oro_irrigation_new/screens/Config/config_maker/source_pump.dart';
import 'package:oro_irrigation_new/screens/Config/config_maker/start.dart';
import 'package:oro_irrigation_new/screens/Config/config_maker/weather_station.dart';
import 'package:provider/provider.dart';


import '../../../state_management/config_maker_provider.dart';
import 'central_dosing.dart';
import 'central_filtration.dart';
import 'finish.dart';
import 'irrigation_lines.dart';
import 'irrigation_pump.dart';
import 'local_dosing.dart';
import 'local_filtration.dart';
import 'mapping_of_inputs.dart';
import 'mapping_of_outputs.dart';

class ConfigMakerForWeb extends StatefulWidget {
  const ConfigMakerForWeb({super.key, required this.userID, required this.customerID, required this.siteId, required this.imeiNo});
  final int userID, siteId, customerID;
  final String imeiNo;

  @override
  State<ConfigMakerForWeb> createState() => _ConfigMakerForWebState();
}

class _ConfigMakerForWebState extends State<ConfigMakerForWeb> {
  int hoverTab = -1;
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        var configPvd = Provider.of<ConfigMakerProvider>(context,listen: false);
        print('web tabs : ${configPvd.tabs}');
      });
    }
  }

  Widget configTables(ConfigMakerProvider configPvd){
    switch(configPvd.tabs[configPvd.selectedTab][3]){
      case (0):{
        return const StartPageConfigMaker();
      }
      case (1):{
        return  const SourcePumpTable();
      }
      case (2):{
        return  const IrrigationPumpTable();
      }
      case (3):{
        return   const CentralDosingTable();
      }
      case (4):{
        return  const CentralFiltrationTable();
      }
      case (5):{
        return  const IrrigationLineTable();
      }
      case (6):{
        return  const LocalDosingTable();
      }
      case (7):{
        return  const LocalFiltrationTable();
      }
      case (8):{
        return  const WeatherStationConfig();
      }
      case (9):{
        return  MappingOfOutputsTable(configPvd: configPvd,);
      }
      case (10):{
        return  MappingOfInputsTable(configPvd: configPvd,);
      }
      case (11):{
        print('check : ${widget.imeiNo}');
        return  FinishPageConfigMaker(userId: widget.userID, customerID: widget.customerID, controllerId: widget.siteId,imeiNo: widget.imeiNo,);
      }
      default : {
        Container();
      }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: true);
    return LayoutBuilder(builder: (context,constrainst){
      return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton.small(
                heroTag: 'btn 1',
                tooltip: 'Previous',
                backgroundColor: configPvd.selectedTab == 0 ? Colors.white54 : Colors.white,
                onPressed: configPvd.selectedTab == 0
                    ? null
                    : () {
                  var stop = false;
                  src: for(var i in configPvd.sourcePumpUpdated){
                    if(i['waterSource'] == '-'){
                      stop = true;
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          title: const Text('Alert Message',style: TextStyle(color: Colors.red,fontSize: 15,fontWeight: FontWeight.w900),),
                          content: const Text('Please assign water source',style: TextStyle(fontSize: 14)),
                          actions: [
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 80,
                                height: 30,
                                color: myTheme.primaryColor,
                                child: const Center(
                                  child: Text('Ok',style: TextStyle(color: Colors.white,fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                    }
                    if(stop == true){
                      break src;
                    }
                  }
                  if(configPvd.tabs[configPvd.selectedTab - 1][3] != 5){
                    var checkPump = [
                      if(configPvd.sourcePumpUpdated.any((element)=>element['deleted'] == false))
                        'sourcePump'
                      'irrigationPump'
                    ];
                    for(var key in checkPump){
                      line: for(var i in configPvd.irrigationLines){
                        if(i[key] == ''){
                          stop = true;
                          showDialog(context: context, builder: (context){
                            return AlertDialog(
                              title: const Text('Alert Message',style: TextStyle(color: Colors.red,fontSize: 15,fontWeight: FontWeight.w900),),
                              content: Text('Please assign $key For all line',style: TextStyle(fontSize: 14)),
                              actions: [
                                InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 30,
                                    color: myTheme.primaryColor,
                                    child: const Center(
                                      child: Text('Ok',style: TextStyle(color: Colors.white,fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                          break line;
                        }
                      }
                    }
                  }
                  if(stop == false){
                    if (configPvd.selectedTab != 0) {
                      configPvd.editSelectedTab(configPvd.selectedTab - 1);
                    }
                  }

                },
                child: const Icon(Icons.arrow_back_outlined),
              ),
              FloatingActionButton.small(
                heroTag: 'btn 2',
                tooltip: 'Next',
                backgroundColor: configPvd.selectedTab == configPvd.tabs.length - 1 ? Colors.white54 : Colors.white,
                onPressed: configPvd.selectedTab == configPvd.tabs.length - 1
                    ? null
                    : () {
                  var stop = false;
                  for(var i in configPvd.sourcePumpUpdated){
                    if(i['waterSource'] == '-'){
                      stop = true;
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          title: const Text('Alert Message',style: TextStyle(color: Colors.red,fontSize: 15,fontWeight: FontWeight.w900),),
                          content: const Text('Please assign water source',style: TextStyle(fontSize: 14)),
                          actions: [
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 80,
                                height: 30,
                                color: myTheme.primaryColor,
                                child: const Center(
                                  child: Text('Ok',style: TextStyle(color: Colors.white,fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                    }
                  }
                  if(configPvd.tabs[configPvd.selectedTab + 1][3] != 5){
                    var checkPump = [
                      if(configPvd.sourcePumpUpdated.any((element)=>element['deleted'] == false))
                        'sourcePump'
                      'irrigationPump'
                    ];
                    for(var key in checkPump){
                      line: for(var i in configPvd.irrigationLines){
                        if(i[key] == ''){
                          stop = true;
                          showDialog(context: context, builder: (context){
                            return AlertDialog(
                              title: const Text('Alert Message',style: TextStyle(color: Colors.red,fontSize: 15,fontWeight: FontWeight.w900),),
                              content: Text('Please assign $key For all line',style: TextStyle(fontSize: 14)),
                              actions: [
                                InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 30,
                                    color: myTheme.primaryColor,
                                    child: const Center(
                                      child: Text('Ok',style: TextStyle(color: Colors.white,fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                          break line;
                        }
                      }
                    }

                  }
                  if (configPvd.selectedTab != configPvd.tabs.length - 1) {
                    if(stop == false){
                      if(configPvd.tabs.length - 1 == (configPvd.selectedTab + 1)){
                        if(configPvd.sendData().toString().contains('-')){
                          getDialogForOutputInputValidation();
                        }else{
                          configPvd.editSelectedTab(configPvd.selectedTab + 1);
                        }
                      }else{
                        configPvd.editSelectedTab(configPvd.selectedTab + 1);
                      }
                    }
                  }

                },
                child: const Icon(Icons.arrow_forward_outlined),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      // color: Color(0xff1D4C43)
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.indigo.shade50,
                        Colors.white70,
                      ],
                    ),
                  ),
                  width: 220,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var i = 0; i < configPvd.tabs.length; i++)
                          InkWell(
                              onTap: (){
                                var stop = false;
                                for(var i in configPvd.sourcePumpUpdated){
                                  if(!i['deleted']){
                                    if(i['waterSource'] == '-'){
                                      stop = true;
                                      showDialog(context: context, builder: (context){
                                        return AlertDialog(
                                          title: const Text('Alert Message',style: TextStyle(color: Colors.red,fontSize: 15,fontWeight: FontWeight.w900),),
                                          content: const Text('Please assign water source',style: TextStyle(fontSize: 14)),
                                          actions: [
                                            InkWell(
                                              onTap: (){
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                width: 80,
                                                height: 30,
                                                color: myTheme.primaryColor,
                                                child: const Center(
                                                  child: Text('Ok',style: TextStyle(color: Colors.white,fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                      break;
                                    }
                                  }

                                }
                                if(configPvd.tabs[i][3] != 5){
                                 var checkPump = [
                                   if(configPvd.sourcePumpUpdated.any((element)=>element['deleted'] == false))
                                     'sourcePump',
                                   'irrigationPump'
                                 ];
                                 for(var key in checkPump){
                                   line: for(var i in configPvd.irrigationLines){
                                     if(i[key] == ''){
                                       stop = true;
                                       showDialog(context: context, builder: (context){
                                         return AlertDialog(
                                           title: const Text('Alert Message',style: TextStyle(color: Colors.red,fontSize: 15,fontWeight: FontWeight.w900),),
                                           content: Text('Please assign $key For all line',style: TextStyle(fontSize: 14)),
                                           actions: [
                                             InkWell(
                                               onTap: (){
                                                 Navigator.pop(context);
                                               },
                                               child: Container(
                                                 width: 80,
                                                 height: 30,
                                                 color: myTheme.primaryColor,
                                                 child: const Center(
                                                   child: Text('Ok',style: TextStyle(color: Colors.white,fontSize: 16),
                                                   ),
                                                 ),
                                               ),
                                             ),
                                           ],
                                         );
                                       });
                                       break line;
                                     }
                                   }
                                 }

                                }
                                if(stop == false){
                                  if(configPvd.tabs.length == (i + 1)){
                                    if(configPvd.sendData().toString().contains('-')){
                                      getDialogForOutputInputValidation();
                                    }else{
                                      configPvd.editSelectedTab(i);
                                    }
                                  }else{
                                    configPvd.editSelectedTab(i);
                                  }
                                }
                              },
                              onHover: (value){
                                if(value == true){
                                  setState(() {
                                    hoverTab = i;
                                  });
                                }else{
                                  setState(() {
                                    hoverTab = -1;
                                  });
                                }
                              },
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: (hoverTab == i && configPvd.selectedTab == i) ? myTheme.primaryColor : hoverTab == i ? myTheme.primaryColor : configPvd.selectedTab == i ? myTheme.primaryColor : null,
                                ),
                                // padding: EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                width: 200,
                                child: Row(
                                    children: [
                                      const SizedBox(width: 20,),
                                      Icon(configPvd.tabs[i][2],color: (hoverTab == i && configPvd.selectedTab == i) ? Colors.white : hoverTab == i ?Colors.white : configPvd.selectedTab == i ? Colors.white : Colors.black,),
                                      const SizedBox(width: 20,),
                                      Text('${configPvd.tabs[i][0]} ${configPvd.tabs[i][1]}',style: TextStyle(color: (hoverTab == i && configPvd.selectedTab == i) ? Colors.white : hoverTab == i ?Colors.white : configPvd.selectedTab == i ? Colors.white : Colors.black,fontWeight: FontWeight.bold),)
                                    ]
                                ),
                              )
                          ),

                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: configTables(configPvd),
                  ),
                ),
              ],
            ),
          ),

        ),
      );
    });

  }
  void getDialogForOutputInputValidation(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Please assign controller and its output/input for all the objects.'),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('Ok')
          )
        ],
      );
    });
  }
}
