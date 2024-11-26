import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../Models/Customer/Dashboard/PumpControllerModel/PumpSettingsMDL.dart';
import '../../../constants/http_service.dart';
import 'PrefrenceScreen/PumpCommonSettings.dart';

class PumpPreferenceScreen extends StatefulWidget {
  const PumpPreferenceScreen({Key? key, required this.customerId, required this.controllerId}) : super(key: key);
  final int customerId, controllerId;

  @override
  State<PumpPreferenceScreen> createState() => _PumpPreferenceScreenState();
}

class _PumpPreferenceScreenState extends State<PumpPreferenceScreen> {

  PumpSettingsMDL pumpControllerSettings = PumpSettingsMDL();
  int listTileIndex = 0;

  @override
  void initState() {
    super.initState();
    getUserPreferenceSetting();
  }

  Future<void> getUserPreferenceSetting() async
  {
    Map<String, Object> body = {
      "userId": widget.customerId,
      "controllerId": widget.controllerId,
    };
    print(body);
    final response = await HttpService().postRequest("getUserPreferenceSetting", body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      //print(response.body);
      if (data["code"] == 200) {
        final jsonData = data["data"];
        try {
          setState(() {
            pumpControllerSettings = (jsonData != null ? PumpSettingsMDL.fromJson(jsonData) : null)!;
          });
        } catch (e) {
          print('Error: $e');
        }
      }
    }
    else {
      //_showSnackBar(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: Row(
        children: <Widget>[
          // This is the permanent drawer
          SizedBox(
            width: 200,
            child: Drawer(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    selected: listTileIndex==0? true: false,
                    selectedTileColor: Colors.teal.shade300,
                    selectedColor: Colors.white,
                    title: const Text('Common settings'),
                    onTap: () {
                      setState(() {
                        listTileIndex = 0;
                      });
                    },
                  ),
                  ListTile(
                    selected: listTileIndex==1? true: false,
                    selectedTileColor: Colors.teal.shade300,
                    selectedColor: Colors.white,
                    title: const Text('Pump 1'),
                    onTap: () {
                      setState(() {
                        listTileIndex = 1;
                      });
                    },
                  ),
                  ListTile(
                    selected: listTileIndex==2? true: false,
                    selectedTileColor: Colors.teal.shade300,
                    selectedColor: Colors.white,
                    title: const Text('Pump 2'),
                    onTap: () {
                      setState(() {
                        listTileIndex = 2;
                      });
                    },
                  ),
                  ListTile(
                    selected: listTileIndex==3? true: false,
                    selectedTileColor: Colors.teal.shade300,
                    selectedColor: Colors.white,
                    title: const Text('Pump 3'),
                    onTap: () {
                      setState(() {
                        listTileIndex = 3;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          // This is the main content area
          Expanded(
            child: listTileIndex==0? PumpCommonSettings(pumpControllerSettings: pumpControllerSettings,):
            Container(
              color: Colors.greenAccent,
            ),
          ),
        ],
      ),
    );
  }
}
