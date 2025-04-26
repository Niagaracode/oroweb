import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/constants/theme.dart';
import 'dart:convert';
import '../../Models/PumpConditionModel.dart';
import '../../constants/MQTTManager.dart';
import '../../constants/http_service.dart';
import '../../constants/snack_bar.dart';

// SelectedPump model for selected pumps

// PumpConditionScreen Widget
class PumpConditionScreen extends StatefulWidget {
  const PumpConditionScreen({
    Key? key,
    required this.userId,
    required this.controllerId,
    required this.imeiNo,
    required this.isProgram,
  }) : super(key: key);

  final userId, controllerId;
  final String imeiNo;
  final bool isProgram;

  @override
  State<PumpConditionScreen> createState() => _PumpConditionScreenState();
}

class _PumpConditionScreenState extends State<PumpConditionScreen> {
  late PumpConditionModel pumpConditionModel = PumpConditionModel();
  var jsonstr = {
    "code": 200,
    "message": "User planning pump condition listed successfully",
    "data": {
      "pumpCondition": [
        {
          "sNo": 3,
          "id": "SP.1",
          "hid": "SP.1",
          "name": "Source Pump 1",
          "location": "",
          "type": "1",
          "controlGem": true,
          "deviceId": "E8EB1B050555",
          "selectedPumps": [
            {"sNo": 4, "id": "SP.2", "hid": "SP.2"},
            {"sNo": 5, "id": "IP.1", "hid": "IP.1"}
          ]
        },
        {
          "sNo": 4,
          "id": "SP.2",
          "hid": "SP.2",
          "name": "Source Pump 2",
          "location": "",
          "type": "1",
          "controlGem": true,
          "deviceId": "E8EB1B04C5D0",
          "selectedPumps": []
        },
        {
          "sNo": 5,
          "id": "IP.1",
          "hid": "IP.1",
          "name": "Irrigation Pump 1",
          "location": "IL.1",
          "type": "1",
          "controlGem": true,
          "deviceId": "E8EB1B050555",
          "selectedPumps": []
        },
        {
          "sNo": 6,
          "id": "IP.2",
          "hid": "IP.2",
          "name": "Irrigation Pump 2",
          "location": "",
          "type": "1",
          "controlGem": true,
          "deviceId": "E8EB1B050555",
          "selectedPumps": []
        },
        {
          "sNo": 7,
          "id": "IP.3",
          "hid": "IP.3",
          "name": "Irrigation Pump 3",
          "location": "IL.1",
          "type": "1",
          "controlGem": true,
          "deviceId": "E8EB1B04C5D0",
          "selectedPumps": []
        },
        {
          "sNo": 8,
          "id": "IP.4",
          "hid": "IP.4",
          "name": "Irrigation Pump 4",
          "location": "",
          "type": "1",
          "controlGem": true,
          "deviceId": "E8EB1B04C5D0",
          "selectedPumps": []
        }
      ],
      "controllerReadStatus": "0"
    }
  };
  @override
  void initState() {
    super.initState();
    // pumpConditionModel = PumpConditionModel.fromJson(jsonstr);
    // Uncomment to use real data
    fetchData();
  }
  Future<void> fetchData() async {
    Map<String, Object> body = {
      "userId": widget.userId,
      "controllerId": widget.controllerId
    };
    final response = await HttpService().postRequest("getUserPlanningPumpCondition", body);
    if (response.statusCode == 200) {
      setState(() {
        var jsondata1 = jsonDecode(response.body);
        print('jsondata1-> $jsondata1');
        pumpConditionModel = PumpConditionModel.fromJson(jsondata1);
      });
    } else {
      // Handle error
    }
  }
  void togglePumpSelection(PumpCondition currentPump, PumpCondition targetPump) {
    var selectedList = currentPump.selectedPumps ?? [];

    // Check if the pump is already selected
    final alreadySelected = selectedList.any((p) => p.id == targetPump.id);

    setState(() {
      if (alreadySelected) {
        // Remove from the selected list if already selected
        selectedList.removeWhere((p) => p.id == targetPump.id);
      } else {
        // Add to the selected list if not selected
        selectedList.add(SelectedPump(
          id: targetPump.id,
          hid: targetPump.hid,
          sNo: targetPump.sNo,
        ));
      }

      currentPump.selectedPumps = selectedList;
    });
  }
  @override
  Widget build(BuildContext context) {
    final allPumps = pumpConditionModel.data?.pumpCondition ?? [];

    return Scaffold(
      backgroundColor: Color(0xffE6EDF5),
      appBar: AppBar(
        title: const Text('Pump Conditions'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: allPumps.map((pumpCondition) {
              var selectedPumps = pumpCondition.selectedPumps ?? [];
              return Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          pumpCondition.name ?? 'No Name',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8.0),


                      Container(height: 0.5,color: Colors.grey,),
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: allPumps.map((pump) {
                           if (pump.id == pumpCondition.id) return const SizedBox.shrink();
                           bool isSelected = selectedPumps.any((sp) => sp.id == pump.id);
                           return GestureDetector(
                            onTap: () => togglePumpSelection(pumpCondition, pump),
                            child: Chip(
                              label: Text(pump.name ?? 'Unknown Pump'),
                              backgroundColor: isSelected
                                  ? Colors.yellowAccent.shade100
                                  : Colors.grey.shade300,
                              avatar: isSelected
                                  ? const Icon(Icons.check_circle, color: Colors.green, size: 18)
                                  : const Icon(Icons.circle_outlined, color: Colors.grey, size: 18),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      )
      ,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _sendData(),
        child: const Icon(Icons.send),
        tooltip: 'Send Data',
      ),
    );
  }

  String convertPumpDataToString(PumpConditionModel model) {
    final buffer = StringBuffer();
    final pumps = model.data?.pumpCondition ?? [];
    for (var pump in pumps) {
      buffer.write(pump.hid ?? '');
      final selected = pump.selectedPumps ?? [];
      if (selected.isNotEmpty) {
        buffer.write(',');
        buffer.writeAll(
          selected.map((sp) => sp.hid ?? ''),
          ',',
        );
      }
      buffer.write(';');
    }
    return buffer.toString();
  }

  _sendData()
  async {
    String mqttSendData = convertPumpDataToString(pumpConditionModel);

    var finaljson = pumpConditionModel.data?.toJson();
    Map<String, Object> body = {
      "userId": widget.userId,
      "controllerId": widget.controllerId,
      "pumpCondition": finaljson!['pumpCondition'],
      "createUser": widget.userId,
      "controllerReadStatus": 0
    };
    final response = await HttpService()
        .postRequest("createUserPlanningPumpCondition", body);
    final jsonDataresponse = json.decode(response.body);
    GlobalSnackBar.show(
        context, jsonDataresponse['message'], response.statusCode);

    String payLoadFinal = jsonEncode({
      "700": [
        {"708": mqttSendData},
      ]
    });
    print(payLoadFinal);
    // MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.imeiNo}');
  }

 }
