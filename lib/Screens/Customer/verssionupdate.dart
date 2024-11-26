import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/Screens/Customer/controllerlogfile.dart';


import 'package:provider/provider.dart';

import '../../../constants/MQTTManager.dart';
import '../../../constants/http_service.dart';
import '../../constants/snack_bar.dart';
import '../../state_management/MqttPayloadProvider.dart';


class ResetVerssion extends StatefulWidget {
  const ResetVerssion(
      {Key? key,
        required this.userId,
        required this.controllerId,
        required this.deviceID});
  final userId, controllerId, deviceID;

  @override
  _ResetVerssionState createState() => _ResetVerssionState();
}

class _ResetVerssionState extends State<ResetVerssion> {
  List<Map<String, dynamic>> mergedList = [];
  late MqttPayloadProvider mqttPayloadProvider;
  IconData iconData = Icons.start;
  Color iconcolor = Colors.transparent;
  String imeicheck = '';
  int checkrst = 0;
  int? selectindex;
  int checkupdatediable = 0;

  valAssing(List<dynamic> data) {
    mergedList = [];
    for (var group in data) {
      var userGroupId = group['userGroupId'];
      var groupName = group['groupName'];
      var active = group['active'];
      var masterList = group['master'];

      for (var device in masterList) {
        mergedList.add({
          'userGroupId': userGroupId,
          'groupName': groupName,
          'active': active,
          'controllerId': device['controllerId'],
          'deviceId': device['deviceId'],
          'deviceName': device['deviceName'],
          'categoryId': device['categoryId'],
          'categoryName': device['categoryName'],
          'modelId': device['modelId'],
          'modelName': device['modelName'],
          'latestVersion': device['latestVersion'] ?? '',
          'currentVersion': device['currentVersion'] ?? '',
          'status': 'Status',
        });
      }
    }
  }

