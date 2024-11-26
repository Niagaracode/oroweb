import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/constants/theme.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../../state_management/config_maker_provider.dart';
import '../../../widgets/drop_down_button.dart';

class SourcePumpTable extends StatefulWidget {
  const SourcePumpTable({super.key});

  @override
  State<SourcePumpTable> createState() => _SourcePumpTableState();
}

class _SourcePumpTableState extends State<SourcePumpTable> {
  ScrollController scrollController = ScrollController();
  bool selectButton = false;
  final GlobalKey widgetKey = GlobalKey();

  var val = '1';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        var configPvd = Provider.of<ConfigMakerProvider>(context,listen: false);
        configPvd.sourcePumpFunctionality(['editsourcePumpSelection',false]);
        configPvd.irrigationPumpFunctionality(['editIrrigationPumpSelection',false]);
        configPvd.centralDosingFunctionality(['c_dosingSelectAll',false]);
        configPvd.centralDosingFunctionality(['c_dosingSelection',false]);
        configPvd.centralFiltrationFunctionality(['centralFiltrationSelection',false]);
        configPvd.centralFiltrationFunctionality(['centralFiltrationSelectAll',false]);
        configPvd.irrigationLinesFunctionality(['editIrrigationSelection',false]);
        configPvd.irrigationLinesFunctionality(['editIrrigationSelectAll',false]);
        configPvd.localDosingFunctionality(['edit_l_DosingSelectAll',false]);
        configPvd.localDosingFunctionality(['edit_l_DosingSelection',false]);
        configPvd.localFiltrationFunctionality(['edit_l_filtrationSelection',false]);
        configPvd.localFiltrationFunctionality(['edit_l_filtrationSelectALL',false]);
        configPvd.cancelSelection();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: true);
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraint){
      var width = constraint.maxWidth;
      return Container(
        color: const Color(0xFFF3F3F3),
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(left: 5,right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 5,),
            configButtons(
                selectFunction: (value){
                  configPvd.sourcePumpFunctionality(['editsourcePumpSelection',value]);

                },
                selectAllFunction: (value){
                  configPvd.sourcePumpFunctionality(['editsourcePumpSelectAll',value]);

                },
                cancelButtonFunction: (){
                  configPvd.sourcePumpFunctionality(['editsourcePumpSelection',false]);
                  configPvd.cancelSelection();
                },
                addButtonFunction: (){
                  if(configPvd.totalSourcePump == 0){
                    showDialog(
                        context: context,
                        builder: (context){
                          return showingMessage('Oops!', 'The source pump limit is achieved!..', context);
                        }
                    );
                  }else{
                    configPvd.sourcePumpFunctionality(['addSourcePump']);
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 500), // Adjust the duration as needed
                      curve: Curves.easeInOut, // Adjust the curve as needed
                    );
                  }
                },
                reOrderFunction: (){
                  List<int> list1 = [];
                  for(var i = 0;i < configPvd.sourcePumpUpdated.length;i++){
                    list1.add(i+1);
                  }
                  showDialog(context: context, builder: (BuildContext context){
                    return ReOrderInSourcePump(list: list1,);
                  });
                },
                deleteButtonFunction: (){
                  configPvd.sourcePumpFunctionality(['deleteSourcePump']);
                  configPvd.cancelSelection();
                },
                selectionCount: configPvd.selection,
                singleSelection: configPvd.sourcePumpSelection,
                multipleSelection: configPvd.sourcePumpSelectAll,
                addBatchButtonFunction: () {
                  showDialog(context: context, builder: (context){
                    return Consumer<ConfigMakerProvider>(builder: (context,configPvd,child){
                      if(configPvd.totalSourcePump == 0){
                        return showingMessage('Oops!', 'The source pump limit is achieved!..', context);
                      }else{
                        return AlertDialog(
                          backgroundColor: myTheme.primaryColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(0))
                          ),
                          title: const Text('Add Batch of Pumps with Same Properties',style: TextStyle(color: Colors.white,fontSize: 14),),
                          content: SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text('No of pumps',style: TextStyle(color: Colors.indigo.shade50,fontSize: 14),),
                                    trailing: DropdownButton(
                                        value: configPvd.val,
                                        icon: const Icon(Icons.arrow_drop_down,color: Colors.white,),
                                        dropdownColor: Colors.black87,
                                        // focusColor: Colors.white,
                                        underline: Container(),
                                        items: dropDownList(configPvd.totalSourcePump).map((String items) {
                                          return DropdownMenuItem(
                                            onTap: (){
                                            },
                                            value: items,
                                            child: Container(
                                                child: Text(items,style: const TextStyle(fontSize: 11,color: Colors.white),)
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value){
                                          configPvd.editVal(value!);
                                        }),
                                  ),
                                  ListTile(
                                    title: Text('Water meter per pumps',style: TextStyle(color: Colors.indigo.shade50,fontSize: 14),),
                                    trailing: int.parse(configPvd.val) > configPvd.totalWaterMeter ?  const Text('N/A',style: TextStyle(color: Colors.white),) : Checkbox(
                                        value: configPvd.wmYesOrNo,
                                        onChanged: (value){
                                          configPvd.editWmYesOrNo(value);
                                        }
                                    ),
                                  ),
                                ],
                              )
                          ),
                          actions: [
                            InkWell(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width : 80,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 0.5,color: Colors.indigo.shade50),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Center(
                                    child: Text('cancel',style: TextStyle(color: Colors.indigo.shade50,fontSize: 16),
                                    ),
                                  ),
                                )
                            ),
                            InkWell(
                              onTap: (){
                                configPvd.sourcePumpFunctionality(['addBatch',configPvd.val,configPvd.wmYesOrNo]);
                                configPvd.editVal('1');
                                configPvd.editWmYesOrNo(false);
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 80,
                                height: 30,
                                color: Colors.indigo.shade50,
                                child: const Center(
                                  child: Text('ok',style: TextStyle(color: Colors.black,fontSize: 16),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }

                    });
                  });
                }
            ),
            Container(
              child: Row(
                children: [
                  topBtmLftRgt('Source', 'Pump(${configPvd.totalSourcePump})'),
                  topBtmRgt('Water','Source(${configPvd.totalWaterSource.length})'),
                  topBtmRgt('Water','Meter(${configPvd.totalWaterMeter})'),
                    // topBtmRgt('ORO','pump'),
                    // topBtmRgt('ORO Pump','Plus'),
                    topBtmRgt('RTU','Name'),
                    topBtmRgt('Ref','no'),
                    topBtmRgt('Level','Sensor(${configPvd.totalLevelSensor})'),
                    topBtmRgt('Pressure','Sensor(${configPvd.total_p_sensor})'),
                    topBtmRgt('Top tank','high(${configPvd.totalFloat})'),
                    topBtmRgt('Top tank','low(${configPvd.totalFloat})'),
                    topBtmRgt('Sump tank','high(${configPvd.totalFloat})'),
                    topBtmRgt('Sump tank','low(${configPvd.totalFloat})'),
                    if([1,2].contains(configPvd.categoryId))
                      topBtmRgt('Gem','Control'),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: configPvd.sourcePumpUpdated.length,
                  itemBuilder: (BuildContext context, int index){
                    return Visibility(
                      visible: configPvd.sourcePumpUpdated[index]['deleted'] == true ? false : true,
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1)),
                          color: Colors.white70,
                        ),
                        margin: index == configPvd.sourcePumpUpdated.length - 1 ? const EdgeInsets.only(bottom: 60) : null,
                        // color: index % 2 != 0 ? Colors.blue.shade100 : Colors.blue.shade50,
                        width: width-20,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(left: BorderSide(width: 1),right: BorderSide(width: 1))
                                ),
                                width: double.infinity,
                                height: 50,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if(configPvd.sourcePumpSelection == true || configPvd.sourcePumpSelectAll == true)
                                        Checkbox(
                                            value: configPvd.sourcePumpUpdated[index]['selection'] == 'select' ? true : false,
                                            onChanged: (value){
                                              configPvd.sourcePumpFunctionality(['selectSourcePump',index,value]);
                                            }),
                                      Text('${index + 1}'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(right: BorderSide(width: 1))
                                  ),
                                  width: double.infinity,
                                  height: 50,
                                  child: MyDropDown(initialValue: configPvd.sourcePumpUpdated[index]['waterSource'], itemList: configPvd.waterSource, pvdName: 'editWaterSource_sp', index: index)
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(width: 1))
                                ),
                                width: double.infinity,
                                height: 50,
                                child: (configPvd.sourcePumpUpdated[index]['oro_pump'] == true || (configPvd.totalWaterMeter == 0 && configPvd.sourcePumpUpdated[index]['waterMeter'].isEmpty)) ?
                                notAvailable :
                                Checkbox(
                                    value: configPvd.sourcePumpUpdated[index]['waterMeter'].isEmpty ? false : true,
                                    onChanged: (value){
                                      configPvd.sourcePumpFunctionality(['editWaterMeter',index,value]);
                                    }),
                              ),
                            ),
                            //   Expanded(
                            //   child: Container(
                            //     decoration: const BoxDecoration(
                            //         border: Border(right: BorderSide(width: 1))
                            //     ),
                            //     width: double.infinity,
                            //     height: 50,
                            //     child: Checkbox(
                            //         value: configPvd.sourcePumpUpdated[index]['oro_pump'],
                            //         onChanged: (value){
                            //           configPvd.sourcePumpFunctionality(['editOroPump',index,value]);
                            //         }),
                            //   ),
                            // ),
                            //   Expanded(
                            //   child: Container(
                            //     decoration: const BoxDecoration(
                            //         border: Border(right: BorderSide(width: 1))
                            //     ),
                            //     width: double.infinity,
                            //     height: 50,
                            //     child: Checkbox(
                            //         value: configPvd.sourcePumpUpdated[index]['oro_pump_plus'],
                            //         onChanged: (value){
                            //           configPvd.sourcePumpFunctionality(['editOroPumpPlus',index,value]);
                            //         }),
                            //   ),
                            // ),
                            // Expanded(
                            //   child: Container(
                            //     decoration: const BoxDecoration(
                            //         border: Border(right: BorderSide(width: 1))
                            //     ),
                            //     width: double.infinity,
                            //     height: 50,
                            //     child: Center(
                            //       child: Text('${configPvd.sourcePumpUpdated[index]['rtu']}'),
                            //     )
                            //   ),
                            // ),
                            Expanded(
                              child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(right: BorderSide(width: 1))
                                  ),
                                  width: double.infinity,
                                  height: 50,
                                  child: DropdownButton(
                                    isExpanded: true,
                                      items: [
                                        '-',
                                        if(configPvd.oSrtuPlus.isNotEmpty)
                                          'O-Smart-Plus',
                                        if(configPvd.oSrtu.isNotEmpty)
                                          'ORO Smart',
                                        if(configPvd.oPump.isNotEmpty)
                                          'ORO Pump',
                                        if(configPvd.oPumpPlus.isNotEmpty)
                                          'O-Pump-Plus'
                                      ].map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Container(
                                              child: Text(
                                                items,
                                                style: const TextStyle(color: Colors.black,fontSize: 12),
                                              )),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if(['O-Smart-Plus','ORO Smart','-'].contains(value)){
                                          print('first function called');
                                          setState(() {
                                            if(configPvd.sourcePumpUpdated[index]['oro_pump_plus'] == true){
                                              configPvd.sourcePumpFunctionality(['editOroPumpPlus',index,false,value]);
                                            }else if(configPvd.sourcePumpUpdated[index]['oro_pump'] == true){
                                              configPvd.sourcePumpFunctionality(['editOroPump',index,false,value]);
                                            }else{
                                              configPvd.sourcePumpUpdated[index]['rtu'] = value;
                                              configPvd.sourcePumpUpdated[index]['rfNo'] = '-';
                                              configPvd.sourcePumpUpdated[index]['output'] = '-';
                                            }
                                          });
                                        }else if(value == 'ORO Pump'){
                                          configPvd.sourcePumpFunctionality(['editOroPump',index,true,value]);
                                        }else{
                                          configPvd.sourcePumpFunctionality(['editOroPumpPlus',index,true,value]);
                                        }
                                      },
                                      value: configPvd.sourcePumpUpdated[index]['rtu'])
                              ),
                            ),
                            Expanded(
                            child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(width: 1))
                                ),
                                width: double.infinity,
                                height: 50,
                                child: MyDropDown(initialValue: configPvd.sourcePumpUpdated[index]['rfNo'], itemList: getRefNo(configPvd.sourcePumpUpdated[index]['rtu'],configPvd,index), pvdName: 'editRefNo_sp', index: index)
                            ),
                          ),

                          Expanded(
                            child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(width: 1))
                                ),
                                width: double.infinity,
                                height: 50,
                                child: showLevel(index,configPvd,) ? Checkbox(
                                    value: configPvd.sourcePumpUpdated[index]['levelSensor'].isEmpty ? false : true,
                                    onChanged: (value){
                                      configPvd.sourcePumpFunctionality(['editLevelSensor',index,value]);
                                    }) : notAvailable
                            ),
                        ),
                              Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(width: 1))
                                ),
                                width: double.infinity,
                                height: 50,
                                  child: showPressure(index,configPvd,) ? Checkbox(
                                      value: configPvd.sourcePumpUpdated[index]['pressureSensor'].isEmpty ? false : true,
                                      onChanged: (value){
                                        configPvd.sourcePumpFunctionality(['editPressureSensor',index,value]);
                                      }) : notAvailable
                              ),
                            ),
                              Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(width: 1))
                                ),
                                width: double.infinity,
                                height: 50,
                                child: showFloat(index,configPvd,'TopTankHigh') ? Checkbox(
                                    value: configPvd.sourcePumpUpdated[index]['TopTankHigh'].isEmpty ? false : true,
                                    onChanged: (value){
                                      configPvd.sourcePumpFunctionality(['editTopTankHigh',index,value]);
                                    }) : notAvailable,
                              ),
                            ),
                              Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(width: 1))
                                ),
                                width: double.infinity,
                                height: 50,
                                child: showFloat(index,configPvd,'TopTankLow') ? Checkbox(
                                    value: configPvd.sourcePumpUpdated[index]['TopTankLow'].isEmpty ? false : true,
                                    onChanged: (value){
                                      configPvd.sourcePumpFunctionality(['editTopTankLow',index,value]);
                                    }) : notAvailable,
                              ),
                            ),
                              Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(width: 1))
                                ),
                                width: double.infinity,
                                height: 50,
                                child: showFloat(index,configPvd,'SumpTankHigh') ? Checkbox(
                                    value: configPvd.sourcePumpUpdated[index]['SumpTankHigh'].isEmpty ? false : true,
                                    onChanged: (value){
                                      configPvd.sourcePumpFunctionality(['editSumpTankHigh',index,value]);
                                    }) : notAvailable,
                              ),
                            ),
                              Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(width: 1))
                                ),
                                width: double.infinity,
                                height: 50,
                                child: showFloat(index,configPvd,'SumpTankLow') ? Checkbox(
                                    value: configPvd.sourcePumpUpdated[index]['SumpTankLow'].isEmpty ? false : true,
                                    onChanged: (value){
                                      configPvd.sourcePumpFunctionality(['editSumpTankLow',index,value]);
                                    }) : notAvailable,

                              ),
                            ),
                            if([1,2].contains(configPvd.categoryId))
                              Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(width: 1))
                                ),
                                width: double.infinity,
                                height: 50,
                                child: Checkbox(
                                  value: configPvd.sourcePumpUpdated[index]['controlGem'],
                                  onChanged: (value){
                                    setState(() {
                                      configPvd.sourcePumpUpdated[index]['controlGem'] = value;
                                    });
                                  },
                                )

                              ),
                            ),

                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      );
    });
  }

  bool showLevel(int index,ConfigMakerProvider configPvd){
    if(configPvd.sourcePumpUpdated[index]['rfNo'] == '-'){
      return false;
    }
    else if(configPvd.sourcePumpUpdated[index]['rtu'] == 'ORO pump'){
      return false;
    }
    else if(['O-Smart-Plus','ORO Smart'].contains(configPvd.sourcePumpUpdated[index]['rtu'])){
      if(configPvd.totalLevelSensor !=0){
        return true;
      }else{
        if(configPvd.sourcePumpUpdated[index]['levelSensor'].isNotEmpty){
          return true;
        }else{
          return false;
        }
      }
    }
    else{
      bool val = true;
      if(configPvd.sourcePumpUpdated[index]['levelSensor'].isNotEmpty){
        val = true;
      }else if(configPvd.totalLevelSensor == 0){
        val = false;
      }else{
        for(var sp = 0; sp < configPvd.sourcePumpUpdated.length;sp++){
          if(sp != index){
            if(configPvd.sourcePumpUpdated[sp]['rtu'] == configPvd.sourcePumpUpdated[index]['rtu']){
              if(configPvd.sourcePumpUpdated[sp]['rfNo'] == configPvd.sourcePumpUpdated[index]['rfNo']){
                if(configPvd.sourcePumpUpdated[sp]['levelSensor'].isNotEmpty){
                  val = false;
                }
              }
            }
          }
        }
        for(var ip = 0; ip < configPvd.irrigationPumpUpdated.length;ip++){
          if(configPvd.irrigationPumpUpdated[ip]['rtu'] == configPvd.sourcePumpUpdated[index]['rtu']){
            if(configPvd.irrigationPumpUpdated[ip]['rfNo'] == configPvd.sourcePumpUpdated[index]['rfNo']){
              if(configPvd.irrigationPumpUpdated[ip]['levelSensor'].isNotEmpty){
                val = false;
              }
            }
          }

        }
      }
      return val;
    }
  }
  bool showPressure(int index,ConfigMakerProvider configPvd){
    if(configPvd.sourcePumpUpdated[index]['rfNo'] == '-'){
      return false;
    }
    else if(configPvd.sourcePumpUpdated[index]['rtu'] == 'ORO pump'){
      return false;
    }
    else if(['O-Smart-Plus','ORO Smart'].contains(configPvd.sourcePumpUpdated[index]['rtu'])){
      if(configPvd.total_p_sensor !=0){
        return true;
      }else{
        if(configPvd.sourcePumpUpdated[index]['pressureSensor'].isNotEmpty){
          return true;
        }else{
          return false;
        }
      }
    }
    else{
      bool val = true;

      if(configPvd.sourcePumpUpdated[index]['pressureSensor'].isNotEmpty){
        val = true;
      }else if(configPvd.total_p_sensor == 0){
        val = false;
      }else{
        for(var sp = 0; sp < configPvd.sourcePumpUpdated.length;sp++){
          if(sp != index){
            if(configPvd.sourcePumpUpdated[sp]['rtu'] == configPvd.sourcePumpUpdated[index]['rtu']){
              if(configPvd.sourcePumpUpdated[sp]['rfNo'] == configPvd.sourcePumpUpdated[index]['rfNo']){
                if(configPvd.sourcePumpUpdated[sp]['pressureSensor'].isNotEmpty){
                  val = false;
                }
              }
            }
          }
        }
        for(var ip = 0; ip < configPvd.irrigationPumpUpdated.length;ip++){
          if(configPvd.irrigationPumpUpdated[ip]['rtu'] == configPvd.sourcePumpUpdated[index]['rtu']){
            if(configPvd.irrigationPumpUpdated[ip]['rfNo'] == configPvd.sourcePumpUpdated[index]['rfNo']){
              if(configPvd.irrigationPumpUpdated[ip]['pressureSensor'].isNotEmpty){
                val = false;
              }
            }
          }

        }
      }
      return val;
    }
  }

  bool showFloat(int index,ConfigMakerProvider configPvd,String title){
    if(configPvd.sourcePumpUpdated[index]['rfNo'] == '-'){
      return false;
    }
    else if(configPvd.sourcePumpUpdated[index]['rtu'] == 'ORO pump'){
      return false;
    }
    else if(['O-Smart-Plus','ORO Smart'].contains(configPvd.sourcePumpUpdated[index]['rtu'])){
      if((title == 'levelSensor' ? configPvd.totalLevelSensor : title == 'pressureSensor' ? configPvd.total_p_sensor :  configPvd.totalFloat) !=0){
        return true;
      }else{
        if(configPvd.sourcePumpUpdated[index][title].isNotEmpty){
          return true;
        }else{
          return false;
        }
      }
    }
    else{
      int count = 0;
      bool val = true;
      if(configPvd.sourcePumpUpdated[index][title].isNotEmpty){
        val = true;
      }else if(configPvd.totalFloat == 0){
        val = false;
      }else{
        for(var sp = 0; sp < configPvd.sourcePumpUpdated.length;sp++){
          if(configPvd.sourcePumpUpdated[sp]['rtu'] == configPvd.sourcePumpUpdated[index]['rtu']){
            if(configPvd.sourcePumpUpdated[sp]['rfNo'] == configPvd.sourcePumpUpdated[index]['rfNo']){
              for(var flt in ['TopTankHigh','TopTankLow','SumpTankHigh','SumpTankLow']){
                if(title == flt && sp == index){

                }else{
                  if(configPvd.sourcePumpUpdated[sp][flt].isNotEmpty){
                    count += 1;
                  }
                }
              }

            }
          }

        }
        for(var ip = 0; ip < configPvd.irrigationPumpUpdated.length;ip++){
          if(configPvd.irrigationPumpUpdated[ip]['rtu'] == configPvd.sourcePumpUpdated[index]['rtu']){
            if(configPvd.irrigationPumpUpdated[ip]['rfNo'] == configPvd.sourcePumpUpdated[index]['rfNo']){
              for(var flt in ['TopTankHigh','TopTankLow','SumpTankHigh','SumpTankLow']){
                if(configPvd.irrigationPumpUpdated[ip][flt].isNotEmpty){
                  count += 1;
                }
              }

            }
          }

        }
        val = count > 5 ? false : true;
      }
      return val;
    }
  }

  List<String> getRefNo(String title,ConfigMakerProvider configPvd,index){
    if(title == 'O-Smart-Plus'){
      return ['-',for(var i in configPvd.oSrtuPlus) '$i'];
    }else if(title == 'ORO Smart'){
      return ['-',for(var i in configPvd.oSrtu) '$i'];
    }else if(title == 'O-Pump-Plus'){
      var list = ['-',for(var i in configPvd.oPumpPlus) '$i'];
      for(var rf = list.length - 1;rf > -1;rf--){
        int count = 0;
        for(var i = 0;i < configPvd.sourcePumpUpdated.length;i++){
          if(list[rf] != '-'){
            if(!configPvd.sourcePumpUpdated[i]['deleted'] && configPvd.sourcePumpUpdated[i]['rtu'] == 'O-Pump-Plus'){
              if(list[rf] == configPvd.sourcePumpUpdated[i]['rfNo']){
                count += 1;
              }
            }
          }
       }
        for(var i = 0;i < configPvd.irrigationPumpUpdated.length;i++){
          if(list[rf] != '-'){
            if(!configPvd.irrigationPumpUpdated[i]['deleted'] && configPvd.irrigationPumpUpdated[i]['rtu'] == 'O-Pump-Plus'){
              if(list[rf] == configPvd.irrigationPumpUpdated[i]['rfNo']){
                count += 1;
              }
            }
          }
        }
        if(count == 3){
          if(configPvd.sourcePumpUpdated[index]['rfNo'] != list[rf]){
            list.removeAt(rf);
          }
        }
      }
      return list;
    }else{
      var list = ['-',for(var i in configPvd.oPump) '$i'];
      for(var rf = list.length - 1;rf > -1;rf--){
        int count = 0;
        for(var i = 0;i < configPvd.sourcePumpUpdated.length;i++){
          if(list[rf] != '-'){
            if(!configPvd.sourcePumpUpdated[i]['deleted'] && configPvd.sourcePumpUpdated[i]['rtu'] == 'ORO Pump'){
              if(list[rf] == configPvd.sourcePumpUpdated[i]['rfNo']){
                count += 1;
              }
            }
          }
        }
        for(var i = 0;i < configPvd.irrigationPumpUpdated.length;i++){
          if(list[rf] != '-'){
            if(!configPvd.irrigationPumpUpdated[i]['deleted'] && configPvd.irrigationPumpUpdated[i]['rtu'] == 'ORO Pump'){
              if(list[rf] == configPvd.irrigationPumpUpdated[i]['rfNo']){
                count += 1;
              }
            }
          }
        }
        if(count == 3){
          if(configPvd.sourcePumpUpdated[index]['rfNo'] != list[rf]){
            list.removeAt(rf);
          }
        }
      }
      return list;
    }
  }
}

