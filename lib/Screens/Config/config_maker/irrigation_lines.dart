import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:oro_irrigation_new/constants/theme.dart';
import 'package:oro_irrigation_new/screens/Config/config_maker/source_pump.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../../state_management/config_maker_provider.dart';
import '../../../widgets/drop_down_button.dart';
import '../../../widgets/text_form_field_config.dart';
import '../../../widgets/text_form_field_for_config_flexible.dart';
import '../../Customer/IrrigationProgram/water_and_fertilizer_screen.dart';


class IrrigationLineTable extends StatefulWidget {
  const IrrigationLineTable({super.key});

  @override
  State<IrrigationLineTable> createState() => _IrrigationLineTableState();
}

class _IrrigationLineTableState extends State<IrrigationLineTable> {
  bool listReady = false;
  late LinkedScrollControllerGroup _scrollable1;
  late ScrollController _verticalScroll1;
  late ScrollController _verticalScroll2;
  late LinkedScrollControllerGroup _scrollable2;
  late ScrollController _horizontalScroll1;
  late ScrollController _horizontalScroll2;
  bool selectButton = false;
  bool delete = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollable1 = LinkedScrollControllerGroup();
    _verticalScroll1 = _scrollable1.addAndGet();
    _verticalScroll2 = _scrollable1.addAndGet();
    _scrollable2 = LinkedScrollControllerGroup();
    _horizontalScroll1 = _scrollable2.addAndGet();
    _horizontalScroll2 = _scrollable2.addAndGet();
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
  }

  @override
  Widget build(BuildContext context) {
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: true);
    return Container(
      color: const Color(0xFFF3F3F3),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5,right: 5),
            child: configButtons(
              selectFunction: (value){
                setState(() {
                  configPvd.irrigationLinesFunctionality(['editIrrigationSelection',value]);
                });
              },
              selectAllFunction: (value){
                configPvd.irrigationLinesFunctionality(['editIrrigationSelectAll',value]);
              },
              cancelButtonFunction: (){
                configPvd.irrigationLinesFunctionality(['editIrrigationSelection',false]);
                configPvd.irrigationLinesFunctionality(['editIrrigationSelectAll',false]);
                configPvd.cancelSelection();
              },
              reOrderFunction: (){
                List<int> list1 = [];
                for(var i = 0;i < configPvd.irrigationLines.length;i++){
                  list1.add(i+1);
                }
                showDialog(context: context, builder: (BuildContext context){
                  return ReOrderInIL(list: list1);
                });
              },
              addButtonFunction: (){
                if(configPvd.totalIrrigationLine == 0){
                  showDialog(
                      context: context,
                      builder: (context){
                        return showingMessage('Oops!', 'The irrigation line limit is achieved!..', context);
                      }
                  );
                }
                // else if(configPvd.totalValve == 0){
                //   showDialog(
                //       context: context,
                //       builder: (context){
                //         return showingMessage('Oops!', 'The valve limit is achieved!..', context);
                //       }
                //   );
                // }
                else{
                  configPvd.irrigationLinesFunctionality(['addIrrigationLine']);
                  _verticalScroll1.animateTo(
                    _verticalScroll1.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500), // Adjust the duration as needed
                    curve: Curves.easeInOut, // Adjust the curve as needed
                  );
                  _verticalScroll2.animateTo(
                    _verticalScroll2.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500), // Adjust the duration as needed
                    curve: Curves.easeInOut, // Adjust the curve as needed
                  );
                }
              },
              deleteButtonFunction: (){
                configPvd.irrigationLinesFunctionality(['editIrrigationSelection',false]);
                configPvd.irrigationLinesFunctionality(['deleteIrrigationLine']);
                configPvd.cancelSelection();
                setState(() {
                  delete = true;
                });
              },
              selectionCount: configPvd.selection,
              singleSelection: configPvd.irrigationSelection,
              multipleSelection: configPvd.irrigationSelectAll,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 5,right: 5),
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                var width = constraints.maxWidth;
                return Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.indigo.shade50,
                                border: const Border(
                                  bottom: BorderSide(width: 1),
                                  right: BorderSide(width: 1),
                                  left: BorderSide(width: 1),
                                  top: BorderSide(width: 1),
                                )
                            ),
                            padding: const EdgeInsets.only(top: 8),
                            width: 60,
                            height: 50,
                            child: Column(
                              children: [
                                Text('Line',style: HeadingFont,),
                                Text('(${configPvd.totalIrrigationLine})',style: HeadingFont,),
                              ],
                            )
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _verticalScroll1,
                            child: Container(
                              child: Column(
                                children: [
                                  for(var i = 0;i < configPvd.irrigationLines.length; i++)
                                    Visibility(
                                      visible : configPvd.irrigationLines[i]['deleted'] == true ? false : true,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.indigo.shade50,
                                            border: const Border(
                                              bottom: BorderSide(width: 1),
                                              left: BorderSide(width: 1),
                                              right: BorderSide(width: 1),
                                            )
                                        ),
                                        width: 60,
                                        height: 51,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if(configPvd.irrigationSelection == true || configPvd.irrigationSelectAll == true)
                                              Checkbox(
                                                  fillColor: MaterialStateProperty.all(Colors.white),
                                                  checkColor: myTheme.primaryColor,
                                                  value: configPvd.irrigationLines[i]['isSelected'] == 'select' ? true : false,
                                                  onChanged: (value){
                                                    configPvd.irrigationLinesFunctionality(['selectIrrigationLine',i,value]);
                                                  }),
                                            Center(child: Text('${i + 1}',style: const TextStyle(fontSize: 12,color: Colors.black))),
                                          ],
                                        ),
                                      ),
                                    ),

                                  const SizedBox(height: 100,)
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: width-60,
                          child: SingleChildScrollView(
                            controller: _horizontalScroll1,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                fixTopBtmRgt('Valve','(${configPvd.totalValve})'),
                                fixTopBtmRgt('Main','Valve(${configPvd.totalMainValve})'),
                                fixTopBtmRgt('Moisture','Sensor(${configPvd.totalMoistureSensor})'),
                                fixTopBtmRgt('Level','Sensor(${configPvd.totalLevelSensor})'),
                                fixTopBtmRgt('Fogger','(${configPvd.totalFogger})'),
                                fixTopBtmRgt('Fan','(${configPvd.totalFan})'),
                                fixTopBtmRgt('Central','Dosing'),
                                fixTopBtmRgt('Central','Filtration'),
                                fixTopBtmRgt('Local','Dosing'),
                                fixTopBtmRgt('Local','Filtration'),
                                fixTopBtmRgt('P.Sensor','In(${configPvd.total_p_sensor})'),
                                fixTopBtmRgt('P.Sensor','Out(${configPvd.total_p_sensor})'),
                                fixTopBtmRgt('Irr.','Pump'),
                                fixTopBtmRgt('Src.','Pump'),
                                fixTopBtmRgt('Agitator',''),
                                fixTopBtmRgt('Water','Meter(${configPvd.totalWaterMeter})'),
                                fixTopBtmRgt('Power','Supply(${configPvd.totalPowerSupply})'),
                                fixTopBtmRgt('Pressure','Switch(${configPvd.totalPressureSwitch})'),
                                // fixTopBtmRgt('ORO Smart','(${configPvd.totalOroSmartRTU})'),
                                // fixTopBtmRgt('ORO Smart','Plus(${configPvd.totalOroSmartRtuPlus})'),
                                // fixTopBtmRgt('RTU','(${configPvd.totalRTU})'),
                                // fixTopBtmRgt('RTU_Plus','(${configPvd.totalRtuPlus})'),
                                // fixTopBtmRgt('ORO','Switch(${configPvd.totalOroSwitch})'),
                                // fixTopBtmRgt('ORO','Sense(${configPvd.totalOroSense})'),
                                // fixTopBtmRgt('ORO','Level(${configPvd.totalOroLevel})'),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: width-60 ,
                            child: Scrollbar(
                              thumbVisibility: true,
                            controller: _horizontalScroll2,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _horizontalScroll2,
                                child: Container(
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    controller: _verticalScroll2,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      controller: _verticalScroll2,
                                      child: Column(
                                        children: [
                                          for(var i = 0;i < configPvd.irrigationLines.length; i++)
                                            Visibility(
                                              visible : configPvd.irrigationLines[i]['deleted'] == true ? false : true,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: const Border(bottom: BorderSide(width: 1)),
                                                  color: i % 2 == 0 ? Colors.white : const Color(0XFFF3F3F3),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.all(5),
                                                      width: 80,
                                                      height: 50,
                                                      child: TextFieldForConfig(index: i, initialValue: '${configPvd.irrigationLines[i]['valve']}', config: configPvd, purpose: 'irrigationLinesFunctionality/valve',),
                                                    ),
                                                    configPvd.totalMainValve == 0 && configPvd.irrigationLines[i]['main_valve'] == '' ?
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.all(5),
                                                      width: 80,
                                                      height: 50,
                                                      child: notAvailable,
                                                    ) : Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.all(5),
                                                      width: 80,
                                                      height: 50,
                                                      child: TextFieldForFlexibleConfig(index: i, initialValue: '${configPvd.irrigationLines[i]['main_valve']}', config: configPvd, purpose: 'irrigationLinesFunctionality/mainValve',),
                                                    ),
                                                    configPvd.totalMoistureSensor == 0 && configPvd.irrigationLines[i]['moistureSensor'] == '' ?
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.all(5),
                                                      width: 80,
                                                      height: 50,
                                                      child: notAvailable,
                                                    ) : Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.all(5),
                                                      width: 80,
                                                      height: 50,
                                                      child: TextFieldForFlexibleConfig(index: i, initialValue: '${configPvd.irrigationLines[i]['moistureSensor']}', config: configPvd, purpose: 'irrigationLinesFunctionality/moistureSensor',),
                                                    ),
                                                    configPvd.totalLevelSensor == 0 && configPvd.irrigationLines[i]['levelSensor'] == '' ?
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.all(5),
                                                      width: 80,
                                                      height: 50,
                                                      child: notAvailable,
                                                    ) : Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.all(5),
                                                      width: 80,
                                                      height: 50,
                                                      child: TextFieldForFlexibleConfig(index: i, initialValue: '${configPvd.irrigationLines[i]['levelSensor']}', config: configPvd, purpose: 'irrigationLinesFunctionality/levelSensor',),
                                                    ),
                                                    configPvd.totalFogger == 0 && configPvd.irrigationLines[i]['fogger'] == '' ?
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.all(5),
                                                      width: 80,
                                                      height: 50,
                                                      child: notAvailable,
                                                    ) : Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.all(5),
                                                      width: 80,
                                                      height: 50,
                                                      child: TextFieldForFlexibleConfig(index: i, initialValue: '${configPvd.irrigationLines[i]['fogger']}', config: configPvd, purpose: 'irrigationLinesFunctionality/fogger',),
                                                    ),
                                                    configPvd.totalFan == 0 && configPvd.irrigationLines[i]['fan'] == '' ?
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.all(5),
                                                      width: 80,
                                                      height: 50,
                                                      child: notAvailable,
                                                    ) : Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.all(5),
                                                      width: 80,
                                                      height: 50,
                                                      child: TextFieldForFlexibleConfig(index: i, initialValue: '${configPvd.irrigationLines[i]['fan']}', config: configPvd, purpose: 'irrigationLinesFunctionality/fan',),
                                                    ),
                                                    Container(
                                                        decoration: const BoxDecoration(
                                                          border: Border(right: BorderSide(width: 1)),
                                                        ),
                                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                                        width: 80,
                                                        height: 50,
                                                        child: MyDropDown(initialValue: configPvd.irrigationLines[i]['Central_dosing_site'], itemList: configPvd.central_dosing_site_list , pvdName: 'editCentralDosing', index: i)
                                                    ),
                                                    Container(
                                                        decoration: const BoxDecoration(
                                                          border: Border(right: BorderSide(width: 1)),
                                                        ),
                                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                                        width: 80,
                                                        height: 50,
                                                        child: MyDropDown(initialValue: configPvd.irrigationLines[i]['Central_filtration_site'], itemList: configPvd.central_filtration_site_list , pvdName: 'editCentralFiltration', index: i)
                                                    ),
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                                      width: 80,
                                                      height: 50,
                                                      child: (configPvd.totalInjector == 0 &&  configPvd.irrigationLines[i]['Local_dosing_site'] == false) ?
                                                      notAvailable :
                                                      Checkbox(
                                                          value:  configPvd.irrigationLines[i]['Local_dosing_site'],
                                                          onChanged: (value){
                                                            if(value == true){
                                                              showDialog(context: context, builder: (BuildContext context){
                                                                return AlertDialog(
                                                                  title: const Text('Add batch',style: TextStyle(color: Colors.black),),
                                                                  content: ldBatch(index: i, value: value!,),
                                                                );
                                                              });
                                                            }else{
                                                              configPvd.irrigationLinesFunctionality(['editLocalDosing',i,value!]);
                                                            }
                                                          }),
                                                    ),
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                                      width: 80,
                                                      height: 50,
                                                      child: (configPvd.totalFilter == 0 &&  configPvd.irrigationLines[i]['local_filtration_site'] == false) ?
                                                      notAvailable :
                                                      Checkbox(
                                                          value:  configPvd.irrigationLines[i]['local_filtration_site'],
                                                          onChanged: (value){
                                                            configPvd.irrigationLinesFunctionality(['editLocalFiltration',i,value]);
                                                          }),
                                                    ),
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                                      width: 80,
                                                      height: 50,
                                                      child: (configPvd.total_p_sensor == 0 && configPvd.irrigationLines[i]['pressureIn'].isEmpty) ?
                                                      notAvailable :
                                                      Checkbox(
                                                          value: configPvd.irrigationLines[i]['pressureIn'].isEmpty ? false : true,
                                                          onChanged: (value){
                                                            configPvd.irrigationLinesFunctionality(['editPressureSensorInConnection',i,value]);
                                                          }),
                                                    ),
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                                      width: 80,
                                                      height: 50,
                                                      child: (configPvd.total_p_sensor == 0 && configPvd.irrigationLines[i]['pressureOut'].isEmpty) ?
                                                      notAvailable :
                                                      Checkbox(
                                                          value: configPvd.irrigationLines[i]['pressureOut'].isEmpty ? false : true,
                                                          onChanged: (value){
                                                            configPvd.irrigationLinesFunctionality(['editPressureSensorOutConnection',i,value]);
                                                          }),
                                                    ),
                                                    InkWell(
                                                      child: Container(
                                                          decoration: const BoxDecoration(
                                                            border: Border(right: BorderSide(width: 1)),
                                                          ),
                                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                                          width: 80,
                                                          height: 50,
                                                          child: Center(
                                                            child: Text('${configPvd.irrigationLines[i]['irrigationPump']}'),
                                                          ),
                                                          // child: MyDropDown(initialValue: configPvd.irrigationLines[i]['irrigationPump'], itemList: getIpList(configPvd) , pvdName: 'editIrrigationPump', index: i)
                                                      ),
                                                      onTap: (){
                                                        sideSheet(constraints, i,AssigningParameterForLine.irrigationPump);
                                                      },
                                                    ),
                                                    InkWell(
                                                      child: Container(
                                                        decoration: const BoxDecoration(
                                                          border: Border(right: BorderSide(width: 1)),
                                                        ),
                                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                                        width: 80,
                                                        height: 50,
                                                        child: Center(
                                                          child: Text('${configPvd.irrigationLines[i]['sourcePump']}'),
                                                        ),
                                                        // child: MyDropDown(initialValue: configPvd.irrigationLines[i]['irrigationPump'], itemList: getIpList(configPvd) , pvdName: 'editIrrigationPump', index: i)
                                                      ),
                                                      onTap: (){
                                                        sideSheet(constraints, i,AssigningParameterForLine.sourcePump);
                                                      },
                                                    ),
                                                    InkWell(
                                                      child: Container(
                                                        decoration: const BoxDecoration(
                                                          border: Border(right: BorderSide(width: 1)),
                                                        ),
                                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                                        width: 80,
                                                        height: 50,
                                                        child: Center(
                                                          child: Text('${configPvd.irrigationLines[i]['agitator']}'),
                                                        ),
                                                        // child: MyDropDown(initialValue: configPvd.irrigationLines[i]['irrigationPump'], itemList: getIpList(configPvd) , pvdName: 'editIrrigationPump', index: i)
                                                      ),
                                                      onTap: (){
                                                        sideSheet(constraints, i,AssigningParameterForLine.agitator);
                                                      },
                                                    ),
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                                      width: 80,
                                                      height: 50,
                                                      child: (configPvd.totalWaterMeter == 0 && configPvd.irrigationLines[i]['water_meter'].isEmpty) ?
                                                      notAvailable :
                                                      Checkbox(
                                                          value: configPvd.irrigationLines[i]['water_meter'].isEmpty ? false : true,
                                                          onChanged: (value){
                                                            configPvd.irrigationLinesFunctionality(['editWaterMeter',i,value]);
                                                          }),
                                                    ),
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                                      width: 80,
                                                      height: 50,
                                                      child: (configPvd.totalPowerSupply == 0 && configPvd.irrigationLines[i]['powerSupply'].isEmpty) ?
                                                      notAvailable :
                                                      Checkbox(
                                                          value: configPvd.irrigationLines[i]['powerSupply'].isEmpty ? false : true,
                                                          onChanged: (value){
                                                            configPvd.irrigationLinesFunctionality(['editTotalPowerSupply',i,value]);
                                                          }),
                                                    ),
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1)),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                                      width: 80,
                                                      height: 50,
                                                      child: (configPvd.totalPressureSwitch == 0 && configPvd.irrigationLines[i]['pressureSwitch'].isEmpty) ?
                                                      notAvailable :
                                                      Checkbox(
                                                          value: configPvd.irrigationLines[i]['pressureSwitch'].isEmpty ? false : true,
                                                          onChanged: (value){
                                                            configPvd.irrigationLinesFunctionality(['editTotalPressureSwitch',i,value]);
                                                          }),
                                                    ),
                                                    // configPvd.totalOroSmartRTU == 0 && configPvd.irrigationLines[i]['ORO_Smart_RTU'] == '' ?
                                                    // Container(
                                                    //   decoration: BoxDecoration(
                                                    //     border: Border(right: BorderSide(width: 1)),
                                                    //   ),
                                                    //   padding: EdgeInsets.all(5),
                                                    //   width: 80,
                                                    //   height: 50,
                                                    //   child: notAvailable,
                                                    // ) : Container(
                                                    //   decoration: BoxDecoration(
                                                    //     border: Border(right: BorderSide(width: 1)),
                                                    //   ),
                                                    //   padding: EdgeInsets.symmetric(horizontal: 5),
                                                    //   width: 80,
                                                    //   height: 50,
                                                    //   child: Center(child: TextFieldForFlexibleConfig(index: i, initialValue: '${configPvd.irrigationLines[i]['ORO_Smart_RTU']}', config: configPvd, purpose: 'irrigationLinesFunctionality/OroSmartRtu',)),
                                                    // ),
                                                    // configPvd.totalOroSmartRtuPlus == 0 && configPvd.irrigationLines[i]['ORO_Smart_RTU_Plus'] == '' ?
                                                    // Container(
                                                    //   decoration: BoxDecoration(
                                                    //     border: Border(right: BorderSide(width: 1)),
                                                    //   ),
                                                    //   padding: EdgeInsets.all(5),
                                                    //   width: 80,
                                                    //   height: 50,
                                                    //   child: notAvailable,
                                                    // ) : Container(
                                                    //   decoration: BoxDecoration(
                                                    //     border: Border(right: BorderSide(width: 1)),
                                                    //   ),
                                                    //   padding: EdgeInsets.symmetric(horizontal: 5),
                                                    //   width: 80,
                                                    //   height: 50,
                                                    //   child: Center(child: TextFieldForFlexibleConfig(index: i, initialValue: '${configPvd.irrigationLines[i]['ORO_Smart_RTU_Plus']}', config: configPvd, purpose: 'irrigationLinesFunctionality/OroSmartRtuPlus',)),
                                                    // ),
                                                    // configPvd.totalRTU == 0 && configPvd.irrigationLines[i]['RTU'] == '' ?
                                                    // Container(
                                                    //   decoration: BoxDecoration(
                                                    //     border: Border(right: BorderSide(width: 1)),
                                                    //   ),
                                                    //   padding: EdgeInsets.all(5),
                                                    //   width: 80,
                                                    //   height: 50,
                                                    //   child: notAvailable,
                                                    // ) : Container(
                                                    //   decoration: BoxDecoration(
                                                    //     border: Border(right: BorderSide(width: 1)),
                                                    //   ),
                                                    //   padding: EdgeInsets.all(5),
                                                    //   width: 80,
                                                    //   height: 50,
                                                    //   child: Center(child: TextFieldForFlexibleConfig(index: i, initialValue: '${configPvd.irrigationLines[i]['RTU']}', config: configPvd, purpose: 'irrigationLinesFunctionality/RTU',)),
                                                    // ),
                                                    // configPvd.totalRtuPlus == 0 && configPvd.irrigationLines[i]['RTU_Plus'] == '' ?
                                                    // Container(
                                                    //   decoration: BoxDecoration(
                                                    //     border: Border(right: BorderSide(width: 1)),
                                                    //   ),
                                                    //   padding: EdgeInsets.all(5),
                                                    //   width: 80,
                                                    //   height: 50,
                                                    //   child: notAvailable,
                                                    // ) : Container(
                                                    //   decoration: BoxDecoration(
                                                    //     border: Border(right: BorderSide(width: 1)),
                                                    //   ),
                                                    //   padding: EdgeInsets.all(5),
                                                    //   width: 80,
                                                    //   height: 50,
                                                    //   child: Center(child: TextFieldForFlexibleConfig(index: i, initialValue: '${configPvd.irrigationLines[i]['RTU_Plus']}', config: configPvd, purpose: 'irrigationLinesFunctionality/RTU_Plus',)),
                                                    // ),
                                                    // configPvd.totalOroSwitch == 0 && configPvd.irrigationLines[i]['ORO_switch'] == '' ?
                                                    // Container(
                                                    //   decoration: BoxDecoration(
                                                    //     border: Border(right: BorderSide(width: 1)),
                                                    //   ),
                                                    //   padding: EdgeInsets.all(5),
                                                    //   width: 80,
                                                    //   height: 50,
                                                    //   child: notAvailable,
                                                    // ) : Container(
                                                    //   decoration: BoxDecoration(
                                                    //     border: Border(right: BorderSide(width: 1)),
                                                    //   ),
                                                    //   padding: EdgeInsets.all(5),
                                                    //   width: 80,
                                                    //   height: 50,
                                                    //   child: Center(child: TextFieldForFlexibleConfig(index: i, initialValue: '${configPvd.irrigationLines[i]['ORO_switch']}', config: configPvd, purpose: 'irrigationLinesFunctionality/0roSwitch',)),
                                                    // ),
                                                    // configPvd.totalOroSense == 0 && configPvd.irrigationLines[i]['ORO_sense'] == '' ?
                                                    // Container(
                                                    //   decoration: BoxDecoration(
                                                    //     border: Border(right: BorderSide(width: 1)),
                                                    //   ),
                                                    //   padding: EdgeInsets.all(5),
                                                    //   width: 80,
                                                    //   height: 50,
                                                    //   child: notAvailable,
                                                    // ) : Container(
                                                    //   decoration: BoxDecoration(
                                                    //     border: Border(right: BorderSide(width: 1)),
                                                    //   ),
                                                    //   padding: EdgeInsets.symmetric(horizontal: 5),
                                                    //   width: 80,
                                                    //   height: 50,
                                                    //   child: Center(child: TextFieldForFlexibleConfig(index: i, initialValue: '${configPvd.irrigationLines[i]['ORO_sense']}', config: configPvd, purpose: 'irrigationLinesFunctionality/0roSense',)),
                                                    // ),
                                                    // configPvd.totalOroLevel == 0 && configPvd.irrigationLines[i]['ORO_level'] == '' ?
                                                    // Container(
                                                    //   decoration: BoxDecoration(
                                                    //     border: Border(right: BorderSide(width: 1)),
                                                    //   ),
                                                    //   padding: EdgeInsets.all(5),
                                                    //   width: 80,
                                                    //   height: 50,
                                                    //   child: notAvailable,
                                                    // ) : Container(
                                                    //   decoration: BoxDecoration(
                                                    //     border: Border(right: BorderSide(width: 1)),
                                                    //   ),
                                                    //   padding: EdgeInsets.symmetric(horizontal: 5),
                                                    //   width: 80,
                                                    //   height: 50,
                                                    //   child: Center(child: TextFieldForFlexibleConfig(index: i, initialValue: '${configPvd.irrigationLines[i]['ORO_level']}', config: configPvd, purpose: 'irrigationLinesFunctionality/0roLevel',)),
                                                    // ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                          const SizedBox(height: 100,)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              },),
            ),
          ),
        ],
      ),
    );
  }
  List<String> getIpList(ConfigMakerProvider configPvd){
    var list = ['-'];
    for(var i = 0;i < configPvd.irrigationPumpUpdated.length;i++){
      if(!configPvd.irrigationPumpUpdated[i]['deleted']){
        list.add('${i+1}');
      }
    }
    return list;
  }

  void sideSheet(constraints,int index,AssigningParameterForLine mode) {
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
                  child: SelectingMultiplePump(index: index, mode: mode,),
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

enum AssigningParameterForLine {sourcePump, irrigationPump, agitator}

class SelectingMultiplePump extends StatefulWidget {
  final int index;
  final AssigningParameterForLine mode;
  const SelectingMultiplePump({super.key, required this.index, required this.mode});

  @override
  State<SelectingMultiplePump> createState() => _SelectingMultiplePumpState();
}

class _SelectingMultiplePumpState extends State<SelectingMultiplePump> {
  List<dynamic> objectList = [];
  @override
  void initState() {
    // TODO: implement initState
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: false);
    var list = widget.mode == AssigningParameterForLine.sourcePump
        ? configPvd.sourcePumpUpdated : widget.mode == AssigningParameterForLine.irrigationPump
        ? configPvd.irrigationPumpUpdated : configPvd.totalAgitator;
    for(var i = 0;i < list.length;i++){
      if(widget.mode == AssigningParameterForLine.agitator || list[i]['deleted'] != true){
        objectList.add({
          'name' : '${widget.mode == AssigningParameterForLine.sourcePump ? 'SP' : widget.mode == AssigningParameterForLine.irrigationPump ? 'IP' : 'AG'}${i+1}',
          'select' : configPvd.irrigationLines[widget.index][widget.mode == AssigningParameterForLine.sourcePump ? 'sourcePump' : widget.mode == AssigningParameterForLine.irrigationPump ? 'irrigationPump' : 'agitator'].contains('${i+1}') ? true : false,
        });
      }
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: true);
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: customBoxShadow
        ),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              onPressed: (){
                Navigator.pop(context);
              },
              color: Colors.red,
              child: const Text("Cancel",style: TextStyle(color: Colors.white),),
            ),
            MaterialButton(
              onPressed: (){
                var listOfObjectString = objectList.where((element) => element['select'] == true)
                    .map((element) => element['name'].split(widget.mode == AssigningParameterForLine.sourcePump
                    ? 'SP' : widget.mode == AssigningParameterForLine.irrigationPump
                    ? 'IP' : 'AG')[1]).join(',');
                  configPvd.irrigationLinesFunctionality(['editAssigningParameterForLine',widget.index,widget.mode,listOfObjectString]);
                Navigator.pop(context);
              },
              color: Theme.of(context).primaryColor,
              child: const Text("OK",style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        child: Column(
          children: [
            for(var object in objectList)
              ListTile(
                title: Text('${object['name']}',style: const TextStyle(fontSize: 12),),
                trailing: Checkbox(
                  value: object['select'],
                  onChanged: (value) {
                    setState(() {
                      object['select'] = !object['select'];
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class ldBatch extends StatefulWidget {
  final int index;
  final bool value;
  const ldBatch({super.key, required this.index, required this.value});

  @override
  State<ldBatch> createState() => _ldBatchState();
}

class _ldBatchState extends State<ldBatch> {
  int line = 1;
  String injector = '-';
  bool d_meter = false;
  bool d_meter_value = false;
  bool booster = false;
  bool booster_value = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: true);
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('No of injector per site : ',style: TextStyle(color: Colors.black,fontSize: 14)),
              DropdownButton(
                value: injector,
                underline: Container(),
                items: getList(configPvd).map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Container(
                        child: Text(items,style: const TextStyle(fontSize: 12),)
                    ),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    injector = newValue!;
                  });
                },
              )

            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: (){
                    Navigator.pop(context);
                    setState(() {
                      line = 0;
                      injector = '-';
                      d_meter = false;
                      d_meter_value = false;
                      booster = false;
                      booster_value = false;
                    });
                  },
                  child: const Text('Cancel',style: TextStyle(color: Colors.white),)
              ),
              ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: (){
                    if(injector != '-'){
                      configPvd.irrigationLinesFunctionality(['editLocalDosing',widget.index,widget.value,line,int.parse(injector),d_meter_value,booster_value]);
                    }
                    setState(() {
                      line = 0;
                      injector = '-';
                      d_meter = false;
                      d_meter_value = false;
                      booster = false;
                      booster_value = false;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Add',style: TextStyle(color: Colors.white))
              ),
            ],
          )
        ],
      ),
    );
  }
  List<String> getList(ConfigMakerProvider configPvd) {
    List<String> myList = ['-'];
    if(line != 0){
      for(var i = 0;i < 6;i++){
        if(line * (i+1) <= configPvd.totalInjector){
          myList.add('${i+1}');
        }
      }
    }
    return myList;
  }
  bool give_D_meter(ConfigMakerProvider configPvd){
    if(injector != '-'){
      if(configPvd.totalDosingMeter - (line * int.parse(injector))  < 0){
        setState(() {
          d_meter = false;
        });
      }else{
        setState(() {
          d_meter = true;
        });
      }
    }

    return d_meter;
  }
  bool give_booster(ConfigMakerProvider configPvd){
    if(injector != '-'){
      if(configPvd.totalBooster - (line * int.parse(injector))  < 0){
        setState(() {
          booster = false;
        });
      }else{
        setState(() {
          booster = true;
        });
      }
    }
    return booster;
  }
}
class ReOrderInIL extends StatefulWidget {
  final List<int> list;
  const ReOrderInIL({super.key, required this.list});

