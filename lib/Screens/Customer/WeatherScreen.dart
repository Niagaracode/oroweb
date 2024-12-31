import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:oro_irrigation_new/Screens/Customer/IrrigationProgram/water_and_fertilizer_screen.dart';
import 'package:oro_irrigation_new/Screens/Customer/web_view.dart';
import 'package:oro_irrigation_new/screens/Customer/weather_report.dart';
import 'package:oro_irrigation_new/state_management/MqttPayloadProvider.dart';
import 'package:provider/provider.dart';
import '../../Models/weather_model.dart';
import '../../constants/MQTTManager.dart';
import '../../constants/http_service.dart';
import '../../constants/theme.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';



class WeatherScreen extends StatefulWidget {
  WeatherScreen(
      {Key? key,
        required this.userId,
        required this.controllerId,
        required this.deviceID,
        required this.initialIndex,});
  final userId, controllerId, deviceID;
  var initialIndex = 0;
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  //  0aa7f59482130e8e8384ae8270d79097 // API KEY
  Map<String, dynamic> weatherData = {};
  late Timer _timer;
  late DateTime _currentTime;
  late MqttPayloadProvider _mqttPayloadProvider;
  String sunrise = '06:00 AM';
  String sunset = '06:00 PM';
  String daylight = 'Day Light Length: 12:00:00';
  List<String> weekDayList = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  int tabclickindex = 0;
  WeatherModel weatherModelinstance = WeatherModel();
  String errorMsgstatus = '';

