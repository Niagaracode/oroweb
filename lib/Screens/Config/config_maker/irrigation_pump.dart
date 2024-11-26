import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/screens/Config/config_maker/source_pump.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../../constants/theme.dart';
import '../../../state_management/config_maker_provider.dart';
import '../../../widgets/drop_down_button.dart';



class IrrigationPumpTable extends StatefulWidget {
  const IrrigationPumpTable({super.key});

  @override
  State<IrrigationPumpTable> createState() => _IrrigationPumpTableState();
}

class _IrrigationPumpTableState extends State<IrrigationPumpTable> {
  bool selectButton = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        var configPvd = Provider.of<ConfigMakerProvider>(context,listen: false);
        configPvd.irrigationPumpFunctionality(['editsourcePumpSelection',false]);
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
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 5,),
            configButtons(
                selectFunction: (value){
                  setState(() {
                    configPvd.irrigationPumpFunctionality(['editIrrigationPumpSelection',value]);
                  });
                },
                selectAllFunction: (value){
                  setState(() {
                    configPvd.irrigationPumpFunctionality(['editIrrigationPumpSelectAll',value]);
                  });
                },
                cancelButtonFunction: (){
                  configPvd.irrigationPumpFunctionality(['editIrrigationPumpSelection',false]);
                  configPvd.cancelSelection();
                },
                addButtonFunction: (){
                  if(configPvd.totalIrrigationPump == 0){
                    showDialog(
                        context: context,
                        builder: (context){
                          return showingMessage('Oops!', 'The irrigation pump limit is achieved!..', context);
                        }
                    );
                  }else{
                    configPvd.irrigationPumpFunctionality(['addIrrigationPump']);
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 500), // Adjust the duration as needed
                      curve: Curves.easeInOut, // Adjust the curve as needed
                    );
                  }
                },
                reOrderFunction: (){
                  List<int> list1 = [];
                  for(var i = 0;i < configPvd.irrigationPumpUpdated.length;i++){
                    list1.add(i+1);
                  }
                  showDialog(context: context, builder: (BuildContext context){
                    return ReOrderInIrrigationPump(list: list1);
                  });
                },
                deleteButtonFunction: (){
                  configPvd.irrigationPumpFunctionality(['deleteIrrigationPump']);
                  configPvd.cancelSelection();
                },
                addBatchButtonFunction: () {
                  showDialog(context: context, builder: (context){

                    return Consumer<ConfigMakerProvider>(builder: (context,configPvd,child){
                      if(configPvd.totalIrrigationPump == 0){
                        return showingMessage('Oops!', 'The irrigation pump limit is achieved!..', context);
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
                                        items: dropDownList(configPvd.totalIrrigationPump).map((String items) {
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
                                        checkColor: Colors.black,
                                        value: configPvd.wmYesOrNo,
                                        fillColor: MaterialStateProperty.all(Colors.amberAccent),
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
                                configPvd.irrigationPumpFunctionality(['addBatch',configPvd.val,configPvd.wmYesOrNo]);
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
                },
                selectionCount: configPvd.selection,
                singleSelection: configPvd.irrigationPumpSelection,
                multipleSelection: configPvd.irrigationPumpSelectAll
            ),
            Container(
              child: Row(
                children: [
                  topBtmLftRgt('Irrigation', 'Pump(${configPvd.totalIrrigationPump})'),
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
                  itemCount: configPvd.irrigationPumpUpdated.length,
                  itemBuilder: (BuildContext context, int index){
                    return Visibility(
                      visible: configPvd.irrigationPumpUpdated[index]['deleted'] == true ? false : true,
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1)),
                          color: Colors.white70,
                        ),
                        margin: index == configPvd.irrigationPumpUpdated.length - 1 ? const EdgeInsets.only(bottom: 60) : null,
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
                                      if(configPvd.irrigationPumpSelection == true || configPvd.irrigationPumpSelectAll == true)
                                        Checkbox(
                                            value: configPvd.irrigationPumpUpdated[index]['selection'] == 'select' ? true : false,
                                            onChanged: (value){
                                              configPvd.irrigationPumpFunctionality(['selectIrrigationPump',index,value]);
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
                                child: (configPvd.irrigationPumpUpdated[index]['oro_pump'] == true || (configPvd.totalWaterMeter == 0 && configPvd.irrigationPumpUpdated[index]['waterMeter'].isEmpty)) ?
                                notAvailable :
                                Checkbox(
                                    value: configPvd.irrigationPumpUpdated[index]['waterMeter'].isEmpty ? false : true,
                                    onChanged: (value){
                                      configPvd.irrigationPumpFunctionality(['editWaterMeter',index,value]);
                                    }),
                              ),
                            ),
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
                                          setState(() {
                                            if(configPvd.irrigationPumpUpdated[index]['oro_pump_plus'] == true){
                                              configPvd.irrigationPumpFunctionality(['editOroPumpPlus',index,false,value]);
                                            }else if(configPvd.irrigationPumpUpdated[index]['oro_pump'] == true){
                                              configPvd.irrigationPumpFunctionality(['editOroPump',index,false,value]);
                                            }else{
                                              configPvd.irrigationPumpUpdated[index]['rtu'] = value;
                                              configPvd.irrigationPumpUpdated[index]['rfNo'] = '-';
                                              configPvd.irrigationPumpUpdated[index]['output'] = '-';
                                            }
                                          });
                                        }else if(value == 'ORO Pump'){
                                          configPvd.irrigationPumpFunctionality(['editOroPump',index,true,value]);
                                        }else{
                                          configPvd.irrigationPumpFunctionality(['editOroPumpPlus',index,true,value]);
                                        }
                                      },
                                      value: configPvd.irrigationPumpUpdated[index]['rtu'])
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(right: BorderSide(width: 1))
                                  ),
                                  width: double.infinity,
                                  height: 50,
                                  child: MyDropDown(initialValue: configPvd.irrigationPumpUpdated[index]['rfNo'], itemList: getRefNo(configPvd.irrigationPumpUpdated[index]['rtu'],configPvd,index), pvdName: 'editRefNo_ip', index: index)
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
                                      value: configPvd.irrigationPumpUpdated[index]['levelSensor'].isEmpty ? false : true,
                                      onChanged: (value){
                                        configPvd.irrigationPumpFunctionality(['editLevelSensor',index,value]);
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
                                      value: configPvd.irrigationPumpUpdated[index]['pressureSensor'].isEmpty ? false : true,
                                      onChanged: (value){
                                        configPvd.irrigationPumpFunctionality(['editPressureSensor',index,value]);
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
                                    value: configPvd.irrigationPumpUpdated[index]['TopTankHigh'].isEmpty ? false : true,
                                    onChanged: (value){
                                      configPvd.irrigationPumpFunctionality(['editTopTankHigh',index,value]);
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
                                    value: configPvd.irrigationPumpUpdated[index]['TopTankLow'].isEmpty ? false : true,
                                    onChanged: (value){
                                      configPvd.irrigationPumpFunctionality(['editTopTankLow',index,value]);
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
                                    value: configPvd.irrigationPumpUpdated[index]['SumpTankHigh'].isEmpty ? false : true,
                                    onChanged: (value){
                                      configPvd.irrigationPumpFunctionality(['editSumpTankHigh',index,value]);
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
                                    value: configPvd.irrigationPumpUpdated[index]['SumpTankLow'].isEmpty ? false : true,
                                    onChanged: (value){
                                      configPvd.irrigationPumpFunctionality(['editSumpTankLow',index,value]);
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
                                      value: configPvd.irrigationPumpUpdated[index]['controlGem'],
                                      onChanged: (value){
                                        setState(() {
                                          configPvd.irrigationPumpUpdated[index]['controlGem'] = value;
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
    if(configPvd.irrigationPumpUpdated[index]['rfNo'] == '-'){
      return false;
    }
    else if(configPvd.irrigationPumpUpdated[index]['rtu'] == 'ORO pump'){
      return false;
    }
    else if(['O-Smart-Plus','ORO Smart'].contains(configPvd.irrigationPumpUpdated[index]['rtu'])){
      if(configPvd.totalLevelSensor !=0){
        return true;
      }else{
        if(configPvd.irrigationPumpUpdated[index]['levelSensor'].isNotEmpty){
          return true;
        }else{
          return false;
        }
      }
    }
    else{
      bool val = true;

      if(configPvd.irrigationPumpUpdated[index]['levelSensor'].isNotEmpty){
        val = true;
      }else if(configPvd.totalLevelSensor == 0){
        val = false;
      }else{
        for(var ip = 0; ip < configPvd.irrigationPumpUpdated.length;ip++){
          if(ip != index){
            if(configPvd.irrigationPumpUpdated[ip]['rtu'] == configPvd.irrigationPumpUpdated[index]['rtu']){
              if(configPvd.irrigationPumpUpdated[ip]['rfNo'] == configPvd.irrigationPumpUpdated[index]['rfNo']){
                if(configPvd.irrigationPumpUpdated[ip]['levelSensor'].isNotEmpty){
                  val = false;
                }
              }
            }
          }
        }
        for(var sp = 0; sp < configPvd.sourcePumpUpdated.length;sp++){
          if(configPvd.sourcePumpUpdated[sp]['rtu'] == configPvd.irrigationPumpUpdated[index]['rtu']){
            if(configPvd.sourcePumpUpdated[sp]['rfNo'] == configPvd.irrigationPumpUpdated[index]['rfNo']){
              if(configPvd.sourcePumpUpdated[sp]['levelSensor'].isNotEmpty){
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
    if(configPvd.irrigationPumpUpdated[index]['rfNo'] == '-'){
      return false;
    }
    else if(configPvd.irrigationPumpUpdated[index]['rtu'] == 'ORO pump'){
      return false;
    }
    else if(['O-Smart-Plus','ORO Smart'].contains(configPvd.irrigationPumpUpdated[index]['rtu'])){
      if(configPvd.total_p_sensor !=0){
        return true;
      }else{
        if(configPvd.irrigationPumpUpdated[index]['pressureSensor'].isNotEmpty){
          return true;
        }else{
          return false;
        }
      }
    }
    else{
      bool val = true;

      if(configPvd.irrigationPumpUpdated[index]['pressureSensor'].isNotEmpty){
        val = true;
      }else if(configPvd.total_p_sensor == 0){
        val = false;
      }else{
        for(var ip = 0; ip < configPvd.irrigationPumpUpdated.length;ip++){
          if(ip != index){
            if(configPvd.irrigationPumpUpdated[ip]['rtu'] == configPvd.irrigationPumpUpdated[index]['rtu']){
              if(configPvd.irrigationPumpUpdated[ip]['rfNo'] == configPvd.irrigationPumpUpdated[index]['rfNo']){
                if(configPvd.irrigationPumpUpdated[ip]['pressureSensor'].isNotEmpty){
                  val = false;
                }
              }
            }
          }
        }
        for(var sp = 0; sp < configPvd.sourcePumpUpdated.length;sp++){
          if(configPvd.sourcePumpUpdated[sp]['rtu'] == configPvd.irrigationPumpUpdated[index]['rtu']){
            if(configPvd.sourcePumpUpdated[sp]['rfNo'] == configPvd.irrigationPumpUpdated[index]['rfNo']){
              if(configPvd.sourcePumpUpdated[sp]['pressureSensor'].isNotEmpty){
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
    if(configPvd.irrigationPumpUpdated[index]['rfNo'] == '-'){
      return false;
    }
    else if(configPvd.irrigationPumpUpdated[index]['rtu'] == 'ORO pump'){
      return false;
    }
    else if(['O-Smart-Plus','ORO Smart'].contains(configPvd.irrigationPumpUpdated[index]['rtu'])){
      if(configPvd.totalFloat !=0){
        return true;
      }else{
        if(configPvd.irrigationPumpUpdated[index][title].isNotEmpty){
          return true;
        }else{
          return false;
        }
      }
    }
    else{
      int count = 0;
      bool val = true;
      if(configPvd.irrigationPumpUpdated[index][title].isNotEmpty){
        val = true;
      }else if(configPvd.totalFloat == 0){
        val = false;
      }else{
        for(var ip = 0; ip < configPvd.irrigationPumpUpdated.length;ip++){
          if(configPvd.irrigationPumpUpdated[ip]['rtu'] == configPvd.irrigationPumpUpdated[index]['rtu']){
            if(configPvd.irrigationPumpUpdated[ip]['rfNo'] == configPvd.irrigationPumpUpdated[index]['rfNo']){
              for(var flt in ['TopTankHigh','TopTankLow','SumpTankHigh','SumpTankLow']){
                if(title == flt && ip == index){

                }else{
                  if(configPvd.irrigationPumpUpdated[ip][flt].isNotEmpty){
                    count += 1;
                  }
                }
              }

            }
          }

        }
        for(var sp = 0; sp < configPvd.sourcePumpUpdated.length;sp++){
          if(configPvd.sourcePumpUpdated[sp]['rtu'] == configPvd.irrigationPumpUpdated[index]['rtu']){
            if(configPvd.sourcePumpUpdated[sp]['rfNo'] == configPvd.irrigationPumpUpdated[index]['rfNo']){
              for(var flt in ['TopTankHigh','TopTankLow','SumpTankHigh','SumpTankLow']){
                if(configPvd.sourcePumpUpdated[sp][flt].isNotEmpty){
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
        for(var i = 0;i < configPvd.irrigationPumpUpdated.length;i++){
          if(list[rf] != '-'){
            if(!configPvd.irrigationPumpUpdated[i]['deleted'] && configPvd.irrigationPumpUpdated[i]['rtu'] == 'O-Pump-Plus'){
              if(list[rf] == configPvd.irrigationPumpUpdated[i]['rfNo']){
                count += 1;
              }
            }
          }
        }
        for(var i = 0;i < configPvd.sourcePumpUpdated.length;i++){
          if(list[rf] != '-'){
            if(!configPvd.sourcePumpUpdated[i]['deleted'] && configPvd.sourcePumpUpdated[i]['rtu'] == 'O-Pump-Plus'){
              if(list[rf] == configPvd.sourcePumpUpdated[i]['rfNo']){
                count += 1;
              }
            }
          }
        }
        if(count == 3){
          if(configPvd.irrigationPumpUpdated[index]['rfNo'] != list[rf]){
            list.removeAt(rf);
          }
        }
      }
      return list;
    }else{
      var list = ['-',for(var i in configPvd.oPump) '$i'];
      for(var rf = list.length - 1;rf > -1;rf--){
        int count = 0;
        for(var i = 0;i < configPvd.irrigationPumpUpdated.length;i++){
          if(list[rf] != '-'){
            if(!configPvd.irrigationPumpUpdated[i]['deleted'] && configPvd.irrigationPumpUpdated[i]['rtu'] == 'ORO Pump'){
              if(list[rf] == configPvd.irrigationPumpUpdated[i]['rfNo']){
                count += 1;
              }
            }
          }
        }
        for(var i = 0;i < configPvd.sourcePumpUpdated.length;i++){
          if(list[rf] != '-'){
            if(!configPvd.sourcePumpUpdated[i]['deleted'] && configPvd.sourcePumpUpdated[i]['rtu'] == 'ORO Pump'){
              if(list[rf] == configPvd.sourcePumpUpdated[i]['rfNo']){
                count += 1;
              }
            }
          }
        }
        if(count == 3){
          if(configPvd.irrigationPumpUpdated[index]['rfNo'] != list[rf]){
            list.removeAt(rf);
          }
        }
      }
      return list;
    }
  }
}
class ReOrderInIrrigationPump extends StatefulWidget {
  final List<int> list;
  const ReOrderInIrrigationPump({super.key, required this.list});

  @override
  State<ReOrderInIrrigationPump> createState() => _ReOrderInIrrigationPumpState();
}

class _ReOrderInIrrigationPumpState extends State<ReOrderInIrrigationPump> {

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
              configPvd.irrigationPumpFunctionality(['reOrderPump',oldIndex,newIndex]);
              Navigator.pop(context);
            },
            child: const Text('Change')
        )
      ],
    );
  }
}