class ReOrderInSourcePump extends StatefulWidget {
  final List<int> list;
  const ReOrderInSourcePump({super.key, required this.list});

  @override
  State<ReOrderInSourcePump> createState() => _ReOrderInSourcePumpState();
}

class _ReOrderInSourcePumpState extends State<ReOrderInSourcePump> {

  late int oldIndex;
  late int newIndex;
  List<int> pumpData = [];
  @override
  Widget buildItem(String text) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(5)
      ),
      width: 50,
      height: 50 ,
      key: ValueKey('P$text'),
      child: Center(child: Text('P$text')),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pumpData = widget.list;
  }
  @override
  Widget build(BuildContext context) {
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: true);
    return AlertDialog(
      title: const Text('Re-Order Pump',style: TextStyle(color: Colors.black),),
      content: SizedBox(
        width: 250,
        height: 250,
        child: Center(
          child: ReorderableGridView.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            primary: true,
            onReorder: (oldIND, newIND) {
              setState(() {
                oldIndex = oldIND;
                newIndex = newIND;
                var removeData = pumpData[oldIND];
                pumpData.removeAt(oldIND);
                pumpData.insert(newIND, removeData);
              });
            },
            children: pumpData.map((e) => buildItem("$e")).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: const Text('Cancel')
        ),
        TextButton(
            onPressed: (){
              configPvd.sourcePumpFunctionality(['reOrderPump',oldIndex,newIndex]);
              Navigator.pop(context);
            },
            child: const Text('Change')
        )
      ],
    );
  }
}