  @override
  State<ReOrderInIL> createState() => _ReOrderInILState();
}

class _ReOrderInILState extends State<ReOrderInIL> {

  late int oldIndex;
  late int newIndex;
  List<int> ilData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ilData = widget.list;
  }
  @override
  Widget build(BuildContext context) {
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: true);
    return AlertDialog(
      title: const Text('Re-Order Irrigation Line',style: TextStyle(color: Colors.black),),
      content: SizedBox(
        width: 250,
        height: 250,
        child: Center(
          child: ReorderableGridView.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            primary: true,
            children: [
              for(var i = 0;i < ilData.length;i++)
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  width: 50,
                  height: 50 ,
                  key: ValueKey('IL${ilData[i]}'),
                  child: GestureDetector(child: Center(child: Text('IL${ilData[i]}'))),
                )
            ],
            onReorder: (oldIND, newIND) {
              setState(() {
                oldIndex = oldIND;
                newIndex = newIND;
                var removeData = ilData[oldIND];
                ilData.removeAt(oldIND);
                ilData.insert(newIND, removeData);
              });
            },
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
              configPvd.irrigationLinesFunctionality(['reOrderIl',oldIndex,newIndex]);
              Navigator.pop(context);
            },
            child: const Text('Change')
        )
      ],
    );
  }
}

