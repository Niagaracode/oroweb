import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/constants/theme.dart';
import 'package:oro_irrigation_new/screens/Config/config_maker/source_pump.dart';
import 'package:provider/provider.dart';

import '../../../state_management/config_maker_provider.dart';
import '../../../widgets/text_form_field_for_config_flexible.dart';
import 'central_dosing.dart';



class LocalDosingTable extends StatefulWidget {
  const LocalDosingTable({super.key});

  @override
  State<LocalDosingTable> createState() => _LocalDosingTableState();
}

class _LocalDosingTableState extends State<LocalDosingTable> {
  ScrollController scrollController = ScrollController();
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
        //color: Color(0xFFF3F3F3),
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            configButtons(
              local: true,
              selectFunction: (value){
                setState(() {
                  configPvd.localDosingFunctionality(['edit_l_DosingSelection',value]);
                });
              },
              selectAllFunction: (value){
                setState(() {
                  configPvd.localDosingFunctionality(['edit_l_DosingSelectAll',value]);
                });
              },
              cancelButtonFunction: (){
                configPvd.localDosingFunctionality(['edit_l_DosingSelectAll',false]);
                configPvd.localDosingFunctionality(['edit_l_DosingSelection',false]);
                configPvd.cancelSelection();
              },
              addBatchButtonFunction: (){

              },
              addButtonFunction: (){
              },
              deleteButtonFunction: (){
                configPvd.localDosingFunctionality(['edit_l_DosingSelection',false]);
                configPvd.localDosingFunctionality(['deleteLocalDosing']);
                configPvd.cancelSelection();
              },
              selectionCount: configPvd.selection,
              singleSelection: configPvd.l_dosingSelection,
              multipleSelection: configPvd.l_dosingSelectAll,
            ),
            Container(
              child: Row(
                children: [
                  topBtmLftRgt('Line',''),
                  topBtmRgt('Booster','(${configPvd.totalBooster})'),
                  topBtmRgt('Ec','(${configPvd.totalEcSensor})'),
                  topBtmRgt('Ph','(${configPvd.totalPhSensor})'),
                  topBtmRgt('Pressure','Switch(${configPvd.totalPressureSwitch})'),
                  topBtmRgt('Injector','(${configPvd.totalInjector})'),
                  topBtmRgt('Dosing','Meter(${configPvd.totalDosingMeter})'),
                  topBtmRgt('Level','Sensor(${configPvd.totalLevelSensor})'),
                  topBtmRgt('Injector','type'),
                  topBtmRgt('Select','Bp'),
                  topBtmRgt('Agitator',''),


                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: configPvd.localDosingUpdated.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      decoration: BoxDecoration(
                          color: index % 2 == 0 ? Colors.white : const Color(0XFFF3F3F3),
                          border: const Border(bottom: BorderSide(width: 1))
                      ),
                      margin: index == configPvd.localDosingUpdated.length - 1 ? const EdgeInsets.only(bottom: 60) : null,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(left: BorderSide(width: 1),right: BorderSide(width: 1)),
                              ),
                              height: (configPvd.localDosingUpdated[index]['injector'].length) * 50,
                              width: double.infinity,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if(configPvd.l_dosingSelection == true || configPvd.l_dosingSelectAll == true)
                                      Checkbox(
                                          fillColor: MaterialStateProperty.all(Colors.white),
                                          checkColor: myTheme.primaryColor,
                                          value: configPvd.localDosingUpdated[index]['selection'] == 'select' ? true : false,
                                          onChanged: (value){
                                            configPvd.localDosingFunctionality(['selectLocalDosing',index]);
                                          }),
                                    Text('${configPvd.localDosingUpdated[index]['line']}',style: const TextStyle(color: Colors.black),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(right: BorderSide(width: 1)),
                                ),
                                height: (configPvd.localDosingUpdated[index]['injector'].length) * 50,
                                width: double.infinity,
                                child : configPvd.totalBooster == 0 && configPvd.localDosingUpdated[index]['boosterPump'] == '' ?
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  width: 80,
                                  height: 50,
                                  child: notAvailable,
                                ) : Center(
                                  child: TextFieldForFlexibleConfig(index: index, initialValue: '${configPvd.localDosingUpdated[index]['boosterPump']}', config: configPvd, purpose: 'localDosingFunctionality/editBoosterPump',),
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(right: BorderSide(width: 1)),
                                ),
                                height: (configPvd.localDosingUpdated[index]['injector'].length) * 50,
                                width: double.infinity,
                                child : configPvd.totalEcSensor == 0 && configPvd.localDosingUpdated[index]['ec'] == '' ?
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  width: 80,
                                  height: 50,
                                  child: notAvailable,
                                ) : Center(
                                    child: TextFieldForFlexibleConfig(index: index, initialValue: '${configPvd.localDosingUpdated[index]['ec']}', config: configPvd, purpose: 'localDosingFunctionality/editEcSensor',)
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(right: BorderSide(width: 1)),
                                ),
                                height: (configPvd.localDosingUpdated[index]['injector'].length) * 50,
                                width: double.infinity,
                                child : configPvd.totalPhSensor == 0 && configPvd.localDosingUpdated[index]['ph'] == '' ?
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  width: 80,
                                  height: 50,
                                  child: notAvailable,
                                ) : Center(
                                    child: TextFieldForFlexibleConfig(index: index, initialValue: '${configPvd.localDosingUpdated[index]['ph']}', config: configPvd, purpose: 'localDosingFunctionality/editPhSensor',)
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(right: BorderSide(width: 1)),
                              ),
                              width: double.infinity,
                              height: (configPvd.localDosingUpdated[index]['injector'].length) * 50 ,
                              child: (configPvd.totalPressureSwitch == 0 && configPvd.localDosingUpdated[index]['pressureSwitch'].isEmpty) ?
                              notAvailable :
                              Checkbox(
                                  value: configPvd.localDosingUpdated[index]['pressureSwitch'].isEmpty ? false : true,
                                  onChanged: (value){
                                    configPvd.localDosingFunctionality(['editPressureSwitch',index,value]);
                                  }),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(width: 1))
                                ),
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    for(var i = 0; i< configPvd.localDosingUpdated[index]['injector'].length;i ++)
                                      Container(
                                        height: 50,
                                        decoration:  BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(width: i == configPvd.localDosingUpdated[index]['injector'].length - 1 ? 0 : 1)
                                            )
                                        ),
                                        child: Center(child: Text('${i+1}')),
                                      )
                                  ],
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(width: 1))
                                ),
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    for(var i = 0; i< configPvd.localDosingUpdated[index]['injector'].length;i ++)
                                      Container(
                                        width: double.infinity,
                                        decoration:  BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(width: i == configPvd.localDosingUpdated[index]['injector'].length - 1 ? 0 : 1)
                                            )
                                        ),
                                        height: 50,
                                        child: (configPvd.totalDosingMeter == 0 && configPvd.localDosingUpdated[index]['injector'][i]['dosingMeter'].isEmpty) ?
                                        notAvailable :
                                        Checkbox(
                                            value: configPvd.localDosingUpdated[index]['injector'][i]['dosingMeter'].isEmpty ? false : true,
                                            onChanged: (value){
                                              configPvd.localDosingFunctionality(['editDosingMeter',index,i,value]);
                                            }),
                                      ),
                                  ],
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(width: 1))
                                ),
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    for(var i = 0; i< configPvd.localDosingUpdated[index]['injector'].length;i ++)
                                      Container(
                                        width: double.infinity,
                                        decoration:  BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(width: i == configPvd.localDosingUpdated[index]['injector'].length - 1 ? 0 : 1)
                                            )
                                        ),
                                        height: 50,
                                        child: (configPvd.totalLevelSensor == 0 && configPvd.localDosingUpdated[index]['injector'][i]['levelSensor'].isEmpty) ?
                                        notAvailable :
                                        Checkbox(
                                            value: configPvd.localDosingUpdated[index]['injector'][i]['levelSensor'].isEmpty ? false : true,
                                            onChanged: (value){
                                              configPvd.localDosingFunctionality(['editLevelSensor',index,i,value]);
                                            }),
                                      ),
                                  ],
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(width: 1))
                                ),
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    for(var i = 0; i< configPvd.localDosingUpdated[index]['injector'].length;i ++)
                                      Container(
                                        width: double.infinity,
                                        decoration:  BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(width: i == configPvd.localDosingUpdated[index]['injector'].length - 1 ? 0 : 1)
                                            )
                                        ),
                                        height: 50,
                                        child: Center(
                                          child: DropdownButton(
                                              focusColor: Colors.transparent,
                                              value: configPvd.localDosingUpdated[index]['injector'][i]['injectorType'],
                                              underline: Container(),
                                              items: ['Venturi','Electrical'].map((String items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Container(
                                                      child: Text(items,style: const TextStyle(fontSize: 11,color: Colors.black),)
                                                  ),
                                                );
                                              }).toList(),
                                              // After selecting the desired option,it will
                                              // change button value to selected value
                                              onChanged: (newValue) {
                                                configPvd.localDosingFunctionality(['editInjectorType',index,i,newValue]);
                                              }
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(width: 1))
                                ),
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    for(var i = 0; i< configPvd.localDosingUpdated[index]['injector'].length;i ++)
                                      Container(
                                        width: double.infinity,
                                        decoration:  BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(width: i == configPvd.localDosingUpdated[index]['injector'].length - 1 ? 0 : 1)
                                            )
                                        ),
                                        height: 50,
                                        child: configPvd.localDosingUpdated[index]['injector'][i]['injectorType'] == 'Electrical' ? Center(
                                          child: DropdownButton(
                                              focusColor: Colors.transparent,
                                              //style: ioText,
                                              value: configPvd.localDosingUpdated[index]['injector'][i]['Which_Booster_Pump'],
                                              underline: Container(),
                                              items: giveBoosterSelection(configPvd.localDosingUpdated[index]['boosterConnection'].length,configPvd).map((String items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Container(
                                                      child: Text(items,style: const TextStyle(fontSize: 11,color: Colors.black),)
                                                  ),
                                                );
                                              }).toList(),
                                              // After selecting the desired option,it will
                                              // change button value to selected value
                                              onChanged: (newValue) {
                                                configPvd.localDosingFunctionality(['boosterSelectionForInjector',index,i,newValue]);
                                              }
                                          ),
                                        ) : notAvailable,
                                      ),
                                  ],
                                )
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap : (){
                                sideSheet(constraint, index, 2);
                              },
                              child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(width: 1)),
                                  ),
                                  width: double.infinity,
                                  height: (configPvd.localDosingUpdated[index]['injector'].length) * 50 ,
                                  child: Center(
                                    child: Text('${configPvd.localDosingUpdated[index]['agitator']}'),
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      );
    });
  }

  List<String> giveBoosterSelection(int count,ConfigMakerProvider configPvd){
    List<String> list = [];
    for(var i = 0; i< count;i++){
      list.add('BP ${i+1}');
    }
    return list;
  }
  void sideSheet(constraints,int index,int centralOrLocal) {
    showGeneralDialog(
      barrierLabel: "Side sheet",
      barrierDismissible: true,
      // barrierColor: const Color(0xff6600),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            elevation: 15,
            color: Colors.transparent,
            borderRadius: BorderRadius.zero,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
                return SizedBox(
                  width: constraints.maxWidth < 600 ? constraints.maxWidth * 0.7 : constraints.maxWidth * 0.2,
                  child: SelectingAgitator(index: index, centralOrLocal: centralOrLocal,),
                );
              },
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: const Offset(0, 0)).animate(animation1),
          child: child,
        );
      },
    );
  }
}
