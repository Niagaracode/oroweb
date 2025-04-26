import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/screens/Config/config_maker/source_pump.dart';
import 'package:provider/provider.dart';
import '../../../state_management/config_maker_provider.dart';
import '../../../widgets/drop_down_button.dart';

class MappingOfInputsTable extends StatefulWidget {
  final ConfigMakerProvider configPvd;
  const MappingOfInputsTable({super.key,required this.configPvd});

  @override
  State<MappingOfInputsTable> createState() => _MappingOfInputsTableState();
}

class _MappingOfInputsTableState extends State<MappingOfInputsTable> {
  @override
  Widget build(BuildContext context) {
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: true);
    return LayoutBuilder(builder: (context,constraint){
      return Container(
        color: const Color(0xFFF3F3F3),
        child: Column(
          children: [
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
                          Text('I-Type',),
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
                          Text('I/P',),

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
                        children: getAnalogSensor(analogSensor(configPvd),configPvd),
                      ),
                      Column(
                        children: getAnalogSensor(commonPressureSensor(configPvd),configPvd),
                      ),
                      Column(
                        children: getAnalogSensor(commonPressureSwitch(configPvd),configPvd),
                      ),
                      Column(
                        children: getAnalogSensor(tankFloat(configPvd),configPvd),
                      ),
                      Column(
                        children: getAnalogSensor(manualButton(configPvd),configPvd),
                      ),
                      Column(
                        children: getAnalogSensor(lowerTankLevel(configPvd),configPvd),
                      ),
                      Column(
                        children: getAnalogSensor(upperTankLevel(configPvd),configPvd),
                      ),
                      Column(
                        children: getContact(contact(configPvd),configPvd),
                      ),
                      Column(
                        children: getTemperature(temperature(configPvd),configPvd),
                      ),
                      Column(
                        children: getTemperature(soilTemperature(configPvd),configPvd),
                      ),
                      // Column(
                      //   children: getTemperature(windDirection(configPvd),configPvd),
                      // ),
                      // Column(
                      //   children: getTemperature(windSpeed(configPvd),configPvd),
                      // ),
                      // Column(
                      //   children: getTemperature(lux(configPvd),configPvd),
                      // ),
                      // Column(
                      //   children: getTemperature(ldr(configPvd),configPvd),
                      // ),
                      // Column(
                      //   children: getTemperature(rainGauge(configPvd),configPvd),
                      // ),
                      Column(
                        children: getTemperature(co2(configPvd),configPvd),
                      ),
                      // Column(
                      //   children: getTemperature(leafWetness(configPvd),configPvd),
                      // ),
                      Column(
                        children: getTemperature(humidity(configPvd),configPvd),
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
  List<Widget> getIrrigationLine(List<Map<String,dynamic>> myList,ConfigMakerProvider configPvd){
    List<Widget> widgetList = [];
    for(var i = 0;i < myList.length;i++){
      if(myList[i]['map'].length != 0){
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
                            child: Center(child: Text('${myList[i]['map'][j]['name']} ${myList[i]['map'][j]['count'] == -1 ? '' : myList[i]['map'][j]['count'] + 1}')),
                          )
                      ),
                      Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                            ),
                            height: 40,
                            child: Center(
                                child: (myList[i]['map'][j]['name'].contains('Ec ')
                                    // || myList[i]['map'][j]['name'].contains('Ph ')
                                    || myList[i]['map'][j]['name'].contains('powerSupply')
                                    || myList[i]['map'][j]['name'].contains('pressureSwitch')
                                ) ? Text('${myList[i]['map'][j]['rtu']}') : MyDropDown(initialValue: '${myList[i]['map'][j]['rtu']}', itemList: getRtuName(configPvd,myList[i]['map'][j]['connection']), pvdName: '${myList[i]['map'][j]['type']}/${myList[i]['map'][j]['index']}/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rtu', index: -1)
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
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                            ),
                            height: 40,
                            child: Center(
                              child: (myList[i]['map'][j]['name'].contains('Ec ')
                                  || myList[i]['map'][j]['name'].contains('Ph ')
                                  || myList[i]['map'][j]['name'].contains('powerSupply')
                                  || myList[i]['map'][j]['name'].contains('pressureSwitch')
                                  || myList[i]['map'][j]['name'].contains('water meter')
                                  || myList[i]['map'][j]['name'].contains('moisture sensor')
                              ) ? Text('${myList[i]['map'][j]['input_type']}') : MyDropDown(initialValue: '${myList[i]['map'][j]['input_type']}', itemList: getInputList(myList[i]['map'][j]['rtu'],myList[i]['map'][j]['rfNo']), pvdName: '${myList[i]['map'][j]['type']}/${myList[i]['map'][j]['index']}/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/input_type', index: -1),
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
                              child: MyDropDown(initialValue: '${myList[i]['map'][j]['input']}', itemList: getInPut(configPvd,'${myList[i]['map'][j]['rtu']}','${myList[i]['map'][j]['rfNo']}','${myList[i]['map'][j]['input']}',myList[i]['map'][j]['count'],myList[i]['map'][j]['input_type'],'${myList[i]['map'][j]['name']} ${myList[i]['map'][j]['count'] == -1 ? '' : myList[i]['map'][j]['count'] + 1}'), pvdName: '${myList[i]['map'][j]['type']}/${myList[i]['map'][j]['index']}/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/input', index: -1),
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
                        child: ['moistureSensorConnection','levelSensorConnection'].contains(myList[i]['map'][j]['connection']) ? IconButton(
                            onPressed: (){
                              configPvd.irrigationLinesFunctionality(['deleteFromMapio',i,myList[i]['map'][j]['connection'],myList[i]['map'][j]['sNo']]);
                            },
                            icon: const Icon(Icons.delete)
                        ) : notAvailable,
                      )
                    ],
                  ),
                )
            );
          }
        }

      }

    }
    return widgetList;
  }
  List<Widget> getCentralDosing(List<Map<String,dynamic>> myList,ConfigMakerProvider configPvd){
    List<Widget> widgetList = [];
    for(var i = 0;i < myList.length;i++){
      if(myList[i]['map'].length != 0){
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
                            child: Center(child: Text('${myList[i]['map'][j]['name']} ${myList[i]['map'][j]['count'] == -1 ? '' : myList[i]['map'][j]['count'] + 1}')),
                          )
                      ),
                      Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                            ),
                            height: 40,
                            child: Center(
                                child: (myList[i]['map'][j]['name'].contains('Ec ')) ? Text('${myList[i]['map'][j]['rtu']}') : MyDropDown(initialValue: '${myList[i]['map'][j]['rtu']}', itemList: getRtuName(configPvd,myList[i]['map'][j]['connection']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rtu', index: -1)
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
                              child: (myList[i]['map'][j]['name'].contains('Ec ') || myList[i]['map'][j]['name'].contains('Ph ')) ? Text('${myList[i]['map'][j]['input_type']}') : MyDropDown(initialValue: '${myList[i]['map'][j]['input_type']}', itemList: getInputList(myList[i]['map'][j]['rtu'],myList[i]['map'][j]['rfNo']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/input_type', index: -1),
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
                              child: MyDropDown(initialValue: '${myList[i]['map'][j]['input']}', itemList: getInPut(configPvd,'${myList[i]['map'][j]['rtu']}','${myList[i]['map'][j]['rfNo']}','${myList[i]['map'][j]['input']}',myList[i]['map'][j]['count'],myList[i]['map'][j]['input_type'],'${myList[i]['map'][j]['name']} ${myList[i]['map'][j]['count'] == -1 ? '' : myList[i]['map'][j]['count'] + 1}'), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/input', index: -1),
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
                        child: ['ecConnection','phConnection'].contains(myList[i]['map'][j]['connection']) ? IconButton(
                            onPressed: (){
                              configPvd.centralDosingFunctionality(['deleteFromMapio',i,myList[i]['map'][j]['connection'],myList[i]['map'][j]['sNo']]);
                            },
                            icon: const Icon(Icons.delete)
                        ) : notAvailable,
                      )
                    ],
                  ),
                )
            );
          }
        }

      }

    }
    return widgetList;
  }
  List<Widget> getCentralFiltration(List<Map<String,dynamic>> myList,ConfigMakerProvider configPvd){
    List<Widget> widgetList = [];
    for(var i = 0;i < myList.length;i++){
      if(myList[i]['map'].length != 0){
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
                            child: Center(child: Text('${myList[i]['map'][j]['name']} ${myList[i]['map'][j]['count'] == -1 ? '' : myList[i]['map'][j]['count'] + 1}')),
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
                              child: MyDropDown(initialValue: '${myList[i]['map'][j]['input_type']}', itemList: getInputList(myList[i]['map'][j]['rtu'],myList[i]['map'][j]['rfNo']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/input_type', index: -1),
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
                              child: MyDropDown(initialValue: '${myList[i]['map'][j]['input']}', itemList: getInPut(configPvd,'${myList[i]['map'][j]['rtu']}','${myList[i]['map'][j]['rfNo']}','${myList[i]['map'][j]['input']}',myList[i]['map'][j]['count'],myList[i]['map'][j]['input_type']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/input', index: -1),
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
                        child: notAvailable,
                      )
                    ],
                  ),
                )
            );
          }
        }

      }

    }
    return widgetList;
  }
  List<Widget> getSourcePump(List<Map<String,dynamic>> myList,ConfigMakerProvider configPvd){
    List<Widget> widgetList = [];
    for(var i = 0;i < myList.length;i++){
      if(myList[i]['map'].length != 0){
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
                            child: Center(child: Text('${myList[i]['map'][j]['name']} ${myList[i]['map'][j]['count'] == -1 ? '' : myList[i]['map'][j]['count'] + 1}')),
                          )
                      ),
                      if(['waterMeter'].contains(myList[i]['map'][j]['connection']))
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
                        )
                      else if(['TopTankHigh','TopTankLow','SumpTankHigh','SumpTankLow'].contains(myList[i]['map'][j]['connection']))
                        Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                              ),
                              height: 40,
                              child: Center(
                                child: Text('${myList[i]['map'][j]['rtu']}'),
                                  // child: MyDropDown(initialValue: '${myList[i]['map'][j]['rtu']}', itemList: getRtuName(configPvd,myList[i]['map'][j]['connection']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rtu', index: -1)
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
                                child: Text('${myList[i]['map'][j]['rtu']}',style: const TextStyle(fontSize: 11),),
                              ),
                            )
                        ),
                      if(['waterMeter','TopTankHigh','TopTankLow','SumpTankHigh','SumpTankLow'].contains(myList[i]['map'][j]['connection']))
                        Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                              ),
                              height: 40,
                              child: Center(
                                child: MyDropDown(initialValue: '${myList[i]['map'][j]['rfNo']}', split: true,itemList: getrefNoForOthers(configPvd,'${myList[i]['map'][j]['rtu']}',{'pump' : 'sourcePump','count' : i}), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rfNo', index: -1),
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
                                child: Text('${myList[i]['map'][j]['rfNo']}',style: const TextStyle(fontSize: 11),),
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
                              child: ['levelSensor','pressureSensor','TopTankHigh','TopTankLow','SumpTankHigh','SumpTankLow'].contains(myList[i]['map'][j]['connection']) ? Text('${myList[i]['map'][j]['input_type']}') :MyDropDown(initialValue: '${myList[i]['map'][j]['input_type']}', itemList: getInputList(myList[i]['map'][j]['rtu'],myList[i]['map'][j]['rfNo']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/input_type', index: -1),
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
                              child: MyDropDown(initialValue: '${myList[i]['map'][j]['input']}', itemList: getInPut(configPvd,'${myList[i]['map'][j]['rtu']}','${myList[i]['map'][j]['rfNo']}','${myList[i]['map'][j]['input']}',myList[i]['map'][j]['count'],myList[i]['map'][j]['input_type'],myList[i]['map'][j]['name']),pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/input', index: -1),
                            ),
                          )
                      ),
                      // Expanded(
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //           border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                      //       ),
                      //       height: 40,
                      //       child: Center(
                      //         child: MyDropDown(initialValue: '${myList[i]['map'][j]['input']}', itemList: ['waterMeter','levelSensor','pressureSensor','TopTankHigh','TopTankLow','SumpTankHigh','SumpTankLow'].contains(myList[i]['map'][j]['connection'])
                      //             ?
                      //         getInPut(configPvd,'${myList[i]['map'][j]['rtu']}','${myList[i]['map'][j]['rfNo']}','${myList[i]['map'][j]['input']}',myList[i]['map'][j]['count'],myList[i]['map'][j]['input_type'])
                      //             :
                      //         getInPutForct(configPvd,'${myList[i]['map'][j]['rtu']}','${myList[i]['map'][j]['rfNo']}','${myList[i]['map'][j]['input']}',myList[i]['map'][j]['pump'],myList[i]['map'][j]['connection']),
                      //             pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/input', index: -1),
                      //       ),
                      //     )
                      // ),

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
                        child: notAvailable,
                      )
                    ],
                  ),
                )
            );
          }
        }

      }

    }
    return widgetList;
  }
  List<Widget> getIrrigationPump(List<Map<String,dynamic>> myList,ConfigMakerProvider configPvd){
    List<Widget> widgetList = [];
    for(var i = 0;i < myList.length;i++){
      if(myList[i]['map'].length != 0){
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
                            child: Center(child: Text('${myList[i]['map'][j]['name']} ${myList[i]['map'][j]['count'] == -1 ? '' : myList[i]['map'][j]['count'] + 1}')),
                          )
                      ),
                      if(['waterMeter'].contains(myList[i]['map'][j]['connection']))
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
                        )
                      else if(['TopTankHigh','TopTankLow','SumpTankHigh','SumpTankLow'].contains(myList[i]['map'][j]['connection']))
                        Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                              ),
                              height: 40,
                              child: Center(
                                child: Text('${myList[i]['map'][j]['rtu']}'),
                                  // child: MyDropDown(initialValue: '${myList[i]['map'][j]['rtu']}', itemList: getRtuName(configPvd,myList[i]['map'][j]['connection']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rtu', index: -1)
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
                                child: Text('${myList[i]['map'][j]['rtu']}',style: const TextStyle(fontSize: 11),),
                              ),
                            )
                        ),
                      if(['waterMeter','TopTankHigh','TopTankLow','SumpTankHigh','SumpTankLow'].contains(myList[i]['map'][j]['connection']))
                        Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(right: const BorderSide(width: 1),top: BorderSide(width: j == 0 ? 1 : 0))
                              ),
                              height: 40,
                              child: Center(
                                child: MyDropDown(initialValue: '${myList[i]['map'][j]['rfNo']}', split: true,itemList: getrefNoForOthers(configPvd,'${myList[i]['map'][j]['rtu']}',{'pump' : 'irrigationPump','count' : i}), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rfNo', index: -1),
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
                                child: Text('${myList[i]['map'][j]['rfNo']}',style: const TextStyle(fontSize: 11),),
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
                              child: ['TopTankHigh','TopTankLow','SumpTankHigh','SumpTankLow'].contains(myList[i]['map'][j]['connection']) ? Text('${myList[i]['map'][j]['input_type']}') : MyDropDown(initialValue: '${myList[i]['map'][j]['input_type']}', itemList: getInputList(myList[i]['map'][j]['rtu'],myList[i]['map'][j]['rfNo']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/input_type', index: -1),
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
                              child: MyDropDown(initialValue: '${myList[i]['map'][j]['input']}', itemList: getInPut(configPvd,'${myList[i]['map'][j]['rtu']}','${myList[i]['map'][j]['rfNo']}','${myList[i]['map'][j]['input']}',myList[i]['map'][j]['count'],myList[i]['map'][j]['input_type']),
                                  pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/input', index: -1),
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
                        child: notAvailable,
                      )
                    ],
                  ),
                )
            );
          }
        }

      }

    }
    return widgetList;
  }
  List<Widget> getAnalogSensor(List<Map<String,dynamic>> myList,ConfigMakerProvider configPvd){
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
                          child: (myList[i]['map'][j]['name'].contains('TNK FLT') || myList[i]['map'][j]['name'].contains('Manual Btn') || myList[i]['map'][j]['name'].contains('Lower Tank') || myList[i]['map'][j]['name'].contains('Upper Tank'))
                              ? Text('${myList[i]['map'][j]['input_type']}')
                              :MyDropDown(initialValue: '${myList[i]['map'][j]['input_type']}', itemList: getInputList(myList[i]['map'][j]['rtu'],myList[i]['map'][j]['rfNo']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/input_type', index: -1),
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
                          child: MyDropDown(initialValue: '${myList[i]['map'][j]['input']}', itemList: getInPut(configPvd,'${myList[i]['map'][j]['rtu']}','${myList[i]['map'][j]['rfNo']}','${myList[i]['map'][j]['input']}',myList[i]['map'][j]['count'],myList[i]['map'][j]['input_type']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/input', index: -1),
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
                          myList[i]['deleteFunction'](j);
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
  List<Widget> getContact(List<Map<String,dynamic>> myList,ConfigMakerProvider configPvd){
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
                          child: MyDropDown(initialValue: '${myList[i]['map'][j]['input_type']}', itemList: getInputList(myList[i]['map'][j]['rtu'],myList[i]['map'][j]['rfNo']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/input_type', index: -1),
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
                          child: MyDropDown(initialValue: '${myList[i]['map'][j]['input']}', itemList: getInPut(configPvd,'${myList[i]['map'][j]['rtu']}','${myList[i]['map'][j]['rfNo']}','${myList[i]['map'][j]['input']}',myList[i]['map'][j]['count'],myList[i]['map'][j]['input_type']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/input', index: -1),
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
                          myList[i]['deleteFunction'](j);
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
  List<Widget> getTemperature(List<Map<String,dynamic>> myList,ConfigMakerProvider configPvd){
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
                            child: myList[i]['map'][j]['name'].contains('Soil Temp')
                                ? MyDropDown(initialValue: '${myList[i]['map'][j]['rtu']}', itemList: getRtuName(configPvd,myList[i]['map'][j]['connection']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rtu', index: -1)
                                : (myList[i]['map'][j]['name'].contains('Temp ') || myList[i]['map'][j]['name'].contains('CO2 ') || myList[i]['map'][j]['name'].contains('humidity '))
                                ? Text('${myList[i]['map'][j]['rtu']}')
                                : MyDropDown(initialValue: '${myList[i]['map'][j]['rtu']}', itemList: getRtuName(configPvd,myList[i]['map'][j]['connection']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/rtu', index: -1)
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
                          child: (myList[i]['map'][j]['name'].contains('Temp ') || myList[i]['map'][j]['name'].contains('Soil Temp ') || myList[i]['map'][j]['name'].contains('CO2 ') || myList[i]['map'][j]['name'].contains('humidity ')) ? Text('${myList[i]['map'][j]['input_type']}') : MyDropDown(initialValue: '${myList[i]['map'][j]['input_type']}', itemList: getInputList(myList[i]['map'][j]['rtu'],myList[i]['map'][j]['rfNo']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/input_type', index: -1),
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
                          child: MyDropDown(initialValue: '${myList[i]['map'][j]['input']}', itemList: getInPut(configPvd,'${myList[i]['map'][j]['rtu']}','${myList[i]['map'][j]['rfNo']}','${myList[i]['map'][j]['input']}',myList[i]['map'][j]['count'],myList[i]['map'][j]['input_type'],myList[i]['map'][j]['name']), pvdName: '${myList[i]['map'][j]['type']}/$i/${myList[i]['map'][j]['connection']}/${myList[i]['map'][j]['count']}/input', index: -1),
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
                          myList[i]['deleteFunction'](j);
                          // if(myList[i]['map'][j]['connection'] == 'connCo2'){
                          //   configPvd.mappingOfInputsFunctionality(['co2Delete',j,]);
                          // }else if(myList[i]['map'][j]['connection'] == 'connHumidity'){
                          //   configPvd.mappingOfInputsFunctionality(['humidityDelete',j,]);
                          // }else if(myList[i]['map'][j]['connection'] == 'connTempSensor'){
                          //   configPvd.mappingOfInputsFunctionality(['temperatureDelete',j,]);
                          // }else if(myList[i]['map'][j]['connection'] == 'connSoilTempSensor'){
                          //   configPvd.mappingOfInputsFunctionality(['soilTemperatureDelete',j,]);
                          // }
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
  List<String> getInputList(rtu,rfNo,[name]){
    if(rtu == 'O-Smart-Plus'){
      return ['-','A-I','D-I','P-I'];
    }else if(rtu == 'ORO Smart'){
      return ['-','A-I'];
    }else if(rtu == 'ORO RTU'){
      return ['-','A-I'];
    }else if(rtu == 'O-RTU-Plus'){
      return ['-','A-I','M-I'];
    }else if(rtu == 'ORO Level'){
      return ['-','A-I','D-I'];
    }else if(rtu == 'ORO Sense'){
      return ['-','M-I','D-I','I2C'];
    }else if(rtu == 'O-Pump-Plus'){
      return ['-','A-I','D-I','P-I'];
    }else if(rtu == 'ORO Pump'){
      return ['-','A-I'];
    }else{
      return ['-'];
    }
  }
  List<String> getRtuName(ConfigMakerProvider configPvd,name){
    var list = ['-'];
    if(configPvd.oRtu.isNotEmpty){
      list.add('ORO RTU');
    }
    if(configPvd.oRtuPlus.isNotEmpty){
      list.add('O-RTU-Plus');
    }
    if(configPvd.oSrtu.isNotEmpty){
      print(configPvd.oSrtu);
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
    if(['water_meter','waterMeter'].contains(name)){
      list.remove('ORO Level');
      list.remove('ORO Pump');
      list.remove('ORO Switch');
      list.remove('ORO Smart');
      list.remove('ORO RTU');
      list.remove('O-RTU-Plus');
      list.remove('ORO Sense');
    }else if(['phConnection','ecConnection','pressureSwitch','pressureIn','pressureOut','dosingMeter','totalManualButton'].contains(name)){
      list.remove('ORO Level');
      list.remove('ORO Pump');
      list.remove('O-Pump-Plus');
      list.remove('ORO Switch');
      if(name != 'phConnection' && name != 'pressureIn' && name != 'pressureOut'){
        list.remove('ORO Smart');
      }
      if(name != 'pressureIn' && name != 'pressureOut'){
        list.remove('ORO RTU');
      }
      list.remove('ORO Sense');
    }else if(['totalAnalogSensor'].contains(name)){
      list.remove('ORO Pump');
      list.remove('ORO Switch');
      list.remove('ORO Smart');
      list.remove('ORO RTU');
    }else if(['totalTankFloat'].contains(name)){
      list.remove('ORO Pump');
      list.remove('O-Pump-Plus');
      list.remove('ORO Switch');
      list.remove('ORO Smart');
      list.remove('ORO RTU');
      list.remove('O-RTU-Plus');
      list.remove('ORO Sense');
    }else if(['levelSensorConnection','levelSensor','injector-levelSensor','TopTankHigh','TopTankLow','SumpTankHigh','SumpTankLow'].contains(name)){
      list.remove('ORO Sense');
      list.remove('ORO Pump');
      list.remove('ORO Switch');
      list.remove('ORO RTU');
      list.remove('ORO Smart');
      list.remove('O-RTU-Plus');
    }else if(['moistureSensorConnection','connCo2','connTempSensor','connSoilTempSensor','connHumidity'].contains(name)){
      list.remove('ORO Level');
      list.remove('ORO Pump');
      list.remove('O-Pump-Plus');
      list.remove('ORO Switch');
      list.remove('ORO Smart');
      list.remove('O-Smart-Plus');
      list.remove('ORO RTU');
    }else if(['powerSupply'].contains(name)){
      list.remove('ORO Pump');
      list.remove('ORO Switch');
      list.remove('ORO Smart');
      list.remove('ORO RTU');
      list.remove('O-RTU-Plus');
      list.remove('O-Pump-Plus');
      list.remove('ORO Level');
    }else if(['totalLowerTankLevelSensor','totalUpperTankLevelSensor'].contains(name)){
      list.remove('ORO Pump');
      list.remove('ORO Switch');
      list.remove('ORO RTU');
      list.remove('O-RTU-Plus');
      list.remove('O-Pump-Plus');
      list.remove('ORO Sense');
    }
    return list;
  }
  List<String> getrefNoForOthers(ConfigMakerProvider configPvd,String title,[dynamic oroPump]){
    List<String> myList = ['-'];
    if(title == 'ORO Smart'){
      for(var i = 0;i < configPvd.oSrtu.length;i++){
        myList.add('${configPvd.oSrtu[i]}\n${configPvd.oSrtuMac[i]}');
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
    }else if(title == 'ORO Level'){
      for(var i = 0;i < configPvd.oLevel.length;i++){
        myList.add('${configPvd.oLevel[i]}\n${configPvd.oLevelMac[i]}');
      }
    }
    return myList;
  }
  List<String> filterInPut(List<dynamic> data,String rtu,String rf,String input){
    List<String> list = [];
    for(var i in data){
      if((i['rtu'] == rtu) && (i['rfNo'] == rf)){
        if(i['input'] != '-' && input != i['input']){
          list.add(i['input']);
        }
      }
    }
    return list;
  }
  List<String> getInPut(ConfigMakerProvider configPvd,String rtu, String rf, String input,int index,String inputType,[String? name]) {
    List<String> myList = [];
    List<String> filterList = [];
   if(rtu == 'O-RTU-Plus'){
     if(inputType == 'A-I'){
       for(var i = 0;i < 4;i++){
         myList.add('A-${i+1}');
       }
     }
     if(inputType == 'M-I'){
       for(var i = 0;i < 4;i++){
         myList.add('M-${i+1}');
       }
     }
     if(inputType == 'D-I'){
       myList.add('D-1');
     }
    }else if(rtu == 'O-Pump-Plus'){
     if(inputType == 'A-I'){
       for(var i = 0;i < 5;i++){
         myList.add('A-${i+1}');
       }
     }else if(inputType == 'D-I'){
       for(var i = 0;i < 6;i++){
         myList.add('D-${i+1}');
       }
     }else if(inputType == 'P-I'){
       myList.add('PI-1');
     }
    }else if(rtu == 'ORO Pump'){
     if(inputType == 'A-I'){
       for(var i = 0;i < 3;i++){
         myList.add('A-${i+1}');
       }
     }
   }else if(rtu == 'ORO Sense'){
     if(inputType == 'M-I'){
       for(var i = 0;i < 4;i++){
         myList.add('M-${i+1}');
       }
     }else if(inputType == 'D-I'){
       myList.add('D-1');

     }else if(inputType == 'I2C'){
       for(var i = 0;i < 3;i++){
         myList.add('I2C-${i+1}');
       }
     }
    }else if(rtu == 'O-Smart-Plus'){
     if(inputType == 'A-I'){
       for(var i = 0;i < 8;i++){
         myList.add('A-${i+1}');
       }
     }else if(inputType == 'D-I'){
       for(var i = 0;i < 5;i++){
         myList.add('D-${i+1}');
       }
     }else if(inputType == 'P-I'){
       myList.add('PI-1');
     }
    }else if(rtu == 'ORO Smart'){
     if(inputType == 'A-I'){
       for(var i = 0;i < 3;i++){
         myList.add('A-${i+1}');
       }
     }
   }else if(rtu == 'ORO RTU'){
     if(inputType == 'A-I'){
       for(var i = 0;i < 4;i++){
         myList.add('A-${i+1}');
       }
     }
   }else if(rtu == 'ORO Level'){
     if(inputType == 'A-I'){
       for(var i = 0;i < 4;i++){
         myList.add('A-${i+1}');
       }
     }else if(inputType == 'D-I'){
       for(var i = 0;i < 6;i++){
         myList.add('D-${i+1}');
       }
     }
    }

    if(rtu != '-' && rf != '-'){
      for(var i in configPvd.sourcePumpUpdated){

        if(i['waterMeter'].isNotEmpty){
          filterList.addAll(filterInPut([i['waterMeter']],rtu,rf,input));
        }
        if(i['levelSensor'].isNotEmpty){
          filterList.addAll(filterInPut([i['levelSensor']],rtu,rf,input));
        }
        if(i['pressureSensor'].isNotEmpty){
          filterList.addAll(filterInPut([i['pressureSensor']],rtu,rf,input));
        }
        if(i['TopTankHigh'] != null){
          if(i['TopTankHigh'].isNotEmpty){
            filterList.addAll(filterInPut([i['TopTankHigh']],rtu,rf,input));
          }
        }
        if(i['TopTankLow'] != null){
          if(i['TopTankLow'].isNotEmpty){
            filterList.addAll(filterInPut([i['TopTankLow']],rtu,rf,input));
          }
        }
        if(i['SumpTankHigh'] != null){
          if(i['SumpTankHigh'].isNotEmpty){
            filterList.addAll(filterInPut([i['SumpTankHigh']],rtu,rf,input));
          }
        }
        if(i['SumpTankLow'] != null){
          if(i['SumpTankLow'].isNotEmpty){
            filterList.addAll(filterInPut([i['SumpTankLow']],rtu,rf,input));
          }
        }

      }
      for(var i in configPvd.irrigationPumpUpdated){
        if(i['waterMeter'].isNotEmpty){
          filterList.addAll(filterInPut([i['waterMeter']],rtu,rf,input));
        }
        if(i['levelSensor'].isNotEmpty){
          filterList.addAll(filterInPut([i['levelSensor']],rtu,rf,input));
        }
        if(i['pressureSensor'].isNotEmpty){
          filterList.addAll(filterInPut([i['pressureSensor']],rtu,rf,input));
        }
        if(i['TopTankHigh'] != null){
          if(i['TopTankHigh'].isNotEmpty){
            filterList.addAll(filterInPut([i['TopTankHigh']],rtu,rf,input));
          }
        }
        if(i['TopTankLow'] != null){
          if(i['TopTankLow'].isNotEmpty){
            filterList.addAll(filterInPut([i['TopTankLow']],rtu,rf,input));
          }
        }
        if(i['SumpTankHigh'] != null){
          if(i['SumpTankHigh'].isNotEmpty){
            filterList.addAll(filterInPut([i['SumpTankHigh']],rtu,rf,input));
          }
        }
        if(i['SumpTankLow'] != null){
          if(i['SumpTankLow'].isNotEmpty){
            filterList.addAll(filterInPut([i['SumpTankLow']],rtu,rf,input));
          }
        }
        if(i['c1'] != null){
          if(i['c1'].isNotEmpty){
            filterList.addAll(filterInPut([i['c1']],rtu,rf,input));
          }
        }
        if(i['c2'] != null){
          if(i['c2'].isNotEmpty){
            filterList.addAll(filterInPut([i['c2']],rtu,rf,input));
          }
        }
        if(i['c3'] != null){
          if(i['c3'].isNotEmpty){
            filterList.addAll(filterInPut([i['c3']],rtu,rf,input));
          }
        }
      }
      for(var i in configPvd.centralFiltrationUpdated){
        filterList.addAll(filterInPut([i['pressureIn']],rtu,rf,input));
        filterList.addAll(filterInPut([i['pressureOut']],rtu,rf,input));
        filterList.addAll(filterInPut([i['pressureSwitch']],rtu,rf,input));
        filterList.addAll(filterInPut([i['diffPressureSensor']],rtu,rf,input));
      }

      for(var i in configPvd.centralDosingUpdated){
        filterList.addAll(filterInPut(i['ecConnection'],rtu,rf,input));
        filterList.addAll(filterInPut(i['phConnection'],rtu,rf,input));
        filterList.addAll(filterInPut([i['pressureSwitch']],rtu,rf,input));
        for(var j in i['injector']){
          if(j['dosingMeter'].isNotEmpty){
            filterList.addAll(filterInPut([j['dosingMeter']],rtu,rf,input));
          }
          if(j['levelSensor'].isNotEmpty){
            filterList.addAll(filterInPut([j['levelSensor']],rtu,rf,input));
          }
        }
      }
      for(var i in configPvd.irrigationLines){
        filterList.addAll(filterInPut(i['moistureSensorConnection'],rtu,rf,input));
        filterList.addAll(filterInPut(i['levelSensorConnection'],rtu,rf,input));
        filterList.addAll(filterInPut([i['pressureIn']],rtu,rf,input));
        filterList.addAll(filterInPut([i['pressureOut']],rtu,rf,input));
        filterList.addAll(filterInPut([i['water_meter']],rtu,rf,input));
        filterList.addAll(filterInPut([i['powerSupply']],rtu,rf,input));
        filterList.addAll(filterInPut([i['pressureSwitch']],rtu,rf,input));
      }
      filterList.addAll(filterInPut(configPvd.totalAnalogSensor,rtu,rf,input));
      filterList.addAll(filterInPut(configPvd.totalCommonPressureSensor,rtu,rf,input));
      filterList.addAll(filterInPut(configPvd.totalCommonPressureSwitch,rtu,rf,input));
      filterList.addAll(filterInPut(configPvd.totalTankFloat,rtu,rf,input));
      filterList.addAll(filterInPut(configPvd.totalManualButton,rtu,rf,input));
      filterList.addAll(filterInPut(configPvd.totalLowerTankLevelSensor,rtu,rf,input));
      filterList.addAll(filterInPut(configPvd.totalUpperTankLevelSensor,rtu,rf,input));
      filterList.addAll(filterInPut(configPvd.totalContact,rtu,rf,input));
      filterList.addAll(filterInPut(configPvd.connTempSensor,rtu,rf,input));
      filterList.addAll(filterInPut(configPvd.connSoilTempSensor,rtu,rf,input));
      filterList.addAll(filterInPut(configPvd.connHumidity,rtu,rf,input));
      filterList.addAll(filterInPut(configPvd.connLdr,rtu,rf,input));
      filterList.addAll(filterInPut(configPvd.connLux,rtu,rf,input));
      filterList.addAll(filterInPut(configPvd.connLeafWetness,rtu,rf,input));
      filterList.addAll(filterInPut(configPvd.connWindSpeed,rtu,rf,input));
      filterList.addAll(filterInPut(configPvd.connWindDirection,rtu,rf,input));
      filterList.addAll(filterInPut(configPvd.connCo2,rtu,rf,input));
      filterList.addAll(filterInPut(configPvd.totalCommonPressureSensor,rtu,rf,input));
      for(var i in configPvd.localDosingUpdated){
        filterList.addAll(filterInPut(i['ecConnection'],rtu,rf,input));
        filterList.addAll(filterInPut(i['phConnection'],rtu,rf,input));
        filterList.addAll(filterInPut([i['pressureSwitch']],rtu,rf,input));
        for(var j in i['injector']){
          if(j['dosingMeter'].isNotEmpty){
            filterList.addAll(filterInPut([j['dosingMeter']],rtu,rf,input));
          }
          if(j['levelSensor'].isNotEmpty){
            filterList.addAll(filterInPut([j['levelSensor']],rtu,rf,input));
          }
        }
      }
      for(var i in configPvd.localFiltrationUpdated){
        filterList.addAll(filterInPut([i['pressureIn']],rtu,rf,input));
        filterList.addAll(filterInPut([i['pressureOut']],rtu,rf,input));
        filterList.addAll(filterInPut([i['pressureSwitch']],rtu,rf,input));
        filterList.addAll(filterInPut([i['diffPressureSensor']],rtu,rf,input));

      }
    }
    for(var i in filterList){
      if(myList.contains(i)){
        myList.remove(i);
      }
    }

    if(name != null){
      // if(name == 'Ec sensor 1'){
      //   if(!myList.contains('A-5') || !myList.contains('A-6')){
      //     myList = [];
      //   }else{
      //     myList.removeWhere((element) => element != 'A-7');
      //   }
      // }
      // else if(name == 'Ec sensor 2'){
      //   if(!myList.contains('A-5') || !myList.contains('A-6')){
      //     myList = [];
      //   }else{
      //     myList.removeWhere((element) => element != 'A-8');
      //   }
      // }
      // else if(name == 'Ph sensor 1'){
      //   if(rtu == 'ORO Smart'){
      //     var checkList = [];
      //     for(var central in configPvd.centralDosingUpdated){
      //       for(var ph in central['phConnection']){
      //         if(ph['rtu'] == 'ORO Smart'){
      //           if(ph['rfNo'] == rf){
      //             checkList.add(ph['input']);
      //           }
      //         }
      //       }
      //     }
      //     for(var local in configPvd.localDosingUpdated){
      //       for(var ph in local['phConnection']){
      //         if(ph['rtu'] == 'ORO Smart'){
      //           if(ph['rfNo'] == rf){
      //             checkList.add(ph['input']);
      //           }
      //         }
      //       }
      //     }
      //     if(checkList.contains('A-2') && !myList.contains('A-2')){
      //       myList.removeWhere((element) => element != 'A-1');
      //     }else{
      //       if(myList.contains('A-2')){
      //         myList.removeWhere((element) => element != 'A-1');
      //       }else{
      //         myList = [];
      //       }
      //     }
      //   }
      //   else{
      //     if(!myList.contains('A-7') || !myList.contains('A-8')){
      //       myList = [];
      //     }else{
      //       myList.removeWhere((element) => element != 'A-5');
      //     }
      //   }
      // }
      // else if(name == 'Ph sensor 2'){
      //   if(rtu == 'ORO Smart'){
      //     var checkList = [];
      //     for(var central in configPvd.centralDosingUpdated){
      //       for(var ph in central['phConnection']){
      //         if(ph['rtu'] == 'ORO Smart'){
      //           if(ph['rfNo'] == rf){
      //             checkList.add(ph['input']);
      //           }
      //         }
      //       }
      //     }
      //     for(var local in configPvd.localDosingUpdated){
      //       for(var ph in local['phConnection']){
      //         if(ph['rtu'] == 'ORO Smart'){
      //           if(ph['rfNo'] == rf){
      //             checkList.add(ph['input']);
      //           }
      //         }
      //       }
      //     }
      //     if(checkList.contains('A-1') && !myList.contains('A-1')){
      //       myList.removeWhere((element) => element != 'A-2');
      //     }else{
      //       if(myList.contains('A-1')){
      //         myList.removeWhere((element) => element != 'A-2');
      //       }else{
      //         myList = [];
      //       }
      //     }
      //   }
      //   else{
      //     if(!myList.contains('A-7') || !myList.contains('A-8')){
      //       myList = [];
      //     }else{
      //       myList.removeWhere((element) => element != 'A-6');
      //     }
      //   }
      //
      // }
      // else
      print('myList ::::: ${myList}');
        if(name == 'powerSupply '){
        myList.removeWhere((element) => element != 'A-8');
      }
      else if(name == 'pressureSwitch '){
        myList.removeWhere((element) => element != 'D-5');
      }
      else if(name.contains('Temp')){
        if(myList.contains('I2C-3')){
          myList = ['I2C-3'];
        }else if(myList.contains('D-1')){
          myList = ['D-1'];
        }else{
          myList = [];
        }
      }
      else if(name.contains('CO2')){
        myList.removeWhere((element) => element != 'I2C-1');
      }
      else if(name.contains('humidity')){
        myList.removeWhere((element) => element != 'I2C-2');
      }
      else if(name.contains('level Sensor')){
        myList.removeWhere((element) => element != 'A-2');
      }
      else if(name.contains('pressure Sensor')){
        myList.removeWhere((element) => element != 'A-1');
      }
      else{
        if(rtu != 'O-Pump-Plus'){
          // for(var i in ['D-5','A-5','A-6','A-7','A-8','A-9']){
          //   myList.remove(i);
          // }
        }
      }
    }else{
      if(rtu == 'O-Smart-Plus'){
        for(var i in ['D-5','A-5','A-6','A-7','A-8']){
          myList.remove(i);
        }
      }
    }
    myList.insert(0, '-');
    return rf == '-' ? ['-'] : myList;
  }

  List<Map<String,dynamic>> irrigationLine(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    for(var i = 0;i < configPvd.irrigationLines.length;i++){
      if(configPvd.irrigationLines[i]['deleted'] == false){
        myList.add(
            {
              'name' : 'Irrigation Line ${i+1}',
              'map' : [],
            }
        );
        for(var moistureSenor = 0;moistureSenor < configPvd.irrigationLines[i]['moistureSensorConnection'].length;moistureSenor++){
          myList[i]['map'].add(
              {
                'name' : 'moisture sensor',
                'type' : 'm_i_line',
                'line' : i,
                'index' : i,
                'count' : moistureSenor,
                'connection' : 'moistureSensorConnection',
                'sNo' :  configPvd.irrigationLines[i]['moistureSensorConnection'][moistureSenor]['sNo'],
                'rtu' :  configPvd.irrigationLines[i]['moistureSensorConnection'][moistureSenor]['rtu'],
                'rfNo' : configPvd.irrigationLines[i]['moistureSensorConnection'][moistureSenor]['rfNo'],
                'input' : configPvd.irrigationLines[i]['moistureSensorConnection'][moistureSenor]['input'],
                'input_type' : configPvd.irrigationLines[i]['moistureSensorConnection'][moistureSenor]['input_type'],
                'deleted' : configPvd.irrigationLines[i]['deleted'],
              }
          );
        }
        for(var levelSenor = 0;levelSenor < configPvd.irrigationLines[i]['levelSensorConnection'].length;levelSenor++){
          myList[i]['map'].add(
              {
                'name' : 'level sensor',
                'type' : 'm_i_line',
                'line' : i,
                'index' : i,
                'count' : levelSenor,
                'connection' : 'levelSensorConnection',
                'sNo' :  configPvd.irrigationLines[i]['levelSensorConnection'][levelSenor]['sNo'],
                'rtu' :  configPvd.irrigationLines[i]['levelSensorConnection'][levelSenor]['rtu'],
                'rfNo' : configPvd.irrigationLines[i]['levelSensorConnection'][levelSenor]['rfNo'],
                'input' : configPvd.irrigationLines[i]['levelSensorConnection'][levelSenor]['input'],
                'input_type' : configPvd.irrigationLines[i]['levelSensorConnection'][levelSenor]['input_type'],
                'deleted' : configPvd.irrigationLines[i]['deleted'],
              }
          );
        }
        if(configPvd.irrigationLines[i]['pressureIn'].isNotEmpty){
          myList[i]['map'].add(
              {
                'name' : 'Press In',
                'type' : 'm_i_line',
                'line' : i,
                'index' : i,
                'count' : -1,
                'connection' : 'pressureIn',
                'sNo' :  configPvd.irrigationLines[i]['pressureIn']['sNo'],
                'rtu' :  configPvd.irrigationLines[i]['pressureIn']['rtu'],
                'rfNo' : configPvd.irrigationLines[i]['pressureIn']['rfNo'],
                'input' : configPvd.irrigationLines[i]['pressureIn']['input'],
                'input_type' : configPvd.irrigationLines[i]['pressureIn']['input_type'],
                'deleted' : configPvd.irrigationLines[i]['deleted'],
              }
          );
        }
        if(configPvd.irrigationLines[i]['pressureOut'].isNotEmpty){
          myList[i]['map'].add(
              {
                'name' : 'Press Out',
                'type' : 'm_i_line',
                'line' : i,
                'index' : i,
                'count' : -1,
                'connection' : 'pressureOut',
                'sNo' :  configPvd.irrigationLines[i]['pressureOut']['sNo'],
                'rtu' :  configPvd.irrigationLines[i]['pressureOut']['rtu'],
                'rfNo' : configPvd.irrigationLines[i]['pressureOut']['rfNo'],
                'input' : configPvd.irrigationLines[i]['pressureOut']['input'],
                'input_type' : configPvd.irrigationLines[i]['pressureOut']['input_type'],
                'deleted' : configPvd.irrigationLines[i]['deleted'],

              }
          );
        }
        if(configPvd.irrigationLines[i]['water_meter'].isNotEmpty){
          myList[i]['map'].add(
              {
                'name' : 'water meter',
                'type' : 'm_i_line',
                'line' : i,
                'index' : i,
                'count' : -1,
                'connection' : 'water_meter',
                'sNo' :  configPvd.irrigationLines[i]['water_meter']['sNo'],
                'rtu' :  configPvd.irrigationLines[i]['water_meter']['rtu'],
                'rfNo' : configPvd.irrigationLines[i]['water_meter']['rfNo'],
                'input' : configPvd.irrigationLines[i]['water_meter']['input'],
                'input_type' : configPvd.irrigationLines[i]['water_meter']['input_type'],
                'deleted' : configPvd.irrigationLines[i]['deleted'],
              }
          );
        }
        if(configPvd.irrigationLines[i]['powerSupply'].isNotEmpty){
          myList[i]['map'].add(
              {
                'name' : 'powerSupply',
                'type' : 'm_i_line',
                'line' : i,
                'index' : i,
                'count' : -1,
                'connection' : 'powerSupply',
                'sNo' :  configPvd.irrigationLines[i]['powerSupply']['sNo'],
                'rtu' :  configPvd.irrigationLines[i]['powerSupply']['rtu'],
                'rfNo' : configPvd.irrigationLines[i]['powerSupply']['rfNo'],
                'input' : configPvd.irrigationLines[i]['powerSupply']['input'],
                'input_type' : configPvd.irrigationLines[i]['powerSupply']['input_type'],
                'deleted' : configPvd.irrigationLines[i]['deleted'],
              }
          );
        }
        if(configPvd.irrigationLines[i]['pressureSwitch'].isNotEmpty){
          myList[i]['map'].add(
              {
                'name' : 'pressureSwitch',
                'type' : 'm_i_line',
                'line' : i,
                'index' : i,
                'count' : -1,
                'connection' : 'pressureSwitch',
                'sNo' :  configPvd.irrigationLines[i]['pressureSwitch']['sNo'],
                'rtu' :  configPvd.irrigationLines[i]['pressureSwitch']['rtu'],
                'rfNo' : configPvd.irrigationLines[i]['pressureSwitch']['rfNo'],
                'input' : configPvd.irrigationLines[i]['pressureSwitch']['input'],
                'input_type' : configPvd.irrigationLines[i]['pressureSwitch']['input_type'],
                'deleted' : configPvd.irrigationLines[i]['deleted'],
              }
          );
        }

        if(configPvd.irrigationLines[i]['Local_dosing_site'] == true){
          localDosing : for(var ld = 0;ld < configPvd.localDosingUpdated.length;ld++){
            if(configPvd.localDosingUpdated[ld]['sNo'] == configPvd.irrigationLines[i]['sNo']){
              for(var ec = 0;ec < configPvd.localDosingUpdated[ld]['ecConnection'].length;ec++){
                myList[i]['map'].add(
                    {
                      'name' : 'Ec sensor',
                      'type' : 'm_i_localDosing',
                      'line' : i,
                      'index' : ld,
                      'count' : ec,
                      'connection' : 'ecConnection',
                      'sNo' :  configPvd.localDosingUpdated[ld]['ecConnection'][ec]['sNo'],
                      'rtu' :  configPvd.localDosingUpdated[ld]['ecConnection'][ec]['rtu'],
                      'rfNo' : configPvd.localDosingUpdated[ld]['ecConnection'][ec]['rfNo'],
                      'input' : configPvd.localDosingUpdated[ld]['ecConnection'][ec]['input'],
                      'input_type' : configPvd.localDosingUpdated[ld]['ecConnection'][ec]['input_type'],
                      'deleted' : configPvd.irrigationLines[i]['deleted'],
                    }
                );
              }
              for(var ph = 0;ph < configPvd.localDosingUpdated[ld]['phConnection'].length;ph++){
                myList[i]['map'].add(
                    {
                      'name' : 'Ph sensor',
                      'type' : 'm_i_localDosing',
                      'line' : i,
                      'index' : ld,
                      'count' : ph,
                      'connection' : 'phConnection',
                      'sNo' :  configPvd.localDosingUpdated[ld]['phConnection'][ph]['sNo'],
                      'rtu' :  configPvd.localDosingUpdated[ld]['phConnection'][ph]['rtu'],
                      'rfNo' : configPvd.localDosingUpdated[ld]['phConnection'][ph]['rfNo'],
                      'input' : configPvd.localDosingUpdated[ld]['phConnection'][ph]['input'],
                      'input_type' : configPvd.localDosingUpdated[ld]['phConnection'][ph]['input_type'],
                      'deleted' : configPvd.irrigationLines[i]['deleted'],
                    }
                );
              }
              for(var inj = 0;inj < configPvd.localDosingUpdated[ld]['injector'].length;inj++){
                if(configPvd.localDosingUpdated[ld]['injector'][inj]['dosingMeter'].isNotEmpty){
                  myList[i]['map'].add(
                      {
                        'name' : 'dosing meter',
                        'type' : 'm_i_localDosing',
                        'line' : i,
                        'index' : ld,
                        'count' : inj,
                        'connection' : 'injector-dosingMeter',
                        'sNo' :  configPvd.localDosingUpdated[ld]['injector'][inj]['dosingMeter']['sNo'],
                        'rtu' :  configPvd.localDosingUpdated[ld]['injector'][inj]['dosingMeter']['rtu'],
                        'rfNo' : configPvd.localDosingUpdated[ld]['injector'][inj]['dosingMeter']['rfNo'],
                        'input' : configPvd.localDosingUpdated[ld]['injector'][inj]['dosingMeter']['input'],
                        'input_type' : configPvd.localDosingUpdated[ld]['injector'][inj]['dosingMeter']['input_type'],
                        'deleted' : configPvd.irrigationLines[i]['deleted'],
                      }
                  );
                }
              }
              if(configPvd.localDosingUpdated[ld]['pressureSwitch'].isNotEmpty){
                myList[i]['map'].add(
                    {
                      'name' : 'press switch',
                      'type' : 'm_i_localDosing',
                      'line' : i,
                      'index' : ld,
                      'count' : -1,
                      'connection' : 'pressureSwitch',
                      'sNo' :  configPvd.localDosingUpdated[ld]['pressureSwitch']['sNo'],
                      'rtu' :  configPvd.localDosingUpdated[ld]['pressureSwitch']['rtu'],
                      'rfNo' : configPvd.localDosingUpdated[ld]['pressureSwitch']['rfNo'],
                      'input' : configPvd.localDosingUpdated[ld]['pressureSwitch']['input'],
                      'input_type' : configPvd.localDosingUpdated[ld]['pressureSwitch']['input_type'],
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
              if(configPvd.localFiltrationUpdated[ld]['pressureIn'].isNotEmpty){
                myList[i]['map'].add(
                    {
                      'name' : 'press In',
                      'type' : 'm_i_localFiltration',
                      'line' : i,
                      'index' : ld,
                      'count' : -1,
                      'connection' : 'pressureIn',
                      'sNo' :  configPvd.localFiltrationUpdated[ld]['pressureIn']['sNo'],
                      'rtu' :  configPvd.localFiltrationUpdated[ld]['pressureIn']['rtu'],
                      'rfNo' : configPvd.localFiltrationUpdated[ld]['pressureIn']['rfNo'],
                      'input' : configPvd.localFiltrationUpdated[ld]['pressureIn']['input'],
                      'input_type' : configPvd.localFiltrationUpdated[ld]['pressureIn']['input_type'],
                      'deleted' : configPvd.irrigationLines[i]['deleted'],
                    }
                );
              }
              if(configPvd.localFiltrationUpdated[ld]['pressureOut'].isNotEmpty){
                myList[i]['map'].add(
                    {
                      'name' : 'press Out',
                      'type' : 'm_i_localFiltration',
                      'line' : i,
                      'index' : ld,
                      'count' : -1,
                      'connection' : 'pressureOut',
                      'sNo' :  configPvd.localFiltrationUpdated[ld]['pressureOut']['sNo'],
                      'rtu' :  configPvd.localFiltrationUpdated[ld]['pressureOut']['rtu'],
                      'rfNo' : configPvd.localFiltrationUpdated[ld]['pressureOut']['rfNo'],
                      'input' : configPvd.localFiltrationUpdated[ld]['pressureOut']['input'],
                      'input_type' : configPvd.localFiltrationUpdated[ld]['pressureOut']['input_type'],
                      'deleted' : configPvd.irrigationLines[i]['deleted'],
                    }
                );
              }
              if(configPvd.localFiltrationUpdated[ld]['pressureSwitch'].isNotEmpty){
                myList[i]['map'].add(
                    {
                      'name' : 'press switch',
                      'type' : 'm_i_localFiltration',
                      'line' : i,
                      'index' : ld,
                      'count' : -1,
                      'connection' : 'pressureSwitch',
                      'sNo' :  configPvd.localFiltrationUpdated[ld]['pressureSwitch']['sNo'],
                      'rtu' :  configPvd.localFiltrationUpdated[ld]['pressureSwitch']['rtu'],
                      'rfNo' : configPvd.localFiltrationUpdated[ld]['pressureSwitch']['rfNo'],
                      'input' : configPvd.localFiltrationUpdated[ld]['pressureSwitch']['input'],
                      'input_type' : configPvd.localFiltrationUpdated[ld]['pressureSwitch']['input_type'],
                      'deleted' : configPvd.irrigationLines[i]['deleted'],
                    }
                );
              }
              if(configPvd.localFiltrationUpdated[ld]['diffPressureSensor'].isNotEmpty){
                myList[i]['map'].add(
                    {
                      'name' : 'D.Press sensor',
                      'type' : 'm_i_localFiltration',
                      'line' : i,
                      'index' : ld,
                      'count' : -1,
                      'connection' : 'diffPressureSensor',
                      'sNo' :  configPvd.localFiltrationUpdated[ld]['diffPressureSensor']['sNo'],
                      'rtu' :  configPvd.localFiltrationUpdated[ld]['diffPressureSensor']['rtu'],
                      'rfNo' : configPvd.localFiltrationUpdated[ld]['diffPressureSensor']['rfNo'],
                      'input' : configPvd.localFiltrationUpdated[ld]['diffPressureSensor']['input'],
                      'input_type' : configPvd.localFiltrationUpdated[ld]['diffPressureSensor']['input_type'],
                      'deleted' : configPvd.irrigationLines[i]['deleted'],
                    }
                );
              }

              break localFiltration;
            }
          }
        }
      }

    }
    return myList;
  }

  List<Map<String,dynamic>> centralDosing(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    for(var i = 0;i < configPvd.centralDosingUpdated.length;i++){
      if(configPvd.centralDosingUpdated[i]['deleted'] == false){
        myList.add(
            {
              'name' : 'Central Dosing Site ${i+1}',
              'map' : [],
            }
        );
        for(var ec = 0;ec < configPvd.centralDosingUpdated[i]['ecConnection'].length;ec++){
          myList[i]['map'].add(
              {
                'name' : 'Ec sensor',
                'type' : 'm_i_centralDosing',
                'line' : i,
                'count' : ec,
                'connection' : 'ecConnection',
                'sNo' :  configPvd.centralDosingUpdated[i]['ecConnection'][ec]['sNo'],
                'rtu' :  configPvd.centralDosingUpdated[i]['ecConnection'][ec]['rtu'],
                'rfNo' : configPvd.centralDosingUpdated[i]['ecConnection'][ec]['rfNo'],
                'input' : configPvd.centralDosingUpdated[i]['ecConnection'][ec]['input'],
                'input_type' : configPvd.centralDosingUpdated[i]['ecConnection'][ec]['input_type'],
                'deleted' : configPvd.centralDosingUpdated[i]['deleted'],
              }
          );
        }
        for(var ph = 0;ph < configPvd.centralDosingUpdated[i]['phConnection'].length;ph++){
          myList[i]['map'].add(
              {
                'name' : 'Ph sensor',
                'type' : 'm_i_centralDosing',
                'line' : i,
                'count' : ph,
                'connection' : 'phConnection',
                'sNo' :  configPvd.centralDosingUpdated[i]['phConnection'][ph]['sNo'],
                'rtu' :  configPvd.centralDosingUpdated[i]['phConnection'][ph]['rtu'],
                'rfNo' : configPvd.centralDosingUpdated[i]['phConnection'][ph]['rfNo'],
                'input' : configPvd.centralDosingUpdated[i]['phConnection'][ph]['input'],
                'input_type' : configPvd.centralDosingUpdated[i]['phConnection'][ph]['input_type'],
                'deleted' : configPvd.centralDosingUpdated[i]['deleted'],
              }
          );
        }
        if(configPvd.centralDosingUpdated[i]['pressureSwitch'].isNotEmpty){
          myList[i]['map'].add(
              {
                'name' : 'press switch',
                'type' : 'm_i_centralDosing',
                'site' : i,
                'count' : -1,
                'connection' : 'pressureSwitch',
                'sNo' :  configPvd.centralDosingUpdated[i]['pressureSwitch']['sNo'],
                'rtu' :  configPvd.centralDosingUpdated[i]['pressureSwitch']['rtu'],
                'rfNo' : configPvd.centralDosingUpdated[i]['pressureSwitch']['rfNo'],
                'input' : configPvd.centralDosingUpdated[i]['pressureSwitch']['input'],
                'input_type' : configPvd.centralDosingUpdated[i]['pressureSwitch']['input_type'],
                'deleted' : configPvd.centralDosingUpdated[i]['deleted'],
              }
          );
        }
        for(var inj = 0;inj < configPvd.centralDosingUpdated[i]['injector'].length;inj++){
          if(configPvd.centralDosingUpdated[i]['injector'][inj]['dosingMeter'].isNotEmpty){
            myList[i]['map'].add(
                {
                  'name' : 'dosing meter',
                  'type' : 'm_i_centralDosing',
                  'site' : i,
                  'count' : inj,
                  'connection' : 'injector-dosingMeter',
                  'sNo' :  configPvd.centralDosingUpdated[i]['injector'][inj]['dosingMeter']['sNo'],
                  'rtu' :  configPvd.centralDosingUpdated[i]['injector'][inj]['dosingMeter']['rtu'],
                  'rfNo' : configPvd.centralDosingUpdated[i]['injector'][inj]['dosingMeter']['rfNo'],
                  'input' : configPvd.centralDosingUpdated[i]['injector'][inj]['dosingMeter']['input'],
                  'input_type' : configPvd.centralDosingUpdated[i]['injector'][inj]['dosingMeter']['input_type'],
                  'deleted' : configPvd.centralDosingUpdated[i]['deleted'],
                }
            );
          }
        }
        for(var inj = 0;inj < configPvd.centralDosingUpdated[i]['injector'].length;inj++){
          if(configPvd.centralDosingUpdated[i]['injector'][inj]['levelSensor'].isNotEmpty){
            myList[i]['map'].add(
                {
                  'name' : 'level sensor',
                  'type' : 'm_i_centralDosing',
                  'site' : i,
                  'count' : inj,
                  'connection' : 'injector-levelSensor',
                  'sNo' :  configPvd.centralDosingUpdated[i]['injector'][inj]['levelSensor']['sNo'],
                  'rtu' :  configPvd.centralDosingUpdated[i]['injector'][inj]['levelSensor']['rtu'],
                  'rfNo' : configPvd.centralDosingUpdated[i]['injector'][inj]['levelSensor']['rfNo'],
                  'input' : configPvd.centralDosingUpdated[i]['injector'][inj]['levelSensor']['input'],
                  'input_type' : configPvd.centralDosingUpdated[i]['injector'][inj]['levelSensor']['input_type'],
                  'deleted' : configPvd.centralDosingUpdated[i]['deleted'],
                }
            );
          }
        }
      }


    }
    return myList;
  }
  List<Map<String,dynamic>> centralFiltration(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    for(var i = 0;i < configPvd.centralFiltrationUpdated.length;i++){
      if(configPvd.centralFiltrationUpdated[i]['deleted'] == false){
        myList.add(
            {
              'name' : 'Central Filtration Site ${i+1}',
              'map' : [],
            }
        );
        if(configPvd.centralFiltrationUpdated[i]['pressureIn'].isNotEmpty){
          myList[i]['map'].add(
              {
                'name' : 'press In',
                'type' : 'm_i_centralFiltration',
                'site' : i,
                'count' : -1,
                'connection' : 'pressureIn',
                'sNo' :  configPvd.centralFiltrationUpdated[i]['pressureIn']['sNo'],
                'rtu' :  configPvd.centralFiltrationUpdated[i]['pressureIn']['rtu'],
                'rfNo' : configPvd.centralFiltrationUpdated[i]['pressureIn']['rfNo'],
                'input' : configPvd.centralFiltrationUpdated[i]['pressureIn']['input'],
                'input_type' : configPvd.centralFiltrationUpdated[i]['pressureIn']['input_type'],
                'deleted' : configPvd.centralFiltrationUpdated[i]['deleted'],
              }
          );
        }
        if(configPvd.centralFiltrationUpdated[i]['pressureOut'].isNotEmpty){
          myList[i]['map'].add(
              {
                'name' : 'press Out',
                'type' : 'm_i_centralFiltration',
                'site' : i,
                'count' : -1,
                'connection' : 'pressureOut',
                'sNo' :  configPvd.centralFiltrationUpdated[i]['pressureOut']['sNo'],
                'rtu' :  configPvd.centralFiltrationUpdated[i]['pressureOut']['rtu'],
                'rfNo' : configPvd.centralFiltrationUpdated[i]['pressureOut']['rfNo'],
                'input' : configPvd.centralFiltrationUpdated[i]['pressureOut']['input'],
                'input_type' : configPvd.centralFiltrationUpdated[i]['pressureOut']['input_type'],
                'deleted' : configPvd.centralFiltrationUpdated[i]['deleted'],
              }
          );
        }
        if(configPvd.centralFiltrationUpdated[i]['pressureSwitch'].isNotEmpty){
          myList[i]['map'].add(
              {
                'name' : 'press switch',
                'type' : 'm_i_centralFiltration',
                'site' : i,
                'count' : -1,
                'connection' : 'pressureSwitch',
                'sNo' :  configPvd.centralFiltrationUpdated[i]['pressureSwitch']['sNo'],
                'rtu' :  configPvd.centralFiltrationUpdated[i]['pressureSwitch']['rtu'],
                'rfNo' : configPvd.centralFiltrationUpdated[i]['pressureSwitch']['rfNo'],
                'input' : configPvd.centralFiltrationUpdated[i]['pressureSwitch']['input'],
                'input_type' : configPvd.centralFiltrationUpdated[i]['pressureSwitch']['input_type'],
                'deleted' : configPvd.centralFiltrationUpdated[i]['deleted'],
              }
          );
        }
        if(configPvd.centralFiltrationUpdated[i]['diffPressureSensor'].isNotEmpty){
          myList[i]['map'].add(
              {
                'name' : 'D.Press sensor',
                'type' : 'm_i_centralFiltration',
                'site' : i,
                'count' : -1,
                'connection' : 'diffPressureSensor',
                'sNo' :  configPvd.centralFiltrationUpdated[i]['diffPressureSensor']['sNo'],
                'rtu' :  configPvd.centralFiltrationUpdated[i]['diffPressureSensor']['rtu'],
                'rfNo' : configPvd.centralFiltrationUpdated[i]['diffPressureSensor']['rfNo'],
                'input' : configPvd.centralFiltrationUpdated[i]['diffPressureSensor']['input'],
                'input_type' : configPvd.centralFiltrationUpdated[i]['diffPressureSensor']['input_type'],
                'deleted' : configPvd.centralFiltrationUpdated[i]['deleted'],
              }
          );
        }
      }
    }
    return myList;
  }
  List<Map<String,dynamic>> sourcePump(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    int nonDeletedPump = configPvd.sourcePumpUpdated.where((pump) => pump['deleted'] == false).length;
    for(var i = 0;i < nonDeletedPump;i++){
      if(configPvd.sourcePumpUpdated[i]['deleted'] == false){
        myList.add(
            {
              'name' : 'Source Pump ${i+1}',
              'map' : [],
            }
        );
        int mapIndex = myList.length - 1;
        if(configPvd.sourcePumpUpdated[i]['waterMeter'].isNotEmpty){
          myList[mapIndex]['map'].add(
              {
                'oroPump' : (configPvd.sourcePumpUpdated[i]['oro_pump'] == true || configPvd.sourcePumpUpdated[i]['oro_pump_plus'] == true) ? true : false,
                'name' : 'water meter',
                'type' : 'm_i_sourcePump',
                'pump' : i,
                'count' : -1,
                'connection' : 'waterMeter',
                'sNo' :  configPvd.sourcePumpUpdated[i]['waterMeter']['sNo'],
                'rtu' :  configPvd.sourcePumpUpdated[i]['waterMeter']['rtu'],
                'rfNo' : configPvd.sourcePumpUpdated[i]['waterMeter']['rfNo'],
                'input' : configPvd.sourcePumpUpdated[i]['waterMeter']['input'],
                'input_type' : configPvd.sourcePumpUpdated[i]['waterMeter']['input_type'],
                'deleted' : configPvd.sourcePumpUpdated[i]['deleted'],
              }
          );
        }
        if(configPvd.sourcePumpUpdated[i]['TopTankHigh'] != null){
          if(configPvd.sourcePumpUpdated[i]['TopTankHigh'].isNotEmpty){
            myList[mapIndex]['map'].add(
                {
                  'oroPump' : (configPvd.sourcePumpUpdated[i]['oro_pump'] == true || configPvd.sourcePumpUpdated[i]['oro_pump_plus'] == true) ? true : false,
                  'name' : 'Tt high',
                  'type' : 'm_i_sourcePump',
                  'pump' : i,
                  'count' : -1,
                  'connection' : 'TopTankHigh',
                  'sNo' :  configPvd.sourcePumpUpdated[i]['TopTankHigh']['sNo'],
                  'rtu' :  configPvd.sourcePumpUpdated[i]['TopTankHigh']['rtu'],
                  'rfNo' : configPvd.sourcePumpUpdated[i]['TopTankHigh']['rfNo'],
                  'input' : configPvd.sourcePumpUpdated[i]['TopTankHigh']['input'],
                  'input_type' : configPvd.sourcePumpUpdated[i]['TopTankHigh']['input_type'],
                  'deleted' : configPvd.sourcePumpUpdated[i]['deleted'],
                }
            );
          }
        }
        if(configPvd.sourcePumpUpdated[i]['TopTankLow'] != null){
          if(configPvd.sourcePumpUpdated[i]['TopTankLow'].isNotEmpty){
            myList[mapIndex]['map'].add(
                {
                  'oroPump' : (configPvd.sourcePumpUpdated[i]['oro_pump'] == true || configPvd.sourcePumpUpdated[i]['oro_pump_plus'] == true) ? true : false,
                  'name' : 'Tt low',
                  'type' : 'm_i_sourcePump',
                  'pump' : i,
                  'count' : -1,
                  'connection' : 'TopTankLow',
                  'sNo' :  configPvd.sourcePumpUpdated[i]['TopTankLow']['sNo'],
                  'rtu' :  configPvd.sourcePumpUpdated[i]['TopTankLow']['rtu'],
                  'rfNo' : configPvd.sourcePumpUpdated[i]['TopTankLow']['rfNo'],
                  'input' : configPvd.sourcePumpUpdated[i]['TopTankLow']['input'],
                  'input_type' : configPvd.sourcePumpUpdated[i]['TopTankLow']['input_type'],
                  'deleted' : configPvd.sourcePumpUpdated[i]['deleted'],
                }
            );
          }
        }
        if(configPvd.sourcePumpUpdated[i]['SumpTankHigh'] != null){
          if(configPvd.sourcePumpUpdated[i]['SumpTankHigh'].isNotEmpty){
            myList[mapIndex]['map'].add(
                {
                  'oroPump' : (configPvd.sourcePumpUpdated[i]['oro_pump'] == true || configPvd.sourcePumpUpdated[i]['oro_pump_plus'] == true) ? true : false,
                  'name' : 'St high',
                  'type' : 'm_i_sourcePump',
                  'pump' : i,
                  'count' : -1,
                  'connection' : 'SumpTankHigh',
                  'sNo' :  configPvd.sourcePumpUpdated[i]['SumpTankHigh']['sNo'],
                  'rtu' :  configPvd.sourcePumpUpdated[i]['SumpTankHigh']['rtu'],
                  'rfNo' : configPvd.sourcePumpUpdated[i]['SumpTankHigh']['rfNo'],
                  'input' : configPvd.sourcePumpUpdated[i]['SumpTankHigh']['input'],
                  'input_type' : configPvd.sourcePumpUpdated[i]['SumpTankHigh']['input_type'],
                  'deleted' : configPvd.sourcePumpUpdated[i]['deleted'],
                }
            );
          }
        }
        if(configPvd.sourcePumpUpdated[i]['SumpTankLow'] != null){
          if(configPvd.sourcePumpUpdated[i]['SumpTankLow'].isNotEmpty){
            myList[mapIndex]['map'].add(
                {
                  'oroPump' : (configPvd.sourcePumpUpdated[i]['oro_pump'] == true || configPvd.sourcePumpUpdated[i]['oro_pump_plus'] == true) ? true : false,
                  'name' : 'St low',
                  'type' : 'm_i_sourcePump',
                  'pump' : i,
                  'count' : -1,
                  'connection' : 'SumpTankLow',
                  'sNo' :  configPvd.sourcePumpUpdated[i]['SumpTankLow']['sNo'],
                  'rtu' :  configPvd.sourcePumpUpdated[i]['SumpTankLow']['rtu'],
                  'rfNo' : configPvd.sourcePumpUpdated[i]['SumpTankLow']['rfNo'],
                  'input' : configPvd.sourcePumpUpdated[i]['SumpTankLow']['input'],
                  'input_type' : configPvd.sourcePumpUpdated[i]['SumpTankLow']['input_type'],
                  'deleted' : configPvd.sourcePumpUpdated[i]['deleted'],
                }
            );
          }
        }
        if(configPvd.sourcePumpUpdated[i]['levelSensor'] != null){
          if(configPvd.sourcePumpUpdated[i]['levelSensor'].isNotEmpty){
            print('see level : ${configPvd.sourcePumpUpdated[i]['levelSensor']}');
            myList[mapIndex]['map'].add(
                {
                  'oroPump' : configPvd.sourcePumpUpdated[i]['oro_pump_plus'],
                  'name' : 'level Sensor',
                  'type' : 'm_i_sourcePump',
                  'pump' : i,
                  'count' : -1,
                  'connection' : 'levelSensor',
                  'sNo' :  configPvd.sourcePumpUpdated[i]['levelSensor']['sNo'],
                  'rtu' :  configPvd.sourcePumpUpdated[i]['levelSensor']['rtu'],
                  'rfNo' : configPvd.sourcePumpUpdated[i]['levelSensor']['rfNo'],
                  'input' : configPvd.sourcePumpUpdated[i]['levelSensor']['input'],
                  'input_type' : configPvd.sourcePumpUpdated[i]['levelSensor']['input_type'],
                  'deleted' : configPvd.sourcePumpUpdated[i]['deleted'],
                }
            );
          }
        }
        if(configPvd.sourcePumpUpdated[i]['pressureSensor'] != null){
          if(configPvd.sourcePumpUpdated[i]['pressureSensor'].isNotEmpty){
            myList[mapIndex]['map'].add(
                {
                  'oroPump' : configPvd.sourcePumpUpdated[i]['oro_pump_plus'],
                  'name' : 'pressure Sensor',
                  'type' : 'm_i_sourcePump',
                  'pump' : i,
                  'count' : -1,
                  'connection' : 'pressureSensor',
                  'sNo' :  configPvd.sourcePumpUpdated[i]['pressureSensor']['sNo'],
                  'rtu' :  configPvd.sourcePumpUpdated[i]['pressureSensor']['rtu'],
                  'rfNo' : configPvd.sourcePumpUpdated[i]['pressureSensor']['rfNo'],
                  'input' : configPvd.sourcePumpUpdated[i]['pressureSensor']['input'],
                  'input_type' : configPvd.sourcePumpUpdated[i]['pressureSensor']['input_type'],
                  'deleted' : configPvd.sourcePumpUpdated[i]['deleted'],
                }
            );
          }

        }
      }
    }
    return myList;
  }
  List<Map<String,dynamic>> irrigationPump(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    for(var i = 0;i < configPvd.irrigationPumpUpdated.length;i++){
      if(configPvd.irrigationPumpUpdated[i]['deleted'] == false){
        myList.add(
            {
              'name' : 'Irrigation Pump ${i+1}',
              'map' : [],
            }
        );
        if(configPvd.irrigationPumpUpdated[i]['waterMeter'].isNotEmpty){
          myList[i]['map'].add(
              {
                'oroPump' : (configPvd.irrigationPumpUpdated[i]['oro_pump'] == true || configPvd.irrigationPumpUpdated[i]['oro_pump_plus'] == true) ? true : false,
                'name' : 'water meter',
                'type' : 'm_i_irrigationPump',
                'pump' : i,
                'count' : -1,
                'connection' : 'waterMeter',
                'sNo' :  configPvd.irrigationPumpUpdated[i]['waterMeter']['sNo'],
                'rtu' :  configPvd.irrigationPumpUpdated[i]['waterMeter']['rtu'],
                'rfNo' : configPvd.irrigationPumpUpdated[i]['waterMeter']['rfNo'],
                'input' : configPvd.irrigationPumpUpdated[i]['waterMeter']['input'],
                'input_type' : configPvd.irrigationPumpUpdated[i]['waterMeter']['input_type'],
                'deleted' : configPvd.irrigationPumpUpdated[i]['deleted'],
              }
          );
        }
        if(configPvd.irrigationPumpUpdated[i]['levelSensor'] != null){
          if(configPvd.irrigationPumpUpdated[i]['levelSensor'].isNotEmpty){
            myList[i]['map'].add(
                {
                  'oroPump' : configPvd.irrigationPumpUpdated[i]['oro_pump_plus'],
                  'name' : 'level Sensor',
                  'type' : 'm_i_irrigationPump',
                  'pump' : i,
                  'count' : -1,
                  'connection' : 'levelSensor',
                  'sNo' :  configPvd.irrigationPumpUpdated[i]['levelSensor']['sNo'],
                  'rtu' :  configPvd.irrigationPumpUpdated[i]['levelSensor']['rtu'],
                  'rfNo' : configPvd.irrigationPumpUpdated[i]['levelSensor']['rfNo'],
                  'input' : configPvd.irrigationPumpUpdated[i]['levelSensor']['input'],
                  'input_type' : configPvd.irrigationPumpUpdated[i]['levelSensor']['input_type'],
                  'deleted' : configPvd.irrigationPumpUpdated[i]['deleted'],
                }
            );
          }

        }
        if(configPvd.irrigationPumpUpdated[i]['pressureSensor'] != null){
          if(configPvd.irrigationPumpUpdated[i]['pressureSensor'].isNotEmpty){
            myList[i]['map'].add(
                {
                  'oroPump' : configPvd.irrigationPumpUpdated[i]['oro_pump_plus'],
                  'name' : 'pressure Sensor',
                  'type' : 'm_i_irrigationPump',
                  'pump' : i,
                  'count' : -1,
                  'connection' : 'pressureSensor',
                  'sNo' :  configPvd.irrigationPumpUpdated[i]['pressureSensor']['sNo'],
                  'rtu' :  configPvd.irrigationPumpUpdated[i]['pressureSensor']['rtu'],
                  'rfNo' : configPvd.irrigationPumpUpdated[i]['pressureSensor']['rfNo'],
                  'input' : configPvd.irrigationPumpUpdated[i]['pressureSensor']['input'],
                  'input_type' : configPvd.irrigationPumpUpdated[i]['pressureSensor']['input_type'],
                  'deleted' : configPvd.irrigationPumpUpdated[i]['deleted'],
                }
            );
          }

        }
        if(configPvd.irrigationPumpUpdated[i]['TopTankHigh'] != null){
          if(configPvd.irrigationPumpUpdated[i]['TopTankHigh'].isNotEmpty){
            myList[i]['map'].add(
                {
                  'oroPump' : (configPvd.irrigationPumpUpdated[i]['oro_pump'] == true || configPvd.irrigationPumpUpdated[i]['oro_pump_plus'] == true) ? true : false,
                  'name' : 'Tt high',
                  'type' : 'm_i_irrigationPump',
                  'pump' : i,
                  'count' : -1,
                  'connection' : 'TopTankHigh',
                  'sNo' :  configPvd.irrigationPumpUpdated[i]['TopTankHigh']['sNo'],
                  'rtu' :  configPvd.irrigationPumpUpdated[i]['TopTankHigh']['rtu'],
                  'rfNo' : configPvd.irrigationPumpUpdated[i]['TopTankHigh']['rfNo'],
                  'input' : configPvd.irrigationPumpUpdated[i]['TopTankHigh']['input'],
                  'input_type' : configPvd.irrigationPumpUpdated[i]['TopTankHigh']['input_type'],
                  'deleted' : configPvd.irrigationPumpUpdated[i]['deleted'],
                }
            );
          }
        }
        if(configPvd.irrigationPumpUpdated[i]['TopTankLow'] != null){
          if(configPvd.irrigationPumpUpdated[i]['TopTankLow'].isNotEmpty){
            myList[i]['map'].add(
                {
                  'oroPump' : (configPvd.irrigationPumpUpdated[i]['oro_pump'] == true || configPvd.irrigationPumpUpdated[i]['oro_pump_plus'] == true) ? true : false,
                  'name' : 'Tt low',
                  'type' : 'm_i_irrigationPump',
                  'pump' : i,
                  'count' : -1,
                  'connection' : 'TopTankLow',
                  'sNo' :  configPvd.irrigationPumpUpdated[i]['TopTankLow']['sNo'],
                  'rtu' :  configPvd.irrigationPumpUpdated[i]['TopTankLow']['rtu'],
                  'rfNo' : configPvd.irrigationPumpUpdated[i]['TopTankLow']['rfNo'],
                  'input' : configPvd.irrigationPumpUpdated[i]['TopTankLow']['input'],
                  'input_type' : configPvd.irrigationPumpUpdated[i]['TopTankLow']['input_type'],
                  'deleted' : configPvd.irrigationPumpUpdated[i]['deleted'],
                }
            );
          }
        }
        if(configPvd.irrigationPumpUpdated[i]['SumpTankHigh'] != null){
          if(configPvd.irrigationPumpUpdated[i]['SumpTankHigh'].isNotEmpty){
            myList[i]['map'].add(
                {
                  'oroPump' : (configPvd.irrigationPumpUpdated[i]['oro_pump'] == true || configPvd.irrigationPumpUpdated[i]['oro_pump_plus'] == true) ? true : false,
                  'name' : 'St high',
                  'type' : 'm_i_irrigationPump',
                  'pump' : i,
                  'count' : -1,
                  'connection' : 'SumpTankHigh',
                  'sNo' :  configPvd.irrigationPumpUpdated[i]['SumpTankHigh']['sNo'],
                  'rtu' :  configPvd.irrigationPumpUpdated[i]['SumpTankHigh']['rtu'],
                  'rfNo' : configPvd.irrigationPumpUpdated[i]['SumpTankHigh']['rfNo'],
                  'input' : configPvd.irrigationPumpUpdated[i]['SumpTankHigh']['input'],
                  'input_type' : configPvd.irrigationPumpUpdated[i]['SumpTankHigh']['input_type'],
                  'deleted' : configPvd.irrigationPumpUpdated[i]['deleted'],
                }
            );
          }
        }
        if(configPvd.irrigationPumpUpdated[i]['SumpTankLow'] != null){
          if(configPvd.irrigationPumpUpdated[i]['SumpTankLow'].isNotEmpty){
            myList[i]['map'].add(
                {
                  'oroPump' : (configPvd.irrigationPumpUpdated[i]['oro_pump'] == true || configPvd.irrigationPumpUpdated[i]['oro_pump_plus'] == true) ? true : false,
                  'name' : 'St low',
                  'type' : 'm_i_irrigationPump',
                  'pump' : i,
                  'count' : -1,
                  'connection' : 'SumpTankLow',
                  'sNo' :  configPvd.irrigationPumpUpdated[i]['SumpTankLow']['sNo'],
                  'rtu' :  configPvd.irrigationPumpUpdated[i]['SumpTankLow']['rtu'],
                  'rfNo' : configPvd.irrigationPumpUpdated[i]['SumpTankLow']['rfNo'],
                  'input' : configPvd.irrigationPumpUpdated[i]['SumpTankLow']['input'],
                  'input_type' : configPvd.irrigationPumpUpdated[i]['SumpTankLow']['input_type'],
                  'deleted' : configPvd.irrigationPumpUpdated[i]['deleted'],
                }
            );
          }
        }
        if(configPvd.irrigationPumpUpdated[i]['c1'] != null){
          if(configPvd.irrigationPumpUpdated[i]['c1'].isNotEmpty){
            myList[i]['map'].add(
                {
                  'oroPump' : (configPvd.irrigationPumpUpdated[i]['oro_pump'] == true || configPvd.irrigationPumpUpdated[i]['oro_pump_plus'] == true) ? true : false,
                  'name' : 'c1',
                  'type' : 'm_i_irrigationPump',
                  'pump' : i,
                  'count' : -1,
                  'connection' : 'c1',
                  'sNo' :  configPvd.irrigationPumpUpdated[i]['c1']['sNo'],
                  'rtu' :  configPvd.irrigationPumpUpdated[i]['c1']['rtu'],
                  'rfNo' : configPvd.irrigationPumpUpdated[i]['c1']['rfNo'],
                  'input' : configPvd.irrigationPumpUpdated[i]['c1']['input'],
                  'input_type' : configPvd.irrigationPumpUpdated[i]['c1']['input_type'],
                  'deleted' : configPvd.irrigationPumpUpdated[i]['deleted'],
                }
            );
          }
        }
        if(configPvd.irrigationPumpUpdated[i]['c2'] != null){
          if(configPvd.irrigationPumpUpdated[i]['c2'].isNotEmpty){
            myList[i]['map'].add(
                {
                  'oroPump' : (configPvd.irrigationPumpUpdated[i]['oro_pump'] == true || configPvd.irrigationPumpUpdated[i]['oro_pump_plus'] == true) ? true : false,
                  'name' : 'c2',
                  'type' : 'm_i_irrigationPump',
                  'pump' : i,
                  'count' : -1,
                  'connection' : 'c2',
                  'sNo' :  configPvd.irrigationPumpUpdated[i]['c2']['sNo'],
                  'rtu' :  configPvd.irrigationPumpUpdated[i]['c2']['rtu'],
                  'rfNo' : configPvd.irrigationPumpUpdated[i]['c2']['rfNo'],
                  'input' : configPvd.irrigationPumpUpdated[i]['c2']['input'],
                  'input_type' : configPvd.irrigationPumpUpdated[i]['c2']['input_type'],
                  'deleted' : configPvd.irrigationPumpUpdated[i]['deleted'],
                }
            );
          }
        }
        if(configPvd.irrigationPumpUpdated[i]['c3'] != null){
          if(configPvd.irrigationPumpUpdated[i]['c3'].isNotEmpty){
            myList[i]['map'].add(
                {
                  'oroPump' : (configPvd.irrigationPumpUpdated[i]['oro_pump'] == true || configPvd.irrigationPumpUpdated[i]['oro_pump_plus'] == true) ? true : false,
                  'name' : 'c3',
                  'type' : 'm_i_irrigationPump',
                  'pump' : i,
                  'count' : -1,
                  'connection' : 'c3',
                  'sNo' :  configPvd.irrigationPumpUpdated[i]['c3']['sNo'],
                  'rtu' :  configPvd.irrigationPumpUpdated[i]['c3']['rtu'],
                  'rfNo' : configPvd.irrigationPumpUpdated[i]['c3']['rfNo'],
                  'input' : configPvd.irrigationPumpUpdated[i]['c3']['input'],
                  'input_type' : configPvd.irrigationPumpUpdated[i]['c3']['input_type'],
                  'deleted' : configPvd.irrigationPumpUpdated[i]['deleted'],
                }
            );
          }
        }
      }


    }
    return myList;
  }
  List<Map<String,dynamic>> analogSensor(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Analog Sensors',
          'map' : [],
          'totalCount': configPvd.totalAnalogSensorCount,
          'totalList': configPvd.totalAnalogSensor,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalAnalogSensorCount != 0) {
                configPvd.totalAnalogSensorCount -= 1;
                configPvd.totalAnalogSensor.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': '-',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalAnalogSensorCount += 1;
              configPvd.totalAnalogSensor.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.totalAnalogSensor.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'AS ${i+1}',
            'type' : 'm_i_analogSensor',
            'sensor' : i,
            'count' : i,
            'connection' : 'totalAnalogSensor',
            'sNo' :  configPvd.totalAnalogSensor[i]['sNo'],
            'rtu' :  configPvd.totalAnalogSensor[i]['rtu'],
            'rfNo' : configPvd.totalAnalogSensor[i]['rfNo'],
            'input' : configPvd.totalAnalogSensor[i]['input'],
            'input_type' : configPvd.totalAnalogSensor[i]['input_type']
          }
      );


    }
    return myList;
  }
  List<Map<String,dynamic>> contact(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Contacts',
          'map' : [],
          'totalCount': configPvd.totalContactCount,
          'totalList': configPvd.totalContact,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalContactCount != 0) {
                configPvd.totalContactCount -= 1;
                configPvd.totalContact.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': '-',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalContactCount += 1;
              configPvd.totalContact.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.totalContact.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'CNT ${i+1}',
            'type' : 'm_i_contact',
            'sensor' : i,
            'count' : i,
            'connection' : 'totalAnalogSensor',
            'sNo' :  configPvd.totalContact[i]['sNo'],
            'rtu' :  configPvd.totalContact[i]['rtu'],
            'rfNo' : configPvd.totalContact[i]['rfNo'],
            'input' : configPvd.totalContact[i]['input'],
            'input_type' : configPvd.totalContact[i]['input_type']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> commonPressureSensor(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Common Pressure Sensor',
          'map' : [],
          'totalCount': configPvd.totalCommonPressureSensorCount,
          'totalList': configPvd.totalCommonPressureSensor,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalCommonPressureSensorCount != 0) {
                configPvd.totalCommonPressureSensorCount -= 1;
                configPvd.totalCommonPressureSensor.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': '-',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalCommonPressureSensorCount += 1;
              configPvd.totalCommonPressureSensor.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.totalCommonPressureSensor.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'CMN PS ${i+1}',
            'type' : 'm_i_totalCommonPressureSensor',
            'sensor' : i,
            'count' : i,
            'connection' : 'totalCommonPressureSensor',
            'sNo' :  configPvd.totalCommonPressureSensor[i]['sNo'],
            'rtu' :  configPvd.totalCommonPressureSensor[i]['rtu'],
            'rfNo' : configPvd.totalCommonPressureSensor[i]['rfNo'],
            'input' : configPvd.totalCommonPressureSensor[i]['input'],
            'input_type' : configPvd.totalCommonPressureSensor[i]['input_type']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> commonPressureSwitch(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Common Pressure Switch',
          'map' : [],
          'totalCount': configPvd.totalCommonPressureSwitchCount,
          'totalList': configPvd.totalCommonPressureSwitch,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalCommonPressureSwitchCount != 0) {
                configPvd.totalCommonPressureSwitchCount -= 1;
                configPvd.totalCommonPressureSwitch.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': '-',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalCommonPressureSwitchCount += 1;
              configPvd.totalCommonPressureSwitch.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.totalCommonPressureSwitch.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'CMN PSW ${i+1}',
            'type' : 'm_i_totalCommonPressureSwitch',
            'sensor' : i,
            'count' : i,
            'connection' : 'totalCommonPressureSwitch',
            'sNo' :  configPvd.totalCommonPressureSwitch[i]['sNo'],
            'rtu' :  configPvd.totalCommonPressureSwitch[i]['rtu'],
            'rfNo' : configPvd.totalCommonPressureSwitch[i]['rfNo'],
            'input' : configPvd.totalCommonPressureSwitch[i]['input'],
            'input_type' : configPvd.totalCommonPressureSwitch[i]['input_type']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> tankFloat(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Tank Float',
          'map' : [],
          'totalCount': configPvd.totalTankFloatCount,
          'totalList': configPvd.totalTankFloat,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalTankFloatCount != 0) {
                configPvd.totalTankFloatCount -= 1;
                configPvd.totalTankFloat.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': 'D-I',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalTankFloatCount += 1;
              configPvd.totalTankFloat.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.totalTankFloat.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'TNK FLT ${i+1}',
            'type' : 'm_i_totalTankFloat',
            'sensor' : i,
            'count' : i,
            'connection' : 'totalTankFloat',
            'sNo' :  configPvd.totalTankFloat[i]['sNo'],
            'rtu' :  configPvd.totalTankFloat[i]['rtu'],
            'rfNo' : configPvd.totalTankFloat[i]['rfNo'],
            'input' : configPvd.totalTankFloat[i]['input'],
            'input_type' : configPvd.totalTankFloat[i]['input_type']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> manualButton(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Manual Button',
          'map' : [],
          'totalCount': configPvd.totalManualButtonCount,
          'totalList': configPvd.totalManualButton,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalManualButtonCount != 0) {
                configPvd.totalManualButtonCount -= 1;
                configPvd.totalManualButton.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': 'D-I',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalManualButtonCount += 1;
              configPvd.totalManualButton.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.totalManualButton.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'Manual Btn ${i+1}',
            'type' : 'm_i_totalManualButton',
            'sensor' : i,
            'count' : i,
            'connection' : 'totalManualButton',
            'sNo' :  configPvd.totalManualButton[i]['sNo'],
            'rtu' :  configPvd.totalManualButton[i]['rtu'],
            'rfNo' : configPvd.totalManualButton[i]['rfNo'],
            'input' : configPvd.totalManualButton[i]['input'],
            'input_type' : configPvd.totalManualButton[i]['input_type']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> lowerTankLevel(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Lower Tank Level',
          'map' : [],
          'totalCount': configPvd.totalLowerTankLevelSensorCount,
          'totalList': configPvd.totalLowerTankLevelSensor,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalLowerTankLevelSensorCount != 0) {
                configPvd.totalLowerTankLevelSensorCount -= 1;
                configPvd.totalLowerTankLevelSensor.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': 'A-I',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalLowerTankLevelSensorCount += 1;
              configPvd.totalLowerTankLevelSensor.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.totalLowerTankLevelSensor.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'Lower Tank Level ${i+1}',
            'type' : 'm_i_totalLowerTankLevelSensor',
            'sensor' : i,
            'count' : i,
            'connection' : 'totalLowerTankLevelSensor',
            'sNo' :  configPvd.totalLowerTankLevelSensor[i]['sNo'],
            'rtu' :  configPvd.totalLowerTankLevelSensor[i]['rtu'],
            'rfNo' : configPvd.totalLowerTankLevelSensor[i]['rfNo'],
            'input' : configPvd.totalLowerTankLevelSensor[i]['input'],
            'input_type' : configPvd.totalLowerTankLevelSensor[i]['input_type']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> upperTankLevel(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Upper Tank Level',
          'map' : [],
          'totalCount': configPvd.totalUpperTankLevelSensorCount,
          'totalList': configPvd.totalUpperTankLevelSensor,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalUpperTankLevelSensorCount != 0) {
                configPvd.totalUpperTankLevelSensorCount -= 1;
                configPvd.totalUpperTankLevelSensor.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': 'A-I',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalUpperTankLevelSensorCount += 1;
              configPvd.totalUpperTankLevelSensor.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.totalUpperTankLevelSensor.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'Upper Tank Level ${i+1}',
            'type' : 'm_i_totalUpperTankLevelSensor',
            'sensor' : i,
            'count' : i,
            'connection' : 'totalUpperTankLevelSensor',
            'sNo' :  configPvd.totalUpperTankLevelSensor[i]['sNo'],
            'rtu' :  configPvd.totalUpperTankLevelSensor[i]['rtu'],
            'rfNo' : configPvd.totalUpperTankLevelSensor[i]['rfNo'],
            'input' : configPvd.totalUpperTankLevelSensor[i]['input'],
            'input_type' : configPvd.totalUpperTankLevelSensor[i]['input_type']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> temperature(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Temperature',
          'map' : [],
          'totalCount': configPvd.totalTempSensor,
          'totalList': configPvd.connTempSensor,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalTempSensor != 0) {
                configPvd.totalTempSensor -= 1;
                configPvd.connTempSensor.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': 'ORO Sense',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': 'I2C',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalTempSensor += 1;
              configPvd.connTempSensor.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.connTempSensor.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'Temp ${i+1}',
            'type' : 'm_i_temperature',
            'sensor' : i,
            'count' : i,
            'connection' : 'connTempSensor',
            'sNo' :  configPvd.connTempSensor[i]['sNo'],
            'rtu' :  configPvd.connTempSensor[i]['rtu'],
            'rfNo' : configPvd.connTempSensor[i]['rfNo'],
            'input' : configPvd.connTempSensor[i]['input'],
            'input_type' : configPvd.connTempSensor[i]['input_type']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> soilTemperature(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Soil Temperature',
          'map' : [],
          'totalCount': configPvd.totalSoilTempSensor,
          'totalList': configPvd.connSoilTempSensor,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalSoilTempSensor != 0) {
                configPvd.totalSoilTempSensor -= 1;
                configPvd.connSoilTempSensor.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': 'D-I',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalSoilTempSensor += 1;
              configPvd.connSoilTempSensor.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.connSoilTempSensor.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'Soil Temp ${i+1}',
            'type' : 'm_i_soilTemperature',
            'sensor' : i,
            'count' : i,
            'connection' : 'connSoilTempSensor',
            'sNo' :  configPvd.connSoilTempSensor[i]['sNo'],
            'rtu' :  configPvd.connSoilTempSensor[i]['rtu'],
            'rfNo' : configPvd.connSoilTempSensor[i]['rfNo'],
            'input' : configPvd.connSoilTempSensor[i]['input'],
            'input_type' : configPvd.connSoilTempSensor[i]['input_type']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> humidity(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Humidity',
          'map' : [],
          'totalCount': configPvd.totalHumidity,
          'totalList': configPvd.connHumidity,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalHumidity != 0) {
                configPvd.totalHumidity -= 1;
                configPvd.connHumidity.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': 'ORO Sense',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': 'I2C',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalHumidity += 1;
              configPvd.connHumidity.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.connHumidity.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'humidity ${i+1}',
            'type' : 'm_i_humidity',
            'sensor' : i,
            'count' : i,
            'connection' : 'connHumidity',
            'sNo' :  configPvd.connHumidity[i]['sNo'],
            'rtu' :  configPvd.connHumidity[i]['rtu'],
            'rfNo' : configPvd.connHumidity[i]['rfNo'],
            'input' : configPvd.connHumidity[i]['input'],
            'input_type' : configPvd.connHumidity[i]['input_type']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> co2(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'CO2',
          'map' : [],
          'totalCount': configPvd.totalCo2,
          'totalList': configPvd.connCo2,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalCo2 != 0) {
                configPvd.totalCo2 -= 1;
                configPvd.connCo2.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': 'ORO Sense',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': 'I2C',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalCo2 += 1;
              configPvd.connCo2.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.connCo2.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'CO2 ${i+1}',
            'type' : 'm_i_co2',
            'sensor' : i,
            'count' : i,
            'connection' : 'connCo2',
            'sNo' :  configPvd.connCo2[i]['sNo'],
            'rtu' :  configPvd.connCo2[i]['rtu'],
            'rfNo' : configPvd.connCo2[i]['rfNo'],
            'input' : configPvd.connCo2[i]['input'],
            'input_type' : configPvd.connCo2[i]['input_type']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> windSpeed(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Wind Speed',
          'map' : [],
          'totalCount': configPvd.totalWindSpeed,
          'totalList': configPvd.connWindSpeed,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalWindSpeed != 0) {
                configPvd.totalWindSpeed -= 1;
                configPvd.connWindSpeed.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': '-',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalWindSpeed += 1;
              configPvd.connWindSpeed.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.connWindSpeed.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'Wind Speed ${i+1}',
            'type' : 'm_i_windSpeed',
            'sensor' : i,
            'count' : i,
            'connection' : 'connWindSpeed',
            'sNo' :  configPvd.connWindSpeed[i]['sNo'],
            'rtu' :  configPvd.connWindSpeed[i]['rtu'],
            'rfNo' : configPvd.connWindSpeed[i]['rfNo'],
            'input' : configPvd.connWindSpeed[i]['input'],
            'input_type' : configPvd.connWindSpeed[i]['input_type']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> windDirection(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Wind Direction',
          'map' : [],
          'totalCount': configPvd.totalWindDirection,
          'totalList': configPvd.connWindDirection,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalWindDirection != 0) {
                configPvd.totalWindDirection -= 1;
                configPvd.connWindDirection.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': '-',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalWindDirection += 1;
              configPvd.connWindDirection.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.connWindDirection.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'Wind Direction ${i+1}',
            'type' : 'm_i_windDirection',
            'sensor' : i,
            'count' : i,
            'connection' : 'connWindDirection',
            'sNo' :  configPvd.connWindDirection[i]['sNo'],
            'rtu' :  configPvd.connWindDirection[i]['rtu'],
            'rfNo' : configPvd.connWindDirection[i]['rfNo'],
            'input' : configPvd.connWindDirection[i]['input'],
            'input_type' : configPvd.connWindDirection[i]['input_type']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> lux(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Lux',
          'map' : [],
          'totalCount': configPvd.totalLux,
          'totalList': configPvd.connLux,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalLux != 0) {
                configPvd.totalLux -= 1;
                configPvd.connLux.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': '-',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalLux += 1;
              configPvd.connLux.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.connLux.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'Lux ${i+1}',
            'type' : 'm_i_lux',
            'sensor' : i,
            'count' : i,
            'connection' : 'connLux',
            'sNo' :  configPvd.connLux[i]['sNo'],
            'rtu' :  configPvd.connLux[i]['rtu'],
            'rfNo' : configPvd.connLux[i]['rfNo'],
            'input' : configPvd.connLux[i]['input'],
            'input_type' : configPvd.connLux[i]['input_type']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> ldr(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'LDR',
          'map' : [],
          'totalCount': configPvd.totalLdr,
          'totalList': configPvd.connLdr,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalLdr != 0) {
                configPvd.totalLdr -= 1;
                configPvd.connLdr.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': '-',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalLdr += 1;
              configPvd.connLdr.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.connLdr.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'LDR ${i+1}',
            'type' : 'm_i_ldr',
            'sensor' : i,
            'count' : i,
            'connection' : 'connLdr',
            'sNo' :  configPvd.connLdr[i]['sNo'],
            'rtu' :  configPvd.connLdr[i]['rtu'],
            'rfNo' : configPvd.connLdr[i]['rfNo'],
            'input' : configPvd.connLdr[i]['input'],
            'input_type' : configPvd.connLdr[i]['input_type']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> rainGauge(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Rain Gauge',
          'map' : [],
          'totalCount': configPvd.totalRainGauge,
          'totalList': configPvd.connRainGauge,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalRainGauge != 0) {
                configPvd.totalRainGauge -= 1;
                configPvd.connRainGauge.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': '-',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalRainGauge += 1;
              configPvd.connRainGauge.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.connRainGauge.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'Rain Gauge ${i+1}',
            'type' : 'm_i_rainGauge',
            'sensor' : i,
            'count' : i,
            'connection' : 'connRainGauge',
            'sNo' :  configPvd.connRainGauge[i]['sNo'],
            'rtu' :  configPvd.connRainGauge[i]['rtu'],
            'rfNo' : configPvd.connRainGauge[i]['rfNo'],
            'input' : configPvd.connRainGauge[i]['input'],
            'input_type' : configPvd.connRainGauge[i]['input_type']
          }
      );
    }
    return myList;
  }
  List<Map<String,dynamic>> leafWetness(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Leaf Wetness',
          'map' : [],
          'totalCount': configPvd.totalLeafWetness,
          'totalList': configPvd.connLeafWetness,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalLeafWetness != 0) {
                configPvd.totalLeafWetness -= 1;
                configPvd.connLeafWetness.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': '-',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalLeafWetness += 1;
              configPvd.connLeafWetness.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.connLeafWetness.length;i++){
      myList[0]['map'].add(
          {
            'name' : 'Leaf Wetness ${i+1}',
            'type' : 'm_i_leafWetness',
            'sensor' : i,
            'count' : i,
            'connection' : 'connLeafWetness',
            'sNo' :  configPvd.connLeafWetness[i]['sNo'],
            'rtu' :  configPvd.connLeafWetness[i]['rtu'],
            'rfNo' : configPvd.connLeafWetness[i]['rfNo'],
            'input' : configPvd.connLeafWetness[i]['input'],
            'input_type' : configPvd.connLeafWetness[i]['input_type']
          }
      );
    }
    return myList;
  }

  List<Map<String,dynamic>> commonPressure(ConfigMakerProvider configPvd){
    List<Map<String,dynamic>> myList = [];
    myList.add(
        {
          'name' : 'Common Pressure',
          'map' : [],
          'totalCount': configPvd.totalCommonPressureSensorCount,
          'totalList': configPvd.totalCommonPressureSensor,
          'addFunction' : (){
            setState(() {
              if(configPvd.totalCommonPressureSensorCount != 0) {
                configPvd.totalCommonPressureSensorCount -= 1;
                configPvd.totalCommonPressureSensor.add({
                  'sNo': configPvd.returnI_O_AutoIncrement(),
                  'deleted': false,
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': '-',
                });
              }
            });
          },
          'deleteFunction' : (index){
            setState(() {
              configPvd.totalCommonPressureSensorCount += 1;
              configPvd.totalCommonPressureSensor.removeAt(index);
            });
          },
        }
    );
    for(var i = 0;i < configPvd.totalCommonPressureSensor.length;i++){
      myList[0]['map'].add(
          {
            'name' : configPvd.totalCommonPressureSensor[i]['name'],
            'type' : 'm_i_commonPressureSensor',
            'sensor' : i,
            'count' : i,
            'connection' : 'totalCommonPressureSensor',
            'sNo' :  configPvd.totalCommonPressureSensor[i]['sNo'],
            'rtu' :  configPvd.totalCommonPressureSensor[i]['rtu'],
            'rtuList' :  configPvd.totalCommonPressureSensor[i]['rtuList'],
            'rfNo' : configPvd.totalCommonPressureSensor[i]['rfNo'],
            'rfList' : configPvd.totalCommonPressureSensor[i]['rfList'],
            'input' : configPvd.totalCommonPressureSensor[i]['input'],
            'input_type' : configPvd.totalCommonPressureSensor[i]['input_type']
          }
      );
    }
    return myList;
  }

}
