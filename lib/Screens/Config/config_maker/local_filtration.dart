import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/screens/Config/config_maker/source_pump.dart';
import 'package:provider/provider.dart';

import '../../../state_management/config_maker_provider.dart';
import '../../../widgets/text_form_field_config.dart';


class LocalFiltrationTable extends StatefulWidget {
  const LocalFiltrationTable({super.key});

  @override
  State<LocalFiltrationTable> createState() => LocalFiltrationTableState();
}

class LocalFiltrationTableState extends State<LocalFiltrationTable> {

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
                  configPvd.localFiltrationFunctionality(['edit_l_filtrationSelection',value]);
                });
              },
              selectAllFunction: (value){
                setState(() {
                  configPvd.localFiltrationFunctionality(['edit_l_filtrationSelectALL',value]);
                });
              },
              cancelButtonFunction: (){
                configPvd.localFiltrationFunctionality(['edit_l_filtrationSelection',false]);
                configPvd.localFiltrationFunctionality(['edit_l_filtrationSelectALL',false]);
                configPvd.cancelSelection();
              },
              addBatchButtonFunction: (){

              },
              addButtonFunction: (){
              },
              deleteButtonFunction: (){
                configPvd.localFiltrationFunctionality(['edit_l_filtrationSelection',false]);
                configPvd.localFiltrationFunctionality(['deleteLocalFiltration']);
                configPvd.cancelSelection();
              },
              selectionCount: configPvd.selection,
              singleSelection: configPvd.l_filtrationSelection,
              multipleSelection: configPvd.l_filtrationSelectALL,
            ),
            Container(
              child: Row(
                children: [
                  topBtmLftRgt('Line', ''),
                  topBtmRgt('Filters','(${configPvd.totalFilter})'),
                  topBtmRgt('D.stream','Valve(${configPvd.total_D_s_valve})'),
                  topBtmRgt('P.Sense','in(${configPvd.total_p_sensor})'),
                  topBtmRgt('P.Sense','out(${configPvd.total_p_sensor})'),
                  topBtmRgt('Pressure','Switch(${configPvd.totalPressureSwitch})'),
                  topBtmRgt('D.Press','Sensor(${configPvd.totalDiffPressureSensor})'),

                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: configPvd.localFiltrationUpdated.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1)),
                        color: Colors.white70,
                      ),
                      margin: index == configPvd.localFiltrationUpdated.length - 1 ? const EdgeInsets.only(bottom: 60) : null,
                      width: width-20,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(left: BorderSide(width: 1),right: BorderSide(width: 1))
                              ),
                              height: 50,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if(configPvd.l_filtrationSelection == true || configPvd.l_filtrationSelectALL == true)
                                      Checkbox(
                                          value: configPvd.localFiltrationUpdated[index]['selection'] == 'select' ? true : false,
                                          onChanged: (value){
                                            configPvd.localFiltrationFunctionality(['selectLocalFiltration',index,value]);
                                          }),
                                    Text('${configPvd.localFiltrationUpdated[index]['line']}'),
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
                                child: Center(
                                  child: TextFieldForConfig(index: index, initialValue: configPvd.localFiltrationUpdated[index]['filter'], config: configPvd, purpose: 'localFiltrationFunctionality',),
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(right: BorderSide(width: 1))
                              ),
                              width: double.infinity,
                              height: 50,
                              child: (configPvd.total_D_s_valve == 0 && configPvd.localFiltrationUpdated[index]['dv'].isEmpty) ?
                              notAvailable :
                              Checkbox(
                                  value: configPvd.localFiltrationUpdated[index]['dv'].isEmpty ? false : true,
                                  onChanged: (value){
                                    configPvd.localFiltrationFunctionality(['editDownStreamValve',index,value]);
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
                              child: (configPvd.total_p_sensor == 0 && configPvd.localFiltrationUpdated[index]['pressureIn'].isEmpty) ?
                              notAvailable :
                              Checkbox(
                                  value: configPvd.localFiltrationUpdated[index]['pressureIn'].isEmpty ? false : true,
                                  onChanged: (value){
                                    configPvd.localFiltrationFunctionality(['editPressureSensor',index,value]);
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
                              child: (configPvd.total_p_sensor == 0 && configPvd.localFiltrationUpdated[index]['pressureOut'].isEmpty) ?
                              notAvailable :
                              Checkbox(
                                  value: configPvd.localFiltrationUpdated[index]['pressureOut'].isEmpty ? false : true,
                                  onChanged: (value){
                                    configPvd.localFiltrationFunctionality(['editPressureSensor_out',index,value]);
                                  }),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(right: BorderSide(width: 1)),
                              ),
                              width: double.infinity,
                              height: 50 ,
                              child: (configPvd.totalPressureSwitch == 0 && configPvd.localFiltrationUpdated[index]['pressureSwitch'].isEmpty) ?
                              notAvailable :
                              Checkbox(
                                  value: configPvd.localFiltrationUpdated[index]['pressureSwitch'].isEmpty ? false : true,
                                  onChanged: (value){
                                    configPvd.localFiltrationFunctionality(['editPressureSwitch',index,value]);
                                  }),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(right: BorderSide(width: 1)),
                              ),
                              width: double.infinity,
                              height: 50 ,
                              child: (configPvd.totalDiffPressureSensor == 0 && configPvd.localFiltrationUpdated[index]['diffPressureSensor'].isEmpty) ?
                              notAvailable :
                              Checkbox(
                                  value: configPvd.localFiltrationUpdated[index]['diffPressureSensor'].isEmpty ? false : true,
                                  onChanged: (value){
                                    configPvd.localFiltrationFunctionality(['editDiffPressureSensor',index,value]);
                                  }),
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
}
