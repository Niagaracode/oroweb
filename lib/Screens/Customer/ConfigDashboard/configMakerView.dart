import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/Screens/Customer/ConfigDashboard/pumpView.dart';
import 'package:oro_irrigation_new/screens/Customer/configDashboard/central_dosing_view.dart';
import 'package:oro_irrigation_new/screens/Customer/configDashboard/central_filtration_view.dart';
import 'package:oro_irrigation_new/screens/Customer/configDashboard/irrigationLineView.dart';
import 'package:oro_irrigation_new/screens/Customer/configDashboard/weather_station_view.dart';

import '../../../constants/http_service.dart';
import 'others_view.dart';

class ConfigMakerView extends StatefulWidget {
  const ConfigMakerView({super.key, required this.userId, required this.customerId, required this.controllerId});
  final int userId, customerId, controllerId;

  @override
  State<ConfigMakerView> createState() => _ConfigMakerViewState();
}

class _ConfigMakerViewState extends State<ConfigMakerView> {
  dynamic nameData = {};
  dynamic sourcePump = [];
  dynamic irrigationPump = [];
  dynamic centralDosing = [];
  dynamic centralFiltration = [];
  dynamic irrigationLines = [];
  dynamic weatherStation = [];
  dynamic others = [];
  dynamic referenceList = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // MqttWebClient().init();
    getData();
  }


  Future<void> getData() async {
    // constantPvd.sendDataToHW();
    HttpService service = HttpService();
    try{
      var configData = await service.postRequest('getUserConfigMakerTesting', {'userId' : widget.customerId,'controllerId' : widget.controllerId});
      var names = await service.postRequest('getUserName', {'userId' : widget.customerId,'controllerId' : widget.controllerId});
      var namesData = jsonDecode(names.body);
      print('mynames : ${jsonEncode(namesData)}');
      var jsonConfigData = jsonDecode(configData.body);
      print('myjson : $jsonConfigData');
      setState(() {
        for(var i in namesData['data']){
          for(var j in i['userName']){
            nameData['${j['sNo']}'] = {};
            nameData['${j['sNo']}']['name'] = j['name'];
            nameData['${j['sNo']}']['id'] = j['id'];
            nameData['${j['sNo']}']['location'] = j['location'];
          }
        }
        referenceList = jsonConfigData['data']['referenceNo'];
        for(var globalKey in jsonConfigData['data']['configMaker'].keys){
          print('$globalKey == > ${jsonConfigData['data']['configMaker'][globalKey].runtimeType}');
          if(globalKey == 'sourcePump'){
            for(var sp in jsonConfigData['data']['configMaker'][globalKey]){
              sp['visible'] = true;
              if(sp['deleted'] == false){
                sourcePump.add(sp);
              }

            }
          }
          if(globalKey == 'irrigationPump'){
            for(var sp in jsonConfigData['data']['configMaker'][globalKey]){
              sp['visible'] = true;
              if(sp['deleted'] == false){
                irrigationPump.add(sp);
              }
            }
          }
          if(globalKey == 'centralFertilizer'){
            for(var cd in jsonConfigData['data']['configMaker'][globalKey]){
              cd['visible'] = true;
              cd['injectorVisible'] = true;
              cd['boosterVisible'] = true;
              cd['ecVisible'] = true;
              cd['phVisible'] = true;
              if(cd['deleted'] == false){
                centralDosing.add(cd);
              }
            }
          }
          if(globalKey == 'centralFilter'){
            for(var cf in jsonConfigData['data']['configMaker'][globalKey]){
              cf['visible'] = true;
              cf['filterVisible'] = true;
              if(cf['deleted'] == false){
                centralFiltration.add(cf);
              }
            }
          }
          if(globalKey == 'irrigationLine'){
            for(var il in jsonConfigData['data']['configMaker'][globalKey]){
              il['visible'] = jsonConfigData['data']['configMaker'][globalKey].indexOf(il) == 0 ? true : false;
              il['valveVisible'] = true;
              il['mainValveVisible'] = true;
              il['moistureVisible'] = true;
              il['levelVisible'] = true;
              il['foggerVisible'] = true;
              il['fanVisible'] = true;
              if(il['Local_dosing_site']){
                localDosing : for(var ld in jsonConfigData['data']['configMaker']['localFertilizer']){
                  if(ld['sNo'] == il['sNo']){
                    il['injector'] = ld['injector'];
                    il['boosterConnection'] = ld['boosterConnection'];
                    il['ecConnection'] = ld['ecConnection'];
                    il['phConnection'] = ld['phConnection'];
                    il['ldPressureSwitch'] = ld['pressureSwitch'];
                  }
                  break localDosing;
                }
                il['injectorVisible'] = true;
                il['boosterVisible'] = true;
                il['ecVisible'] = true;
                il['phVisible'] = true;
              }
              if(il['local_filtration_site']){
                localFilter : for(var lf in jsonConfigData['data']['configMaker']['localFilter']){
                  if(lf['sNo'] == il['sNo']){
                    il['filterConnection'] = lf['filterConnection'];
                    il['lfPressureIn'] = lf['pressureIn'];
                    il['lfPressureOut'] = lf['pressureOut'];
                    il['lfPressureSwitch'] = lf['pressureSwitch'];
                    il['diffPressureSensor'] = lf['diffPressureSensor'];
                    il['dv'] = lf['dv'];
                  }
                  break localFilter;
                }
                il['filterVisible'] = true;
              }
              if(il['deleted'] == false){
                irrigationLines.add(il);
              }
            }
          }
          if(globalKey == 'weatherStation'){
            for(var key in jsonConfigData['data']['configMaker'][globalKey].keys){
              if(jsonConfigData['data']['configMaker'][globalKey][key]['apply']){
                var data = {};
                for(var subKey in jsonConfigData['data']['configMaker'][globalKey][key].keys){
                  if(subKey != 'apply'){
                    if(jsonConfigData['data']['configMaker'][globalKey][key][subKey]['apply']){
                      data[subKey] = jsonConfigData['data']['configMaker'][globalKey][key][subKey];
                    }
                  }
                }
                if(data.isNotEmpty){
                  weatherStation.add(data);
                }
              }
            }
          }
          if(globalKey == 'productLimit'){
            for(var key in ['totalAgitator','totalSelector','totalTankFloat','totalCommonPressureSwitch','totalCommonPressureSensor','totalAnalogSensor']){
              if(jsonConfigData['data']['configMaker'][globalKey][key].isNotEmpty){
                others.add({
                  'visible' : true,
                  'name' : key,
                  'connection' : jsonConfigData['data']['configMaker'][globalKey][key]
                });
              }
            }

          }
        }
      });
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('ConfigMaker View'),
      ),
      body: DefaultTabController(
        length: 7,
        child: Column(
          children: [
            const TabBar(
                tabs: [
                  Tab(
                    child: Text('Source pump'),
                  ),
                  Tab(
                    child: Text('Irrigation pump'),
                  ),
                  Tab(
                    child: Text('Dosing site'),
                  ),
                  Tab(
                    child: Text('Filtration site'),
                  ),
                  Tab(
                    child: Text('Lines'),
                  ),
                  Tab(
                    child: Text('Weather Station'),
                  ),
                  Tab(
                    child: Text('Others'),
                  ),

                ]
            ),
            Expanded(
                child: Container(
                  child: TabBarView(
                    children: [
                      PumpView(sourcePump: sourcePump,names: nameData,referenceList : referenceList),
                      PumpView(sourcePump: irrigationPump, names: nameData, referenceList: referenceList,),
                      CentralDosingView(centralDosing: centralDosing, referenceList: referenceList, names: nameData,),
                      CentralFiltrationView(centralFiltration: centralFiltration,names: nameData,referenceList : referenceList),
                      IrrigationLinesView(irrigationLine: irrigationLines,names: nameData,referenceList : referenceList),
                      WeatherStationView(weatherStation: weatherStation,names: nameData,referenceList : referenceList),
                      OthersView(others: others, referenceList: referenceList, names: nameData,)
                    ],
                  ),
                )
            )
          ],
        ),
      ),
      // body : LayoutBuilder(
      //   builder: (context,constraints){
      //     return Center(child: ConnectedCircles());
      //   },
      // ),
    );
  }
}