Widget configButtons(
    {
      required Function(bool?) selectFunction,
      required Function(bool?) selectAllFunction,
      required VoidCallback cancelButtonFunction,
      required VoidCallback addButtonFunction,
      required VoidCallback deleteButtonFunction,
      VoidCallback? addBatchButtonFunction,
      VoidCallback? reOrderFunction,
      required int selectionCount,
      required bool singleSelection,
      required bool multipleSelection,
      List<dynamic>? myList,
      bool? local
    }){
  return Container(
    height: 50,
    color: Colors.white,
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if(singleSelection == false)
            Row(
              children: [
                Checkbox(
                  value: singleSelection,
                  onChanged: selectFunction,
                ),
                const Text('Select')
              ],
            )
          else
            Row(
              children: [
                IconButton(
                    onPressed: cancelButtonFunction, icon: const Icon(Icons.cancel_outlined)),
                Text('$selectionCount')
              ],
            ),
          if(singleSelection == false)
            if(reOrderFunction != null)
              Row(
                children: [
                  IconButton(
                      onPressed: reOrderFunction,
                      icon: const Icon(Icons.reorder)
                  ),
                  const Text('Reorder')
                ],
              ),
          if(local == null)
            if(singleSelection == false)
              IconButton(
                color: Colors.black,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green)
                ),
                highlightColor: myTheme.primaryColor,
                onPressed: addButtonFunction,
                icon: const Icon(Icons.add,color: Colors.white,),
              ),
          if(local == null)
            if(singleSelection == false)
              if(addBatchButtonFunction != null)
                IconButton(
                  splashColor: Colors.grey,
                  color: Colors.black,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blueGrey)
                  ),
                  highlightColor: myTheme.primaryColor,
                  onPressed: addBatchButtonFunction,
                  icon: const Icon(Icons.batch_prediction,color: Colors.white,),
                ),

          if(singleSelection == true)
            IconButton(
              color: Colors.black,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)
              ),
              highlightColor: myTheme.primaryColor,
              onPressed: deleteButtonFunction,
              icon: const Icon(Icons.delete_forever,color: Colors.white,),
            ),
          if(singleSelection == true)
            Row(
              children: [
                Checkbox(
                    value: multipleSelection,
                    onChanged: selectAllFunction
                ),
                const Text('All')
              ],
            ),

        ],
      ),
    ),
  );
}

