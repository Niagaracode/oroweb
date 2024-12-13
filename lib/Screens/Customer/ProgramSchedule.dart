import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/Screens/Config/NewPreference/preference_main_screen.dart';
import 'package:oro_irrigation_new/Screens/Customer/program_queue_screen.dart';
import 'package:oro_irrigation_new/Screens/Customer/radiationsets.dart';
import 'package:oro_irrigation_new/screens/Customer/system_definition_screen.dart';
import 'package:oro_irrigation_new/screens/Customer/virtual_screen.dart';
import 'package:oro_irrigation_new/screens/Customer/watersourceUI.dart';
import 'package:provider/provider.dart';

import '../../constants/http_service.dart';
import '../../state_management/FertilizerSetProvider.dart';
import '../Config/Constant/constant_tab_bar_view.dart';
import '../Config/names_form.dart';
import '../map/custommarker.dart';
import 'FertilizerSet.dart';
import 'GlobalFertilizerLimit.dart';
import 'IrrigationProgram/program_library.dart';
import 'WeatherScreen.dart';
import 'calibration.dart';
import 'conditionscreen.dart';
import 'fiterbackwash.dart';
import 'frost_productionScreen.dart';
import 'groupscreen.dart';

class ProgramSchedule extends StatefulWidget {
  const ProgramSchedule({
    Key? key,
    required this.customerID,
    required this.controllerID,
    required this.siteName,
    required this.imeiNumber,
    required this.userId,
  }) : super(key: key);

  final int userId, customerID, controllerID;
  final String siteName, imeiNumber;

  @override
  State<ProgramSchedule> createState() => _ProgramScheduleState();
}