class IrrlineCmForMob extends StatefulWidget {
  const IrrlineCmForMob({super.key});

  @override
  State<IrrlineCmForMob> createState() => _IrrlineCmForMobState();
}

class _IrrlineCmForMobState extends State<IrrlineCmForMob> {
  var list = ['OUTPUT','INPUT'];
  String selectedItem = '';
  @override
  Widget build(BuildContext context) {
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: true);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              color: Colors.blueGrey.shade50,
              width: double.infinity,
              height: 40,
              child: Row(
                children: [
                  IconButton(
                      onPressed: (){

                      },
                      icon: const Icon(Icons.arrow_left)
                  ),
                  const SizedBox(
                      width: 300,
                      height: 40,
                      child: Center(child: Text('IRRIGATION PUMP 1'))
                  ),
                  IconButton(
                      onPressed: (){

                      },
                      icon: const Icon(Icons.arrow_right)
                  ),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 350,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('valve',style: TextStyle(fontSize: 16),),
                        const SizedBox(height: 10,),
                        for(var i = 0;i < 10;i++)
                          InkWell(
                            onTap: (){
                              setState(() {
                                selectedItem = 'V ${i+1}';
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: selectedItem == 'V ${i+1}' ? myTheme.primaryColor : Colors.blue.shade50
                              ),
                              child: Center(
                                child: Text('V ${i+1}',style: TextStyle(color: selectedItem == 'V ${i+1}' ? Colors.white : Colors.black),)
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                SizedBox(
                  width: 100,
                  height: 350,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('M.Valve',style: TextStyle(fontSize: 16),),
                        const SizedBox(height: 10,),
                        for(var i = 0;i < 10;i++)
                          InkWell(
                            onTap: (){
                              setState(() {
                                selectedItem = 'MV ${i+1}';
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: selectedItem == 'MV ${i+1}' ? myTheme.primaryColor : Colors.blue.shade50
                              ),
                              child: Center(
                                  child: Text('MV ${i+1}',style: TextStyle(color: selectedItem == 'MV ${i+1}' ? Colors.white : Colors.black),)
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 350,
              color: const Color(0xff707070),
              width: double.infinity,
              child: Column(
                children: [
                  const Text('INPUT AND OUTPUT CONNECTION',style: TextStyle(color: Colors.white,fontSize: 20),),
                  const SizedBox(height: 10,),
                  SizedBox(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(width: 50,),
                          Container(
                            width: 250,
                            color: Colors.yellow.shade50,
                            child: Column(
                              children: [
                                const Text('ORO RTU'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 250,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          for(var i = 0;i < 8;i++)
                                            Container(
                                              width: 30,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                                  color: Colors.black45
                                              ),
                                              child: Center(child: Text('R ${i+1}',style: const TextStyle(fontSize: 12,color: Colors.white),)),
                                            )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      height: 250,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 250,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                                color: Colors.blueGrey.shade50
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                for(var i in list[1].split(''))
                                                  Text(i)
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 50,
                                            height: 250,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                                color: Colors.blueGrey.shade100
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                for(var i in list[0].split(''))
                                                  Text(i)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 250,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          for(var i = 0;i < 8;i++)
                                            Container(
                                              width: 30,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                                  color: Colors.black45
                                              ),
                                              child: Center(child: Text('R ${i+1}',style: const TextStyle(fontSize: 12,color: Colors.white),)),
                                            )
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(
                                  width: 140,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: (){

                                          },
                                          icon: const Icon(Icons.arrow_left)
                                      ),
                                      const SizedBox(
                                          width: 55,
                                          height: 40,
                                          child: Center(child: Text('1'))
                                      ),
                                      IconButton(
                                          onPressed: (){

                                          },
                                          icon: const Icon(Icons.arrow_right)
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 50,),
                          Container(
                            width: 600,
                            color: Colors.yellow.shade100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('ORO SMART RTU'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 250,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              for(var i = 0;i < 8;i++)
                                                Container(
                                                  width: 30,
                                                  height: 20,
                                                  decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                                      color: Colors.black45
                                                  ),
                                                  child: Center(child: Text('R ${i+1}',style: const TextStyle(fontSize: 12,color: Colors.white),)),
                                                )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          height: 250,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 250,
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                                    color: Colors.blueGrey.shade50
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    for(var i in list[1].split(''))
                                                      Text(i)
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 50,
                                                height: 250,
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                                    color: Colors.blueGrey.shade100
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    for(var i in list[0].split(''))
                                                      Text(i)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 250,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              for(var i = 0;i < 8;i++)
                                                Container(
                                                  width: 30,
                                                  height: 20,
                                                  decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                                      color: Colors.black45
                                                  ),
                                                  child: Center(child: Text('R ${i+1}',style: const TextStyle(fontSize: 12,color: Colors.white),)),
                                                )
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                    const SizedBox(width: 50,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 250,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              for(var i = 0;i < 8;i++)
                                                Container(
                                                  width: 30,
                                                  height: 20,
                                                  decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                                      color: Colors.black45
                                                  ),
                                                  child: Center(child: Text('R ${i+1+8}',style: const TextStyle(fontSize: 12,color: Colors.white),)),
                                                )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          height: 250,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 250,
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                                    color: Colors.blueGrey.shade50
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    for(var i in list[1].split(''))
                                                      Text(i)
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 50,
                                                height: 250,
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                                    color: Colors.blueGrey.shade100
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    for(var i in list[0].split(''))
                                                      Text(i)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 250,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              for(var i = 0;i < 8;i++)
                                                Container(
                                                  width: 30,
                                                  height: 20,
                                                  decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                                      color: Colors.black45
                                                  ),
                                                  child: Center(child: Text('R ${i+1+8}',style: const TextStyle(fontSize: 12,color: Colors.white),)),
                                                )
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 140,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: (){

                                          },
                                          icon: const Icon(Icons.arrow_left)
                                      ),
                                      const SizedBox(
                                          width: 55,
                                          height: 40,
                                          child: Center(child: Text('1'))
                                      ),
                                      IconButton(
                                          onPressed: (){

                                          },
                                          icon: const Icon(Icons.arrow_right)
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 50,),
                          Container(
                            width: 250,
                            color: Colors.yellow.shade50,
                            child: Column(
                              children: [
                                const Text('ORO RTU PLUS'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 250,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          for(var i = 0;i < 8;i++)
                                            Container(
                                              width: 30,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                                  color: Colors.black45
                                              ),
                                              child: Center(child: Text('R ${i+1}',style: const TextStyle(fontSize: 12,color: Colors.white),)),
                                            )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      height: 250,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 250,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                                color: Colors.blueGrey.shade50
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                for(var i in list[1].split(''))
                                                  Text(i)
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 50,
                                            height: 250,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                                color: Colors.blueGrey.shade100
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                for(var i in list[0].split(''))
                                                  Text(i)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 250,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          for(var i = 0;i < 8;i++)
                                            Container(
                                              width: 30,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                                  color: Colors.black45
                                              ),
                                              child: Center(child: Text('R ${i+1}',style: const TextStyle(fontSize: 12,color: Colors.white),)),
                                            )
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(
                                  width: 140,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: (){

                                          },
                                          icon: const Icon(Icons.arrow_left)
                                      ),
                                      const SizedBox(
                                          width: 55,
                                          height: 40,
                                          child: Center(child: Text('1'))
                                      ),
                                      IconButton(
                                          onPressed: (){

                                          },
                                          icon: const Icon(Icons.arrow_right)
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 50,),
                          Container(
                            width: 250,
                            color: Colors.yellow.shade100,
                            child: Column(
                              children: [
                                const Text('ORO LEVEL'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 250,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          for(var i = 0;i < 4;i++)
                                            Container(
                                              width: 30,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                                  color: Colors.black45
                                              ),
                                              child: Center(child: Text('R ${i+1}',style: const TextStyle(fontSize: 12,color: Colors.white),)),
                                            )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      height: 250,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 250,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                                color: Colors.blueGrey.shade50
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                for(var i in list[1].split(''))
                                                  Text(i)
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 50,
                                            height: 250,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                                color: Colors.blueGrey.shade100
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                for(var i in list[0].split(''))
                                                  Text(i)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 250,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          for(var i = 0;i < 4;i++)
                                            Container(
                                              width: 30,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                                  color: Colors.black45
                                              ),
                                              child: Center(child: Text('R ${i+1}',style: const TextStyle(fontSize: 12,color: Colors.white),)),
                                            )
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(
                                  width: 140,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: (){

                                          },
                                          icon: const Icon(Icons.arrow_left)
                                      ),
                                      const SizedBox(
                                          width: 55,
                                          height: 40,
                                          child: Center(child: Text('1'))
                                      ),
                                      IconButton(
                                          onPressed: (){

                                          },
                                          icon: const Icon(Icons.arrow_right)
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 50,),
                          Container(
                            width: 250,
                            color: Colors.yellow.shade100,
                            child: Column(
                              children: [
                                const Text('ORO SENSE'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 250,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          for(var i = 0;i < 4;i++)
                                            Container(
                                              width: 30,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                                  color: Colors.black45
                                              ),
                                              child: Center(child: Text('R ${i+1}',style: const TextStyle(fontSize: 12,color: Colors.white),)),
                                            )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      height: 250,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 250,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                                color: Colors.blueGrey.shade50
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                for(var i in list[1].split(''))
                                                  Text(i)
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 50,
                                            height: 250,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                                color: Colors.blueGrey.shade100
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                for(var i in list[0].split(''))
                                                  Text(i)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 250,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          for(var i = 0;i < 4;i++)
                                            Container(
                                              width: 30,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                                  color: Colors.black45
                                              ),
                                              child: Center(child: Text('R ${i+1}',style: const TextStyle(fontSize: 12,color: Colors.white),)),
                                            )
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(
                                  width: 140,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: (){

                                          },
                                          icon: const Icon(Icons.arrow_left)
                                      ),
                                      const SizedBox(
                                          width: 55,
                                          height: 40,
                                          child: Center(child: Text('1'))
                                      ),
                                      IconButton(
                                          onPressed: (){

                                          },
                                          icon: const Icon(Icons.arrow_right)
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),



                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Vent
// Screen
// Heating
// Misting
// Fan and pad
// Air Circulation
// CO2
// Crop Protection
// Light