Widget notAvailable = const Center(child: Text('N/A',style: TextStyle(fontSize: 12,color: Colors.black54),));

TextStyle HeadingFont = const TextStyle(color: Colors.black);
Widget topBtmRgt(first,second){
  return  Expanded(
    child: Container(
      decoration: BoxDecoration(
          color: Colors.indigo.shade50,
          border: const Border(
            top: BorderSide(width: 1),
            bottom: BorderSide(width: 1),
            right: BorderSide(width: 1),

          )
      ),
      width: double.infinity,
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(first,style: const TextStyle(color: Colors.black87),),
          Text(second,style: const TextStyle(color: Colors.black87)),
        ],
      ),
    ),
  );
}
Widget topBtmLftRgt(first,second){
  return  Expanded(
    child: Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.indigo.shade50,
          border: const Border(
            top: BorderSide(width: 1),
            bottom: BorderSide(width: 1),
            right: BorderSide(width: 1),
            left: BorderSide(width: 1),
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(first,style: const TextStyle(color: Colors.black87),),
          Text(second,style: const TextStyle(color: Colors.black87)),
        ],
      ),
    ),
  );
}

Widget fixTopBtmRgt(first,second){
  return Container(
    decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        border: const Border(
          top: BorderSide(width: 1),
          bottom: BorderSide(width: 1),
          right: BorderSide(width: 1),
        )
    ),
    padding: const EdgeInsets.only(top: 8),
    width: 80,
    height: 50,
    child: Column(
      children: [
        Text(first,style: HeadingFont,),
        Text(second,style: HeadingFont,),
      ],
    ),
  );
}
List<String> dropDownList(int count){
  print("the count is $count");
  List<String> list = [];
  for(var i = 0;i < count;i++){
    list.add('${i+1}');
  }
  print(list);
  return list;
}

Widget showingMessage(title,message,BuildContext context){
  return AlertDialog(
    title: Text('$title',style: const TextStyle(color: Colors.red)),
    content: Text(message,style: const TextStyle(color: Colors.black87,fontSize: 14),),
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
            child: Text('ok',style: TextStyle(color: Colors.white,fontSize: 16),
            ),
          ),
        ),
      )
    ],
  );

}