class _ProgramScheduleState extends State<ProgramSchedule> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> sideMenuList = [];
  int hoverTab = -1;
  int selectedIndex =  0;


  @override
  void initState() {
    super.initState();
     // selectedIndex = widget.checkprogramcondition == 5 ? 5 : 0;

    getPlanningSideMenu();
  }

  Future<void> getPlanningSideMenu() async {
    try {
      Map<String, Object> body = {"userId": widget.customerID, "controllerId": widget.controllerID};
      final response = await HttpService().postRequest("getUserMainMenuHiddenStatus", body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<dynamic> itemList = jsonResponse['data'];
        List<Map<String, dynamic>> newSideMenuList = [{'id': 1, 'label': 'Irrigation Program', 'value': '1'}];
        newSideMenuList.addAll(itemList.where((item) => item['value'] == '1')
            .map((item) => {'id': item['dealerDefinitionId'], 'label': item['parameter'] ?? '', 'value': item['value'].toString()
        }).toList());

        setState(() {
          sideMenuList = newSideMenuList;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Icon getIconForParameter(int id) {
    switch (id) {
      case 66:
        return const Icon(Icons.water, color: Colors.white,);
      case 67:
        return const Icon(Icons.gas_meter_outlined, color: Colors.white,);
      case 68:
        return const Icon(Icons.waves, color: Colors.white,);
      case 69:
        return const Icon(Icons.group_work_outlined, color: Colors.white,);
      case 70:
        return const Icon(Icons.format_list_numbered, color: Colors.white,);
      case 71:
        return const Icon(Icons.deblur_outlined, color: Colors.white,);
      case 72:
        return const Icon(Icons.filter_alt_outlined, color: Colors.white,);
      case 73:
        return const Icon(Icons.settings_outlined, color: Colors.white,);
      case 74:
        return const Icon(Icons.settings_outlined, color: Colors.white,);
      case 75:
        return const Icon(Icons.power_outlined, color: Colors.white,);
      case 76:
        return const Icon(Icons.question_answer_outlined, color: Colors.white,);
      case 78:
        return const Icon(Icons.settings, color: Colors.white,);
      case 79:
        return const Icon(Icons.code, color: Colors.white,);
      case 80:
        return const Icon(Icons.text_fields, color: Colors.white,);
      case 81:
        return const Icon(Icons.map_outlined, color: Colors.white,);
      default:
        return const Icon(Icons.help_outline, color: Colors.white,);
    }
  }

  Widget getViewForParameter(int id) {
    switch (id) {
      case 1:
        return ProgramLibraryScreen(customerId: widget.customerID, controllerId: widget.controllerID, deviceId: widget.imeiNumber, siteName: widget.siteName, userID: widget.userId,);
      case 66:
        return watersourceUI(userId: widget.customerID, controllerId: widget.controllerID, deviceID: widget.imeiNumber,);
      case 67:
        return VirtualMeterScreen(userId: widget.customerID, controllerId: widget.controllerID, deviceId: widget.imeiNumber);
      case 68:
        return RadiationSetUI(userId: widget.customerID, controllerId: widget.controllerID, );
      case 69:
      return MyGroupScreen(userId: widget.customerID, controllerId: widget.controllerID,  imeiNo: widget.imeiNumber);
      case 70:
        return ConditionScreen(customerId: widget.customerID, controllerId: widget.controllerID, imeiNo: widget.imeiNumber, isProgram: false, serialNumber: 0,);
      case 71:
        return FrostMobUI(userId: widget.customerID, controllerId: widget.controllerID,deviceID: widget.imeiNumber,);
      case 72:
        return FilterBackwashUI1(userId: widget.customerID, controllerId: widget.controllerID,deviceID: widget.imeiNumber,);
      case 73:
        return FertilizerSetScreen(userId: widget.customerID, controllerId: widget.controllerID, customerID: widget.customerID, deviceId: widget.imeiNumber,);
      case 74:
        return GlobalFertilizerLimit(userId: widget.customerID, controllerId: widget.controllerID, customerId: widget.customerID, deviceId: widget.imeiNumber,);
      case 75:
        return SystemDefinition(userId: widget.customerID, controllerId: widget.controllerID, deviceId: widget.imeiNumber,);
      case 76:
        return ProgramQueueScreen(userId: widget.customerID, controllerId: widget.controllerID, cutomerId: widget.customerID, customerId: widget.customerID, deviceId: widget.imeiNumber,);
      case 77:
        return WeatherScreen(userId: widget.customerID, controllerId: widget.controllerID,deviceID: widget.imeiNumber,initialIndex: 0,);
      case 78:
        return PreferenceMainScreen(userId: widget.customerID, controllerId: widget.controllerID, customerID: widget.customerID, deviceId: widget.imeiNumber,);
      case 79:
        return ConstantInConfig(userId: widget.customerID, deviceId: widget.imeiNumber, customerId: widget.customerID, controllerId: widget.controllerID);
      case 80:
        return Names(userID: widget.customerID, customerID: widget.customerID, controllerId: widget.controllerID, imeiNo: widget.imeiNumber);
      case 81:
        return CustomMarkerPage(userId: widget.customerID,deviceID: widget.imeiNumber,controllerId: widget.controllerID,);
      case 127:
        return Calibration(controllerId: widget.controllerID, userId: widget.customerID, deviceId:  widget.imeiNumber);

      default:
        return const Center(child: Text('id'));
    }

  }


  @override
  Widget build(BuildContext context) {
    var fertSetPvd = Provider.of<FertilizerSetProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: const Color(0xFF03464F),
      body: sideMenuList.isEmpty? const Center(child: CircularProgressIndicator()):
      SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF1C7C8A),
                      Color(0xFF03464F),
                    ],
                  ),
                ),
                width: 210,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // padding: EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            width: 200,
                            child: const Row(children: [
                              SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.arrow_back,color: Colors.white,),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Planning',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,fontSize: 22),
                              )
                            ]),
                          )),
                      for (var i = 0; i < sideMenuList.length; i++)
                        InkWell(
                            onTap: () {
                              //fertSetPvd.closeOverLay();
                              setState(() {
                                selectedIndex = i;
                              });
                            },
                            onHover: (value) {
                              if (value == true) {
                                setState(() {
                                  hoverTab = i;
                                });
                              } else {
                                setState(() {
                                  hoverTab = -1;
                                });
                              }
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: (hoverTab == i && selectedIndex == i)
                                    ? const Color(0xFF2999A9)
                                    : hoverTab == i
                                    ? const Color(0xFF2999A9)
                                    : selectedIndex == i
                                    ? const Color(0xFF2999A9)
                                    : null,
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              width: 200,
                              child: Row(children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                getIconForParameter(sideMenuList[i]['id']),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  sideMenuList[i]['label'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                            )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        color: const Color(0xffE6EDF5),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: getViewForParameter(sideMenuList[selectedIndex]['id']),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