  @override
  void initState() {
    _currentTime = DateTime.now();
    super.initState();
    Request();
    fetchDataSunRiseSet();
    fetchDataLive();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer1() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _mqttPayloadProvider =
        Provider.of<MqttPayloadProvider>(context, listen: true);
    if (weatherData.isNotEmpty && (weatherData != null)) {
      sunrise = '${weatherData['results']['sunrise']}';
      sunset = '${weatherData['results']['sunset']}';
      daylight = 'Day Light Length: ${weatherData['results']['day_length']}';
    }
    if (_mqttPayloadProvider.weatherModelinstance.data == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (_mqttPayloadProvider.weatherModelinstance.data!.isEmpty) {
      return  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
              child: Text('Currently No Weather Data Available')),
          TextButton.icon(onPressed: (){
            // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(userId: customer.userId, fromDealer: true)));
            Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewExample(userid: widget.userId,controllerid: widget.controllerId,)));
          }, label: Text('Click To Open External Weather Data')),
        ],
      );
    } else if (_mqttPayloadProvider.weatherModelinstance.data![0] == null ||
        _mqttPayloadProvider
            .weatherModelinstance.data![0].WeatherSensorlist!.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
              child: Text('Currently No Weather Data Available...')),
          TextButton.icon(onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewExample(userid: widget.userId,controllerid: widget.controllerId,)));
          }, label: Text('Click To Open External Weather Data')),

        ],
      ); //http
    } else {
      return DefaultTabController(
        length: _mqttPayloadProvider
            .weatherModelinstance.data![0].WeatherSensorlist!.length,
        initialIndex: widget.initialIndex! < _mqttPayloadProvider
            .weatherModelinstance.data![0].WeatherSensorlist!.length ? widget.initialIndex ?? 0 : 0,
        child: Scaffold(
          backgroundColor: Colors.teal.shade50,
          body: Center(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TabBar(
                            // controller: _tabController,
                            indicatorColor: const Color.fromARGB(255, 175, 73, 73),
                            isScrollable: true,
                            unselectedLabelColor: Colors.grey,
                            labelColor: myTheme.primaryColor,
                            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                            tabs: [
                              for (var i = 0;
                              i <
                                  _mqttPayloadProvider.weatherModelinstance
                                      .data![0].WeatherSensorlist!.length;
                              i++)
                                Tab(
                                  text: '${_mqttPayloadProvider.weatherModelinstance
                                      .data![0].WeatherSensorlist![i].deviceName ?? "Weather Station ${i + 1}" } ',
                                ),
                            ],
                            onTap: (value) {
                              setState(() {
                                tabclickindex = value;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 40,
                        child: TextButton.icon(onPressed: (){
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(userId: customer.userId, fromDealer: true)));
                          Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewExample(userid: widget.userId,controllerid: widget.controllerId,)));
                        }, label: Icon(Icons.devices_other)),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                      child: TabBarView(children: [
                        for (var i = 0;
                        i <
                            _mqttPayloadProvider.weatherModelinstance
                                .data![0].WeatherSensorlist!.length;
                        i++)
                          buildTab(i)
                      ],),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  changeval(int Selectindexrow) {}
  Widget buildTab(int i) {
    return Scaffold(body: Center(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (MediaQuery.sizeOf(context).width < 800) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                      // width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: const RadialGradient(
                            center: Alignment.bottomCenter,
                            radius: 1.5,
                            colors: [
                              Color.fromARGB(255, 131, 180, 237),
                              Color.fromARGB(255, 220, 240, 247),
                            ],
                          )),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset(
                                    'assets/images/w08.png',
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].temperature}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 28,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 200,
                                height: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset(
                                          'assets/images/sunrise.png',
                                          width: 30.0,
                                          height: 30.0,
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                          '$sunrise',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Image.asset(
                                          'assets/images/sunset.png',
                                          width: 30.0,
                                          height: 30.0,
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                          '$sunset',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$daylight',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          ),
                          Text(
                            'Last Sync: ${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![0].time} / ${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![0].date}',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          ),

                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 10, top: 10),
                        child: LayoutBuilder(
                          builder:
                              (BuildContext context, BoxConstraints constraints) {
                            return GridView.builder(
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 20.0,
                                childAspectRatio: 1,
                              ),
                              // childAspectRatio: 1.7),
                              itemCount: _mqttPayloadProvider
                                  .weatherModelinstance
                                  .data![0]
                                  .WeatherSensorlist![0]
                                  .sensorlist
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const RadialGradient(
                                          center: Alignment.bottomLeft,
                                          radius: 1.5,
                                          colors: [
                                            Color.fromARGB(255, 131, 180, 237),
                                            Color.fromARGB(255, 220, 240, 247),
                                          ],
                                        )),
                                    child: gaugeViewWeather(
                                        _mqttPayloadProvider
                                            .weatherModelinstance
                                            .data![0]
                                            .WeatherSensorlist![i]
                                            .sensorlist[index],
                                        i,
                                        index),
                                  ),
                                  onTap: () {
                                    if (_mqttPayloadProvider
                                        .weatherModelinstance
                                        .data![0]
                                        .WeatherSensorlist![0]
                                        .sensorlist[index] !=
                                        'WindDirection') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WeatherReportbar(
                                                index: i,
                                                Sno: _mqttPayloadProvider
                                                    .weatherModelinstance
                                                    .data![0]
                                                    .WeatherSensorlist![i]
                                                    .sNo,
                                                userId: widget.userId,
                                                controllerId:
                                                widget.controllerId,
                                                titletype: _mqttPayloadProvider
                                                    .weatherModelinstance
                                                    .data![0]
                                                    .WeatherSensorlist![i]
                                                    .sensorlist[index],
                                                titlekeyvalue: _mqttPayloadProvider
                                                    .weatherModelinstance
                                                    .data![0]
                                                    .WeatherSensorlist![i]
                                                    .sensorlisthw[index])),
                                      );
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              //WEB Screen
              return Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.teal.shade50,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            // Text(
                            //   'Irrigation Line: ${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![0].irrigationLine} ',
                            //   style: const TextStyle(
                            //       fontWeight: FontWeight.bold, fontSize: 15),
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Last Sync:'),
                                IconButton(
                                    onPressed: () {
                                      Request();
                                      fetchDataLive();
                                    },
                                    icon: Icon(Icons.refresh)),
                              ],
                            ),
                            Text(
                              maxLines: 3,
                              '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].time} / ${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].date}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/images/w08.png',
                          width: 150.0,
                          height: 150.0,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].temperature}',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 68,
                              color: myTheme.primaryColor),
                        ),
                        SizedBox(
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Image.asset(
                                    'assets/images/sunrise.png',
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    '$sunrise',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Image.asset(
                                    'assets/images/sunset.png',
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    '$sunset',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '$daylight',
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                        ),

                        // Container(
                        //   height: 1,
                        //   color: Colors.black,
                        // ),

                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Container(
                          //   height: 20,
                          //   padding:
                          //   EdgeInsets.only(left: 30, right: 30, bottom: 5),
                          //   alignment: Alignment.centerLeft,
                          //   child: const Text(
                          //     'Weather Sensors ',
                          //     style: TextStyle(fontWeight: FontWeight.w900),
                          //   ),
                          // ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Irrigation Line: ${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![0].irrigationLineName ?? "All Line"} ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    color: Colors.teal.shade50,
                                    padding:
                                    EdgeInsets.only(left: 15, right: 15, bottom: 10),
                                    // height: constraints.maxHeight * 0.59,
                                    child: LayoutBuilder(
                                      builder: (BuildContext context,
                                          BoxConstraints constraints) {
                                        return SingleChildScrollView(
                                          child: customizeGridView(
                                            maxWith: 200,
                                            maxHeight: 290,
                                            screenWidth: constraints.maxWidth,
                                            listOfWidget: [
                                              for (var index = 0;
                                              index <
                                                  _mqttPayloadProvider
                                                      .weatherModelinstance
                                                      .data![0]
                                                      .WeatherSensorlist![i]
                                                      .sensorlist
                                                      .length;
                                              index++)
                                                InkWell(
                                                  onTap: () {
                                                    if (_mqttPayloadProvider
                                                        .weatherModelinstance
                                                        .data![0]
                                                        .WeatherSensorlist![0]
                                                        .sensorlist[index] !=
                                                        'WindDirection') {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => WeatherReportbar(
                                                                index: i,
                                                                Sno: _mqttPayloadProvider
                                                                    .weatherModelinstance
                                                                    .data![0]
                                                                    .WeatherSensorlist![i]
                                                                    .sNo,
                                                                userId: widget.userId,
                                                                controllerId:
                                                                widget.controllerId,
                                                                titletype: _mqttPayloadProvider
                                                                    .weatherModelinstance
                                                                    .data![0]
                                                                    .WeatherSensorlist![i]
                                                                    .sensorlist[index],
                                                                titlekeyvalue: _mqttPayloadProvider
                                                                    .weatherModelinstance
                                                                    .data![0]
                                                                    .WeatherSensorlist![i]
                                                                    .sensorlisthw[index])),
                                                      );
                                                    }
                                                  },
                                                  child: gaugeViewWeather(
                                                      _mqttPayloadProvider
                                                          .weatherModelinstance
                                                          .data![0]
                                                          .WeatherSensorlist![i]
                                                          .sensorlist[index],
                                                      i,
                                                      index),
                                                )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
    ));
  }

  Widget gaugeViewWeather(String title, int i, int index) {
    String type = '0';
    String Unit = '0';
    String imageAsserStr = '';
    double Max = 100;
    String value = cardValues(
        _mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![0]
            .sensorlist[index],
        i);
    String errorStatus = cardErrValues(
        _mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![0]
            .sensorlist[index],
        i);
    Color bgcolor = Colors.transparent;
    if (errorStatus == '1') {
      bgcolor = Colors.red.shade50;
    } else if (errorStatus == '2') {
      bgcolor = Colors.yellow.shade50;
    } else if (errorStatus == '3') {
      bgcolor = Colors.orange.shade50;
    } else {
      bgcolor = Colors.white;
    }
    if (title == 'SoilMoisture1') {
      title = 'SoilMoisture 1';
      type = '1';
      Unit = 'CB';
      Max = 200;
      imageAsserStr = 'assets/weatherIcons2/SoilMoisture.png';
    } else if (title == 'SoilMoisture2') {
      title = 'SoilMoisture 2';
      type = '1';
      Unit = 'CB';
      Max = 200;
      imageAsserStr = 'assets/weatherIcons2/SoilMoisture.png';
    } else if (title == 'SoilMoisture3') {
      title = 'SoilMoisture 3';
      type = '1';
      Unit = 'CB';
      Max = 200;
      imageAsserStr = 'assets/weatherIcons2/SoilMoisture.png';
    } else if (title == 'SoilMoisture4') {
      title = 'SoilMoisture 4';
      type = '1';
      Unit = 'CB';
      Max = 200;
      imageAsserStr = 'assets/weatherIcons2/SoilMoisture.png';
    } else if (title == 'SoilTemperature') {
      type = '2';
      Unit = '°C';
      Max = 100;
      imageAsserStr = 'assets/weatherIcons2/SoilTemp .png';
    } else if (title == 'Temperature') {
      type = '2';
      Unit = '°C';
      Max = 100;
      imageAsserStr = 'assets/weatherIcons2/SoilTemp .png';
    } else if (title == 'AtmospherePressure') {
      type = '3';
      Unit = 'kPa';
      Max = 2000;
      imageAsserStr = 'assets/weatherIcons2/pressure.png';
    } else if (title == 'Humidity') {
      type = '2';
      Unit = '%';
      Max = 100;
      imageAsserStr = 'assets/weatherIcons2/humidity.png';
    } else if (title == 'LeafWetness') {
      type = '4';
      Unit = '%';
      Max = 100;
      imageAsserStr = 'assets/weatherIcons2/leafWetness.png';
    } else if (title == 'Co2') {
      type = '2';
      Unit = 'ppm';
      Max = 1000;
      imageAsserStr = 'assets/weatherIcons2/CO-2.png';
    } else if (title == 'LDR') {
      type = '5';
      Unit = 'Lu';
      Max = 100;
      imageAsserStr = 'assets/weatherIcons2/LDR.png';
    } else if (title == 'Lux') {
      type = '5';
      Unit = 'Lu';
      Max = 100;
      imageAsserStr = 'assets/weatherIcons2/Lux.png';
    } else if (title == 'WindDirection') {
      type = '7';
      Unit = 'CB';
      Max = 360;
      imageAsserStr = 'assets/weatherIcons2/WindDirection.png';
    } else if (title == 'Rainfall') {
      type = '2';
      Unit = 'mm';
      Max = 100;
      imageAsserStr = 'assets/weatherIcons2/rainFall.png';
    } else if (title == 'WindSpeed') {
      type = '3';
      Unit = 'km/h';
      Max = 100;
      imageAsserStr = 'assets/weatherIcons2/WindSpeed.png';
    } else {
      type = '0';
      Unit = '';
      imageAsserStr = 'assets/weatherIcons2/WindSpeed.png';
    }
    // type = '1';
    if (type == "1") {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: bgcolor,// This sets the corner radius
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    imageAsserStr,
                    width: 30.0,
                    height: 30.0,
                    // fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 30, width: 150, child: Text('$title',textAlign: TextAlign.center, style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold))),
              ],
            ),
            Container(height: 200,
                width: 200,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.001),
                    borderRadius: BorderRadius.circular(5)),
                child: SfRadialGauge(
                    backgroundColor: bgcolor,
                    enableLoadingAnimation: true,
                    animationDuration: 1000,
                    // title: GaugeTitle(text: title),
                    axes: <RadialAxis>[
                      RadialAxis(
                          axisLineStyle: const AxisLineStyle(
                              thicknessUnit: GaugeSizeUnit.factor, thickness: 0.25),
                          radiusFactor:   0.8,
                          showTicks: false,
                          showLastLabel: true,
                          maximum: Max,
                          axisLabelStyle: const GaugeTextStyle(),
                          // Added custom axis renderer that extended from RadialAxisRenderer
                          pointers: <GaugePointer>[
                            RangePointer(
                                value: double.parse(value),
                                width: 0.25,
                                sizeUnit: GaugeSizeUnit.factor,
                                color: const Color(0xFF494CA2),
                                animationDuration: 1300,
                                animationType: AnimationType.easeOutBack,
                                gradient: const SweepGradient(
                                    colors: <Color>[Colors.greenAccent,Colors.amber, Color(0xFFE63B86),Colors.redAccent],
                                    stops: <double>[0.30,0.50,1.0,2.0]),
                                enableAnimation: true)
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                widget: Container(
                                    child: Text('${value} ${Unit}',
                                        style: const TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold))),
                                angle: 90,
                                positionFactor: 1.2)
                          ]
                      ),
                    ])),
            Column(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(child: SizedBox(height: 20, width: 150, child: MinMAxvalues("Min",'00','00:00:00'))),
                Center(child: SizedBox(height: 20, width: 150, child: MinMAxvalues("Max",'00','00:00:00'))),
              ],
            ),

          ],
        ),
      );
    } else if (type == "2") {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: bgcolor,// This sets the corner radius
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    imageAsserStr,
                    width: 30.0,
                    height: 30.0,
                    // fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 30, width: 160, child: Text('$title',textAlign: TextAlign.center, style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold))),
              ],
            ),
            Container(
              height: 180,
              width: 200,
              decoration: BoxDecoration(
                  border: Border.all(width: 0.001),
                  borderRadius: BorderRadius.circular(5)),
              child: SfLinearGauge(
                minimum: 0,
                maximum: Max,
                orientation: LinearGaugeOrientation.vertical,
                markerPointers: [
                  LinearShapePointer(
                    shapeType: LinearShapePointerType.invertedTriangle,
                    color: Colors.green,
                    value: double.parse(value),
                  ),
                ],
                ranges: [
                  LinearGaugeRange(
                    edgeStyle: LinearEdgeStyle.bothCurve,
                    startWidth: 10,
                    endWidth: 10,
                    midWidth: 10,
                    startValue: 0,
                    endValue: double.parse(value),
                  ),

                ],
              ),

            ),
            SizedBox(
                height: 30,
                width: 200,
                child: Text(
                    '$value  $Unit',
                    textAlign: TextAlign.center,   style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold)
                )),
            Column(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(child: SizedBox(height: 20, width: 150, child: MinMAxvalues("Min",'00','00:00:00'))),
                Center(child: SizedBox(height: 20, width: 150, child: MinMAxvalues("Max",'00','00:00:00'))),
              ],
            ),
          ],
        ),
      );
    } else if (type == "3") {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: bgcolor,// This sets the corner radius
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    imageAsserStr,
                    width: 30.0,
                    height: 30.0,
                    // fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 30, width: 160, child: Text('$title',textAlign: TextAlign.center, style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold))),
              ],
            ),
            Container(height: 200,
                width: 200,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.001),
                    borderRadius: BorderRadius.circular(5)),
                child: SfRadialGauge(
                    backgroundColor: bgcolor,
                    enableLoadingAnimation: true,
                    animationDuration: 1000,
                    axes: <RadialAxis>[
                      RadialAxis(
                          showFirstLabel: true,
                          showLastLabel: true,
                          showLabels: true,
                          majorTickStyle: const MajorTickStyle(
                              length: 7,
                              thickness: 2,
                              lengthUnit: GaugeSizeUnit.logicalPixel,
                              color: Colors.deepOrangeAccent),
                          canScaleToFit: true,
                          minimum: 0,
                          maximum: Max,
                          ranges: <GaugeRange>[
                            GaugeRange(
                                startValue: 0,
                                endValue: (40 / 100) * Max,
                                color: Colors.green),
                            GaugeRange(
                                startValue: (40 / 100) * Max,
                                endValue: (60 / 100) * Max,
                                color: Colors.yellow),
                            GaugeRange(
                                startValue: (60 / 100) * Max,
                                endValue: (80 / 100) * Max,
                                color: Colors.orange),
                            GaugeRange(
                                startValue: (80 / 100) * Max,
                                endValue: (100 / 100) * Max,
                                color: Colors.red)
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(
                              value: double.parse(value),
                              needleLength: 0.7,
                              needleEndWidth: 5,
                              needleStartWidth: 0.8,
                              tailStyle: const TailStyle(
                                width: 5,
                              ),
                            )
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                widget: Container(
                                    child: Text('${value} ${Unit}',
                                        style: const TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold))),
                                angle: 90,
                                positionFactor: 0.9)
                          ])
                    ])),
            Column(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(child: SizedBox(height: 20, width: 150, child: MinMAxvalues("Min",'00','00:00:00'))),
                Center(child: SizedBox(height: 20, width: 150, child: MinMAxvalues("Max",'00','00:00:00'))),
              ],
            ),
          ],
        ),
      );
    } else if (type == "7") {//winddirection
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: bgcolor,// This sets the corner radius
        ),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    imageAsserStr,
                    width: 30.0,
                    height: 30.0,
                    // fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 30, width: 150, child: Text('$title',textAlign: TextAlign.center, style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold))),
              ],
            ),
            Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.001),
                    borderRadius: BorderRadius.circular(5)),
                child: SfRadialGauge(

                    backgroundColor: bgcolor,
                    enableLoadingAnimation: true,
                    animationDuration: 1000,
                    axes: <RadialAxis>[
                      RadialAxis(
                          backgroundImage: AssetImage('assets/weather/compass.png'),
                          radiusFactor: 1,
                          canRotateLabels: true,
                          offsetUnit: GaugeSizeUnit.factor,
                          onLabelCreated: handleAxisLabelCreated,
                          startAngle: 270,
                          endAngle: 270,
                          maximum: 360,
                          interval: 30,
                          minorTicksPerInterval: 4,

                          showAxisLine: false,
                          showFirstLabel: false,
                          showLastLabel: false,
                          showLabels: false,
                          canScaleToFit: false,
                          showTicks: false,
                          minimum: 0,
                          ranges: <GaugeRange>[],
                          pointers: <GaugePointer>[
                            MarkerPointer(
                              value: double.parse(value),
                              color: Colors.redAccent,
                              enableAnimation: true,
                              animationDuration: 1200,
                              markerOffset: 0.62,
                              offsetUnit: GaugeSizeUnit.factor,
                              markerType: MarkerType.triangle,
                              markerHeight: 70,
                              markerWidth: 15,
                            ),
                            MarkerPointer(
                              value: double.parse(value) < 180 ? double.parse(value) + 180 : double.parse(value) - 180,
                              color: Colors.grey,
                              enableAnimation: true,
                              animationDuration: 1200,
                              markerOffset: 0.60,
                              offsetUnit: GaugeSizeUnit.factor,
                              markerType: MarkerType.triangle,
                              markerHeight: 70,
                              markerWidth: 15,
                            )

                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                widget: Container(
                                    child: Text(degreeToDirection(value),
                                        style: const TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold))),
                                angle: 90,
                                positionFactor: 1.1)
                          ]
                      ),

                    ])),
          ],
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: bgcolor,// This sets the corner radius
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    imageAsserStr,
                    width: 30.0,
                    height: 30.0,
                    // fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 30, width: 150, child: Text('$title',textAlign: TextAlign.center, style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold))),
              ],
            ),
            Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.001),
                    borderRadius: BorderRadius.circular(5)),
                child: SfRadialGauge(
                    backgroundColor: bgcolor,
                    enableLoadingAnimation: true,
                    animationDuration: 1000,
                    axes: <RadialAxis>[
                      RadialAxis(
                          showFirstLabel: true,
                          showLastLabel: true,
                          showLabels: true,
                          majorTickStyle: const MajorTickStyle(
                              length: 7,
                              thickness: 2,
                              lengthUnit: GaugeSizeUnit.logicalPixel,
                              color: Colors.deepOrangeAccent),
                          canScaleToFit: true,
                          minimum: 0,
                          maximum: Max,
                          ranges: <GaugeRange>[
                            GaugeRange(
                                startValue: 0,
                                endValue: (40 / 100) * Max,
                                color: Colors.green),
                            GaugeRange(
                                startValue: (40 / 100) * Max,
                                endValue: (60 / 100) * Max,
                                color: Colors.yellow),
                            GaugeRange(
                                startValue: (60 / 100) * Max,
                                endValue: (80 / 100) * Max,
                                color: Colors.orange),
                            GaugeRange(
                                startValue: (80 / 100) * Max,
                                endValue: (100 / 100) * Max,
                                color: Colors.red)
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(
                              value: double.parse(value),
                              needleLength: 0.7,
                              needleEndWidth: 5,
                              needleStartWidth: 0.8,
                              tailStyle: const TailStyle(
                                width: 5,
                              ),
                            )
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                widget: Container(
                                    child: Text('${value} ${Unit}',
                                        style: const TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold))),
                                angle: 90,
                                positionFactor: 0.9)
                          ])
                    ])),
            Center(child: SizedBox(height: 20, width: 150, child: MinMAxvalues("Min",'00','00:00:00'))),
            Center(child: SizedBox(height: 20, width: 150, child: MinMAxvalues("Max",'00','00:00:00'))),
          ],
        ),
      );
    }
  }
  Widget MinMAxvalues(String M,String Mval,String Mtime )
  {
    return Column(mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 20, width: 150, child: RichText(
          text:   TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '$M: ',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              TextSpan(
                text: '$Mval',
                style: TextStyle(color: Colors.red, fontSize: 15,fontWeight: FontWeight.bold),
              ),

              TextSpan(
                text: '\t\t$Mtime',
                style: TextStyle(color: Colors.teal, fontSize: 15,fontWeight: FontWeight.w100),
              ),

            ],
          ),
        ), ),
      ],
    );
  }

  static String degreeToDirection(String degreestr) {
    print('degreestr$degreestr');
    String cleanedString = degreestr.replaceAll('º', '').trim();
    double degree = double.parse(degreestr);
    if ((degree >= 337.5 && degree <= 360) || (degree >= 0.0 && degree < 22.5)) {
      return 'North';
    } else if (degree >= 22.5 && degree < 67.5) {
      return 'NorthEast';
    } else if (degree >= 67.5 && degree < 112.5) {
      return 'East';
    } else if (degree >= 112.5 && degree < 157.5) {
      return 'SouthEast';
    } else if (degree >= 157.5 && degree < 202.5) {
      return 'South';
    } else if (degree >= 202.5 && degree < 247.5) {
      return 'SouthWest';
    } else if (degree >= 247.5 && degree < 292.5) {
      return 'West';
    } else if (degree >= 292.5 && degree < 337.5) {
      return 'NorthWest';
    } else {
      return degreestr;
    }
  }

  void handleAxisLabelCreated(AxisLabelCreatedArgs args) {
    if (args.text == '90') {
      args.text = 'E';
      args.labelStyle = const GaugeTextStyle(
        color: Color(0xFFDF5F2D),
        fontSize: 10,
      );
    } // Gauge TextStyle
    else if (args.text == '360') {
      args.text = '';
    } else {
      if (args.text == '0') {
        args.text = 'N';
      } else if (args.text == '180') {
        args.text = 'S';
      } else if (args.text == '270') {
        args.text = 'W';
      }
      args.labelStyle =
      const GaugeTextStyle(color: Color(0xFFFFFFFF), fontSize: 10);
    }
  }
  String cardValues(String checkStr, int i) {
    _mqttPayloadProvider =
        Provider.of<MqttPayloadProvider>(context, listen: true);
    switch (checkStr) {
      case 'SoilMoisture1':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].soilMoisture1}';
      case 'SoilMoisture2':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].soilMoisture2}';
      case 'SoilMoisture3':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].soilMoisture3}';
      case 'SoilMoisture4':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].soilMoisture4}';
      case 'SoilTemperature':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].soilTemperature}';
      case 'Humidity':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].humidity}';
      case 'Temperature':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].temperature}';
      case 'AtmospherePressure':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].atmospherePressure}';
      case 'Co2':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].co2}';
      case 'LDR':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].ldr}';
      case 'Lux':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].lux}';
      case 'WindDirection':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].windDirection}';
      case 'WindSpeed':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].windSpeed}';
      case 'Rainfall':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].rainfall}';
      case 'LeafWetness':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].leafWetness}';
      default:
        return '0';
    }
  }

  String cardErrValues(String checkstr, int i) {
    _mqttPayloadProvider =
        Provider.of<MqttPayloadProvider>(context, listen: false);
    switch (checkstr) {
      case 'SoilMoisture1':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].soilMoisture1Err}';
      case 'SoilMoisture2':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].soilMoisture2Err}';
      case 'SoilMoisture3':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].soilMoisture3Err}';
      case 'SoilMoisture4':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].soilMoisture4Err}';
      case 'SoilTemperature':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].soilTemperatureErr}';
      case 'Humidity':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].humidityErr}';
      case 'Temperature':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].temperatureErr}';
      case 'AtmospherePressure':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].atmospherePressureErr}';
      case 'Co2':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].co2Err}';
      case 'LDR':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].ldrErr}';
      case 'Lux':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].luxErr}';
      case 'WindDirection':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].windDirectionErr}';
      case 'WindSpeed':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].windSpeedErr}';
      case 'Rainfall':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].rainfallErr}';
      case 'LeafWetness':
        return '${_mqttPayloadProvider.weatherModelinstance.data![0].WeatherSensorlist![i].leafWetnessErr}';
      default:
        return '0';
    }
  }
  Request() {
    print("inital :: ${widget.initialIndex}");
    String payLoadFinal = jsonEncode({
      "5000": [
        {"5001": ""},
      ]
    });
    MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.deviceID}');
    print('AppToFirmware/${widget.deviceID}');
  }

  // TODO: implement widget
  Future<void> fetchDataSunRiseSet() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.sunrisesunset.io/json?lat=11.0168&lng=77.9558'));
      if (response.statusCode == 200) {
        weatherData = json.decode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
      DateTime nowDate = DateTime.now();
      String day = DateFormat('EEE').format(nowDate);

      int indexOfThu = weekDayList.indexOf(day); // 3

      weekDayList = [
        ...weekDayList.sublist(indexOfThu),
        ...weekDayList.sublist(0, indexOfThu),
      ];
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> fetchDataLive() async {
    Map<String, Object> body = {
      "userId": widget.userId,
      "controllerId": widget.controllerId
    };
    final response =
    await HttpService().postRequest("getUserWeatherLive", body);
    if (response.statusCode == 200) {
      setState(() {
        var jsonData = jsonDecode(response.body);
        if (jsonData['code'] == 200) {
          Map<String, dynamic> payLoadFinal = {
            "5100": [
              {"5101": jsonData['data']},
            ]
          };
          _mqttPayloadProvider.updatehttpweather(payLoadFinal);
        }
      });
    } else {
      //_showSnackBar(response.body);
    }
  }
}