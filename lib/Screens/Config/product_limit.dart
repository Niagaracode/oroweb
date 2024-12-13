import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Models/product_limit_model.dart';
import '../../constants/http_service.dart';
import 'config_maker/config_maker.dart';
import 'config_screen.dart';

class ProductLimits extends StatefulWidget {
  const ProductLimits({Key? key, required this.userID,  required this.customerID, required this.userType, required this.inputCount, required this.siteName, required this.controllerId, required this.deviceId, required this.outputCount, required this.myCatIds}) : super(key: key);
  final int userID, customerID, userType, inputCount,outputCount, controllerId;
  final String siteName, deviceId;
  final List<int> myCatIds;


  @override
  State<ProductLimits> createState() => _ProductLimitsState();
}

class _ProductLimitsState extends State<ProductLimits> with SingleTickerProviderStateMixin {

  int filledOutputCount = 0;
  int filledInputCount = 0;
  int currentTxtFldVal = 0;
  List<MdlProductLimit> productLimits = <MdlProductLimit>[];

  var myControllers = [];
  bool visibleLoading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    getProductLimits();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      if(_tabController.index==0){
        getProductLimits();
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (var c in myControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> getProductLimits() async
  {
    indicatorViewShow();
    await Future.delayed(const Duration(milliseconds: 500));
    Map<String, dynamic> body = {"userId" : widget.customerID, "controllerId" : widget.controllerId};
    final response = await HttpService().postRequest("getUserProductLimit", body);
    if (response.statusCode == 200)
    {
      print(response.body);
      productLimits.clear();
      var data = jsonDecode(response.body);
      if(data["code"]==200)
      {
        final cntList = data["data"] as List;
        myControllers = [];
        filledOutputCount = 0;
        filledInputCount = 0;
        for (int i = 0; i < cntList.length; i++) {
          bool existsInCategory = widget.myCatIds.any((value) => cntList[i]['category'].contains(value.toString()));
          if (existsInCategory) {
            productLimits.add(MdlProductLimit.fromJson(cntList[i]));
            myControllers.add(TextEditingController(text: "${cntList[i]['quantity']}"));
            int quantity = cntList[i]['quantity']!;
            if(cntList[i]['connectionType'] == 'Output'){
              filledOutputCount += quantity;
            }else if(cntList[i]['connectionType']=='Input'){
              filledInputCount += quantity;
            }else{
              //other common count...
            }
          } else {
            print("None of the values");
          }
        }
      }
      setState(() {
        productLimits;
        indicatorViewHide();
      });

    }
    else{
      //_showSnackBar(response.body);
    }
  }

  Future<void> updateProductLimit() async
  {
    for (int i=0; i < productLimits.length; i++) {
      if(myControllers[i].text==""){
        myControllers[i].text = "0";
      }
      productLimits[i].quantity = int.parse(myControllers[i].text);
    }

    Map<String, dynamic> body = {
      "userId": widget.customerID,
      "controllerId": widget.controllerId,
      "productLimit": productLimits,
      "createUser": widget.userID,
    };
    final response = await HttpService().postRequest("createUserProductLimit", body);
    if(response.statusCode == 200)
    {
      var data = jsonDecode(response.body);
      if(data["code"]==200) {
        _showSnackBar(data["message"]);
      }
      else{
        _showSnackBar(data["message"]);
      }
    }
  }


  @override
  Widget build(BuildContext context)
  {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.siteName),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.teal,
            tabs: const [
              Tab(text: 'Product limit'),
              Tab(text: 'Config maker'),
              Tab(text: 'Others'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  height: mediaQuery.size.height-230,
                  color:  Colors.white,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            itemCount: productLimits.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsetsDirectional.all(5.0),
                                decoration:  BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black38, // Border color
                                    width: 1.0,          // Border width
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded (
                                      flex:1,
                                      child : Container(
                                        constraints: const BoxConstraints.expand(),
                                        decoration: BoxDecoration(
                                          color: Colors.yellow.shade50,
                                          border: Border.all(width: 0.2, color: Colors.black54),
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child : Image.asset(getImageForProduct(productLimits[index].product)),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex :3,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10, right: 10),
                                            child: TextField(
                                              controller: myControllers[index],
                                              keyboardType: TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.digitsOnly
                                              ],
                                              decoration: InputDecoration(
                                                labelText: productLimits[index].product,
                                              ),
                                              onTap: () {
                                                currentTxtFldVal = int.parse(myControllers[index].text);
                                                print(currentTxtFldVal);
                                              },
                                              onChanged: (input) async {
                                                await Future.delayed(const Duration(milliseconds: 50));
                                                filledOutputCount = 0;
                                                filledInputCount = 0;
                                                for (int i = 0; i < productLimits.length; i++) {
                                                  var controller = myControllers[i];
                                                  if (productLimits[i].connectionType == 'Output') {
                                                    filledOutputCount += int.tryParse(controller.text) ?? 0; // Accumulate value for 'Output'
                                                  } else if (productLimits[i].connectionType == 'Input') {
                                                    filledInputCount += int.tryParse(controller.text) ?? 0; // Accumulate value for 'Input'
                                                  } else {
                                                    // Handle other cases if needed
                                                  }
                                                }
                                                setState(() {
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),)
                                  ],
                                ),
                              );
                            },
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: mediaQuery.size.width > 1200 ? 6 : 4,
                              childAspectRatio: mediaQuery.size.width / 460,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        color: Colors.teal.shade50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text('Total Output :'),
                            const SizedBox(width: 10,),
                            Text('${widget.outputCount}', style: const TextStyle(fontSize: 17),),
                            const SizedBox(width: 20,),
                            const Text('Remaining :'),
                            const SizedBox(width: 10,),
                            Text('${widget.outputCount - filledOutputCount}', style: TextStyle(fontSize: 17, color:
                            (widget.outputCount - filledOutputCount) >= 0 ? Colors.black: Colors.red)),
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: VerticalDivider(),
                            ),
                            const Text('Total Input :'),
                            const SizedBox(width: 10,),
                            Text('${widget.inputCount}', style: const TextStyle(fontSize: 17),),
                            const SizedBox(width: 20,),
                            const Text('Remaining :'),
                            const SizedBox(width: 10,),
                            Text('${widget.inputCount - filledInputCount}', style: TextStyle(fontSize: 17, color:
                            (widget.inputCount - filledInputCount) >= 0 ? Colors.black : Colors.red)),
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: VerticalDivider(),
                            ),
                            TextButton.icon(
                              onPressed: (){
                                updateProductLimit();
                              },
                              label: const Text('Save'),
                              icon: const Icon(
                                Icons.save_as_outlined,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ConfigMakerScreen(userID: widget.userID, customerID: widget.customerID, controllerId: widget.controllerId, imeiNumber: widget.deviceId,),
                ConfigScreen(userID: widget.userID, customerID: widget.customerID, siteName: widget.siteName, controllerId: widget.controllerId, imeiNumber: widget.deviceId,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String getImageForProduct(String product) {
    String baseImgPath = 'assets/images/';
    switch (product) {
      case 'Valve':
        return '${baseImgPath}valve_gray.png';
      case 'Main Valve':
        return '${baseImgPath}dp_main_valve_not_open.png';
      case 'Source Pump':
        return '${baseImgPath}irrigation_pump.png';
      case 'Irrigation Pump':
        return '${baseImgPath}irrigation_pump.png';
      case 'Irrigation Line':
        return '${baseImgPath}dl_irrigation_line.png';
      case 'Analog Sensor':
        return '${baseImgPath}dl_analog_sensor.png';
      case 'Level Sensor':
        return '${baseImgPath}dl_level_sensor.png';
      case 'Booster Pump':
        return '${baseImgPath}booster_pump.png';
      case 'Central Fertilizer Site':
        return '${baseImgPath}dl_central_fertilizer_site.png';
      case 'Central Filter Site':
        return '${baseImgPath}dl_central_filtration_site.png';
      case 'Agitator':
        return '${baseImgPath}dp_agitator_gray.png';
      case 'Injector':
        return '${baseImgPath}fert_chanel.png';
      case 'Filter':
        return '${baseImgPath}filter.png';
      case 'Downstream Valve':
        return '${baseImgPath}dl_downstream_valve.png';
      case 'Fan':
        return '${baseImgPath}dl_fan.png';
      case 'Fogger':
        return '${baseImgPath}dl_fogger.png';
      case 'Selector':
        return '${baseImgPath}dl_selector.png';
      case 'Water Meter':
        return '${baseImgPath}water_meter.png';
      case 'Fertilizer Meter':
        return '${baseImgPath}dl_fertilizer_meter.png';
      case 'Co2 Sensor':
        return '${baseImgPath}dl_co2.png';
      case 'Pressure Switch':
        return '${baseImgPath}pressure_switch.png';
      case 'Pressure Sensor':
        return '${baseImgPath}pressure_sensor.png';
      case 'Differential Pressure Sensor':
        return '${baseImgPath}pressure_sensor.png';
      case 'EC Sensor':
        return '${baseImgPath}dl_ec_sensor.png';
      case 'PH Sensor':
        return '${baseImgPath}dl_ph_sensor.png';
      case 'Temperature Sensor':
        return '${baseImgPath}dl_temperature_sensor.png';
      case 'Soil Temperature Sensor':
        return '${baseImgPath}dl_soil_temperature_sensor.png';
      case 'Wind Direction Sensor':
        return '${baseImgPath}dl_wind_direction_sensor.png';
      case 'Wind Speed Sensor':
        return '${baseImgPath}dl_wind_speed_sensor.png';
      case 'LUX Sensor':
        return '${baseImgPath}dl_lux_sensor.png';
      case 'LDR Sensor':
        return '${baseImgPath}dl_ldr_sensor.png';
      case 'Humidity Sensor':
        return '${baseImgPath}dl_humidity_sensor.png';
      case 'Leaf Wetness Sensor':
        return '${baseImgPath}dl_leaf_wetness_sensor.png';
      case 'Rain Gauge Sensor':
        return '${baseImgPath}dl_rain_gauge_sensor.png';
      case 'Contact':
        return '${baseImgPath}dl_contact.png';
      case 'Weather Station':
        return '${baseImgPath}dl_weather_station.png';
      case 'Condition':
        return '${baseImgPath}dl_condition.png';
      case 'Valve Group':
        return '${baseImgPath}dl_valve_group.png';
      case 'Virtual Water Meter':
        return '${baseImgPath}dl_virtual_water_meter.png';
      case 'Program':
        return '${baseImgPath}dl_programs.png';
      case 'Radiation Set':
        return '${baseImgPath}dl_radiation_sets.png';
      case 'Fertilizer Set':
        return '${baseImgPath}dl_fertilization_sets.png';
      case 'Filter Set':
        return '${baseImgPath}dl_filter_sets.png';
      case 'Moisture Sensor':
        return '${baseImgPath}moisture_sensor.png';
      case 'Float':
        return '${baseImgPath}dl_float.png';
      case 'Moisture Condition':
        return '${baseImgPath}dl_moisture_condition.png';
      case 'Tank Float':
        return '${baseImgPath}dl_tank_float.png';
      case 'Power Supply':
        return '${baseImgPath}dl_power_supply.png';
      case 'Level Condition':
        return '${baseImgPath}dl_level_condition.png';
      case 'Common Pressure Sensor':
        return '${baseImgPath}dl_common_pressure_sensor.png';
      case 'Common Pressure Switch':
        return '${baseImgPath}dl_common_pressure_switch.png';
      case 'Water Source':
        return '${baseImgPath}dl_water_source.png';
      default:
        return '${baseImgPath}dl_humidity_sensor.png';
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void indicatorViewShow() {
    setState(() {
      visibleLoading = true;
    });
  }

  void indicatorViewHide() {
    setState(() {
      visibleLoading = false;
    });
  }

}
