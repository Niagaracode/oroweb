import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:oro_irrigation_new/constants/theme.dart';
import '../../../Models/Customer/Dashboard/DashboardNode.dart';
import '../../../Models/language.dart';
import '../../../Models/notification_list_model.dart';
import '../../../constants/MQTTManager.dart';
import '../../../constants/http_service.dart';
import '../../../constants/snack_bar.dart';
import '../../Config/names_form.dart';
import '../../Forms/create_account.dart';

import 'package:timezone/standalone.dart' as tz;

class ControllerSettings extends StatefulWidget {
  const ControllerSettings(
      {Key? key,
        required this.customerID,
        required this.siteData,
        required this.masterIndex,
        required this.adDrId,
        required this.allSiteList})
      : super(key: key);

  final int customerID, masterIndex, adDrId;
  final DashboardModel siteData;
  final List<DashboardModel> allSiteList;

  @override
  State<ControllerSettings> createState() => _ControllerSettingsState();
}

class _ControllerSettingsState extends State<ControllerSettings> {
  bool visibleLoading = false;

  final List<LanguageList> languageList = <LanguageList>[];
  String _mySelection = 'English';

  String selectedTheme = '0xFF036673';
  Map<String, Color> themeColors = {
    '0xFF036673': const Color(0xFF036673),
    'Blue': Colors.blue,
    'Green': Colors.green,
    'Yellow': Colors.yellow,
  };

  List<Map<String, dynamic>> subUsers = [];

  final TextEditingController txtEcSiteName = TextEditingController();
  final TextEditingController txtEcGroupName = TextEditingController();
  String modelName = '', deviceId = '', categoryName = '', controllerVersion='', newVersion='';
  int groupId = 0;

  String? _selectedTimeZone;
  String _currentDate = '';
  String _currentTime = '';

  double opacity = 1.0;
  Timer? _timer;

  List<NotificationListModel> notifications = [];

