import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/Screens/Customer/IrrigationProgram/preview_screen.dart';
import 'package:oro_irrigation_new/screens/Config/config_maker/source_pump.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart';

import '../../../constants/theme.dart';
import '../../../state_management/config_maker_provider.dart';


class WeatherStationConfig extends StatefulWidget {
  const WeatherStationConfig({super.key});

  @override
  State<WeatherStationConfig> createState() => _WeatherStationConfigState();
}

class _WeatherStationConfigState extends State<WeatherStationConfig> {
  var lineData = [];
  @override
  @override
  Widget build(BuildContext context) {
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: true);
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        padding: const EdgeInsets.all(10),
        color: const Color(0xFFF3F3F3),
        child: Column(
          children: [
            const SizedBox(height: 5,),
            Row(
              children: [
                InkWell(
                  onTap: (){
                    var add = false;
                    for(var key in configPvd.weatherStation.keys){
                      if(configPvd.weatherStation[key]['apply'] == false){
                        add = true;
                      }
                    }
                    if(add == false){
                      showDialog(
                          context: context,
                          builder: (context){
                            return showingMessage('Oops!', 'The weather station limit is achieved!..', context);
                          }
                      );
                    }else{
                      configPvd.weatherStationFuntionality(['add']);
                    }
                  },
                  child: Container(
                    width: 180,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: myTheme.primaryColor
                    ),
                    child: Center(
                      child: Text('Add ORO Weather(${configPvd.weatherStation.keys.where((element) => configPvd.weatherStation[element]['apply'] == false).toList().length})',style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w100),),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10,),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for(var key in configPvd.weatherStation.keys)
                        if(configPvd.weatherStation[key]['apply'] == true)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: primaryColorDark
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(left: 20),
                                      child: Text('ORO WEATHER ${configPvd.weatherStation.keys.toList().indexOf(key) + 1}',style: TextStyle(color: Colors.white),)
                                    ),
                                    Container(
                                      color: Colors.white,
                                      width: 300,
                                      child: ListTile(
                                        title: const Text('Irrigation Line',style: TextStyle(fontWeight: FontWeight.bold),),
                                        trailing: InkWell(
                                          onTap: (){
                                            setState(() {
                                              lineData.clear();
                                              for(var i = 0;i < configPvd.irrigationLines.length;i++){
                                                lineData.add({
                                                  'name' : 'IL.${i+1}',
                                                  'value' : false,
                                                });
                                              }
                                            });
                                            sideSheet(constraints,key,configPvd);
                                          },
                                            child: Text('${configPvd.weatherStation[key]['irrigationLine']}')
                                        ),
                                        // trailing: DropdownButton(
                                        //   underline: Container(),
                                        //   value: configPvd.weatherStation[key]['irrigationLine'],
                                        //   items: [
                                        //     DropdownMenuItem(
                                        //         value: '-',
                                        //         child: Text('-')
                                        //     ),
                                        //     for(var i = 0;i < configPvd.irrigationLines.length;i++)
                                        //       if(!configPvd.irrigationLines[i]['deleted'])
                                        //         DropdownMenuItem(
                                        //             value: i,
                                        //             child: Text('${i+1}')
                                        //         )
                                        //   ],
                                        //   onChanged: (value) {
                                        //     setState(() {
                                        //       configPvd.weatherStation[key]['irrigationLine'] = value;
                                        //     });
                                        //   },),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: IconButton(
                                          onPressed: (){
                                            configPvd.weatherStationFuntionality(['delete',key]);
                                          },
                                          icon: const Icon(Icons.delete,color: Colors.orange,),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              Wrap(
                                children: [
                                  for(var sensor in configPvd.weatherStation[key].keys)
                                    if(!['apply','irrigationLine'].contains(sensor))
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: customBoxShadow
                                        ),
                                        width: 250,
                                        child: CheckboxListTile(
                                          title: Text(sensor),
                                          value: configPvd.weatherStation[key][sensor]['apply'],
                                          onChanged: (bool? value) {
                                            configPvd.weatherStationFuntionality(['sensorUpdate',key,sensor]);
                                          },
                                        ),
                                      )
                                ],
                              ),
                            ],
                          ),
                      const SizedBox(height: 100,)
                    ],
                  ),
                )
            )

          ],
        ),
      );
    },);
  }

  void sideSheet(constraints,key,ConfigMakerProvider configPvd) {
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
                return Container(
                  color: Colors.white,
                  width: constraints.maxWidth < 600 ? constraints.maxWidth * 0.7 : constraints.maxWidth * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          for(var i in lineData)
                            CheckboxListTile(
                              title: Text(i['name']),
                                value: i['value'],
                                onChanged: (value){
                                  stateSetter((){
                                    setState(() {
                                      i['value'] = !i['value'];
                                    });
                                  });
                                }
                            )
                        ],
                      ),
                      MaterialButton(
                        color: primaryColorDark,
                        child: Text('OK',style: TextStyle(color: Colors.white),),
                          onPressed: (){
                          stateSetter((){
                            setState(() {
                              configPvd.weatherStation[key]['irrigationLine'] = lineData.where((l)=> l['value'] == true).map((e)=>e['name']).toList().join('_');
                              if(configPvd.weatherStation[key]['irrigationLine'].isEmpty){
                                configPvd.weatherStation[key]['irrigationLine'] = '-';
                              }
                            });
                          });
                          Navigator.pop(context);
                          }
                      )
                    ],
                  ),
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

  int gridCount(BoxConstraints constraints){
    if(constraints.maxWidth > 1000){
      return 8;
    }else if(constraints.maxWidth > 800){
      return 7;
    }else if(constraints.maxWidth > 600){
      return 5;
    }else if(constraints.maxWidth > 400){
      return 4;
    }else{
      return 3;
    }
  }
  List<dynamic> weatherFeatures(int index){
    switch (index){
      case 0:{
        return ['Temperature','assets/images/temperature.png'];
      }
      case 1:{
        return ['Humidity','assets/images/humidity.png'];
      }
      case 2:{
        return ['Wind Speed','assets/images/windSpeed.png'];
      }
      case 3:{
        return ['Rain','assets/images/windDirection.png'];
      }
      case 4:{
        return ['Atm.Pressure','assets/images/moisture.png'];
      }
      case 5:{
        return ['UV-Radiation','assets/images/rainGauge.png'];
      }
      case 6:{
        return ['Alert','assets/images/soilTemperature.png'];
      }
      case 7:{
        return ['Daily Forecast','assets/images/lux.png'];
      }
      case 8:{
        return ['Sunset','assets/images/co2.png'];
      }
      case 9:{
        return ['W-Prediction','assets/images/ldrSensor.png'];
      }
      case 10:{
        return ['W-Prediction','assets/images/leafWetness.png'];
      }
      default:{
        return ['nothing'];
      }
    }
  }
}