  Future<void> fetchData() async {
    Map<String, Object> body = {"userId": widget.userId};
    final response =
    await HttpService().postRequest("getUserDeviceFirmwareDetails", body);
    if (response.statusCode == 200) {
      setState(() {
        var jsondata = jsonDecode(response.body);

        valAssing(jsondata['data']);

        MQTTManager().connect();
      });
    } else {
      //_showSnackBar(response.body);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mqttPayloadProvider =
        Provider.of<MqttPayloadProvider>(context, listen: false);
    fetchData();
  }

  ResetAll(int index) async {
    sendHttp("2","Controller Restart");
    mergedList[index]["status"] = 'Started';
    iconData = Icons.restart_alt;
    iconcolor = Colors.blue;
    Map<String, dynamic> payLoadFinal = {
      "5700": [
        {"5701": "2"},
      ]
    };

    MQTTManager()
        .publish(jsonEncode(payLoadFinal), "AppToFirmware/${mergedList[index]["deviceId"]}");
  }

  Update(int index) async {


    sendHttp("3","Controller Version Update");
    mergedList[index]["status"] = 'Started';
    iconData = Icons.start;
    iconcolor = Colors.blue;
    Map<String, dynamic> payLoadFinal = {
      "5700": [
        {"5701": "3"},
      ]
    };
    MQTTManager()
        .publish(jsonEncode(payLoadFinal), "AppToFirmware/${mergedList[index]["deviceId"]}");

    GlobalSnackBar.show(context, mqttPayloadProvider.messageFromHw, 200);
    // MQTTManager().publish(payLoadFinal, 'OroGemLog/${overAllPvd.imeiNo}');
  }

  bool compareVersions(String version1, String version2) {
    // Extract the version part before the colon
    String cleanVersion1 = version1.split(':')[0];
    String cleanVersion2 = version2.split(':')[0];

    // Split and convert to integer lists
    List<int> version1Parts = cleanVersion1.split('.').map(int.parse).toList();
    List<int> version2Parts = cleanVersion2.split('.').map(int.parse).toList();

    int length = max(version1Parts.length, version2Parts.length);
    for (int i = 0; i < length; i++) {
      int v1 = i < version1Parts.length ? version1Parts[i] : 0;
      int v2 = i < version2Parts.length ? version2Parts[i] : 0;

      if (v1 > v2) {
        return true; // version1 is greater
      } else if (v1 < v2) {
        return false; // version1 is less
      }
    }

    return false; // versions are equal, so not greater
  }

  @override
  Widget build(BuildContext context) {
    mqttPayloadProvider =
        Provider.of<MqttPayloadProvider>(context, listen: true);
    status();
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      appBar: AppBar(
        title: Text('Controller Info'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 40,
            ),
            padding: EdgeInsets.all(5),
            itemCount: mergedList.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          mergedList[index]['categoryName']!,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.teal.shade100)),
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ControllerLog(
                                      deviceID: mergedList[index]['deviceId']!),
                                ),
                              );
                            });
                          },
                          icon: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SelectableText(mergedList[index]['deviceId']!,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),

                    SizedBox(height: 10),
                    Text(
                      'SiteName:${mergedList[index]['groupName'] ?? ''}',
                      style:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 10),
                    Text(
                      'Model:${mergedList[index]['modelName'] ?? ''}',
                      style:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Controller version:${mergedList[index]['currentVersion'] ?? ''}',
                      style:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Server version:${mergedList[index]['latestVersion']!}',
                      style:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    imeicheck != mergedList[index]['deviceId']!
                        ? mergedList[index]['status'] != 'Status'
                        ? Container(
                      width: 200,
                      child: Icon(
                        iconData,
                        color: iconcolor,
                        size: 40.0,
                      ),
                    )
                        : Container()
                        : Container(),
                    imeicheck != mergedList[index]['deviceId']!
                        ? Text(
                      '${mergedList[index]['status']}',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    )
                        : Text('Status'),

                    // Center(child: Text('${mqttPayloadProvider.messageFromHw ?? 'Status'} ',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FilledButton(
                            style: ButtonStyle(
                                backgroundColor: checkupdatediable == 0
                                    ? MaterialStateProperty.all(Colors.red)
                                    : MaterialStateProperty.all(Colors.grey)),
                            onPressed: () {
                              selectindex = index;
                              checkupdatediable == 0
                                  ? resetItem(index)
                                  : _showSnackBar("Please wait ....");
                            },
                            child: Text('Restart'),
                          ),
                          SizedBox(width: 10),
                          FilledButton(
                            style: ButtonStyle(
                                backgroundColor: checkupdatediable == 0
                                    ? MaterialStateProperty.all(Colors.green)
                                    : MaterialStateProperty.all(Colors.grey)),
                            onPressed: () {
                              selectindex = index;
                              checkupdatediable == 0
                                  ? updateItem(index)
                                  : _showSnackBar("Please wait ....");
                            },
                            child: checkupdatediable == 0
                                ? mergedList[index]['currentVersion'] !=
                                mergedList[index]['latestVersion']
                                ? const BlinkingText(
                              text: 'Update!', // Provide text here
                              style: TextStyle(color: Colors.white),
                              blinkDuration:
                              Duration(milliseconds: 500),
                            )
                                : Text("Update")
                                : Text("Update"),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  sendHttp(String val, String msgstatus) async {
    Map<String, dynamic> payLoadFinal = {
      "5700": [
        {"5701": "$val"},
      ]
    };
    Map<String, dynamic> body = {
      "userId": widget.userId,
      "controllerId": widget.controllerId,
      "hardware": payLoadFinal,
      "messageStatus": msgstatus,
      "createUser": widget.userId
    };
    print('body $body');
    final response = await HttpService()
        .postRequest("createUserSentAndReceivedMessageManually", body);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["code"] == 200) {
        _showSnackBar(data["message"]);
      } else {
        _showSnackBar(data["message"]);
      }
    }
  }

  status() {
    if (selectindex != null) {
      Map<String, dynamic>? ctrldata = mqttPayloadProvider.messageFromHw;
      print("ctrldata------------>$ctrldata");
      if ((ctrldata != null && ctrldata.isNotEmpty)) {
        var name = ctrldata['Name'];
        // String message = ctrldata['Message'];
        var code = ctrldata['Code'];
        // imeicheck = ctrldata['DeviceId'];
        if (name.contains('Started')) {
          mergedList[selectindex!]['status'] = 'Started';
          iconData = Icons.start;
          iconcolor = Colors.blue;
        } else if (name.contains('Restarting')) {
          mergedList[selectindex!]['status'] = 'Restarting...';
          iconData = Icons.incomplete_circle;
          iconcolor = Colors.teal;
        } else if (name.contains('Turned')) {
          iconData = Icons.check_circle;
          mergedList[selectindex!]['status'] = checkrst == 0
              ? 'Last update:${ctrldata['Time']}'
              : 'Last Restart:${ctrldata['Time']}';
          iconcolor = Colors.green;
          checkupdatediable = 0;
          selectindex = null;
          // startDelay();
        } else if (name.contains('wrong')) {
          mergedList[selectindex!]['status'] = '${ctrldata['Message']}';
          iconData = Icons.error;
          iconcolor = Colors.red;
          checkupdatediable = 0;
          selectindex = null;
        }else if (name.contains('GitFailed')) {
          mergedList[selectindex!]['status'] = '${ctrldata['Message']}';
          iconData = Icons.error;
          iconcolor = Colors.red;
          checkupdatediable = 0;
          selectindex = null;
        }
        else {
          mergedList[selectindex!]['status'] = 'Status';
          iconcolor = Colors.transparent;
          // checkupdatediable = 0;
          // selectindex = null;
        }
        print("mergedList------>$mergedList");
      }
    }
  }


  void resetItem(int index) {
    setState(() {
      checkupdatediable = 1;
      _showDialogcheck(context, "Restart", index);
    });
  }

  void updateItem(int index) {
    setState(() {
      checkupdatediable = 1;
      _showDialogcheck(context, "Update", index);
    });
  }

  void _showDialogcheck(BuildContext context, String update, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text(
              "Are you sure you want to $update?\n First, stop. If you confirm that you want to stop, then update your controller by clicking the 'Sure' button."),
          actions: [
            TextButton(
              onPressed: () {
                update == "Update" ? Update(index) : ResetAll(index);
                Navigator.of(context).pop();
              },
              child: Text('Sure'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class BlinkingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration blinkDuration;

  const BlinkingText({
    Key? key,
    required this.text,
    this.style = const TextStyle(fontSize: 20, color: Colors.red),
    this.blinkDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _BlinkingTextState createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.blinkDuration,
      reverseDuration: widget.blinkDuration,
    )..repeat(reverse: true);

    _opacityAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Text(
        widget.text,
        style: widget.style,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
