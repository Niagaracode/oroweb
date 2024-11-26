import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/screens/Config/config_maker/source_pump.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../../constants/theme.dart';
import '../../../state_management/config_maker_provider.dart';
import '../../../widgets/text_form_field_config.dart';


class CentralFiltrationTable extends StatefulWidget {
  const CentralFiltrationTable({super.key});

  @override
  State<CentralFiltrationTable> createState() => _CentralFiltrationTableState();
}

class _CentralFiltrationTableState extends State<CentralFiltrationTable> {
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
        color: const Color(0xFFF3F3F3),
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            configButtons(
              selectFunction: (value){
                setState(() {
                  configPvd.centralFiltrationFunctionality(['centralFiltrationSelection',value]);
                });
              },
              selectAllFunction: (value){
                setState(() {
                  configPvd.centralFiltrationFunctionality(['centralFiltrationSelectAll',value]);
                });
              },
              cancelButtonFunction: (){
                configPvd.centralFiltrationFunctionality(['centralFiltrationSelection',false]);
                configPvd.centralFiltrationFunctionality(['centralFiltrationSelectAll',false]);
                configPvd.cancelSelection();
              },
              addBatchButtonFunction: (){
                showDialog(context: context, builder: (BuildContext context){
                  return Consumer<ConfigMakerProvider>(builder: (context,configPvd,child){
                    if(configPvd.totalCentralFiltration == 0){
                      return showingMessage('Oops!', 'The filtration site limit is achieved!..', context);
                    }else if(configPvd.totalFilter == 0){
                      return showingMessage('Oops!', 'The filter limit is achieved!..', context);
                    }else{
                      return AlertDialog(
                        backgroundColor: myTheme.primaryColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0))
                        ),
                        title: const Text('Add Batch of Filtration Sites',style: TextStyle(color: Colors.white,fontSize: 14),),
                        content: SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text('No of Filtration sites',style: TextStyle(color: Colors.indigo.shade50,fontSize: 14),),
                                  trailing: DropdownButton(
                                      value: configPvd.cfSite,
                                      icon: const Icon(Icons.arrow_drop_down,color: Colors.white,),
                                      dropdownColor: Colors.black87,
                                      // focusColor: Colors.white,
                                      underline: Container(),
                                      items: dropDownList(configPvd.totalCentralFiltration).map((String items) {
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
                                        configPvd.editCfSite(value!);
                                        configPvd.editFilter('1');
                                      }),
                                ),
                                ListTile(
                                  title: Text('no of filter per site',style: TextStyle(color: Colors.indigo.shade50,fontSize: 14),),
                                  trailing: int.parse(configPvd.cfSite) > configPvd.totalFilter ?  const Text('N/A',style: TextStyle(color: Colors.white),) : DropdownButton(
                                      value: configPvd.filter,
                                      icon: const Icon(Icons.arrow_drop_down,color: Colors.white,),
                                      dropdownColor: Colors.black87,
                                      // focusColor: Colors.white,
                                      underline: Container(),
                                      items: dropDownList(configPvd.totalFilter ~/ int.parse(configPvd.cfSite)).map((String items) {
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
                                        configPvd.editFilter(value!);
                                      }),
                                ),
                              ],
                            )
                        ),
                        actions: [
                          InkWell(
                              onTap: (){
                                configPvd.editCfSite('1');
                                configPvd.editFilter('1');
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
                              configPvd.centralFiltrationFunctionality(['addBatch_CF',int.parse(configPvd.cfSite),configPvd.totalFilter == 0 ? 0 : int.parse(configPvd.filter)]);
                              configPvd.editCfSite('1');
                              configPvd.editFilter('1');
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
              reOrderFunction: (){
                List<int> list1 = [];
                for(var i = 0;i < configPvd.centralFiltrationUpdated.length;i++){
                  list1.add(i+1);
                }
                showDialog(context: context, builder: (BuildContext context){
                  return ReOrderInCfSite(list: list1);
                });
              },
              addButtonFunction: (){
                if(configPvd.totalCentralFiltration == 0){
                  showDialog(
                      context: context,
                      builder: (context){
                        return showingMessage('Oops!', 'The filtration site limit is achieved!..', context);
                      }
                  );
                }else if(configPvd.totalFilter == 0){
                  showDialog(
                      context: context,
                      builder: (context){
                        return showingMessage('Oops!', 'The filter limit is achieved!..', context);
                      }
                  );
                }else{
                  configPvd.centralFiltrationFunctionality(['addCentralFiltration']);
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500), // Adjust the duration as needed
                    curve: Curves.easeInOut, // Adjust the curve as needed
                  );
                }
              },
              deleteButtonFunction: (){
                configPvd.centralFiltrationFunctionality(['centralFiltrationSelection',false]);
                configPvd.centralFiltrationFunctionality(['deleteCentralFiltration']);
                configPvd.cancelSelection();
              },
              selectionCount: configPvd.selection,
              singleSelection: configPvd.centralFiltrationSelection,
              multipleSelection: configPvd.centralFiltrationSelectAll,
            ),
            Container(
              child: Row(
                children: [
                  topBtmLftRgt('Site', '(${configPvd.totalCentralFiltration})'),
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
                  controller: scrollController,
                  itemCount: configPvd.centralFiltrationUpdated.length,
                  itemBuilder: (BuildContext context, int index){
                    return Visibility(
                      visible: configPvd.centralFiltrationUpdated[index]['deleted'] == true ? false : true,
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1)),
                          color: Colors.white70,
                        ),
                        margin: index == configPvd.centralFiltrationUpdated.length - 1 ? const EdgeInsets.only(bottom: 60) : null,
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
                                      if(configPvd.centralFiltrationSelection == true || configPvd.centralFiltrationSelectAll == true)
                                        Checkbox(
                                            value: configPvd.centralFiltrationUpdated[index]['selection'] == 'select' ? true : false,
                                            onChanged: (value){
                                              configPvd.centralFiltrationFunctionality(['selectCentralFiltration',index,value]);
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
                                  child: Center(
                                    child: TextFieldForConfig(index: index, initialValue: configPvd.centralFiltrationUpdated[index]['filter'], config: configPvd, purpose: 'centralFiltrationFunctionality',),
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
                                child: (configPvd.total_D_s_valve == 0 && configPvd.centralFiltrationUpdated[index]['dv'].isEmpty) ?
                                notAvailable :
                                Checkbox(
                                    value: configPvd.centralFiltrationUpdated[index]['dv'].isEmpty ? false : true,
                                    onChanged: (value){
                                      configPvd.centralFiltrationFunctionality(['editDownStreamValve',index,value]);
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
                                child: (configPvd.total_p_sensor == 0 && configPvd.centralFiltrationUpdated[index]['pressureIn'].isEmpty) ?
                                notAvailable :
                                Checkbox(
                                    value: configPvd.centralFiltrationUpdated[index]['pressureIn'].isEmpty ? false : true,
                                    onChanged: (value){
                                      configPvd.centralFiltrationFunctionality(['editPressureSensor',index,value]);
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
                                child: (configPvd.total_p_sensor == 0 && configPvd.centralFiltrationUpdated[index]['pressureOut'].isEmpty) ?
                                notAvailable :
                                Checkbox(
                                    value: configPvd.centralFiltrationUpdated[index]['pressureOut'].isEmpty ? false : true,
                                    onChanged: (value){
                                      configPvd.centralFiltrationFunctionality(['editPressureSensor_out',index,value]);
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
                                child: (configPvd.totalPressureSwitch == 0 && configPvd.centralFiltrationUpdated[index]['pressureSwitch'].isEmpty) ?
                                notAvailable :
                                Checkbox(
                                    value: configPvd.centralFiltrationUpdated[index]['pressureSwitch'].isEmpty ? false : true,
                                    onChanged: (value){
                                      configPvd.centralFiltrationFunctionality(['editPressureSwitch',index,value]);
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
                                child: (configPvd.totalDiffPressureSensor == 0 && configPvd.centralFiltrationUpdated[index]['diffPressureSensor'].isEmpty) ?
                                notAvailable :
                                Checkbox(
                                    value: configPvd.centralFiltrationUpdated[index]['diffPressureSensor'].isEmpty ? false : true,
                                    onChanged: (value){
                                      configPvd.centralFiltrationFunctionality(['editDiffPressureSensor',index,value]);
                                    }),
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
}

class ReOrderInCfSite extends StatefulWidget {
  final List<int> list;
  const ReOrderInCfSite({super.key, required this.list});

  @override
  State<ReOrderInCfSite> createState() => _ReOrderInCfSiteState();
}

class _ReOrderInCfSiteState extends State<ReOrderInCfSite> {

  late int oldIndex;
  late int newIndex;
  List<int> cfData = [];
  @override
  Widget buildItem(String text) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(5)
      ),
      width: 50,
      height: 50 ,
      key: ValueKey('CF$text'),
      child: Center(child: Text('CF$text')),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cfData = widget.list;
  }
  @override
  Widget build(BuildContext context) {
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: true);
    return AlertDialog(
      title: const Text('Re-Order Central Filtration Site',style: TextStyle(color: Colors.black),),
      content: SizedBox(
        width: 250,
        height: 250,
        child: Center(
          child: ReorderableGridView.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            children: cfData.map((e) => buildItem("$e")).toList(),
            onReorder: (oldIND, newIND) {
              setState(() {
                oldIndex = oldIND;
                newIndex = newIND;
                var removeData = cfData[oldIND];
                cfData.removeAt(oldIND);
                cfData.insert(newIND, removeData);
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
              configPvd.centralFiltrationFunctionality(['reOrderCfSite',oldIndex,newIndex]);
              Navigator.pop(context);
            },
            child: const Text('Change')
        )
      ],
    );
  }
}
