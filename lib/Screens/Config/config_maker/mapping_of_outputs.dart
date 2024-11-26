import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/screens/Config/config_maker/source_pump.dart';
import 'package:provider/provider.dart';

import '../../../constants/theme.dart';
import '../../../state_management/config_maker_provider.dart';
import '../../../widgets/drop_down_button.dart';



class MappingOfOutputsTable extends StatefulWidget {
  final ConfigMakerProvider configPvd;
  const MappingOfOutputsTable({super.key,required this.configPvd});

  @override
  State<MappingOfOutputsTable> createState() => _MappingOfOutputsTableState();
}

class _MappingOfOutputsTableState extends State<MappingOfOutputsTable> {
  bool odd = false;
  String nodeName = '-';
  String nodeReferenceNumber = '-';
  String newValue = '-';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<String> getItems(String name,ConfigMakerProvider configPvd){
    var list = ['-'];
    if(name == 'ORO Smart'){
      list.addAll(configPvd.oSrtu.map((element) => element.toString()).toList());
    }else if(name == 'O-Smart-Plus'){
      list.addAll(configPvd.oSrtuPlus.map((element) => element.toString()).toList());
    }else if(name == 'ORO RTU'){
      list.addAll(configPvd.oRtu.map((element) => element.toString()).toList());
    }else if(name == 'O-RTU-Plus'){
      list.addAll(configPvd.oRtuPlus.map((element) => element.toString()).toList());
    }else if(name == 'ORO Pump'){
      list.addAll(configPvd.oPump.map((element) => element.toString()).toList());
    }else if(name == 'O-Pump-Plus'){
      list.addAll(configPvd.oPumpPlus.map((element) => element.toString()).toList());
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: true);
    return LayoutBuilder(builder: (context,constrainst){
      var width = constrainst.maxWidth;
      return Container(
        color: const Color(0xFFF3F3F3),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 400,
                  child: ListTile(
                    title: const Text('Node Category',style: TextStyle(fontWeight: FontWeight.bold),),
                    trailing: DropdownButton(
                      value: nodeName,
                      items: [
                        for(var i in ['-', 'ORO Smart', 'O-Smart-Plus', 'ORO RTU', 'O-RTU-Plus', 'ORO Pump', 'O-Pump-Plus'])
                          DropdownMenuItem(
                            value: i,
                              child: Text(i)
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          if(nodeName != value){
                            nodeReferenceNumber = '-';
                          }
                          nodeName = value!;
                        });
                      },),
                  ),
                ),
                SizedBox(
                  width: 400,
                  child: ListTile(
                    title: const Text('Reference Number',style: TextStyle(fontWeight: FontWeight.bold),),
                    trailing: DropdownButton(
                      value: nodeReferenceNumber,
                      items: [
                        for(var i in getItems(nodeName,configPvd))
                          DropdownMenuItem(
                            value: i,
                              child: Text(i)
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          nodeReferenceNumber = value!;
                        });
                      },),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          border: const Border(
                            top: BorderSide(width: 1),
                            bottom: BorderSide(width: 1),
                            right: BorderSide(width: 1),
                            left: BorderSide(width: 1),
                          )
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Obj',),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          border: const Border(
                            top: BorderSide(width: 1),
                            bottom: BorderSide(width: 1),
                            right: BorderSide(width: 1),
                          )
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('RTU',),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          border: const Border(
                            top: BorderSide(width: 1),
                            bottom: BorderSide(width: 1),
                            right: BorderSide(width: 1),
                          )
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Ref.no',),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          border: const Border(
                            top: BorderSide(width: 1),
                            bottom: BorderSide(width: 1),
                            right: BorderSide(width: 1),
                          )
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('O/P',),
                          Text('relays',),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        border: const Border(
                          top: BorderSide(width: 1),
                          bottom: BorderSide(width: 1),
                          right: BorderSide(width: 1),
                        )
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.more_vert)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 5,right: 5),
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: getIrrigationLine(irrigationLine(configPvd),configPvd),
                      ),
                      Column(
                        children: getCentralDosing(centralDosing(configPvd),configPvd),
                      ),
                      Column(
                        children: getCentralFiltration(centralFiltration(configPvd),configPvd),
                      ),
                      Column(
                        children: getSourcePump(sourcePump(configPvd),configPvd),
                      ),
                      Column(
                        children: getIrrigationPump(irrigationPump(configPvd),configPvd),
                      ),
                      Column(
                        children: getAgitator(agitator(configPvd),configPvd),
                      ),
                      Column(
                        children: getSelector(selector(configPvd),configPvd),
                      ),
                      const SizedBox(height: 150,),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });

  }

  void myDialog(title){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text(title,style: const TextStyle(color: Colors.red,fontSize: 15,fontWeight: FontWeight.w900),),
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

  List<Widget> getIrrigationLine(List<Map<String,dynamic>> myList,ConfigMakerProvider configPvd){
    List<Widget> widgetList = [];
    for(var i = 0;i < myList.length;i++){
      if(!myList[i]['map'][0]['deleted']){
        widgetList.add(
            SizedBox(
              width: double.infinity,
              height: 40,
              child: Center(
                child: Text('${myList[i]['name']}',style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
              ),
            )
        );
        for(var j = 0;j < myList[i]['map'].length;j++){
          widgetList.add(
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  border: const Border(bottom: BorderSide(width: 1)),
                  color: j % 2 == 0 ? Colors.white : Colors.white70,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(left: const BorderSide(width: 1),right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                          ),
                          height: 40,
                          child: Center(child: Text('${myList[i]['map'][j]['name']} ${myList[i]['map'][j]['count'] == -1 ? 1 : myList[i]['map'][j]['count'] + 1}')),
                        )
                    ),
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                          ),
                          height: 40,
                          child: Center(
                              child: MyDropDown(initialValue: '${myList[i]['map'][j]['rtu']}', itemList: getRtuName(configPvd,myList[i]['map'][j]['connection']), pvdName: '${myList[i]['map'][j]['type']}/${myList[i]['map'][j]['index']}/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rtu', index: -1)
                          ),
                        )
                    ),
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                          ),
                          height: 40,
                          child: Center(
                            child: MyDropDown(initialValue: '${myList[i]['map'][j]['rfNo']}', split: true,itemList: getrefNoForOthers(configPvd,'${myList[i]['map'][j]['rtu']}'), pvdName: '${myList[i]['map'][j]['type']}/${myList[i]['map'][j]['index']}/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rfNo', index: -1),
                          ),
                        )
                    ),
                    Expanded(
                        child: InkWell(
                          onTap: (){
                            showDialog(context: context, builder: (context){
                              return StatefulBuilder(builder: (context,stateSetter){
                                return AlertDialog(
                                  title: Text('ORO SMART'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Wrap(
                                        children: [
                                          for(var r in getOutPut(configPvd,nodeName,nodeReferenceNumber,'${myList[i]['map'][j]['output']}',myList[i]['map'][j]['count']))
                                            InkWell(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color:  newValue == r ? Colors.green : Colors.grey
                                                ),
                                                padding: EdgeInsets.all(8),
                                                child: Text(r,style: TextStyle(color: Colors.white),),
                                              ),
                                              onTap: (){
                                                stateSetter((){
                                                  setState(() {
                                                    newValue = r;
                                                  });
                                                });
                                              },
                                            )
                                        ],
                                        spacing: 10,
                                        runSpacing: 10,
                                      )
                                    ],
                                  ),
                                  actions: [
                                    MaterialButton(
                                        onPressed: (){
                                          var path = '${myList[i]['map'][j]['type']}/${myList[i]['map'][j]['index']}/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}';
                                          stateSetter((){
                                            setState(() {
                                              for(var i = 0;i < 3;i++){
                                                editParameter(
                                                    index: -1,
                                                    pvdName: '$path/${i == 0 ? 'rtu' : i == 1 ? 'rfNo' : 'output'}',
                                                    configPvd: configPvd,
                                                    newValue: i == 0 ? nodeName : i == 1 ? nodeReferenceNumber : newValue
                                                );
                                              }
                                              newValue = '-';
                                            });
                                          });
                                          Navigator.pop(context);

                                        },
                                      child: Text('Ok'),
                                    )
                                  ],
                                );
                              });
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                            ),
                            height: 40,
                            child: Center(
                              child: MyDropDown(initialValue: '${myList[i]['map'][j]['output']}', itemList: getOutPut(configPvd,'${myList[i]['map'][j]['rtu']}','${myList[i]['map'][j]['rfNo']}','${myList[i]['map'][j]['output']}',myList[i]['map'][j]['count']), pvdName: '${myList[i]['map'][j]['type']}/${myList[i]['map'][j]['index']}/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/output', index: -1),
                            ),
                          ),
                        )
                    ),
                    if(['injector','boosterConnection','valveConnection','main_valveConnection','foggerConnection','fanConnection','filterConnection'].contains(myList[i]['map'][j]['connection']))
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            border: Border(
                              top:  BorderSide(width: j == 0 ? 1 : 0),
                              right: const BorderSide(width: 1),
                            )
                        ),
                        child: IconButton(
                            onPressed: (){
                              for(var ld in configPvd.localDosingUpdated){
                                if(ld['sNo'] == configPvd.irrigationLines[i]['sNo']){
                                  if(ld['injector'].length == 1){
                                    myDialog('Irrigation Line contains atleast single injector');
                                  }
                                }
                              }
                              for(var lf in configPvd.localFiltrationUpdated){
                                if(lf['sNo'] == configPvd.irrigationLines[i]['sNo']){
                                  if(lf['filterConnection'].length == 1){
                                    myDialog('Irrigation Line contains atleast single filter');
                                  }
                                }
                              }
                              if(configPvd.irrigationLines[i]['valveConnection'].length == 1){
                                myDialog('Irrigation Line contains atleast single valve');
                              }else{
                                configPvd.irrigationLinesFunctionality(['deleteFromMapio',i,myList[i]['map'][j]['connection'],myList[i]['map'][j]['sNo']]);
                              }
                            },
                            icon: const Icon(Icons.delete)
                        ),
                      )
                    else
                      Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              border: Border(
                                top:  BorderSide(width: j == 0 ? 1 : 0),
                                right: const BorderSide(width: 1),
                              )
                          ),
                          child: notAvailable
                      )
                  ],
                ),
              )
          );
        }
      }
    }
    return widgetList;
  }
  List<Widget> getCentralDosing(List<Map<String,dynamic>> myList,ConfigMakerProvider configPvd){
    List<Widget> widgetList = [];
    for(var i = 0;i < myList.length;i++){
      if(!myList[i]['map'][0]['deleted']){
        widgetList.add(
            SizedBox(
              width: double.infinity,
              height: 40,
              child: Center(
                child: Text('${myList[i]['name']}',style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
              ),
            )
        );
        for(var j = 0;j < myList[i]['map'].length;j++){
          widgetList.add(
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  border: const Border(bottom: BorderSide(width: 1)),
                  color: j % 2 == 0 ? Colors.yellow.shade50 : Colors.yellow.shade100,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(left: const BorderSide(width: 1),right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                          ),
                          height: 40,
                          child: Center(child: Text('${myList[i]['map'][j]['name']} ${myList[i]['map'][j]['count'] == -1 ? 1 : myList[i]['map'][j]['count'] + 1}')),
                        )
                    ),
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                          ),
                          height: 40,
                          child: Center(
                              child: MyDropDown(initialValue: '${myList[i]['map'][j]['rtu']}', itemList: getRtuName(configPvd,myList[i]['map'][j]['connection']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rtu', index: -1)
                          ),
                        )
                    ),
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                          ),
                          height: 40,
                          child: Center(
                            child: MyDropDown(initialValue: '${myList[i]['map'][j]['rfNo']}', split: true,itemList: getrefNoForOthers(configPvd,'${myList[i]['map'][j]['rtu']}'), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rfNo', index: -1),
                          ),
                        )
                    ),
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                          ),
                          height: 40,
                          child: Center(
                            child: MyDropDown(initialValue: '${myList[i]['map'][j]['output']}', itemList: getOutPut(configPvd,'${myList[i]['map'][j]['rtu']}','${myList[i]['map'][j]['rfNo']}','${myList[i]['map'][j]['output']}',myList[i]['map'][j]['count']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/output', index: -1),
                          ),
                        )
                    ),
                    if(['injector','boosterConnection'].contains(myList[i]['map'][j]['connection']))
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            border: Border(
                              top:  BorderSide(width: j == 0 ? 1 : 0),
                              right: const BorderSide(width: 1),
                            )
                        ),
                        child: IconButton(
                            onPressed: (){
                              if(configPvd.centralDosingUpdated[i]['injector'].length == 1){
                                myDialog('Central dosing site contains atleast single injector');
                              }else{
                                configPvd.centralDosingFunctionality(['deleteFromMapio',i,myList[i]['map'][j]['connection'],myList[i]['map'][j]['sNo']]);
                              }
                            },
                            icon: const Icon(Icons.delete)
                        ),
                      )
                    else
                      Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              border: Border(
                                top:  BorderSide(width: j == 0 ? 1 : 0),
                                right: const BorderSide(width: 1),
                              )
                          ),
                          child: notAvailable
                      )
                  ],
                ),
              )
          );
        }
      }

    }
    return widgetList;
  }
  List<Widget> getCentralFiltration(List<Map<String,dynamic>> myList,ConfigMakerProvider configPvd){
    List<Widget> widgetList = [];
    for(var i = 0;i < myList.length;i++){
      if(!myList[i]['map'][0]['deleted']){
        widgetList.add(
            SizedBox(
              width: double.infinity,
              height: 40,
              child: Center(
                child: Text('${myList[i]['name']}',style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
              ),
            )
        );
        for(var j = 0;j < myList[i]['map'].length;j++){
          widgetList.add(
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  border: const Border(bottom: BorderSide(width: 1)),
                  color: j % 2 == 0 ? Colors.green.shade50 : Colors.green.shade100,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(left: const BorderSide(width: 1),right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                          ),
                          height: 40,
                          child: Center(child: Text('${myList[i]['map'][j]['name']} ${myList[i]['map'][j]['count'] == -1 ? 1 : myList[i]['map'][j]['count'] + 1}')),
                        )
                    ),
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                          ),
                          height: 40,
                          child: Center(
                              child: MyDropDown(initialValue: '${myList[i]['map'][j]['rtu']}', itemList: getRtuName(configPvd,myList[i]['map'][j]['connection']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rtu', index: -1)
                          ),
                        )
                    ),
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                          ),
                          height: 40,
                          child: Center(
                            child: MyDropDown(initialValue: '${myList[i]['map'][j]['rfNo']}', split: true,itemList: getrefNoForOthers(configPvd,'${myList[i]['map'][j]['rtu']}'), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rfNo', index: -1),
                          ),
                        )
                    ),
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                          ),
                          height: 40,
                          child: Center(
                            child: MyDropDown(initialValue: '${myList[i]['map'][j]['output']}', itemList: getOutPut(configPvd,'${myList[i]['map'][j]['rtu']}','${myList[i]['map'][j]['rfNo']}','${myList[i]['map'][j]['output']}',myList[i]['map'][j]['count']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/output', index: -1),
                          ),
                        )
                    ),
                    if(['filterConnection'].contains(myList[i]['map'][j]['connection']))
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            border: Border(
                              top:  BorderSide(width: j == 0 ? 1 : 0),
                              right: const BorderSide(width: 1),
                            )
                        ),
                        child: IconButton(
                            onPressed: (){
                              if(configPvd.centralFiltrationUpdated[i]['filterConnection'].length == 1){
                                myDialog('Central Filtration site contains atleast single filter');
                              }
                              configPvd.centralFiltrationFunctionality(['deleteFromMapio',i,myList[i]['map'][j]['connection'],myList[i]['map'][j]['sNo']]);
                            },
                            icon: const Icon(Icons.delete)
                        ),
                      )
                    else
                      Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              border: Border(
                                top:  BorderSide(width: j == 0 ? 1 : 0),
                                right: const BorderSide(width: 1),
                              )
                          ),
                          child: notAvailable
                      )
                  ],
                ),
              )
          );
        }
      }

    }
    return widgetList;
  }
  List<Widget> getSourcePump(List<Map<String,dynamic>> myList,ConfigMakerProvider configPvd){
    List<Widget> widgetList = [];
    for(var i = 0;i < myList.length;i++){
      if(!myList[i]['map'][0]['deleted']){
        widgetList.add(
            SizedBox(
              width: double.infinity,
              height: 40,
              child: Center(
                child: Text('${myList[i]['name']}',style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
              ),
            )
        );
        for(var j = 0;j < myList[i]['map'].length;j++){
          widgetList.add(
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  border: const Border(bottom: BorderSide(width: 1)),
                  color: j % 2 == 0 ? Colors.lightGreen.shade50 : Colors.lightGreen.shade100,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(left: const BorderSide(width: 1),right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                          ),
                          height: 40,
                          child: Center(child: Text('${myList[i]['map'][j]['name']} ${myList[i]['map'][j]['count'] == -1 ? '' : myList[i]['map'][j]['count'] + 1}')),
                        )
                    ),
                    if(myList[i]['map'][j]['oroPump'] == true)
                      Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                            ),
                            height: 40,
                            child: Center(
                              child: Text('${myList[i]['map'][j]['rtu']}',style: const TextStyle(fontSize: 11),),
                            ),
                          )
                      )
                    else
                      Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                            ),
                            height: 40,
                            child: Center(
                              child: Text('${myList[i]['map'][j]['rtu']}'),
                            ),
                          )
                      ),
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                          ),
                          height: 40,
                          child: Center(
                            child: Text('${myList[i]['map'][j]['rfNo']}'),
                          ),
                        )
                    ),
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                          ),
                          height: 40,
                          child: Center(
                            child: MyDropDown(initialValue: '${myList[i]['map'][j]['output']}', itemList: getOutPut(configPvd,'${myList[i]['map'][j]['rtu']}','${myList[i]['map'][j]['rfNo']}','${myList[i]['map'][j]['output']}',myList[i]['map'][j]['count']), pvdName: '${myList[i]['map'][j]['type']}/$i/output', index: -1),
                          ),
                        )
                    ),
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            border: Border(
                              top:  BorderSide(width: j == 0 ? 1 : 0),
                              right: const BorderSide(width: 1),
                            )
                        ),
                        child: notAvailable
                    )

                  ],
                ),
              )
          );
        }
      }

    }
    return widgetList;
  }
  List<Widget> getIrrigationPump(List<Map<String,dynamic>> myList,ConfigMakerProvider configPvd){
    List<Widget> widgetList = [];
    for(var i = 0;i < myList.length;i++){
      if(!myList[i]['map'][0]['deleted']){
        widgetList.add(
            SizedBox(
              width: double.infinity,
              height: 40,
              child: Center(
                child: Text('${myList[i]['name']}',style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
              ),
            )
        );
        for(var j = 0;j < myList[i]['map'].length;j++){
          widgetList.add(
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  border: const Border(bottom: BorderSide(width: 1)),
                  color: j % 2 == 0 ? Colors.brown.shade50 : Colors.brown.shade100,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(left: const BorderSide(width: 1),right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                          ),
                          height: 40,
                          child: Center(child: Text('${myList[i]['map'][j]['name']} ${myList[i]['map'][j]['count'] == -1 ? '' : myList[i]['map'][j]['count'] + 1}')),
                        )
                    ),
                    if(myList[i]['map'][j]['oroPump'] == true)
                      Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                            ),
                            height: 40,
                            child: Center(
                              child: Text('${myList[i]['map'][j]['rtu']}',style: const TextStyle(fontSize: 11),),
                            ),
                          )
                      )
                    else
                      Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                            ),
                            height: 40,
                            child: Center(
                                child: MyDropDown(initialValue: '${myList[i]['map'][j]['rtu']}', itemList: myList[i]['map'][j]['oroPump'] == false ? getRtuName(configPvd,myList[i]['map'][j]['connection']) : ['-','ORO Pump'], pvdName: '${myList[i]['map'][j]['type']}/$i/rtu', index: -1)
                            ),
                          )
                      ),
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                          ),
                          height: 40,
                          child: Center(
                            child: MyDropDown(initialValue: '${myList[i]['map'][j]['rfNo']}', split: true,itemList: getrefNoForOthers(configPvd,'${myList[i]['map'][j]['rtu']}'), pvdName: '${myList[i]['map'][j]['type']}/$i/rfNo', index: -1),
                          ),
                        )
                    ),
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                          ),
                          height: 40,
                          child: Center(
                            child: MyDropDown(initialValue: '${myList[i]['map'][j]['output']}', itemList: getOutPut(configPvd,'${myList[i]['map'][j]['rtu']}','${myList[i]['map'][j]['rfNo']}','${myList[i]['map'][j]['output']}',myList[i]['map'][j]['count']), pvdName: '${myList[i]['map'][j]['type']}/$i/output', index: -1),
                          ),
                        )
                    ),
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            border: Border(
                              top:  BorderSide(width: j == 0 ? 1 : 0),
                              right: const BorderSide(width: 1),
                            )
                        ),
                        child: notAvailable
                    )

                  ],
                ),
              )
          );
        }
      }

    }
    return widgetList;
  }
  List<Widget> getAgitator(List<Map<String,dynamic>> myList,ConfigMakerProvider configPvd){
    List<Widget> widgetList = [];
    for(var i = 0;i < myList.length;i++){
      if(myList[i]['totalCount'] != 0 || myList[i]['totalList'].length != 0){
        widgetList.add(
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                color: Colors.indigo.shade50,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('   ${myList[i]['name']} (${myList[i]['totalCount']})',style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                  IconButton(
                      onPressed: (){
                        myList[i]['addFunction']();
                      },
                      icon: Icon(Icons.add_circle_outlined,color: Colors.green,)
                  ),
                ],
              ),
            )
        );
      }
      for(var j = 0;j < myList[i]['map'].length;j++){
        widgetList.add(
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                border: const Border(bottom: BorderSide(width: 1)),
                color: j % 2 == 0 ? Colors.white : Colors.white70,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(left: const BorderSide(width: 1),right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                        ),
                        height: 40,
                        child: Center(child: Text('${myList[i]['map'][j]['name']} ')),
                      )
                  ),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                        ),
                        height: 40,
                        child: Center(
                            child: MyDropDown(initialValue: '${myList[i]['map'][j]['rtu']}', itemList: getRtuName(configPvd,myList[i]['map'][j]['connection']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rtu', index: -1)
                        ),
                      )
                  ),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                        ),
                        height: 40,
                        child: Center(
                          child: MyDropDown(initialValue: '${myList[i]['map'][j]['rfNo']}', split: true,itemList: getrefNoForOthers(configPvd,'${myList[i]['map'][j]['rtu']}'), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rfNo', index: -1),
                        ),
                      )
                  ),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                        ),
                        height: 40,
                        child: Center(
                          child: MyDropDown(initialValue: '${myList[i]['map'][j]['output']}', itemList: getOutPut(configPvd,'${myList[i]['map'][j]['rtu']}','${myList[i]['map'][j]['rfNo']}','${myList[i]['map'][j]['output']}',myList[i]['map'][j]['count']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/output', index: -1),
                        ),
                      )
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        border: Border(
                          top:  BorderSide(width: j == 0 ? 1 : 0),
                          right: const BorderSide(width: 1),
                        )
                    ),
                    child: IconButton(
                        onPressed: (){
                          configPvd.mappingOfOutputsFunctionality(['agitatorDelete',j,]);
                        },
                        icon: const Icon(Icons.delete)
                    ),
                  )
                ],
              ),
            )
        );
      }
    }
    return widgetList;
  }
  List<Widget> getSelector(List<Map<String,dynamic>> myList,ConfigMakerProvider configPvd){
    List<Widget> widgetList = [];
    for(var i = 0;i < myList.length;i++){
      if(myList[i]['totalCount'] != 0 || myList[i]['totalList'].length != 0){
        widgetList.add(
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              color: Colors.indigo.shade50,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('   ${myList[i]['name']} (${myList[i]['totalCount']})',style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                  IconButton(
                      onPressed: (){
                        myList[i]['addFunction']();
                      },
                      icon: Icon(Icons.add_circle_outlined,color: Colors.green,)
                  ),

                ],
              ),
            )
        );
      }
      for(var j = 0;j < myList[i]['map'].length;j++){
        widgetList.add(
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                border: const Border(bottom: BorderSide(width: 1)),
                color: j % 2 == 0 ? Colors.white : Colors.white70,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(left: const BorderSide(width: 1),right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                        ),
                        height: 40,
                        child: Center(child: Text('${myList[i]['map'][j]['name']} ')),
                      )
                  ),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                        ),
                        height: 40,
                        child: Center(
                            child: MyDropDown(initialValue: '${myList[i]['map'][j]['rtu']}', itemList: getRtuName(configPvd,myList[i]['map'][j]['connection']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rtu', index: -1)
                          // child: Text('${myList[i]['map'][j]['rtu']}')
                        ),
                      )
                  ),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                        ),
                        height: 40,
                        child: Center(
                          child: MyDropDown(initialValue: '${myList[i]['map'][j]['rfNo']}', split: true,itemList: getrefNoForOthers(configPvd,'${myList[i]['map'][j]['rtu']}'), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rfNo', index: -1),
                          // child: Text('${myList[i]['map'][j]['rfNo']}')
                        ),
                      )
                  ),
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                        ),
                        height: 40,
                        child: Center(
                          child: MyDropDown(initialValue: '${myList[i]['map'][j]['output']}', itemList: getOutPut(configPvd,'${myList[i]['map'][j]['rtu']}','${myList[i]['map'][j]['rfNo']}','${myList[i]['map'][j]['output']}',myList[i]['map'][j]['count']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/output', index: -1),
                        ),
                      )
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        border: Border(
                          top:  BorderSide(width: j == 0 ? 1 : 0),
                          right: const BorderSide(width: 1),
                        )
                    ),
                    child: IconButton(
                        onPressed: (){
                          configPvd.mappingOfOutputsFunctionality(['selectorDelete',j,]);
                        },
                        icon: const Icon(Icons.delete)
                    ),
                  )
                ],
              ),
            )
        );
      }
    }
    return widgetList;
  }
  List<String> getRtuName(ConfigMakerProvider configPvd,name){
    var list = ['-'];
    if(configPvd.oRtu.isNotEmpty){
      list.add('ORO RTU');
    }
    if(configPvd.oRtuPlus.isNotEmpty){
      list.add('O-RTU-Plus');
    }
    print("configPvd.oSrtu : ${configPvd.oSrtu}");
    if(configPvd.oSrtu.isNotEmpty){
      list.add('ORO Smart');
    }
    if(configPvd.oSrtuPlus.isNotEmpty){
      list.add('O-Smart-Plus');
    }
    if(configPvd.totalOroSwitch != 0){
      list.add('ORO Switch');
    }
    if(configPvd.oPump.isNotEmpty){
      list.add('ORO Pump');
    }
    if(configPvd.oPumpPlus.isNotEmpty){
      list.add('O-Pump-Plus');
    }
    if(configPvd.oLevel.isNotEmpty){
      list.add('ORO Level');
    }
    if(configPvd.oSense.isNotEmpty){
      list.add('ORO Sense');
    }
    if(['valveConnection','main_valveConnection','foggerConnection','fanConnection','water_meter','pressureIn','pressureOut','injector','dosingMeter','boosterConnection','ecConnection','phConnection','pressureSwitch','filterConnection','dv','diffPressureSensor','pumpConnection'].contains(name)){
      list.remove('ORO Sense');
      list.remove('ORO Level');
      list.remove('ORO Pump');
      list.remove('O-Pump-Plus');
      list.remove('ORO Switch');

    }else if(['levelSensorConnection','levelSensor'].contains(name)){
      list.remove('ORO Sense');
      list.remove('ORO Pump');
      list.remove('O-Pump-Plus');
      list.remove('ORO RTU');
      list.remove('ORO Smart');
      list.remove('O-RTU-Plus');
      list.remove('ORO Switch');
    }else if(['moistureSensorConnection'].contains(name)){
      list.remove('ORO Level');
      list.remove('ORO Pump');
      list.remove('O-Pump-Plus');
      list.remove('ORO Switch');
      list.remove('ORO RTU');
      list.remove('ORO Smart');
      list.remove('O-Smart-Plus');
    }
    return list;
  }
  List<String> getrefNoForOthers(ConfigMakerProvider configPvd,String title){
    List<String> myList = ['-'];
    if(title == 'ORO Smart'){
      for(var i = 0;i < configPvd.oSrtu.length;i++){
        print(configPvd.oSrtu);
        print(configPvd.oSrtuMac);
        myList.add('${configPvd.oSrtu[i]}\n${configPvd.oSrtuMac[i] ?? ''}');
      }
    }else if(title == 'O-Smart-Plus'){
      for(var i = 0;i < configPvd.oSrtuPlus.length;i++){
        myList.add('${configPvd.oSrtuPlus[i]}\n${configPvd.oSrtuPlusMac[i]}');
      }
    }else if(title == 'ORO Switch'){
      for(var i = 0;i < configPvd.oSwitch.length;i++){
        myList.add('${configPvd.oSwitch[i]}\n${configPvd.oSwitchMac[i]}');
      }
    }else if(title == 'ORO Sense'){
      for(var i = 0;i < configPvd.oSense.length;i++){
        myList.add('${configPvd.oSense[i]}\n${configPvd.oSenseMac[i]}');
      }
    }else if(title == 'ORO RTU'){
      for(var i = 0;i < configPvd.oRtu.length;i++){
        myList.add('${configPvd.oRtu[i]}\n${configPvd.oRtuMac[i]}');
      }
    }else if(title == 'O-RTU-Plus'){
      for(var i = 0;i < configPvd.oRtuPlus.length;i++){
        myList.add('${configPvd.oRtuPlus[i]}\n${configPvd.oRtuPlusMac[i]}');
      }
    }else if(title == 'ORO Pump'){
      for(var i = 0;i < configPvd.oPump.length;i++){
        myList.add('${configPvd.oPump[i]}\n${configPvd.oPumpMac[i]}');
      }
    }else if(title == 'O-Pump-Plus'){
      for(var i = 0;i < configPvd.oPumpPlus.length;i++){
        myList.add('${configPvd.oPumpPlus[i]}\n${configPvd.oPumpPlusMac[i]}');
      }
    }
    return myList;
  }
  List<String> filterOutPut(List<dynamic> data,String rtu,String rf,String output){
    List<String> list = [];
    for(var i in data){
      if((i['rtu'] == rtu) && (i['rfNo'] == rf)){
        if(i['output'] != '-' && output != i['output']){
          list.add(i['output']);
        }
      }
    }
    return list;
  }
  List<String> filterCt(List<dynamic> data,String rtu,String rf,String ct){
    List<String> list = [];
    for(var i in data){
      if((i['rtu'] == rtu) && (i['rfNo'] == rf)){
        if(i['current_selection'] != '-' && ct != i['current_selection']){
          list.add(i['current_selection']);
        }
      }
    }
    return list;
  }

  List<String> getOutPut(ConfigMakerProvider configPvd,String rtu, String rf, String output,int index) {
    List<String> myList = [];
    List<String> filterList = [];
    if(rtu == 'ORO RTU'){
      for(var i = 0;i < 8;i++){
        myList.add('R${i+1}');
      }
    }else if(rtu == 'O-RTU-Plus'){
      for(var i = 0;i < 4;i++){
        myList.add('R${i+1}');
      }
    }else if(rtu == 'ORO Pump'){
      for(var i = 0;i < 3;i++){
        myList.add('R${i+1}');
      }
    }else if(rtu == 'O-Pump-Plus'){
      for(var i = 0;i < 3;i++){
        myList.add('R${i+1}');
      }
    }else if(rtu == 'ORO Smart'){
      for(var i = 0;i < 8;i++){
        myList.add('R${i+1}');
      }
    }else if(rtu == 'O-Smart-Plus'){
      for(var i = 0;i < 16;i++){
        myList.add('R${i+1}');
      }
    }else if(rtu == 'ORO Switch'){
      for(var i = 0;i < 4;i++){
        myList.add('R${i+1}');
      }
    }
    if(rtu != '-' && rf != '-'){
      for(var i in configPvd.sourcePumpUpdated){
        if(!i['deleted']){
          filterList.addAll(filterOutPut([i],rtu,rf,output));
        }
      }
      for(var i in configPvd.irrigationPumpUpdated){
        if(!i['deleted']){
          filterList.addAll(filterOutPut([i],rtu,rf,output));
        }
      }
      filterList.addAll(filterOutPut(configPvd.totalAgitator,rtu,rf,output));
      filterList.addAll(filterOutPut(configPvd.totalSelector,rtu,rf,output));
      for(var i in configPvd.centralFiltrationUpdated){
        filterList.addAll(filterOutPut(i['filterConnection'],rtu,rf,output));
        filterList.addAll(filterOutPut([i['dv']],rtu,rf,output));
      }
      for(var i in configPvd.centralDosingUpdated){
        filterList.addAll(filterOutPut(i['injector'],rtu,rf,output));
        filterList.addAll(filterOutPut(i['boosterConnection'],rtu,rf,output));
      }
      for(var i in configPvd.irrigationLines){
        filterList.addAll(filterOutPut(i['valveConnection'],rtu,rf,output));
        filterList.addAll(filterOutPut(i['main_valveConnection'],rtu,rf,output));
        filterList.addAll(filterOutPut(i['foggerConnection'],rtu,rf,output));
        filterList.addAll(filterOutPut(i['fanConnection'],rtu,rf,output));
      }
      for(var i in configPvd.localFiltrationUpdated){
        filterList.addAll(filterOutPut(i['filterConnection'],rtu,rf,output));
        filterList.addAll(filterOutPut([i['dv']],rtu,rf,output));
      }
      for(var i in configPvd.localDosingUpdated){
        filterList.addAll(filterOutPut(i['injector'],rtu,rf,output));
        filterList.addAll(filterOutPut(i['boosterConnection'],rtu,rf,output));
      }
    }
    for(var i in filterList){
      if(myList.contains(i)){
        myList.remove(i);
      }
    }
    myList.insert(0, '-');
    return rf == '-' ? ['-'] : myList;
  }
  List<Map<String,dynamic>> irrigationLine(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    for(var i = 0;i < configPvd.irrigationLines.length;i++){
      myList.add(
          {
            'name' : 'Irrigation Line ${i+1}',
            'map' : [],
          }
      );
      for(var valve = 0;valve < configPvd.irrigationLines[i]['valveConnection'].length;valve++){
        myList[i]['map'].add(
            {
              'name' : 'valve',
              'type' : 'm_o_line',
              'line' : i,
              'index' : i,
              'count' : valve,
              'connection' : 'valveConnection',
              'sNo' :  configPvd.irrigationLines[i]['valveConnection'][valve]['sNo'],
              'rtu' :  configPvd.irrigationLines[i]['valveConnection'][valve]['rtu'],
              'rfNo' : configPvd.irrigationLines[i]['valveConnection'][valve]['rfNo'],
              'output' : configPvd.irrigationLines[i]['valveConnection'][valve]['output'],
              'deleted' : configPvd.irrigationLines[i]['deleted'],
            }
        );
      }
      for(var mainValve = 0;mainValve < configPvd.irrigationLines[i]['main_valveConnection'].length;mainValve++){
        myList[i]['map'].add(
            {
              'name' : 'mainValve',
              'type' : 'm_o_line',
              'line' : i,
              'index' : i,
              'count' : mainValve,
              'connection' : 'main_valveConnection',
              'sNo' :  configPvd.irrigationLines[i]['main_valveConnection'][mainValve]['sNo'],
              'rtu' :  configPvd.irrigationLines[i]['main_valveConnection'][mainValve]['rtu'],
              'rfNo' : configPvd.irrigationLines[i]['main_valveConnection'][mainValve]['rfNo'],
              'output' : configPvd.irrigationLines[i]['main_valveConnection'][mainValve]['output'],
              'deleted' : configPvd.irrigationLines[i]['deleted'],
            }
        );
      }
      for(var fogger = 0;fogger < configPvd.irrigationLines[i]['foggerConnection'].length;fogger++){
        myList[i]['map'].add(
            {
              'name' : 'fogger',
              'type' : 'm_o_line',
              'line' : i,
              'index' : i,
              'count' : fogger,
              'connection' : 'foggerConnection',
              'sNo' :  configPvd.irrigationLines[i]['foggerConnection'][fogger]['sNo'],
              'rtu' :  configPvd.irrigationLines[i]['foggerConnection'][fogger]['rtu'],
              'rfNo' : configPvd.irrigationLines[i]['foggerConnection'][fogger]['rfNo'],
              'output' : configPvd.irrigationLines[i]['foggerConnection'][fogger]['output'],
              'deleted' : configPvd.irrigationLines[i]['deleted'],
            }
        );
      }
      for(var fan = 0;fan < configPvd.irrigationLines[i]['fanConnection'].length;fan++){
        myList[i]['map'].add(
            {
              'name' : 'fan',
              'type' : 'm_o_line',
              'line' : i,
              'index' : i,
              'count' : fan,
              'connection' : 'fanConnection',
              'sNo' :  configPvd.irrigationLines[i]['fanConnection'][fan]['sNo'],
              'rtu' :  configPvd.irrigationLines[i]['fanConnection'][fan]['rtu'],
              'rfNo' : configPvd.irrigationLines[i]['fanConnection'][fan]['rfNo'],
              'output' : configPvd.irrigationLines[i]['fanConnection'][fan]['output'],
              'deleted' : configPvd.irrigationLines[i]['deleted'],
            }
        );
      }
      if(configPvd.irrigationLines[i]['Local_dosing_site'] == true){
        localDosing : for(var ld = 0;ld < configPvd.localDosingUpdated.length;ld++){
          if(configPvd.localDosingUpdated[ld]['sNo'] == configPvd.irrigationLines[i]['sNo']){
            for(var injector = 0;injector < configPvd.localDosingUpdated[ld]['injector'].length;injector++){
              myList[i]['map'].add(
                  {
                    'name' : 'injector',
                    'type' : 'm_o_localDosing',
                    'line' : i,
                    'index' : ld,
                    'count' : injector,
                    'connection' : 'injector',
                    'sNo' :  configPvd.localDosingUpdated[ld]['injector'][injector]['sNo'],
                    'rtu' :  configPvd.localDosingUpdated[ld]['injector'][injector]['rtu'],
                    'rfNo' : configPvd.localDosingUpdated[ld]['injector'][injector]['rfNo'],
                    'output' : configPvd.localDosingUpdated[ld]['injector'][injector]['output'],
                    'deleted' : configPvd.irrigationLines[i]['deleted'],
                  }
              );
            }
            for(var boosterPump = 0;boosterPump < configPvd.localDosingUpdated[ld]['boosterConnection'].length;boosterPump++){
              myList[i]['map'].add(
                  {
                    'name' : 'Booster',
                    'type' : 'm_o_localDosing',
                    'line' : i,
                    'index' : ld,
                    'count' : boosterPump,
                    'connection' : 'boosterConnection',
                    'sNo' :  configPvd.localDosingUpdated[ld]['boosterConnection'][boosterPump]['sNo'],
                    'rtu' :  configPvd.localDosingUpdated[ld]['boosterConnection'][boosterPump]['rtu'],
                    'rfNo' : configPvd.localDosingUpdated[ld]['boosterConnection'][boosterPump]['rfNo'],
                    'output' : configPvd.localDosingUpdated[ld]['boosterConnection'][boosterPump]['output'],
                    'deleted' : configPvd.irrigationLines[i]['deleted'],
                  }
              );
            }
            break localDosing;
          }
        }
      }
      if(configPvd.irrigationLines[i]['local_filtration_site'] == true){
        localFiltration : for(var ld = 0;ld < configPvd.localFiltrationUpdated.length;ld++){
          if(configPvd.localFiltrationUpdated[ld]['sNo'] == configPvd.irrigationLines[i]['sNo']){
            for(var filter = 0;filter < configPvd.localFiltrationUpdated[ld]['filterConnection'].length;filter++){
              myList[i]['map'].add(
                  {
                    'name' : 'filter',
                    'type' : 'm_o_localFiltration',
                    'line' : i,
                    'index' : ld,
                    'count' : filter,
                    'connection' : 'filterConnection',
                    'sNo' :  configPvd.localFiltrationUpdated[ld]['filterConnection'][filter]['sNo'],
                    'rtu' :  configPvd.localFiltrationUpdated[ld]['filterConnection'][filter]['rtu'],
                    'rfNo' : configPvd.localFiltrationUpdated[ld]['filterConnection'][filter]['rfNo'],
                    'output' : configPvd.localFiltrationUpdated[ld]['filterConnection'][filter]['output'],
                    'deleted' : configPvd.irrigationLines[i]['deleted'],
                  }
              );
            }
            if(configPvd.localFiltrationUpdated[ld]['dv'].isNotEmpty){
              myList[i]['map'].add(
                  {
                    'name' : 'd_valve',
                    'type' : 'm_o_localFiltration',
                    'line' : i,
                    'index' : ld,
                    'count' : -1,
                    'connection' : 'dv',
                    'sNo' :  configPvd.localFiltrationUpdated[ld]['dv']['sNo'],
                    'rtu' :  configPvd.localFiltrationUpdated[ld]['dv']['rtu'],
                    'rfNo' : configPvd.localFiltrationUpdated[ld]['dv']['rfNo'],
                    'output' : configPvd.localFiltrationUpdated[ld]['dv']['output'],
                    'deleted' : configPvd.irrigationLines[i]['deleted'],
                  }
              );
            }

            break localFiltration;
          }
        }
      }

    }
    return myList;
  }
  List<Map<String,dynamic>> centralDosing(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    for(var i = 0;i < configPvd.centralDosingUpdated.length;i++){
      myList.add(
          {
            'name' : 'Central Dosing Site ${i+1}',
            'map' : [],
          }
      );
      for(var injector = 0;injector < configPvd.centralDosingUpdated[i]['injector'].length;injector++){
        myList[i]['map'].add(
            {
              'name' : 'injector',
              'type' : 'm_o_centralDosing',
              'site' : i,
              'count' : injector,
              'connection' : 'injector',
              'sNo' :  configPvd.centralDosingUpdated[i]['injector'][injector]['sNo'],
              'rtu' :  configPvd.centralDosingUpdated[i]['injector'][injector]['rtu'],
              'rfNo' : configPvd.centralDosingUpdated[i]['injector'][injector]['rfNo'],
              'output' : configPvd.centralDosingUpdated[i]['injector'][injector]['output'],
              'deleted' : configPvd.centralDosingUpdated[i]['deleted'],
            }
        );
      }
      for(var boosterPump = 0;boosterPump < configPvd.centralDosingUpdated[i]['boosterConnection'].length;boosterPump++){
        myList[i]['map'].add(
            {
              'name' : 'Booster',
              'type' : 'm_o_centralDosing',
              'line' : i,
              'count' : boosterPump,
              'connection' : 'boosterConnection',
              'sNo' :  configPvd.centralDosingUpdated[i]['boosterConnection'][boosterPump]['sNo'],
              'rtu' :  configPvd.centralDosingUpdated[i]['boosterConnection'][boosterPump]['rtu'],
              'rfNo' : configPvd.centralDosingUpdated[i]['boosterConnection'][boosterPump]['rfNo'],
              'output' : configPvd.centralDosingUpdated[i]['boosterConnection'][boosterPump]['output'],
              'deleted' : configPvd.centralDosingUpdated[i]['deleted'],
            }
        );
      }
    }
    return myList;
  }
  List<Map<String,dynamic>> centralFiltration(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    for(var i = 0;i < configPvd.centralFiltrationUpdated.length;i++){
      myList.add(
          {
            'name' : 'Central Filtration Site ${i+1}',
            'map' : [],
          }
      );
      for(var filter = 0;filter < configPvd.centralFiltrationUpdated[i]['filterConnection'].length;filter++){
        myList[i]['map'].add(
            {
              'name' : 'filter',
              'type' : 'm_o_centralFiltration',
              'line' : i,
              'count' : filter,
              'connection' : 'filterConnection',
              'sNo' :  configPvd.centralFiltrationUpdated[i]['filterConnection'][filter]['sNo'],
              'rtu' :  configPvd.centralFiltrationUpdated[i]['filterConnection'][filter]['rtu'],
              'rfNo' : configPvd.centralFiltrationUpdated[i]['filterConnection'][filter]['rfNo'],
              'output' : configPvd.centralFiltrationUpdated[i]['filterConnection'][filter]['output'],
              'deleted' : configPvd.centralFiltrationUpdated[i]['deleted'],
            }
        );
      }
      if(configPvd.centralFiltrationUpdated[i]['dv'].isNotEmpty){
        myList[i]['map'].add(
            {
              'name' : 'd_valve',
              'type' : 'm_o_centralFiltration',
              'line' : i,
              'count' : -1,
              'connection' : 'dv',
              'sNo' :  configPvd.centralFiltrationUpdated[i]['dv']['sNo'],
              'rtu' :  configPvd.centralFiltrationUpdated[i]['dv']['rtu'],
              'rfNo' : configPvd.centralFiltrationUpdated[i]['dv']['rfNo'],
              'output' : configPvd.centralFiltrationUpdated[i]['dv']['output'],
              'deleted' : configPvd.centralFiltrationUpdated[i]['deleted'],
            }
        );
      }
    }
    return myList;
  }
  List<Map<String,dynamic>> sourcePump(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    for(var i = 0;i < configPvd.sourcePumpUpdated.length;i++){
      myList.add(
          {
            'name' : 'Source Pump ${i+1}',
            'map' : [],
          }
      );
      myList[i]['map'].add(
          {
            'oroPump' : (configPvd.sourcePumpUpdated[i]['oro_pump'] == true || configPvd.sourcePumpUpdated[i]['oro_pump_plus'] == true) ? true : false,
            'name' : 'pump',
            'type' : 'm_o_sourcePump',
            'pump' : i,
            'count' : -1,
            'connection' : 'connection',
            'sNo' :  configPvd.sourcePumpUpdated[i]['sNo'],
            'rtu' :  configPvd.sourcePumpUpdated[i]['rtu'],
            'rfNo' : configPvd.sourcePumpUpdated[i]['rfNo'],
            'output' : configPvd.sourcePumpUpdated[i]['output'],
            'c-type' : configPvd.sourcePumpUpdated[i]['current_selection'],
            'deleted' : configPvd.sourcePumpUpdated[i]['deleted']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> irrigationPump(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    for(var i = 0;i < configPvd.irrigationPumpUpdated.length;i++){
      myList.add(
          {
            'name' : 'Irrigation Pump ${i+1}',
            'map' : [],
          }
      );
      myList[i]['map'].add(
          {
            'oroPump' : (configPvd.irrigationPumpUpdated[i]['oro_pump'] == true || configPvd.irrigationPumpUpdated[i]['oro_pump_plus'] == true) ? true : false,
            'name' : 'pump',
            'type' : 'm_o_irrigationPump',
            'pump' : i,
            'count' : -1,
            'connection' : 'connection',
            'sNo' :  configPvd.irrigationPumpUpdated[i]['sNo'],
            'rtu' :  configPvd.irrigationPumpUpdated[i]['rtu'],
            'rfNo' : configPvd.irrigationPumpUpdated[i]['rfNo'],
            'output' : configPvd.irrigationPumpUpdated[i]['output'],
            'c-type' : configPvd.irrigationPumpUpdated[i]['current_selection'],
            'deleted' : configPvd.irrigationPumpUpdated[i]['deleted']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> agitator(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Agitator',
          'map' : [],
          'totalCount': configPvd.totalAgitatorCount,
          'totalList': configPvd.totalAgitator,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalAgitatorCount != 0) {
                configPvd.totalAgitatorCount -= 1;
                configPvd.totalAgitator.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'output': '-',
                  'output_type': '-',
                });
              }
            });
          },
        }
    );
    for(var i = 0;i < configPvd.totalAgitator.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'AG ${i+1}',
            'type' : 'm_o_agitator',
            'agitator' : i,
            'count' : i,
            'connection' : 'totalAgitator',
            'sNo' :  configPvd.totalAgitator[i]['sNo'],
            'rtu' :  configPvd.totalAgitator[i]['rtu'],
            'rfNo' : configPvd.totalAgitator[i]['rfNo'],
            'output' : configPvd.totalAgitator[i]['output'],
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> selector(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Selector',
          'map' : [],
          'totalCount': configPvd.totalSelectorCount,
          'totalList': configPvd.totalSelector,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalSelectorCount != 0) {
                configPvd.totalSelectorCount -= 1;
                configPvd.totalSelector.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'output': '-',
                  'output_type': '-',
                });
              }
            });
          },
        }
    );
    for(var i = 0;i < configPvd.totalSelector.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'Sl ${i+1}',
            'type' : 'm_o_selector',
            'agitator' : i,
            'count' : i,
            'connection' : 'totalSelector',
            'sNo' :  configPvd.totalSelector[i]['sNo'],
            'rtu' :  configPvd.totalSelector[i]['rtu'],
            'rfNo' : configPvd.totalSelector[i]['rfNo'],
            'output' : configPvd.totalSelector[i]['output'],
          }
      );
    }
    return myList;
  }

}