  @override
  void initState() {
    super.initState();
    getLanguage();
    getControllerInfo();
    getSubUserList();
    getNotificationList();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void timerFunction(){
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        opacity = opacity == 1.0 ? 0.0 : 1.0;
      });
    });
  }

  void callbackFunction(String message) {
    Future.delayed(const Duration(milliseconds: 500), () {
      const GlobalSnackBar(code: 200, message: 'Sub user created successfully');
      getSubUserList();
    });
  }

  Future<void> getLanguage() async {
    final response =
    await HttpService().postRequest("getLanguageByActive", {"active": '1'});
    if (response.statusCode == 200) {
      languageList.clear();
      var data = jsonDecode(response.body);
      if (data["code"] == 200) {
        final cntList = data["data"] as List;
        for (int i = 0; i < cntList.length; i++) {
          languageList.add(LanguageList.fromJson(cntList[i]));
        }
        setState(() {
          languageList;
        });
      }
    }
  }

  Future<void> getControllerInfo() async {
    final response = await HttpService().postRequest("getUserMasterDetails", {
      "userId": widget.customerID,
      "controllerId": widget.siteData.master[widget.masterIndex].controllerId
    });
    if (response.statusCode == 200) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (data["code"] == 200) {
        txtEcSiteName.text = data["data"][0]['groupName'];
        txtEcGroupName.text = data["data"][0]['deviceName'];
        setState(() {
          deviceId = data["data"][0]['deviceId'];
          modelName = data["data"][0]['modelName'];
          categoryName = data["data"][0]['categoryName'];
          groupId = data["data"][0]['groupId'];
          controllerVersion = data["data"][0]['hwVersion'];
          newVersion = data["data"][0]['availableHwVersion'];
          _updateCurrentDateTime(data["data"][0]['timeZone']);
          if(controllerVersion!=newVersion){
            timerFunction();
          }else{
            _timer?.cancel();
          }

        });
      }
    }
  }

  Future<void> getSubUserList() async {
    print(widget.customerID);
    final response = await HttpService()
        .postRequest("getUserSharedList", {"userId": widget.customerID});
    if (response.statusCode == 200) {
      languageList.clear();
      var data = jsonDecode(response.body);
      if (data["code"] == 200) {
        setState(() {
          subUsers = List<Map<String, dynamic>>.from(data["data"]);
        });
      }
    }
  }

  Future<void> getNotificationList() async {
    final response =   await HttpService().postRequest("getUserPushNotificationType", {"userId": widget.customerID, "controllerId": widget.siteData.master[0].controllerId});
    if (response.statusCode == 200) {
      languageList.clear();
      var data = jsonDecode(response.body);
      if (data["code"] == 200) {
        notifications = parseNotifications(response.body);
      }
    }
  }

  List<NotificationListModel> parseNotifications(String responseBody) {
    final parsed = json.decode(responseBody);
    return (parsed['data'] as List)
        .map((notification) => NotificationListModel.fromJson(notification))
        .toList();
  }

  final List<String> _timeZones = tz.timeZoneDatabase.locations.keys.toList();

  void _updateCurrentDateTime(String timeZone) {
    final tz.Location location = tz.getLocation(timeZone);
    final tz.TZDateTime now = tz.TZDateTime.now(location);

    setState(() {
      _currentDate = DateFormat.yMd().format(now); // Date only
      _currentTime = DateFormat.jm().format(now); // Time only
      _selectedTimeZone = timeZone;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return visibleLoading
        ? buildLoadingIndicator(
        visibleLoading, MediaQuery.sizeOf(context).width)
        : Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 5,
        child: Column(
          children: [
            TabBar(
              indicatorColor: Colors.teal,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              dividerColor: Colors.teal.shade100,
              tabs: const [
                Tab(text: 'General'),
                Tab(text: 'Preference'),
                Tab(text: 'Notification'),
                Tab(text: 'Names'),
                Tab(text: 'View Settings'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildGeneralContent(screenWidth),
                  ),
                  const Center(child: Text('Tab 2 Content')),
                  buildNotifications(),
                  Center(
                      child: Names(
                        userID: widget.customerID,
                        customerID: widget.customerID,
                        controllerId: widget.siteData.master[0].controllerId,
                        imeiNo: widget.siteData.master[0].deviceId,)),
                  const Center(child: Text('Tab 5 Content')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNotifications() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: (notifications.length / 3).ceil(), // Grouping items in rows of 3
            itemBuilder: (context, index) {
              int startIndex = index * 3; // Each row starts with a multiple of 3
              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildNotificationCard(startIndex),
                    if (startIndex + 1 < notifications.length)
                      buildNotificationCard(startIndex + 1),
                    if (startIndex + 2 < notifications.length)
                      buildNotificationCard(startIndex + 2),
                  ],
                ),
              );
            },
          ),
        ),
        ListTile(trailing: MaterialButton(
          color: Colors.green,
          textColor: Colors.white,
          onPressed:() async {
            List<int> selectedIds = notifications.where((notification) => notification.selected).map((notification) => notification.pushNotificationId).toList();
            if(selectedIds.isNotEmpty){
              final response = await HttpService().putRequest("updateUserPushNotificationType",
                  {"userId": widget.customerID, "controllerId": widget.siteData.master[0].controllerId, "pushNotificationType": selectedIds, "modifyUser": widget.customerID,});
              if (response.statusCode == 200) {
                var data = jsonDecode(response.body);
                if (data["code"] == 200) {
                  GlobalSnackBar.show(context, data["message"], 200);
                }
              }
            }else{
              GlobalSnackBar.show(context, "Notification setting saved successfully", 200);
            }
          },
          child: const Text('Save'),
        ),),
      ],
    );
  }

  Widget buildNotificationCard(int index) {
    final notification = notifications[index];
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(5.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: Colors.teal.shade50, width: 0.5)
        ),
        color: Colors.teal.shade50,
        child: ListTile(
          title: Text(notification.notificationName),
          subtitle: Text(notification.notificationDescription, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          trailing: Transform.scale(
            scale: 0.7,
            child: Tooltip(
              message: notification.selected? 'Disable' : 'Enable',
              child: Switch(
                hoverColor: Colors.pink.shade100,
                activeColor: Colors.teal,
                value: notification.selected,
                onChanged: (bool value) {
                  setState(() {
                    notification.selected = value;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget buildLoadingIndicator(bool isVisible, double width) {
    return Visibility(
      visible: isVisible,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: width / 2 - 25),
        child: const LoadingIndicator(
          indicatorType: Indicator.ballPulse,
        ),
      ),
    );
  }

  Widget buildGeneralContent(screenWidth) {

    return screenWidth > 600 ? Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 385,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('Farm Name'),
                          leading: const Icon(Icons.area_chart_outlined),
                          trailing: SizedBox(
                            width: 300,
                            child: TextField(
                              controller: txtEcSiteName,
                              decoration: const InputDecoration(
                                filled: false,
                                suffixIcon: Icon(Icons.edit),
                              ),
                            ),
                          ),
                        ),
                        Divider(color: Colors.grey.shade200,),
                        ListTile(
                          title: const Text('Controller Name'),
                          leading: const Icon(Icons.developer_board),
                          trailing: SizedBox(
                            width: 300,
                            child: TextField(
                              controller: txtEcGroupName,
                              decoration: const InputDecoration(
                                filled: false,
                                suffixIcon: Icon(Icons.edit),
                              ),
                            ),
                          ),
                        ),
                        Divider(color: Colors.grey.shade200,),
                        ListTile(
                          title: const Text('Device Category'),
                          leading: const Icon(Icons.category_outlined),
                          trailing: Text(
                            categoryName,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(color: Colors.grey.shade200,),
                        ListTile(
                          title: const Text('Model'),
                          leading: const Icon(Icons.model_training),
                          trailing: Text(
                            modelName,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(color: Colors.grey.shade200,),
                        ListTile(
                          title: const Text('Device ID'),
                          leading: const Icon(Icons.numbers_outlined),
                          trailing: SelectableText(
                            deviceId,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(color: Colors.grey.shade200,),
                        ListTile(
                          title: const Text('Version'),
                          leading: const Icon(Icons.perm_device_info),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                controllerVersion,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              controllerVersion != newVersion? const SizedBox(width: 16,):
                              const SizedBox(),
                              controllerVersion != newVersion? TextButton(
                                onPressed: () {
                                },
                                child: AnimatedOpacity(
                                  opacity: opacity,
                                  duration: const Duration(seconds: 2),
                                  child: Text('New Version available - $newVersion', style: const TextStyle(color: Colors.black54),),
                                ),
                              ):
                              const SizedBox(),
                            ],
                          ),
                        ),
                        /*ListTile(
                                title: const Text('Language'),
                                leading: const Icon(Icons.language),
                                trailing: DropdownButton(
                                  underline: Container(),
                                  items: languageList.map((item) {
                                    return DropdownMenuItem(
                                      value: item.languageName,
                                      child: Text(item.languageName),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      _mySelection = newVal!;
                                    });
                                  },
                                  value: _mySelection,
                                ),
                              ),*/
                        Divider(color: Colors.grey.shade300,),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: VerticalDivider(width: 0, color: Colors.grey.shade200),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('App Theme Color'),
                          leading: const Icon(Icons.color_lens_outlined),
                          trailing: DropdownButton<String>(
                            underline: Container(),
                            value: selectedTheme,
                            hint: const Text('Select your theme color'),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedTheme = newValue;
                                });
                              }
                            },
                            items: themeColors.entries
                                .map<DropdownMenuItem<String>>((entry) {
                              return DropdownMenuItem<String>(
                                value: entry.key,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      color: entry.value,
                                      margin:
                                      const EdgeInsets.only(right: 8),
                                    ),
                                    Text(entry.key),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Divider(color: Colors.grey.shade200,),
                        ListTile(
                          title: const Text('UTC'),
                          leading: const Icon(Icons.timer_outlined),
                          trailing: DropdownButton<String>(
                            hint: const Text('Select Time Zone'),
                            value: _selectedTimeZone,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                _updateCurrentDateTime(newValue);
                              }
                            },
                            items: _timeZones
                                .map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                          ),
                        ),
                        Divider(color: Colors.grey.shade200,),
                        ListTile(
                          title: const Text('Current Date'),
                          leading: Icon(Icons.date_range),
                          trailing: Text(
                            _currentDate,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(color: Colors.grey.shade200,),
                        ListTile(
                          title: const Text('Current UTC Time'),
                          leading: const Icon(Icons.date_range),
                          trailing: Text(
                            _currentTime,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(color: Colors.grey.shade200,),
                        const ListTile(
                          title: Text('Time Format'),
                          leading: Icon(Icons.date_range),
                          trailing: Text(
                            '24 Hrs',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(color: Colors.grey.shade200,),
                        const ListTile(
                          title: Text('Unit'),
                          leading: Icon(Icons.ac_unit_rounded),
                          trailing: Text(
                            'm3',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(color: Colors.grey.shade300,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.sizeOf(context).width,
              child: ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MaterialButton(
                      color: Colors.teal,
                      textColor: Colors.white,
                      onPressed: () async {
                      },
                      child: const Text('Restart the controller'),
                    ),
                    const SizedBox(width: 16,),
                    MaterialButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () async {
                        Map<String, Object> body = {
                          'userId': widget.customerID,
                          'controllerId':
                          widget.siteData.master[0].controllerId,
                          'deviceName': txtEcGroupName.text,
                          'groupId': groupId,
                          'groupName': txtEcSiteName.text,
                          'modifyUser': widget.customerID,
                          'timeZone': _selectedTimeZone ?? '',
                        };
                        final Response response = await HttpService()
                            .putRequest("updateUserMasterDetails", body);

                        String payLoadFinal = jsonEncode({
                          "6800": [
                            {"6801": _selectedTimeZone ?? ''},
                          ]
                        });
                        MQTTManager().publish(payLoadFinal, 'AppToFirmware/$deviceId');

                        if (response.statusCode == 200) {
                          var data = jsonDecode(response.body);
                          if (data["code"] == 200) {
                            if (context.mounted) {
                              GlobalSnackBar.show(context, data["message"],
                                  response.statusCode);
                            }
                          }
                        }
                      },
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.supervised_user_circle_outlined),
              title: const Text(
                'My Sub users',
                style:
                TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              trailing: widget.adDrId != 0
                  ? IconButton(
                  tooltip: 'Add new sub user',
                  onPressed: () async {

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return FractionallySizedBox(
                          heightFactor: 0.84,
                          widthFactor: 0.75,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                            ),
                            child: CreateAccount(callback: callbackFunction, subUsrAccount: true, customerId: widget.customerID, from: 'Sub User',),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add))
                  : null,
            ),
            Divider(height:0, color: Colors.grey.shade300,),
            SizedBox(
              height: 70,
              child: subUsers.isNotEmpty
                  ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subUsers.length,
                itemBuilder: (context, index) {
                  final user = subUsers[index];
                  return SizedBox(
                    width: 250,
                    child: Card(
                      surfaceTintColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5.0), // Adjust the radius as needed
                      ),
                      child: ListTile(
                        title: Text(user['userName']),
                        subtitle: Text(
                            '+${user['countryCode']} ${user['mobileNumber']}'),
                        trailing: IconButton(
                          tooltip: 'User Permission',
                          onPressed: () => _showAlertDialog(
                              context, user['userName'], user['userId']),
                          icon: const Icon(Icons.menu),
                        ),
                      ),
                    ),
                  );
                },
              )
                  : const Center(
                  child: Text(
                      'No Sub user available for this controller')),
            ),
          ],
        ),
      ),
    )
        : Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: screenWidth,
                  child: TextField(
                    controller: txtEcSiteName,
                    decoration: InputDecoration(
                      filled: false,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Farm name',
                      suffixIcon: const Icon(Icons.edit),
                    ),
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: screenWidth,
                  child: TextField(
                    controller: txtEcGroupName,
                    decoration: InputDecoration(
                      filled: false,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Controller name',
                      suffixIcon: const Icon(Icons.edit),
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Device Category'),
                  leading: const Icon(Icons.category_outlined),
                  trailing: Text(
                    categoryName,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Model'),
                  leading: const Icon(Icons.model_training),
                  trailing: Text(
                    modelName,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Device ID'),
                  leading: const Icon(Icons.numbers_outlined),
                  trailing: Text(
                    deviceId,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Language'),
                  leading: const Icon(Icons.language),
                  trailing: DropdownButton(
                    underline: Container(),
                    items: languageList.map((item) {
                      return DropdownMenuItem(
                        value: item.languageName,
                        child: Text(item.languageName),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelection = newVal!;
                      });
                    },
                    value: _mySelection,
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('App Theme Color'),
                  leading: const Icon(Icons.color_lens_outlined),
                  trailing: DropdownButton<String>(
                    underline: Container(),
                    value: selectedTheme,
                    hint: const Text('Select your theme color'),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedTheme = newValue;
                        });
                      }
                    },
                    items: themeColors.entries
                        .map<DropdownMenuItem<String>>((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              color: entry.value,
                              margin: const EdgeInsets.only(right: 8),
                            ),
                            Text(entry.key),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Divider(),
                const ListTile(
                  title: Text('Current UTC Time'),
                  leading: Icon(Icons.date_range),
                  trailing: Text(
                    '15:10:00',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                const ListTile(
                  title: Text('Time Format'),
                  leading: Icon(Icons.date_range),
                  trailing: Text(
                    '24 Hrs',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                const ListTile(
                  title: Text('Current Date'),
                  leading: Icon(Icons.date_range),
                  trailing: Text(
                    '13-05-2024',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                const ListTile(
                  title: Text('Unit'),
                  leading: Icon(Icons.ac_unit_rounded),
                  trailing: Text(
                    'm3',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
              ],
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.sizeOf(context).width,
              child: ListTile(
                trailing: MaterialButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () async {
                    Map<String, Object> body = {
                      'userId': widget.customerID,
                      'controllerId':
                      widget.siteData.master[0].controllerId,
                      'deviceName': txtEcGroupName.text,
                      'groupId': groupId,
                      'groupName': txtEcSiteName.text,
                      'modifyUser': widget.customerID,
                    };
                    final Response response = await HttpService()
                        .putRequest("updateUserMasterDetails", body);
                    if (response.statusCode == 200) {
                      var data = jsonDecode(response.body);
                      if (data["code"] == 200) {
                        if (context.mounted) {
                          GlobalSnackBar.show(context, data["message"],
                              response.statusCode);
                        }
                      }
                    }
                  },
                  child: const Text('Restore'),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.supervised_user_circle_outlined),
              title: const Text(
                'My Sub users',
                style:
                TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              trailing: widget.adDrId != 0
                  ? IconButton(
                  tooltip: 'Add new sub user',
                  onPressed: () async {
                    showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: CreateAccount(
                          callback: callbackFunction,
                          subUsrAccount: true,
                          customerId: widget.customerID, from: 'Sub User',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add))
                  : null,
            ),
            const Divider(
              height: 0,
            ),
            SizedBox(
              height: 70,
              child: subUsers.isNotEmpty
                  ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subUsers.length,
                itemBuilder: (context, index) {
                  final user = subUsers[index];
                  return SizedBox(
                    width: 250,
                    child: Card(
                      surfaceTintColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5.0), // Adjust the radius as needed
                      ),
                      child: ListTile(
                        title: Text(user['userName']),
                        subtitle: Text(
                            '+${user['countryCode']} ${user['mobileNumber']}'),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.menu),
                        ),
                      ),
                    ),
                  );
                },
              )
                  : const Center(
                  child: Text(
                      'No Sub user available for this controller')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUserSharedDeviceList(int suId) async {
    final response = await HttpService()
        .postRequest("getUserSharedDeviceList", {"userId": widget.customerID, "sharedUserId": suId,});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      if (data["code"] == 200) {
        /*setState(() {
          subUsers = List<Map<String, dynamic>>.from(data["data"]);
        });*/
      }
    }
  }

  Future<void> _showAlertDialog(BuildContext context, String cName, int suId) async {

    List<UserGroup> userGroups = [];

    final response = await HttpService().postRequest("getUserSharedDeviceList",
        {"userId": widget.customerID, "sharedUserId": suId,});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      //print(response.body);
      if (data["code"] == 200) {
        var list = data['data'] as List;
        setState(() {
          userGroups = list.map((i) => UserGroup.fromJson(i)).toList();
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$cName - Permissions'),
          content: SizedBox(
            width: 400,
            height: 400,
            child: Scaffold(
              body: ListView.builder(
                itemCount: userGroups.length,
                itemBuilder: (context, index) {
                  return UserGroupWidget(group: userGroups[index]);
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                List<MasterItem> masterList = [];
                for(int gix=0; gix<userGroups.length; gix++){
                  for(int mix=0; mix<userGroups[gix].master.length; mix++){
                    masterList.add(MasterItem(id: userGroups[gix].master[mix].controllerId, action: userGroups[gix].master[mix].isSharedDevice, userPermission: userGroups[gix].master[mix].userPermission));
                  }
                }
                sendUpdatedPermission(masterList.map((item) => item.toMap()).toList(), suId);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> sendUpdatedPermission(List<Map<String, dynamic>> uptJson, int suId) async
  {
    final response = await HttpService().postRequest("createUserSharedController",
        {"userId": widget.customerID, "masterList": uptJson, "sharedUser": suId, "createUser": widget.customerID,});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["code"] == 200) {
        GlobalSnackBar.show(context, data["message"], 200);
        Navigator.of(context).pop();
      }
    }
  }

}

class ThemeChangeDialog extends StatefulWidget {
  final ThemeData initialTheme;

  const ThemeChangeDialog({super.key, required this.initialTheme});

  @override
  _ThemeChangeDialogState createState() => _ThemeChangeDialogState();
}

class _ThemeChangeDialogState extends State<ThemeChangeDialog> {
  late ThemeData _selectedTheme;

  @override
  void initState() {
    _selectedTheme = widget.initialTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RadioListTile(
            title: Container(
              color: Colors.cyan,
              width: 150,
              height: 75,
              child: const Center(child: Text('Theme cyan')),
            ),
            value: ThemeData.light(),
            groupValue: _selectedTheme,
            onChanged: (value) {
              setState(() {
                _selectedTheme = value!;
              });
            },
          ),
          RadioListTile(
            title: Container(
              color: Colors.yellow,
              width: 150,
              height: 75,
              child: const Center(child: Text('Theme yellow')),
            ),
            value: ThemeData.light(),
            groupValue: _selectedTheme,
            onChanged: (value) {
              setState(() {
                _selectedTheme = value!;
              });
            },
          ),
          RadioListTile(
            title: Container(
              color: Colors.green,
              width: 150,
              height: 75,
              child: const Center(child: Text('Theme green')),
            ),
            value: ThemeData.light(),
            groupValue: _selectedTheme,
            onChanged: (value) {
              setState(() {
                _selectedTheme = value!;
              });
            },
          ),
          RadioListTile(
            title: Container(
              color: Colors.pink,
              width: 150,
              height: 75,
              child: const Center(child: Text('Theme pink')),
            ),
            value: ThemeData.light(),
            groupValue: _selectedTheme,
            onChanged: (value) {
              setState(() {
                _selectedTheme = value!;
              });
            },
          ),
          RadioListTile(
            title: Container(
              color: Colors.purple,
              width: 150,
              height: 75,
              child: const Center(child: Text('Theme purple')),
            ),
            value: ThemeData.light(),
            groupValue: _selectedTheme,
            onChanged: (value) {
              setState(() {
                _selectedTheme = value!;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        MaterialButton(
          onPressed: () {
            // Update the theme and close the dialog
            //ThemeController().updateTheme(_selectedTheme);
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}


class UserGroup {
  final int userGroupId;
  final String groupName;
  final bool active;
  final List<Master> master;

  UserGroup({required this.userGroupId, required this.groupName, required this.active, required this.master});

  factory UserGroup.fromJson(Map<String, dynamic> json) {
    var list = json['master'] as List;
    List<Master> masterList = list.map((i) => Master.fromJson(i)).toList();
    return UserGroup(
      userGroupId: json['userGroupId'],
      groupName: json['groupName'],
      active: json['active'] == '1',
      master: masterList,
    );
  }
}

class Master {
  final int controllerId;
  final String deviceId;
  final String deviceName;
  bool isSharedDevice;
  final List<UserPermission> userPermission;

  Master({required this.controllerId, required this.deviceId, required this.deviceName, required this.isSharedDevice, required this.userPermission});

  factory Master.fromJson(Map<String, dynamic> json) {
    var list = json['userPermission'] as List;
    List<UserPermission> userPermissionList = list.map((i) => UserPermission.fromJson(i)).toList();
    return Master(
      controllerId: json['controllerId'],
      deviceId: json['deviceId'],
      deviceName: json['deviceName'],
      isSharedDevice: json['isSharedDevice'],
      userPermission: userPermissionList,
    );
  }
}

class UserPermission {
  final int sNo;
  final String name;
  bool status;

  UserPermission({required this.sNo, required this.name, required this.status});

  Map<String, dynamic> toMap() {
    return {
      'sNo': sNo,
      'name': name,
      'status': status,
    };
  }

  factory UserPermission.fromJson(Map<String, dynamic> json) {
    return UserPermission(
      sNo: json['sNo'],
      name: json['name'],
      status: json['status'],
    );
  }

}


class UserGroupWidget extends StatefulWidget {
  final UserGroup group;
  const UserGroupWidget({super.key, required this.group});

  @override
  _UserGroupWidgetState createState() => _UserGroupWidgetState();
}

class _UserGroupWidgetState extends State<UserGroupWidget> {
  void toggleGroup(UserGroup group, bool value) {
    setState(() {
      for (var master in group.master) {
        master.isSharedDevice = value;
        for (var permission in master.userPermission) {
          permission.status = value;
        }
      }
    });
  }

  void toggleMaster(Master master, bool value) {
    setState(() {
      master.isSharedDevice = value;
      for (var permission in master.userPermission) {
        permission.status = value;
      }

      if (!value) {
        for (var otherMaster in widget.group.master) {
          if (otherMaster != master && otherMaster.isSharedDevice) return;
        }
      }
    });
  }

  void togglePermission(UserGroup group, Master master, UserPermission permission, bool value) {
    setState(() {
      permission.status = value;

      if (!value) {
        bool allPermissionsUnchecked = master.userPermission.every((p) => !p.status);
        if (allPermissionsUnchecked) {
          master.isSharedDevice = false;
          bool allMastersUnchecked = group.master.every((m) => !m.isSharedDevice);
          if (allMastersUnchecked) {
            for (var m in group.master) {
              m.isSharedDevice = false;
            }
          }
        }
      } else {
        master.isSharedDevice = true;
        for (var m in group.master) {
          m.isSharedDevice = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      childrenPadding: const EdgeInsets.only(left: 16),
      enabled: false,
      title: Row(
        children: [
          Checkbox(
            value: widget.group.master.every((m) => m.isSharedDevice),
            onChanged: (value) => toggleGroup(widget.group, value!),
          ),
          Text(widget.group.groupName),
        ],
      ),
      children: widget.group.master.map((master){
        return ExpansionTile(
          initiallyExpanded: true,
          childrenPadding: const EdgeInsets.only(left: 16),
          enabled: false,
          shape: InputBorder.none,
          title: Row(
            children: [
              Checkbox(
                value: master.isSharedDevice,
                onChanged: (value) => toggleMaster(master, value!),
              ),
              Text(master.deviceName),
            ],
          ),
          children: master.userPermission.map((permission) {
            return ListTile(
              leading: Checkbox(
                value: permission.status,
                onChanged: (value) => togglePermission(widget.group, master, permission, value!),
              ),
              title: Text(permission.name),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

class MasterItem {
  final int id;
  final bool action;
  final List<UserPermission> userPermission;

  MasterItem({
    required this.id,
    required this.action,
    required this.userPermission,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'action': action,
      'userPermission': userPermission.map((perm) => perm.toMap()).toList(),
    };
  }

  factory MasterItem.fromJson(Map<String, dynamic> json) {
    return MasterItem(
      id: json['id'],
      action: json['action'],
      userPermission: List<UserPermission>.from(
          json['userPermission'].map((x) => UserPermission.fromJson(x))
      ),
    );
  }
}