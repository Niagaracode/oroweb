import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/Screens/Customer/IrrigationProgram/water_and_fertilizer_screen.dart';

class WeatherStationView extends StatefulWidget {
  final dynamic weatherStation;
  final dynamic referenceList;
  Map<dynamic,dynamic> names;
  WeatherStationView({super.key,required this.weatherStation, required this.referenceList,required this.names});

  @override
  State<WeatherStationView> createState() => _WeatherStationViewState();
}

class _WeatherStationViewState extends State<WeatherStationView> {


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return SingleChildScrollView(
        child: Column(
          children: [
            for(var i = 0;i < widget.weatherStation.length;i++)
              Column(
                children: [
                  Container(
                    width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xff1C7C8A)
                      ),
                      child: Center(child: Text('Weather Station ${i+1}',style: TextStyle(color: Colors.white),))
                  ),
                  customizeGridView(
                      maxWith: 250,
                      maxHeight: 60,
                      screenWidth: constraints.maxWidth,
                      listOfWidget: [
                        for(var key in widget.weatherStation[i].keys)
                          Container(
                            width: 250,
                              height: 50,
                              decoration: BoxDecoration(
                                boxShadow: customBoxShadow,
                                color: Colors.white
                              ),
                              child: Center(child: Text('${widget.names['${widget.weatherStation[i][key]['sNo']}']['name']}'))
                          )
                      ]
                  ),
                  SizedBox(height: 30,)
                ],
              )
        
          ],
        ),
      );
    },);

  }
}
