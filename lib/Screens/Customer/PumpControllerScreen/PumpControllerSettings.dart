import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:oro_irrigation_new/Screens/Config/NewPreference/preference_main_screen.dart';
import 'package:provider/provider.dart';

import '../../../Models/language.dart';
import '../../../constants/http_service.dart';
import '../../../constants/snack_bar.dart';
import '../../../state_management/overall_use.dart';
import '../../Config/names_form.dart';
import '../../Forms/create_account.dart';

import 'package:timezone/standalone.dart' as tz;

import '../Dashboard/ControllerSettings.dart';
import 'PumpPreferenceScreen.dart';

class PumpControllerSettings extends StatefulWidget {
  const PumpControllerSettings({Key? key, required this.customerId, required this.controllerId, required this.adDrId}) : super(key: key);

  final int customerId, controllerId, adDrId;

  @override
  State<PumpControllerSettings> createState() => _PumpControllerSettingsState();
}

class _PumpControllerSettingsState extends State<PumpControllerSettings> {
  late OverAllUse overAllUse;
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
  String modelName= '', deviceId= '', categoryName= '';
  int groupId=0;

  String? _selectedTimeZone;
  String _currentDate = '';
  String _currentTime = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLanguage();
    getControllerInfo();
    getSubUserList();
    overAllUse = Provider.of<OverAllUse>(context, listen: false);
  }

  void callbackFunction(String message)
  {
    Future.delayed(const Duration(milliseconds: 500), () {
      const GlobalSnackBar(code: 200, message: 'Sub user created successfully');
      getSubUserList();
    });
  }

  Future<void> getLanguage() async {
    final response = await HttpService().postRequest("getLanguageByActive", {"active": '1'});
    if (response.statusCode == 200)
    {
      languageList.clear();
      var data = jsonDecode(response.body);
      if(data["code"]==200)
      {
        final cntList = data["data"] as List;
        for (int i=0; i < cntList.length; i++) {
          languageList.add(LanguageList.fromJson(cntList[i]));
        }
        setState(() {
          languageList;
        });
      }
    }
  }

  Future<void> getControllerInfo() async{
    final response = await HttpService().postRequest("getUserMasterDetails", {"userId": widget.customerId,"controllerId": widget.controllerId});
    if (response.statusCode == 200)
    {
      print(response.body);
      var data = jsonDecode(response.body);
      if(data["code"]==200)
      {
        txtEcSiteName.text = data["data"][0]['groupName'];
        txtEcGroupName.text = data["data"][0]['deviceName'];
        setState(() {
          deviceId = data["data"][0]['deviceId'];
          modelName = data["data"][0]['modelName'];
          categoryName = data["data"][0]['categoryName'];
          groupId = data["data"][0]['groupId'];
          _updateCurrentDateTime(data["data"][0]['timeZone']);
        });
      }
    }
  }


  Future<void> getSubUserList() async {
    final response = await HttpService().postRequest("getUserSharedList", {"userId": widget.customerId});
    if (response.statusCode == 200)
    {
      languageList.clear();
      var data = jsonDecode(response.body);
      if(data["code"]==200)
      {
        setState(() {
          subUsers = List<Map<String, dynamic>>.from(data["data"]);
        });
      }
    }
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
    overAllUse = Provider.of<OverAllUse>(context, listen: true);
    final screenWidth = MediaQuery.of(context).size.width;
    return visibleLoading? buildLoadingIndicator(visibleLoading, MediaQuery.sizeOf(context).width):
    Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              indicatorColor: Colors.pinkAccent,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Preference'),
                Tab(text: 'General'),
                Tab(text: 'Names'),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  overAllUse.showTab
                      ? PreferenceMainScreen(customerID: widget.customerId, controllerId: widget.controllerId, deviceId: deviceId, userId: widget.customerId)
                      : const Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator())),
                  overAllUse.showTab
                      ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildGeneralContent(screenWidth),
                  ) : const Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator())),
                  // PumpPreferenceScreen(customerId: widget.customerId, controllerId: widget.controllerId,),
                  overAllUse.showTab
                      ? Names(userID: widget.customerId,  customerID: widget.customerId, controllerId: widget.controllerId, imeiNo: '',)
                      : const Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator())),
                ],
              ),
            ),
          ],
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
    return screenWidth>600?Container(
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
                          title: const Text('Form Name'),
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
                        const Divider(),
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
                        const Divider(),
                        ListTile(
                          title: const Text('Device Category'),
                          leading: const Icon(Icons.category_outlined),
                          trailing: Text(categoryName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text('Model'),
                          leading: const Icon(Icons.model_training),
                          trailing: Text(modelName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text('Device ID'),
                          leading: const Icon(Icons.numbers_outlined),
                          trailing: SelectableText(
                            deviceId,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: VerticalDivider(width: 0),
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
                            items: themeColors.entries.map<DropdownMenuItem<String>>((entry) {
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
                            items: _timeZones.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text('Current Date'),
                          leading: const Icon(Icons.date_range),
                          trailing: Text(_currentDate, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text('Current UTC Time'),
                          leading: const Icon(Icons.date_range),
                          trailing: Text(_currentTime, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                        ),
                        const Divider(),
                        const ListTile(
                          title: Text('Time Format'),
                          leading: Icon(Icons.date_range),
                          trailing: Text('24 Hrs', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                        ),
                        const Divider(),
                        const ListTile(
                          title: Text('Unit'),
                          leading: Icon(Icons.ac_unit_rounded),
                          trailing: Text('m3', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.sizeOf(context).width,
              child: ListTile(trailing: MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                onPressed:() async {
                  Map<String, Object> body = {
                    'userId': widget.customerId,
                    'controllerId': widget.controllerId,
                    'deviceName': txtEcGroupName.text,
                    'groupId': groupId,
                    'groupName': txtEcSiteName.text,
                    'modifyUser': widget.customerId,
                    'timeZone': _selectedTimeZone ?? '',
                  };
                  final Response response = await HttpService().putRequest("updateUserMasterDetails", body);
                  if(response.statusCode == 200)
                  {
                    var data = jsonDecode(response.body);
                    if(data["code"]==200)
                    {
                      if (context.mounted){
                        GlobalSnackBar.show(context, data["message"], response.statusCode);
                      }
                    }
                  }
                },
                child: const Text('Restore'),
              ),),
            ),
            ListTile(
              leading: const Icon(Icons.supervised_user_circle_outlined),
              title: const Text('My Sub users', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
              trailing: widget.adDrId!=0?IconButton(tooltip:'Add new sub user', onPressed: () async {
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
                        child: CreateAccount(callback: callbackFunction, subUsrAccount: true, customerId: widget.customerId, from: 'Sub User',),
                      ),
                    );
                  },
                );
              }, icon: const Icon(Icons.add)):
              null,
            ),
            const Divider(height: 0,),
            SizedBox(
              height: 70,
              child: subUsers.isNotEmpty?ListView.builder(
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
              ):
              const Center(child: Text('No Sub user available for this controller')),
            ),
          ],
        ),
      ),
    ):
    Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(height: 8,),
                SizedBox(
                  width: screenWidth,
                  child: TextField(
                    controller: txtEcSiteName,
                    decoration: InputDecoration(
                      filled: false,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Form name',
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
                        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
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
                  trailing: Text(categoryName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Model'),
                  leading: const Icon(Icons.model_training),
                  trailing: Text(modelName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Device ID'),
                  leading: const Icon(Icons.numbers_outlined),
                  trailing: Text(deviceId, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
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
                    items: themeColors.entries.map<DropdownMenuItem<String>>((entry) {
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
                  trailing: Text('15:10:00', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                ),
                const Divider(),
                const ListTile(
                  title: Text('Time Format'),
                  leading: Icon(Icons.date_range),
                  trailing: Text('24 Hrs', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                ),
                const Divider(),
                const ListTile(
                  title: Text('Current Date'),
                  leading: Icon(Icons.date_range),
                  trailing: Text('13-05-2024', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                ),
                const Divider(),
                const ListTile(
                  title: Text('Unit'),
                  leading: Icon(Icons.ac_unit_rounded),
                  trailing: Text('m3', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                ),
                const Divider(),
              ],
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.sizeOf(context).width,
              child: ListTile(trailing: MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                onPressed:() async {
                  Map<String, Object> body = {
                    'userId': widget.customerId,
                    'controllerId': widget.controllerId,
                    'deviceName': txtEcGroupName.text,
                    'groupId': groupId,
                    'groupName': txtEcSiteName.text,
                    'modifyUser': widget.customerId,
                  };
                  final Response response = await HttpService().putRequest("updateUserMasterDetails", body);
                  if(response.statusCode == 200)
                  {
                    var data = jsonDecode(response.body);
                    if(data["code"]==200)
                    {
                      if (context.mounted){
                        GlobalSnackBar.show(context, data["message"], response.statusCode);
                      }
                    }
                  }
                },
                child: const Text('Restore'),
              ),),
            ),
            ListTile(
              leading: const Icon(Icons.supervised_user_circle_outlined),
              title: const Text('My Sub users', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
              trailing: widget.adDrId!=0?IconButton(tooltip:'Add new sub user', onPressed: () async {
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
                        child: CreateAccount(callback: callbackFunction, subUsrAccount: true, customerId: widget.customerId, from: 'Sub User',),
                      ),
                    );
                  },
                );
              }, icon: const Icon(Icons.add)):
              null,
            ),
            const Divider(height: 0,),
            SizedBox(
              height: 70,
              child: subUsers.isNotEmpty?ListView.builder(
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
              ):
              const Center(child: Text('No Sub user available for this controller')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAlertDialog(BuildContext context, String cName, int suId) async {

    List<UserGroup> userGroups = [];

    final response = await HttpService().postRequest("getUserSharedDeviceList",
        {"userId": widget.customerId, "sharedUserId": suId,});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
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
        {"userId": widget.customerId, "masterList": uptJson, "sharedUser": suId, "createUser": widget.customerId,});
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
          child: const Text('OK'),
        ),
      ],
    );
  }
}