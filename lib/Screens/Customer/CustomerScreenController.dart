import 'dart:async';
import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:oro_irrigation_new/Screens/Customer/verssionupdate.dart';
import 'package:oro_irrigation_new/screens/Customer/Dashboard/SentAndReceived.dart';
import 'package:oro_irrigation_new/screens/Customer/WeatherScreen.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/Customer/Dashboard/DashboardNode.dart';
import '../../Models/Customer/Dashboard/ProgramList.dart';
import '../../constants/MQTTManager.dart';
import '../../constants/MyFunction.dart';
import '../../constants/http_service.dart';
import '../../constants/snack_bar.dart';
import '../../constants/theme.dart';
import '../../state_management/MqttPayloadProvider.dart';
import '../../state_management/overall_use.dart';
import '../UserChat/user_chat.dart';
import '../product_inventory.dart';
import 'AccountManagement.dart';
import 'CustomerDashboard.dart';
import 'Dashboard/AllNodeListAndDetails.dart';
import 'Dashboard/ControllerLogs.dart';
import 'Dashboard/ControllerSettings.dart';
import 'Dashboard/NodeHourlyLog/NodeHrsLog.dart';
import 'Dashboard/RunByManual.dart';
import 'Dashboard/SensorHourlyLog/SensorHourlyLogs.dart';
import 'Dashboard/sevicecustomer.dart';
import 'Logs/irrigation_and_pump_log.dart';
import 'ProgramSchedule.dart';
import 'PumpControllerScreen/PumpDashboard.dart';
import 'ScheduleView.dart';


class CustomerScreenController extends StatefulWidget {
  const CustomerScreenController({Key? key, required this.customerId, required this.customerName, required this.mobileNo, required this.emailId, required this.comingFrom, required this.userId}) : super(key: key);
  final int userId, customerId;
  final String customerName, mobileNo, emailId, comingFrom;

  @override
  _CustomerScreenControllerState createState() => _CustomerScreenControllerState();
}

class _CustomerScreenControllerState extends State<CustomerScreenController> with TickerProviderStateMixin
{
  List<DashboardModel> mySiteList = [];
  int siteIndex = 0;
  int masterIndex = 0;
  int lineIndex = 0;
  bool visibleLoading = false;
  int _selectedIndex = 0;
  List<ProgramList> programList = [];

  String lastSyncData = '';

  late String _myCurrentSite;
  late String _myCurrentMaster;
  String _myCurrentIrrLine= 'No Line Available';

  String fromWhere = '';
  bool appbarBottomOpen = false;



  @override
  void initState() {
    super.initState();
    print('coming from: ${widget.comingFrom}');
    print('coming userId: ${widget.userId}');
    print('coming customerId: ${widget.customerId}');
    indicatorViewShow();
    getCustomerSite(widget.customerId);
  }

  void callbackFunction(message)
  {
    Navigator.pop(context);
    Future.delayed(const Duration(milliseconds: 500), () {
      _showSnackBar(message);
    });
  }

  void onRefreshClicked() {

    MqttPayloadProvider payloadProvider = Provider.of<MqttPayloadProvider>(context, listen: false);
    Future.delayed(const Duration(milliseconds: 1000), () {

      payloadProvider.liveSyncCall(true);
      String livePayload = '';

      if(mySiteList[siteIndex].master[masterIndex].categoryId==1 ||
          mySiteList[siteIndex].master[masterIndex].categoryId==2){
        livePayload = jsonEncode({"3000": [{"3001": ""}]});
      }else{
        livePayload = jsonEncode({"sentSMS": "#live"});
      }
      MQTTManager().publish(livePayload, 'AppToFirmware/${mySiteList[siteIndex].master[masterIndex].deviceId}');
    });

    Future.delayed(const Duration(milliseconds: 6000), () {
      payloadProvider.liveSyncCall(false);
    });
  }

  Future<void> getCustomerSite(userId) async
  {
    Map<String, Object> body = {"userId" : userId ?? 0};
    final response = await HttpService().postRequest("getCustomerDashboard", body);
    if (response.statusCode == 200)
    {
      mySiteList.clear();
      var data = jsonDecode(response.body);
      print(response.body);
      if(data["code"]==200)
      {
        final jsonData = data["data"] as List;
        try {
          if(jsonData[0]['master'][0]['categoryId']==1||jsonData[0]['master'][0]['categoryId']==2){
            MqttPayloadProvider payloadProvider = Provider.of<MqttPayloadProvider>(context, listen: false);
            payloadProvider.saveUnits(jsonData[0]['master'][0]['units']);
            payloadProvider.nodeConnection(true);
          }
          mySiteList.addAll(jsonData.map((json) => DashboardModel.fromJson(json)).toList());
          getSharedSite(userId ?? 0);
        } catch (e) {
          print('Error: $e');
          indicatorViewHide();
        }
      }
      else{
        getSharedSite(widget.customerId);
      }

    }
    else{
      indicatorViewHide();
    }
  }

  Future<void> getSharedSite(int userId) async {
    Map<String, dynamic> body = {"userId": userId, "sharedUserId": null};
    final response = await HttpService().postRequest("getSharedUserDeviceList", body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["code"] == 200) {
        try {
          final sharedUsers = data["data"]["users"] as List;
          for (var user in sharedUsers) {
            await fetchDevicesForUser(userId, user["userId"]);
          }

          indicatorViewHide();
          if (mySiteList.isNotEmpty) {
            fromWhere = 'init';
            updateSite(0, 0, 0);
            getProgramList();
          }
        } catch (e) {
          print('Error: $e');
          indicatorViewHide();
        }
      }
      else{
        indicatorViewHide();
        if (mySiteList.isNotEmpty) {
          fromWhere = 'init';
          updateSite(0, 0, 0);
          getProgramList();
        }
      }
    } else {
      indicatorViewHide();
    }
  }

  Future<void> fetchDevicesForUser(int userId, int sharedUserId) async
  {
    Map<String, dynamic> body = {"userId": userId, "sharedUserId": sharedUserId};
    final response = await HttpService().postRequest("getSharedUserDeviceList", body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["code"] == 200) {
        try {
          var groupedDevices = <int, Map<String, dynamic>>{};

          for (var device in data["data"]["devices"]) {
            if (!groupedDevices.containsKey(device["groupId"])) {
              groupedDevices[device["groupId"]] = {
                "userGroupId": device["groupId"],
                "groupName": device["groupName"],
                "customerId": sharedUserId,
                "active": "1",
                "master": []
              };
            }

            var deviceData = {
              "2400": device["2400"],
              "controllerId": device["controllerId"],
              "deviceId": device["deviceId"],
              "deviceName": device["deviceName"],
              "categoryId": device["categoryId"],
              "categoryName": device["categoryName"],
              "modelId": device["modelId"],
              "modelName": device["modelName"],
              "liveSyncDate": device["liveSyncDate"],
              "liveSyncTime": device["liveSyncTime"],
              "conditionLibraryCount": device["conditionLibraryCount"] ?? 0,
              "userPermission": device["userPermission"],
              "irrigationLine": device["irrigationLine"],
              "units": device["units"]
            };

            groupedDevices[device["groupId"]]?["master"].add(deviceData);
          }

          var transformedData = groupedDevices.values.toList();

          if(mySiteList.isEmpty){
            if(transformedData[0]['master'][0]['categoryId']==1||transformedData[0]['master'][0]['categoryId']==2){
              MqttPayloadProvider payloadProvider = Provider.of<MqttPayloadProvider>(context, listen: false);
              payloadProvider.saveUnits(transformedData[0]['master'][0]['units']);
              payloadProvider.saveUserPermission(transformedData[0]['master'][0]['userPermission']);
              payloadProvider.nodeConnection(true);
            }
          }
          mySiteList.addAll(transformedData.map((json) => DashboardModel.fromJson(json)).toList());

        } catch (e) {
          print('Error: $e');
        }
      }
    }
  }

  void updateSite(sIdx, mIdx, lIdx){
    _myCurrentSite = mySiteList[sIdx].groupName;
    updateMaster(sIdx, mIdx, lIdx);
  }

  void updateMaster(sIdx, mIdx, lIdx){
    _myCurrentMaster = mySiteList[sIdx].master[mIdx].categoryName;
    subscribeCurrentMaster(sIdx, mIdx);
    if(mySiteList[sIdx].master[mIdx].categoryId == 1 ||
        mySiteList[sIdx].master[mIdx].categoryId == 2){
      updateMasterLine(sIdx, mIdx, lIdx);
      displayServerData();
    }else{
      //pump controller
      MqttPayloadProvider payloadProvider = Provider.of<MqttPayloadProvider>(context, listen: false);
      payloadProvider.updateLastSync('${mySiteList[siteIndex].master[masterIndex].liveSyncDate} ${mySiteList[siteIndex].master[masterIndex].liveSyncTime}');
    }

  }

  void updateMasterLine(sIdx, mIdx, lIdx){
    if(mySiteList[sIdx].master[mIdx].irrigationLine.isNotEmpty){
      setState(() {
        _myCurrentIrrLine = mySiteList[sIdx].master[mIdx].irrigationLine[lIdx].name;
      });
    }
  }

  void subscribeCurrentMaster(sIdx, mIdx) async {
    MyFunction().clearMQTTPayload(context);
    Future.delayed(const Duration(seconds: 1), () {
      MQTTManager().subscribeToTopic('FirmwareToApp/${mySiteList[sIdx].master[mIdx].deviceId}');
      onRefreshClicked();
    });
  }


  Future<void> getProgramList() async
  {
    programList.clear();
    try {
      Map<String, Object> body = {"userId": widget.customerId, "controllerId": mySiteList[siteIndex].master[masterIndex].controllerId};
      final response = await HttpService().postRequest("getUserProgramNameList", body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<dynamic> programsJson = jsonResponse['data'];
        setState((){
          programList = [...programsJson.map((programJson) => ProgramList.fromJson(programJson)).toList()];
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  void displayServerData(){
    MqttPayloadProvider payloadProvider = Provider.of<MqttPayloadProvider>(context, listen: false);

    if(mySiteList[siteIndex].master[masterIndex].categoryId==1 ||
        mySiteList[siteIndex].master[masterIndex].categoryId==2) {
      //gem or gem+ controller
      payloadProvider.updateWifiStrength(mySiteList[siteIndex].master[masterIndex].gemLive[0].wifiStrength);
      payloadProvider.updateLastSync('${mySiteList[siteIndex].master[masterIndex].liveSyncDate} ${mySiteList[siteIndex].master[masterIndex].liveSyncTime}');

      List<dynamic> ndlLst = mySiteList[siteIndex].master[masterIndex].gemLive[0].nodeList.map((ndl) => ndl.toJson()).toList();
      payloadProvider.updateNodeList(ndlLst);

      List<dynamic> allPumps = mySiteList[siteIndex].master[masterIndex].gemLive[0].pumpList.map((pl) => pl.toJson()).toList();

      List<dynamic> spLst = mySiteList[siteIndex].master[masterIndex].gemLive[0].scheduledProgramList.map((sp) => sp.toJson()).toList();
      List<ScheduledProgram> sp = spLst.map((sp) => ScheduledProgram.fromJson(sp)).toList();
      payloadProvider.updateScheduledProgram(sp);

      payloadProvider.updateAlarmPayload(mySiteList[siteIndex].master[masterIndex].gemLive[0].alarmList);
      payloadProvider.updatePayload2408(mySiteList[siteIndex].master[masterIndex].gemLive[0].irrigationLine);

      if(payloadProvider.lastCommunication.inMinutes>=10){
        mySiteList[siteIndex].master[masterIndex].gemLive[0].currentSchedule=[];
        mySiteList[siteIndex].master[masterIndex].gemLive[0].queProgramList=[];

        //pump-------------------------------------------------
        List<PumpData> pumpList = allPumps.map((pl) => PumpData.fromJson(pl)).toList();
        for (var item in pumpList) {
          if (item.status!= 0) {
            item.status= 0;
          }
        }
        payloadProvider.updatePumpPayload(pumpList);

        //filter-----------------------------------------------
        String filterList = jsonEncode(mySiteList[siteIndex].master[masterIndex].gemLive[0].filterList.map((filter) => filter.toJson()).toList());
        List<dynamic> jsonFilterList = jsonDecode(filterList);
        for (var item in jsonFilterList) {
          if (item["Status"] != 0) {
            item["Status"] = 0;
          }
          if (item.containsKey("FilterStatus")) {
            for (var filterStatus in item["FilterStatus"]) {
              if (filterStatus["Status"] != 0) {
                filterStatus["Status"] = 0;
              }
            }
          }
        }

        String filterPayloadFinal = jsonEncode({
          "2400": [{"2405": jsonFilterList.toList()}]
        });
        payloadProvider.updateFilterPayload(filterPayloadFinal);

        //fertilizer----------------------------------------
        String fertilizerSiteList = jsonEncode(mySiteList[siteIndex].master[masterIndex].gemLive[0].fertilizerSiteList.map((pump) => pump.toJson()).toList());
        List<dynamic> jsonFertilizerList = jsonDecode(fertilizerSiteList);
        for (var item in jsonFertilizerList) {
          updateFertStatus(item);
        }
        String fertilizerPayloadFinal = jsonEncode({
          "2400": [{"2406": jsonFertilizerList.toList()}]
        });
        payloadProvider.updateFertilizerPayload(fertilizerPayloadFinal);

      }
      else{
        if(fromWhere!='line'){
          List<dynamic> csLst = mySiteList[siteIndex].master[masterIndex].gemLive[0].currentSchedule.map((cs) => cs.toJson()).toList();
          List<CurrentScheduleModel> cs = csLst.map((cs) => CurrentScheduleModel.fromJson(cs)).toList();
          payloadProvider.updateCurrentScheduled(cs);

          List<dynamic> pqLst = mySiteList[siteIndex].master[masterIndex].gemLive[0].queProgramList.map((pq) => pq.toJson()).toList();
          List<ProgramQueue> pq = pqLst.map((pq) => ProgramQueue.fromJson(pq)).toList();
          payloadProvider.updateProgramQueue(pq);

          //pump-------------------------------------------------
          List<PumpData> pumpList = allPumps.map((pl) => PumpData.fromJson(pl)).toList();
          payloadProvider.updatePumpPayload(pumpList);

          //filter------------------------------------
          String filterList = jsonEncode(mySiteList[siteIndex].master[masterIndex].gemLive[0].filterList.map((filter) => filter.toJson()).toList());
          List<dynamic> jsonFilterList = jsonDecode(filterList);
          String filterPayloadFinal = jsonEncode({
            "2400": [{"2405": jsonFilterList.toList()}]
          });
          payloadProvider.updateFilterPayload(filterPayloadFinal);

          //fertilizer------------------------------------------
          String fertilizerSiteList = jsonEncode(mySiteList[siteIndex].master[masterIndex].gemLive[0].fertilizerSiteList.map((pump) => pump.toJson()).toList());
          List<dynamic> jsonFertilizerList = jsonDecode(fertilizerSiteList);
          String fertilizerPayloadFinal = jsonEncode({
            "2400": [{"2406": jsonFertilizerList.toList()}]
          });
          payloadProvider.updateFertilizerPayload(fertilizerPayloadFinal);
        }
      }
    }
    else{
      //pump controller
    }

  }

  void updateFertStatus(Map<String, dynamic> json) {
    json.forEach((key, value) {
      if (key == "Status" && value != 0) {
        json[key] = 0;
      } else if (value is List) {
        for (var item in value) {
          if (item is Map<String, dynamic>) {
            updateFertStatus(item);
          }
        }
      } else if (value is Map<String, dynamic>) {
        updateFertStatus(value);
      }
    });
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }


  @override
  Widget build(BuildContext context)
  {
    final screenWidth = MediaQuery.of(context).size.width;
    final provider = Provider.of<MqttPayloadProvider>(context);
    Duration lastComDifference = provider.lastCommunication;

    if(mySiteList.isNotEmpty){
      if(mySiteList[siteIndex].master[masterIndex].categoryId==1||
          mySiteList[siteIndex].master[masterIndex].categoryId==2){
        //gem or gem+ controller
        if(lastComDifference.inMinutes>=10){
          mySiteList[siteIndex].master[masterIndex].gemLive[0].currentSchedule=[];
          mySiteList[siteIndex].master[masterIndex].gemLive[0].queProgramList=[];
        }
        else{
          List<CurrentScheduleModel> currentSchedule = provider.currentSchedule;
          mySiteList[siteIndex].master[masterIndex].gemLive[0].currentSchedule = currentSchedule;

          List<ProgramQueue> programQueue = provider.programQueue;
          mySiteList[siteIndex].master[masterIndex].gemLive[0].queProgramList = programQueue;
        }
      }else{
        //pump controller
        if(provider.pumpLiveList.isNotEmpty){
          List<CM> pl = provider.pumpLiveList;
          mySiteList[siteIndex].master[masterIndex].pumpLive = pl;
        }
      }
    }

    return Consumer<MqttPayloadProvider>(
      builder: (context, payload, child){
        return visibleLoading? buildLoadingIndicator(visibleLoading, screenWidth):
        buildWideLayout(screenWidth, payload);
      },
    );
  }

  Widget buildWideLayout(screenWidth, MqttPayloadProvider payload) {

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Image(image: AssetImage("assets/images/oro_logo_white.png")),
        ),
        title:  Row(
          children: [
            const SizedBox(width: 10,),
            Container(width: 1, height: 20, color: Colors.white54,),
            const SizedBox(width: 5,),
            mySiteList.length>1? DropdownButton(
              underline: Container(),
              items: (mySiteList ?? []).map((site) {
                return DropdownMenuItem(
                  value: site.groupName,
                  child: Text(site.groupName, style: const TextStyle(color: Colors.white, fontSize: 17),),
                );
              }).toList(),
              onChanged: (newSiteName) {
                int newIndex = mySiteList.indexWhere((site) => site.groupName == newSiteName);
                if (newIndex != -1 && mySiteList.length > 1) {
                  siteIndex = newIndex;
                  masterIndex = 0;
                  lineIndex = 0;
                  fromWhere='site';
                  updateSite(newIndex, 0, 0);
                }
                //TODO: Modified by saravanan
                final overAllUse = Provider.of<OverAllUse>(context, listen: false);
                setState(() {
                  overAllUse.showTab = false;
                  Future.delayed(const Duration(milliseconds: 1000), () {
                    overAllUse.showTab = true;
                  });
                });
              },
              value: _myCurrentSite,
              dropdownColor: Colors.teal,
              iconEnabledColor: Colors.white,
              iconDisabledColor: Colors.white,
              focusColor: Colors.transparent,
            ):
            Text(mySiteList[siteIndex].groupName, style: const TextStyle(fontSize: 17),),

            const SizedBox(width: 15,),
            Container(width: 1,height: 20, color: Colors.white54,),
            const SizedBox(width: 5,),
            mySiteList[siteIndex].master.length>1? DropdownButton(
              underline: Container(),
              items: (mySiteList[siteIndex].master ?? []).map((master) {
                return DropdownMenuItem(
                  value: master.categoryName,
                  child: Text(master.deviceName, style: const TextStyle(color: Colors.white, fontSize: 17),),
                );
              }).toList(),
              onChanged: (newCategoryName) {
                int masterIdx = mySiteList[siteIndex].master.indexWhere((master)=> master.categoryName == newCategoryName);
                if (masterIdx != -1 && mySiteList[siteIndex].master.length > 1) {
                  masterIndex = masterIdx;
                  lineIndex = 0;
                  fromWhere='master';
                  updateMaster(siteIndex, masterIdx, 0);
                }
                //TODO: Modified by saravanan
                final overAllUse = Provider.of<OverAllUse>(context, listen: false);
                setState(() {
                  overAllUse.showTab = false;
                  Future.delayed(const Duration(milliseconds: 1000), () {
                    overAllUse.showTab = true;
                  });
                });
              },
              value: _myCurrentMaster,
              dropdownColor: Colors.teal,
              iconEnabledColor: Colors.white,
              iconDisabledColor: Colors.white,
              focusColor: Colors.transparent,
            ) :
            Text(mySiteList[siteIndex].master[masterIndex].categoryName, style: const TextStyle(fontSize: 17),),

            mySiteList[siteIndex].master[masterIndex].categoryId == 1 ||
                mySiteList[siteIndex].master[masterIndex].categoryId == 2? const SizedBox(width: 15,): const SizedBox(),

            mySiteList[siteIndex].master[masterIndex].categoryId == 1 ||
                mySiteList[siteIndex].master[masterIndex].categoryId == 2? Container(width: 1,height: 20, color: Colors.white54,): const SizedBox(),

            mySiteList[siteIndex].master[masterIndex].categoryId == 1 ||
                mySiteList[siteIndex].master[masterIndex].categoryId == 2? const SizedBox(width: 5,): const SizedBox(),

            (mySiteList[siteIndex].master[masterIndex].categoryId == 1 ||
                mySiteList[siteIndex].master[masterIndex].categoryId == 2) && mySiteList[siteIndex].master[masterIndex].irrigationLine.length>1?
            DropdownButton(
              underline: Container(),
              items: (mySiteList[siteIndex].master[masterIndex].irrigationLine ?? []).map((line) {
                return DropdownMenuItem(
                  value: line.name,
                  child: Text(line.name, style: const TextStyle(color: Colors.white, fontSize: 17),),
                );
              }).toList(),
              onChanged: (newLineName) {
                int lIndex = mySiteList[siteIndex].master[masterIndex].irrigationLine.indexWhere((line)
                => line.name == newLineName);
                if (lineIndex != -1 && mySiteList[siteIndex].master[masterIndex].irrigationLine.length > 1) {
                  lineIndex = lIndex;
                  fromWhere='line';
                  updateMasterLine(siteIndex, masterIndex, lIndex);
                }
              },
              value: _myCurrentIrrLine,
              dropdownColor: Colors.teal,
              iconEnabledColor: Colors.white,
              iconDisabledColor: Colors.white,
              focusColor: Colors.transparent,
            ) :
            (mySiteList[siteIndex].master[masterIndex].categoryId == 1 ||
                mySiteList[siteIndex].master[masterIndex].categoryId == 2)?
            Text(mySiteList[siteIndex].master[masterIndex].irrigationLine.isNotEmpty?mySiteList[siteIndex].master[masterIndex].irrigationLine[0].name:'Line empty', style: const TextStyle(fontSize: 17),):
            const SizedBox(),

            const SizedBox(width: 15,),
            Container(width: 1, height: 20, color: Colors.white54,),
            const SizedBox(width: 5,),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.transparent
              ),
              width: 45,
              height: 45,
              child: IconButton(
                tooltip: 'refresh',
                onPressed: onRefreshClicked,
                icon: const Icon(Icons.refresh),
                color: Colors.white,
                iconSize: 24.0,
                hoverColor: Colors.cyan,
              ),
            ),
            Text(
              'Last sync @ : ${formatDateTime(DateTime.parse(payload.syncDateTime))}',
              style: const TextStyle(fontSize: 15, color: Colors.white70),
            )

          ],
        ),
        leadingWidth: 75,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              tileMode: TileMode.clamp,
              colors: [myTheme.primaryColorDark, myTheme.primaryColor], // Define your gradient colors
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              mySiteList[siteIndex].master[masterIndex].irrigationLine.length>1 && payload.currentSchedule.isNotEmpty?
              CircleAvatar(
                radius: 15,
                backgroundImage: const AssetImage('assets/GifFile/water_drop_ani.gif'),
                backgroundColor: Colors.blue.shade100,
              ):
              const SizedBox(),
              const SizedBox(width: 10,),

              mySiteList[siteIndex].master[masterIndex].irrigationLine.length>1? TextButton(
                onPressed: () {
                  String strPRPayload = '';
                  for (int i = 0; i < payload.payloadIrrLine.length; i++) {
                    if (payload.payloadIrrLine.every((record) => record.irrigationPauseFlag == 1)) {
                      strPRPayload += '${payload.payloadIrrLine[i].sNo},0;';
                    } else {
                      strPRPayload += '${payload.payloadIrrLine[i].sNo},1;';
                    }
                  }
                  String payloadFinal = jsonEncode({
                    "4900": [{"4901": strPRPayload}]
                  });
                  MQTTManager().publish(payloadFinal, 'AppToFirmware/${mySiteList[siteIndex].master[masterIndex].deviceId}');
                  if (payload.payloadIrrLine.every((record) => record.irrigationPauseFlag == 1)) {
                    sentToServer('Resumed all line', payloadFinal);
                  } else {
                    sentToServer('Paused all line', payloadFinal);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(payload.payloadIrrLine.every((record) => record.irrigationPauseFlag == 1)?Colors.green: Colors.orange),
                  shape: WidgetStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    payload.payloadIrrLine.every((record) => record.irrigationPauseFlag == 1)
                        ? const Icon(Icons.play_arrow_outlined, color: Colors.black)
                        : const Icon(Icons.pause, color: Colors.black),
                    const SizedBox(width: 5),
                    Text(payload.payloadIrrLine.every((record) => record.irrigationPauseFlag == 1) ? 'RESUME ALL LINE' : 'PAUSE ALL LINE',
                        style: const TextStyle(color: Colors.black)),
                  ],
                ),
              ):
              const SizedBox(),

              const SizedBox(width: 10),
              const IconButton(color: Colors.transparent, onPressed: null, icon: CircleAvatar(
                radius: 17,
                backgroundColor: Colors.black12,
                child: Icon(Icons.mic, color: Colors.black26,),
              )),
              IconButton(tooltip : 'Help & Support', onPressed: (){
                showMenu(
                  context: context,
                  color: Colors.white,
                  position: const RelativeRect.fromLTRB(100, 0, 50, 0),
                  items: <PopupMenuEntry>[
                    PopupMenuItem(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.info_outline),
                            title: const Text('App info'),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder:(context) => UserChatScreen(userId: widget.userId, dealerId: 0, userName: widget.customerName)));
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.info_outline),
                            title: const Text('Controller info'),
                            onTap: ()  {
                              Navigator.pop(context);
                              _showPasswordDialog(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.help_outline),
                            title: const Text('Help'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.model_training),
                            title: const Text('Training'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Divider(height: 0),
                          ListTile(
                            leading: const Icon(Icons.feedback_outlined),
                            title: const Text('Send feedback'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }, icon: const CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white,
                child: Icon(Icons.live_help_outlined),
              )),
              IconButton(tooltip : 'Niagara Account\n${widget.customerName}\n ${widget.mobileNo}', onPressed: (){
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(100, 0, 10, 0),
                  surfaceTintColor: myTheme.primaryColor,
                  items: <PopupMenuEntry>[
                    PopupMenuItem(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Center(
                                child: CircleAvatar(radius: 35, backgroundColor: myTheme.primaryColor.withOpacity(0.1), child: Text(widget.customerName.substring(0, 1).toUpperCase(), style: const TextStyle(fontSize: 25)),),
                              ),
                              Positioned(
                                bottom: 0.0,
                                right: 70.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: myTheme.primaryColor,
                                  ),
                                  child: IconButton(
                                    tooltip:'Edit',
                                    icon: const Icon(Icons.edit_outlined, color: Colors.white),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text('Hi, ${widget.customerName}!',style: const TextStyle(fontSize: 20)),
                          //Text(widget.emailId, style: const TextStyle(fontSize: 13)),
                          Text(widget.mobileNo, style: const TextStyle(fontSize: 13)),
                          const SizedBox(height: 8),
                          MaterialButton(
                            color: myTheme.primaryColor,
                            textColor: Colors.white,
                            child: const Text('Manage Your Niagara Account'),
                            onPressed: () async {
                              Navigator.pop(context);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AccountManagement(userID: widget.customerId, callback: callbackFunction),
                                ),
                              );

                              /*showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return AccountManagement(userID: widget.customerId, callback: callbackFunction);
                                },
                              );*/
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                tooltip:'Logout',
                                icon: const Icon(Icons.exit_to_app, color: Colors.red),
                                onPressed: () async {
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.remove('userId');
                                  await prefs.remove('userName');
                                  await prefs.remove('userType');
                                  await prefs.remove('countryCode');
                                  await prefs.remove('mobileNumber');
                                  await prefs.remove('subscribeTopic');
                                  await prefs.remove('password');
                                  await prefs.remove('email');

                                  MyFunction().clearMQTTPayload(context);
                                  MQTTManager().onDisconnected();

                                  if (context.mounted){
                                    Navigator.pushReplacementNamed(context, '/login');
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Add more menu items as needed
                  ],
                );
              }, icon: CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white,
                child: Text(widget.customerName.substring(0, 1).toUpperCase()),
              )),
            ],),
          const SizedBox(width: 05),
        ],
      ),
      backgroundColor: Colors.white,
      extendBody: true,
      body: (mySiteList[siteIndex].master[masterIndex].categoryId==1 ||
          mySiteList[siteIndex].master[masterIndex].categoryId==2) ?
      Container(
        width: double.infinity,
        height: double.infinity,
        color: myTheme.scaffoldBackgroundColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              labelType: NavigationRailLabelType.all,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: const [
                NavigationRailDestination(
                  padding: EdgeInsets.only(top: 5),
                  icon: Tooltip(
                    message: 'Home',
                    child: Icon(Icons.home_outlined),
                  ),
                  selectedIcon: Icon(Icons.home, color: Colors.white,),
                  label: Text(''),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'All my devices',
                    child: Icon(Icons.devices_other),
                  ),
                  selectedIcon: Icon(Icons.devices_other_outlined, color: Colors.white),
                  label: Text(''),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'Sent & Received',
                    child: Icon(Icons.question_answer_outlined),
                  ),
                  selectedIcon: Icon(Icons.question_answer, color: Colors.white,),
                  label: Text(''),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'Controller Logs',
                    child: Icon(Icons.receipt_outlined),
                  ),
                  selectedIcon: Icon(Icons.receipt, color: Colors.white,),
                  label: Text(''),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'Weather',
                    child: Icon(CupertinoIcons.cloud_sun_bolt),
                  ),
                  selectedIcon: Icon(CupertinoIcons.cloud_sun_bolt_fill, color: Colors.white,),
                  label: Text(''),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'Service request',
                    child: Icon(Icons.support_agent),
                  ),
                  selectedIcon: Icon(Icons.support_agent_outlined, color: Colors.white,),
                  label: Text(''),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'Settings',
                    child: Icon(Icons.settings_outlined),
                  ),
                  selectedIcon: Icon(Icons.settings, color: Colors.white,),
                  label: Text(''),
                ),
              ],
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Tooltip(
                      message: 'ⓒ Powered by Niagara Automation',
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 7, right: 4, left: 4),
                          child: Image.asset('assets/images/company_logo.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: mySiteList[siteIndex].master[masterIndex].categoryId==1 ||
                  mySiteList[siteIndex].master[masterIndex].categoryId==2? MediaQuery.sizeOf(context).width-140:
              MediaQuery.sizeOf(context).width-80,
              height: MediaQuery.sizeOf(context).height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  tileMode: TileMode.clamp,
                  colors: [myTheme.primaryColorDark, myTheme.primaryColor],
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: myTheme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                ),
                child: buildScreen(payload),
              ),
            ),
            mySiteList[siteIndex].master[masterIndex].categoryId==1 ||
                mySiteList[siteIndex].master[masterIndex].categoryId==2?
            Container(
              width: 60,
              height: MediaQuery.sizeOf(context).height,
              color: myTheme.primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.transparent
                    ),
                    width: 45,
                    height: 45,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(payload.wifiStrength == 0? Icons.wifi_off:
                        payload.wifiStrength >= 1 && payload.wifiStrength <= 20 ? Icons.network_wifi_1_bar_outlined:
                        payload.wifiStrength >= 21 && payload.wifiStrength <= 40 ? Icons.network_wifi_2_bar_outlined:
                        payload.wifiStrength >= 41 && payload.wifiStrength <= 60 ? Icons.network_wifi_3_bar_outlined:
                        payload.wifiStrength >= 61 && payload.wifiStrength <= 80 ? Icons.network_wifi_3_bar_outlined:
                        Icons.wifi, color: Colors.white,),
                        Text('${payload.wifiStrength} %',style: const TextStyle(fontSize: 11.0, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  AlarmButton(payload: payload, deviceID: mySiteList[siteIndex].master[masterIndex].deviceId, customerId: widget.customerId, controllerId: mySiteList[siteIndex].master[masterIndex].controllerId,),
                  const SizedBox(height: 15),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                    child: SizedBox(
                      height: 45,
                      width: 45,
                      child: IconButton(
                        tooltip: 'Node status',
                        onPressed: () {
                          sideSheet();
                        },
                        icon: const Icon(Icons.format_list_numbered),
                        color: Colors.white,
                        iconSize: 24.0,
                        hoverColor: Colors.cyan,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.transparent
                    ),
                    width: 45,
                    height: 45,
                    child: IconButton(
                      tooltip: 'Input/Output Connection details',
                      onPressed: () {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => AllNodeListAndDetails(userID: widget.userId, customerID: mySiteList[siteIndex].customerId, masterInx: masterIndex, siteData: mySiteList[siteIndex],),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings_input_component_outlined),
                      color: Colors.white,
                      iconSize: 24.0,
                      hoverColor: Colors.cyan,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.transparent
                    ),
                    width: 45,
                    height: 45,
                    child: IconButton(
                      tooltip: 'Program',
                      onPressed: getPermissionStatusBySNo(context, 10) ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgramSchedule(
                              customerID: mySiteList[siteIndex].customerId,
                              controllerID: mySiteList[siteIndex].master[masterIndex].controllerId,
                              siteName: mySiteList[siteIndex].groupName,
                              imeiNumber: mySiteList[siteIndex].master[masterIndex].deviceId,
                              userId: widget.userId,
                            ),
                          ),
                        );
                      }:null,
                      icon: const Icon(Icons.list_alt),
                      color: Colors.white,
                      iconSize: 24.0,
                      hoverColor: Colors.cyan,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.transparent
                    ),
                    width: 45,
                    height: 45,
                    child: IconButton(
                      tooltip: 'Scheduled Program details',
                      onPressed: getPermissionStatusBySNo(context, 3) ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScheduleViewScreen(deviceId: mySiteList[siteIndex].master[masterIndex].deviceId, userId: widget.userId, controllerId: mySiteList[siteIndex].master[masterIndex].controllerId, customerId: widget.customerId),
                          ),
                        );
                      }:null,
                      icon: const Icon(Icons.view_list_outlined),
                      color: Colors.white,
                      iconSize: 24.0,
                      hoverColor: Colors.cyan,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.transparent
                    ),
                    width: 45,
                    height: 45,
                    child: IconButton(
                      tooltip: 'Manual',
                      onPressed: getPermissionStatusBySNo(context, 2) ? () {
                        showGeneralDialog(
                          barrierLabel: "Side sheet",
                          barrierDismissible: true,
                          barrierColor: const Color(0xff66000000),
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
                                    return RunByManual(siteID: mySiteList[siteIndex].userGroupId,
                                      siteName: mySiteList[siteIndex].groupName,
                                      controllerID: mySiteList[siteIndex].master[masterIndex].controllerId,
                                      customerID: mySiteList[siteIndex].customerId,
                                      imeiNo: mySiteList[siteIndex].master[masterIndex].deviceId,
                                      callbackFunction: callbackFunction, userId: widget.userId,);
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
                      }:
                      null,
                      icon: const Icon(Icons.touch_app_outlined),
                      color: Colors.white,
                      iconSize: 24.0,
                      hoverColor: Colors.cyan,
                    ),
                  ),
                ],
              ),
            ):
            const SizedBox(),
          ],
        ),
      ):
      PumpDashboard(siteData: mySiteList[siteIndex], masterIndex: masterIndex, customerId: widget.customerId, dealerId: widget.comingFrom=='AdminORDealer'? widget.userId:0, siteIndex: siteIndex,),
    );
  }

  Widget buildScreen(MqttPayloadProvider payload)
  {
    Duration lastCommunication = payload.lastCommunication;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        lastCommunication.inMinutes >= 10 && payload.powerSupply == 0?Container(
          height: 20.0,
          decoration: BoxDecoration(
            color: Colors.red.shade300,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
          ),
          child: Center(
            child: Text('No communication and power Supply to Controller'.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ),
        ):
        payload.powerSupply == 0?Container(
          height: 20.0,
          decoration: BoxDecoration(
            color: Colors.red.shade300,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
          ),
          child: Center(
            child: Text('No power Supply to Controller'.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ),
        ):
        const SizedBox(),

        payload.nodeAndControllerConnection==false?Container(
          height: 20.0,
          decoration: const BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0)),
          ),
          child: Center(
            child: Text('Some node missing or not liked properly with the Controller'.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ),
        ):
        const SizedBox(),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
            _selectedIndex == 0 ? CustomerDashboard(customerId: mySiteList[siteIndex].customerId, type: 1, customerName: widget.customerName, userId: widget.userId, mobileNo: widget.mobileNo, siteData: mySiteList[siteIndex], masterInx: masterIndex, lineIdx: lineIndex,):
            _selectedIndex == 1 ? ProductInventory(userName: widget.customerName, userId: mySiteList[siteIndex].customerId, userType: 3,):
            _selectedIndex == 2 ? SentAndReceived(customerID: mySiteList[siteIndex].customerId, controllerId: mySiteList[siteIndex].master[masterIndex].controllerId, from: 'Gem',):
            _selectedIndex == 3 ? IrrigationAndPumpLog(userId: mySiteList[siteIndex].customerId, controllerId: mySiteList[siteIndex].master[masterIndex].controllerId,):
            _selectedIndex == 4 ? WeatherScreen(userId: mySiteList[siteIndex].customerId, controllerId: mySiteList[siteIndex].master[masterIndex].controllerId, deviceID: mySiteList[siteIndex].master[masterIndex].deviceId, initialIndex: 0,):
            _selectedIndex == 5 ? TicketHomePage(userId: mySiteList[siteIndex].customerId, controllerId: mySiteList[siteIndex].master[masterIndex].controllerId,):
            ControllerSettings(customerID: mySiteList[siteIndex].customerId, siteData: mySiteList[siteIndex], masterIndex: masterIndex, adDrId: widget.comingFrom=='AdminORDealer'? widget.userId:0, allSiteList: mySiteList,),
          ),
        ),
      ],
    );
  }

  void sideSheet() {
    showGeneralDialog(
      barrierLabel: "Side sheet",
      barrierDismissible: true,
      barrierColor: const Color(0xff66000000),
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
                return SideSheetClass(customerId: mySiteList[siteIndex].customerId, nodeList: mySiteList[siteIndex].master[masterIndex].gemLive[0].nodeList,
                  deviceId: mySiteList[siteIndex].master[masterIndex].deviceId,
                  lastSyncDate: '${mySiteList[siteIndex].master[masterIndex].liveSyncDate} - ${mySiteList[siteIndex].master[masterIndex].liveSyncTime}',
                  deviceName: mySiteList[siteIndex].master[masterIndex].categoryName, controllerId: mySiteList[siteIndex].master[masterIndex].controllerId, userId: widget.userId,);
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

  Widget buildLoadingIndicator(bool isVisible, double width)
  {
    return Visibility(
      visible: isVisible,
      child: Center(
        child: Container(
          color: Colors.white,
          width: double.maxFinite,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: width / 2 - 25),
          child: const LoadingIndicator(
            indicatorType: Indicator.ballPulse,
          ),
        ),
      ),
    );
  }

  void _showPasswordDialog(BuildContext context) {
    final TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Password'),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String _correctPassword = 'Oro@321';
                final enteredPassword = _passwordController.text;

                if (enteredPassword == _correctPassword) {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  ResetVerssion(userId: widget.customerId, controllerId: mySiteList[siteIndex].master[masterIndex].controllerId,deviceID: mySiteList[siteIndex].master[masterIndex].deviceId),
                    ),
                  );
                } else {
                  Navigator.of(context).pop(); // Close the dialog
                  _showErrorDialog(context);
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Incorrect password. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void indicatorViewShow() {
    setState((){
      visibleLoading = true;
    });
  }

  void indicatorViewHide() {
    if(mounted){
      setState(() {
        visibleLoading = false;
      });
    }
  }

  void sentToServer(String msg, String payLoad) async
  {
    Map<String, Object> body = {"userId": widget.customerId, "controllerId": mySiteList[siteIndex].master[masterIndex].controllerId, "messageStatus": msg, "hardware": jsonDecode(payLoad), "createUser": widget.userId};
    final response = await HttpService().postRequest("createUserSentAndReceivedMessageManually", body);
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class AlarmButton extends StatelessWidget {
  const AlarmButton({Key? key, required this.payload, required this.deviceID, required this.customerId, required this.controllerId}) : super(key: key);
  final MqttPayloadProvider payload;
  final String deviceID;
  final int customerId, controllerId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: BadgeButton(
        onPressed: (){
          showPopover(
            context: context,
            bodyBuilder: (context) => AlarmListItems(payload:payload, deviceID:deviceID, customerId: customerId, controllerId: controllerId,),
            onPop: () => print('Popover was popped!'),
            direction: PopoverDirection.left,
            width: payload.alarmList.isNotEmpty?600:250,
            height: payload.alarmList.isNotEmpty?(payload.alarmList.length*45)+20:50,
            arrowHeight: 15,
            arrowWidth: 30,
          );
        },
        icon: Icons.alarm,
        badgeNumber: payload.alarmList.length,
      ),
    );
  }
}

class BadgeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final int badgeNumber;

  const BadgeButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.badgeNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          tooltip: 'Alarm',
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white,),
          hoverColor: Colors.cyan,
        ),
        if (badgeNumber > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                badgeNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class AlarmListItems extends StatelessWidget {
  const AlarmListItems({Key? key, required this.payload, required this.deviceID, required this.customerId, required this.controllerId}) : super(key: key);
  final MqttPayloadProvider payload;
  final String deviceID;
  final int customerId, controllerId;

  @override
  Widget build(BuildContext context) {
    return payload.alarmList.isNotEmpty? DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 600,
      dataRowHeight: 45.0,
      headingRowHeight: 35.0,
      headingRowColor: WidgetStateProperty.all<Color>(primaryColorDark.withOpacity(0.1)),
      columns: const [
        DataColumn2(
          label: Text('', style: TextStyle(fontSize: 13)),
          fixedWidth: 40,
        ),
        DataColumn2(
            label: Text('Message', style: TextStyle(fontSize: 13),),
            size: ColumnSize.L
        ),
        DataColumn2(
            label: Text('Location', style: TextStyle(fontSize: 13),),
            size: ColumnSize.M
        ),
        DataColumn2(
            label: Text('Date-time', style: TextStyle(fontSize: 13),),
            size: ColumnSize.L
        ),
        DataColumn2(
          label: Center(child: Text('', style: TextStyle(fontSize: 13),)),
          fixedWidth: 80,
        ),
      ],
      rows: List<DataRow>.generate(payload.alarmList.length, (index) => DataRow(cells: [
        DataCell(Icon(Icons.warning_amber, color: payload.alarmList[index].status==1 ? Colors.orangeAccent : Colors.redAccent,)),
        DataCell(Text(getAlarmMessage(payload.alarmList[index].alarmType))),
        DataCell(Text(payload.alarmList[index].location)),
        DataCell(Text('${payload.alarmList[index].date} - ${payload.alarmList[index].time}')),
        DataCell(Center(child: MaterialButton(
          color: Colors.redAccent,
          textColor: Colors.white,
          onPressed: getPermissionStatusBySNo(context, 6) ?(){
            String finalPayload =  '${payload.alarmList[index].sNo}';
            String payLoadFinal = jsonEncode({
              "4100": [{"4101": finalPayload}]
            });
            MQTTManager().publish(payLoadFinal, 'AppToFirmware/$deviceID');
            sentToServer('Rested the ${getAlarmMessage(payload.alarmList[index].alarmType)} alarm', payLoadFinal);
          }:
          null,
          child: const Text('Reset'),
        ))),
      ])),
    ):
    const Center(child: Text('Alarm not found'),);
  }

  void sentToServer(String msg, String payLoad) async
  {
    Map<String, Object> body = {"userId": customerId, "controllerId": controllerId, "messageStatus": msg, "data": payLoad, "hardware": jsonDecode(payLoad), "createUser": customerId};
    final response = await HttpService().postRequest("createUserSentAndReceivedMessageManually", body);
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class SideSheetClass extends StatefulWidget {
  const SideSheetClass({Key? key, required this.customerId, required this.nodeList, required this.deviceId, required this.lastSyncDate, required this.deviceName, required this.controllerId, required this.userId}) : super(key: key);
  final int userId, controllerId, customerId;
  final String deviceId, deviceName, lastSyncDate;
  final List<NodeData> nodeList;


  @override
  State<SideSheetClass> createState() => _SideSheetClassState();
}

class _SideSheetClassState extends State<SideSheetClass> {

  String lastSyncData = '';

  Future<void> showEditProductDialog(BuildContext context, String nodeName, int nodeId, int index) async {
    final TextEditingController nodeNameController = TextEditingController(text: nodeName);
    final formKey = GlobalKey<FormState>();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Node Name'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nodeNameController,
              maxLength: 15,
              decoration: const InputDecoration(hintText: "Enter node name"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Node name cannot be empty';
                }
                return null;
              },
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
              child: const Text('Save'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Map<String, Object> body = {"userId": widget.customerId, "controllerId": widget.controllerId, "nodeControllerId": nodeId, "deviceName": nodeNameController.text, "createUser": widget.userId};
                  final response = await HttpService().putRequest("updateUserNodeDetails", body);
                  if (response.statusCode == 200) {
                    setState(() {
                      widget.nodeList[index].deviceName = nodeNameController.text;
                    });
                    GlobalSnackBar.show(context, 'Node name updated successfully', 200);
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                    throw Exception('Failed to load data');
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final nodeList = Provider.of<MqttPayloadProvider>(context).nodeList;
    try{
      for (var item in nodeList) {
        if (item is Map<String, dynamic>) {
          try {
            int position = getNodeListPosition(item['SNo']);
            if (position != -1) {
              widget.nodeList[position].status = item['Status'];
              widget.nodeList[position].batVolt = item['BatVolt'];
              widget.nodeList[position].sVolt = item['SVolt'];
              widget.nodeList[position].lastFeedbackReceivedTime = item['LastFeedbackReceivedTime'];

              widget.nodeList[position].rlyStatus = [];

              List<dynamic> dynamicList = item['RlyStatus'];

              if (dynamicList is List<Map<String, dynamic>>) {
                //List<RelayStatus> rlyList = dynamicList.map((item) => RelayStatus.fromJson(item)).toList();
                // widget.nodeList[position].rlyStatus = rlyList;
              } else {
                List<RelayStatus> rlyList = dynamicList.map((item) => RelayStatus.fromJson(item)).toList();
                widget.nodeList[position].rlyStatus = rlyList;
              }

              // widget.nodeList[position].rlyStatus = rlyList;

              /*List<dynamic> snrList = item['Sensor'];
              List<SensorStatus> snrStatusList = snrList.isNotEmpty? snrList.map((rl) => SensorStatus.fromJson(rl)).toList() : [];
              widget.nodeList[position].sensor = snrStatusList;*/

            }else {
              if(item['SNo']!=0){
                Provider.of<MqttPayloadProvider>(context).nodeConnection(false);
              }
            }
          } catch (e) {
            print('Error updating node properties: $e');
          }
        }
      }
      setState(() {
        widget.nodeList;
      });
    }
    catch(e){
      print(e);
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return screenWidth>600? Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.zero,
      ),
      height: screenHeight,
      width: 400,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Close',
                icon: const Icon(Icons.close, color: Colors.redAccent),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Expanded(child: Text('NODE STATUS', style: TextStyle(color: Colors.black, fontSize: 15))),
                IconButton(tooltip:'Hourly Power Logs for the Node',onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => NodeHrsLog(userId: widget.customerId, controllerId: widget.controllerId,),
                    ),
                  );
                }, icon: const Icon(Icons.power_outlined, color: primaryColorDark,)),
                IconButton(tooltip:'Hourly Sensor Logs',onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => SensorHourlyLogs(userId: widget.customerId, controllerId: widget.controllerId,),
                    ),
                  );
                }, icon: const Icon(Icons.settings_input_antenna, color: primaryColorDark,)),
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 5),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 5),
                            CircleAvatar(radius: 5, backgroundColor: Colors.green,),
                            SizedBox(width: 5),
                            Text('Connected', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.black))
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 5),
                            CircleAvatar(radius: 5, backgroundColor: Colors.grey),
                            SizedBox(width: 5),
                            Text('No Communication', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.black))
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 10),
                            CircleAvatar(radius: 5, backgroundColor: Colors.redAccent,),
                            SizedBox(width: 5),
                            Text('Set Serial Error', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.black))
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(width: 10),
                            CircleAvatar(radius: 5, backgroundColor: Colors.yellow),
                            SizedBox(width: 5),
                            Text('Low Battery', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.black))
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        tooltip: 'Set serial for all Nodes',
                        icon: Icon(Icons.format_list_numbered, color: getPermissionStatusBySNo(context, 7)? primaryColorDark:Colors.black26),
                        onPressed: getPermissionStatusBySNo(context, 7)?() async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirmation'),
                                content: const Text('Are you sure! you want to proceed to reset all node ids?'),
                                actions: <Widget>[
                                  MaterialButton(
                                    color: Colors.redAccent,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  MaterialButton(
                                    color: myTheme.primaryColor,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      String payLoadFinal = jsonEncode({
                                        "2300": [
                                          {"2301": ""},
                                        ]
                                      });
                                      MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.deviceId}');
                                      sentToServer('Set serial for all nodes comment sent successfully', payLoadFinal);
                                      GlobalSnackBar.show(context, 'Sent your comment successfully', 200);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              );
                            },
                          );
                        }:null,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        tooltip: 'Test Communication',
                        icon: Icon(Icons.network_check, color: getPermissionStatusBySNo(context, 8)? primaryColorDark:Colors.black26),
                        onPressed: getPermissionStatusBySNo(context, 8)? () async {
                          String payLoadFinal = jsonEncode({
                            "4500": [{"4501": ""},]
                          });
                          MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.deviceId}');
                          sentToServer('Test Communication comment sent successfully', payLoadFinal);
                          GlobalSnackBar.show(context, 'Sent your comment successfully', 200);
                          //Navigator.of(context).pop();
                        }:null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 400,
            height: screenHeight-170,
            child: Column(
              children: [
                SizedBox(
                  width:400,
                  height: 35,
                  child: DataTable2(
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: 400,
                    headingRowHeight: 35.0,
                    headingRowColor: WidgetStateProperty.all<Color>(myTheme.primaryColorDark.withOpacity(0.3)),
                    columns: const [
                      DataColumn2(
                          label: Center(child: Text('S.No', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.black),)),
                          fixedWidth: 35
                      ),
                      DataColumn2(
                        label: Center(child: Text('Status', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.black),)),
                        fixedWidth: 55,
                      ),
                      DataColumn2(
                        label: Center(child: Text('Rf.No', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.black),)),
                        fixedWidth: 45,
                      ),
                      DataColumn2(
                        label: Text('Category', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.black),),
                        size: ColumnSize.M,
                        numeric: true,
                      ),
                      DataColumn2(
                        label: Text('Info', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.black),),
                        fixedWidth: 100,
                      ),
                    ],
                    rows: List<DataRow>.generate(0,(index) => const DataRow(cells: [],),
                    ),
                  ),
                ),
                Expanded(
                  flex:1,
                  child: ListView.builder(
                    itemCount: widget.nodeList.length,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                        //initiallyExpanded: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            widget.nodeList[index].rlyStatus.any((rly) => rly.Status == 2 || rly.Status == 3)? const Icon(Icons.warning, color: Colors.orangeAccent):
                            const Icon(Icons.info_outline,),
                            IconButton(
                              onPressed: () {
                                showEditProductDialog(context, widget.nodeList[index].deviceName, widget.nodeList[index].controllerId, index);
                              },
                              icon: const Icon(Icons.edit_outlined, color: primaryColorDark,),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.teal.shade50,
                        title: Row(
                          children: [
                            SizedBox(width: 30, child: Text('${widget.nodeList[index].serialNumber}', style: const TextStyle(fontSize: 13),)),
                            SizedBox(
                              width:50,
                              child: Center(child: CircleAvatar(radius: 7, backgroundColor:
                              widget.nodeList[index].status == 1? Colors.green.shade400:
                              widget.nodeList[index].status == 2? Colors.grey:
                              widget.nodeList[index].status == 3? Colors.redAccent:
                              widget.nodeList[index].status == 4? Colors.yellow:
                              Colors.grey,
                              )),
                            ),
                            SizedBox(width: 40, child: Center(child: Text('${widget.nodeList[index].referenceNumber}', style: const TextStyle(fontSize: 13),))),
                            SizedBox(
                              width: 142,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(widget.nodeList[index].deviceName, style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 13)),
                                  Text(widget.nodeList[index].deviceId, style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 11, color: Colors.black)),
                                  Text(widget.nodeList[index].categoryName, style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 11, color: Colors.black)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: calculateDynamicHeight(widget.nodeList[index]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                  tileColor: myTheme.primaryColor,
                                  textColor: Colors.black,
                                  title: const Text('Last feedback', style: TextStyle(fontSize: 10)),
                                  subtitle: Text(
                                    formatDateTime(widget.nodeList[index].lastFeedbackReceivedTime),
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.solar_power),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${widget.nodeList[index].sVolt} - V',
                                        style: const TextStyle(fontWeight: FontWeight.normal),
                                      ),
                                      const SizedBox(width: 5),
                                      const Icon(Icons.battery_3_bar_rounded),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${widget.nodeList[index].batVolt} - V',
                                        style: const TextStyle(fontWeight: FontWeight.normal),
                                      ),
                                      const SizedBox(width: 5),
                                      IconButton(
                                        tooltip: 'Serial set',
                                        onPressed: getPermissionStatusBySNo(context, 7) ? () {
                                          String payLoadFinal = jsonEncode({
                                            "2300": [
                                              {"2301": "${widget.nodeList[index].serialNumber}"},
                                            ]
                                          });
                                          MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.deviceId}');
                                          sentToServer('Serial set for the ${widget.nodeList[index].deviceName} all Relay', payLoadFinal);
                                          GlobalSnackBar.show(context, 'Your comment sent successfully', 200);
                                        }:null,
                                        icon: Icon(Icons.fact_check_outlined, color: getPermissionStatusBySNo(context, 7) ? primaryColorDark:Colors.black26),
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    if (widget.nodeList[index].rlyStatus.isNotEmpty ||
                                        widget.nodeList[index].sensor.isNotEmpty)
                                      const SizedBox(
                                        width: double.infinity,
                                        height: 20,
                                        child: Row(
                                          children: [
                                            SizedBox(width: 10),
                                            CircleAvatar(
                                              radius: 5,
                                              backgroundColor: Colors.green,
                                            ),
                                            SizedBox(width: 5),
                                            Text('ON', style: TextStyle(fontSize: 12)),
                                            SizedBox(width: 20),
                                            CircleAvatar(
                                              radius: 5,
                                              backgroundColor: Colors.black45,
                                            ),
                                            SizedBox(width: 5),
                                            Text('OFF', style: TextStyle(fontSize: 12)),
                                            SizedBox(width: 20),
                                            CircleAvatar(
                                              radius: 5,
                                              backgroundColor: Colors.orange,
                                            ),
                                            SizedBox(width: 5),
                                            Text('ON in OFF', style: TextStyle(fontSize: 12)),
                                            SizedBox(width: 20),
                                            CircleAvatar(
                                              radius: 5,
                                              backgroundColor: Colors.redAccent,
                                            ),
                                            SizedBox(width: 5),
                                            Text('OFF in ON', style: TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: double.infinity,
                                      height: calculateGridHeight(widget.nodeList[index].rlyStatus.length),
                                      child: GridView.builder(
                                        itemCount: widget.nodeList[index].rlyStatus.length, // Number of items in the grid
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 5,
                                          crossAxisSpacing: 5.0,
                                          mainAxisSpacing: 5.0,
                                          childAspectRatio: 1.45,
                                        ),
                                        itemBuilder: (BuildContext context, int indexGv) {
                                          return Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 13,
                                                backgroundColor: widget.nodeList[index].rlyStatus[indexGv]
                                                    .Status ==
                                                    0
                                                    ? Colors.grey
                                                    : widget.nodeList[index].rlyStatus[indexGv].Status ==
                                                    1
                                                    ? Colors.green
                                                    : widget.nodeList[index].rlyStatus[indexGv]
                                                    .Status ==
                                                    2
                                                    ? Colors.orange
                                                    : widget.nodeList[index].rlyStatus[indexGv]
                                                    .Status ==
                                                    3
                                                    ? Colors.redAccent
                                                    : Colors.black12, // Avatar background color
                                                child: Text(
                                                  (widget.nodeList[index].rlyStatus[indexGv].rlyNo)
                                                      .toString(),
                                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                                ),
                                              ),
                                              Text(
                                                (widget.nodeList[index].rlyStatus[indexGv].swName!.isNotEmpty
                                                    ? widget.nodeList[index].rlyStatus[indexGv].swName
                                                    : widget.nodeList[index].rlyStatus[indexGv].name)
                                                    .toString(),
                                                style:
                                                const TextStyle(color: Colors.black, fontSize: 9),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    widget.nodeList[index].sensor.isNotEmpty? const Padding(
                                      padding: EdgeInsets.only(left: 8, right: 8),
                                      child: Divider(
                                        thickness: 0.5,
                                      ),
                                    ):
                                    const SizedBox(),
                                    widget.nodeList[index].sensor.isNotEmpty? SizedBox(
                                      width: double.infinity,
                                      height: calculateGridHeight(widget.nodeList[index].sensor.length),
                                      child: GridView.builder(
                                        itemCount: widget.nodeList[index].sensor.length, // Number of items in the grid
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 5,
                                          crossAxisSpacing: 5.0,
                                          mainAxisSpacing: 5.0,
                                          childAspectRatio: 1.45,
                                        ),
                                        itemBuilder: (BuildContext context, int indexSnr) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 13,
                                                backgroundColor: Colors.black38,
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  (widget.nodeList[index].sensor[indexSnr].angIpNo !=
                                                      null
                                                      ? 'A-${widget.nodeList[index].sensor[indexSnr].angIpNo}'
                                                      : 'P-${widget.nodeList[index].sensor[indexSnr].pulseIpNo}')
                                                      .toString(),
                                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                                ),
                                              ),
                                              Text(
                                                (widget.nodeList[index].sensor[indexSnr].swName!.isNotEmpty
                                                    ? widget.nodeList[index].sensor[indexSnr].swName
                                                    : widget.nodeList[index].sensor[indexSnr].name)
                                                    .toString(),
                                                style: const TextStyle(color: Colors.black, fontSize: 8),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ):
                                    const SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ):
    Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.zero,
      ),
      height: screenHeight,
      width: 400,
      child: SingleChildScrollView(
        child:Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'Close',
                  icon: const Icon(Icons.close, color: Colors.redAccent),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text('NODE STATUS', style: TextStyle(color: Colors.black, fontSize: 15))),
                SizedBox(
                  width: 40,
                  child: IconButton(
                    tooltip: 'Set serial for all Nodes',
                    icon: Icon(Icons.format_list_numbered, color: myTheme.primaryColorDark),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmation'),
                            content: const Text('Are you sure! you want to proceed to reset all node ids?'),
                            actions: <Widget>[
                              MaterialButton(
                                color: Colors.redAccent,
                                textColor: Colors.white,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              MaterialButton(
                                color: myTheme.primaryColor,
                                textColor: Colors.white,
                                onPressed: () {
                                  String payLoadFinal = jsonEncode({
                                    "2300": [
                                      {"2301": ""},
                                    ]
                                  });
                                  MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.deviceId}');
                                  sentToServer('Set serial for all nodes comment sent successfully', payLoadFinal);
                                  GlobalSnackBar.show(context, 'Your comment sent successfully', 200);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: IconButton(
                    tooltip: 'Test Communication',
                    icon: Icon(Icons.network_check, color: myTheme.primaryColorDark),
                    onPressed: () async {
                      String payLoadFinal = jsonEncode({
                        "4500": [{"4501": ""},]
                      });
                      MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.deviceId}');
                      sentToServer('Test Communication comment sent successfully', payLoadFinal);
                      GlobalSnackBar.show(context, 'Sent your comment successfully', 200);
                      //Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 50,
              child: Row(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 5),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 5),
                              CircleAvatar(radius: 5, backgroundColor: Colors.green,),
                              SizedBox(width: 5),
                              Text('Connected', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.black))
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(width: 5),
                              CircleAvatar(radius: 5, backgroundColor: Colors.grey),
                              SizedBox(width: 5),
                              Text('No Communication', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.black))
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: 05),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 10),
                              CircleAvatar(radius: 5, backgroundColor: Colors.redAccent,),
                              SizedBox(width: 5),
                              Text('Set Serial Error', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.black))
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              CircleAvatar(radius: 5, backgroundColor: Colors.yellow),
                              SizedBox(width: 5),
                              Text('Low Battery', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.black))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 400,
              height: MediaQuery.sizeOf(context).height-150,
              child: DataTable2(
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 325,
                dataRowHeight: 40.0,
                headingRowHeight: 35.0,
                headingRowColor: WidgetStateProperty.all<Color>(myTheme.primaryColorDark.withOpacity(0.2)),
                columns: const [
                  DataColumn2(
                      label: Center(child: Text('S.No', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.black),)),
                      fixedWidth: 35
                  ),
                  DataColumn2(
                    label: Center(child: Text('Status', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.black),)),
                    fixedWidth: 55,
                  ),
                  DataColumn2(
                    label: Center(child: Text('Rf.No', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.black),)),
                    fixedWidth: 45,
                  ),
                  DataColumn2(
                    label: Text('Category', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.black),),
                    size: ColumnSize.M,
                    numeric: true,
                  ),
                  DataColumn2(
                    label: Text('Info', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: Colors.black),),
                    fixedWidth: 40,
                  ),
                ],
                rows: List<DataRow>.generate(widget.nodeList.length, (index) => DataRow(cells: [
                  DataCell(Center(child: Text('${widget.nodeList[index].serialNumber}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black),))),
                  DataCell(Center(child: CircleAvatar(radius: 7, backgroundColor:
                  widget.nodeList[index].status == 1? Colors.green.shade400:
                  widget.nodeList[index].status == 2? Colors.grey:
                  widget.nodeList[index].status == 3? Colors.redAccent:
                  widget.nodeList[index].status == 4? Colors.yellow:
                  Colors.grey,
                  ))),
                  DataCell(Center(child: Text('${widget.nodeList[index].referenceNumber}', style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black)))),
                  DataCell(Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.nodeList[index].categoryName, style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black)),
                      Text(widget.nodeList[index].deviceId, style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 11, color: Colors.black)),
                    ],
                  )),
                  DataCell(Center(child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(tooltip: 'View Relay status',
                        icon: widget.nodeList[index].rlyStatus.any((rly) => rly.Status == 2 || rly.Status == 3)? const Icon(Icons.warning, color: Colors.orangeAccent):
                        Icon(Icons.info_outline, color: myTheme.primaryColorDark), // Icon to display
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                width: double.infinity,
                                height: 270,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    ListTile(
                                      tileColor: myTheme.primaryColor,
                                      textColor: Colors.white,
                                      leading: const Icon(Icons.developer_board_rounded, color: Colors.white),
                                      title: Text('${widget.nodeList[index].categoryName} - ${widget.nodeList[index].deviceId}'),
                                      subtitle: Text(formatDateTime(widget.nodeList[index].lastFeedbackReceivedTime)),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.solar_power_outlined, color: Colors.white),
                                          const SizedBox(width: 5,),
                                          Text('${widget.nodeList[index].sVolt} Volt', style: const TextStyle(fontWeight: FontWeight.normal),),
                                          const SizedBox(width: 5,),
                                          const Icon(Icons.battery_3_bar_rounded, color: Colors.white),
                                          const SizedBox(width: 5,),
                                          Text('${widget.nodeList[index].batVolt} Volt', style: const TextStyle(fontWeight: FontWeight.normal),),
                                          const SizedBox(width: 5,),
                                          IconButton(tooltip : 'Serial set', onPressed: (){
                                            String payLoadFinal = jsonEncode({
                                              "2300": [
                                                {"2301": "${widget.nodeList[index].serialNumber}"},
                                              ]
                                            });
                                            MQTTManager().publish(payLoadFinal, 'AppToFirmware/${widget.deviceId}');
                                            sentToServer('Serial set for ${widget.nodeList[index].categoryName} comment sent successfully', payLoadFinal);
                                          }, icon: const Icon(Icons.fact_check_outlined, color: primaryColorDark))
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        const SizedBox(
                                          width: double.infinity,
                                          height : 40,
                                          child: Row(
                                            children: [
                                              SizedBox(width: 10),
                                              CircleAvatar(radius: 5,backgroundColor: Colors.green,),
                                              SizedBox(width: 5),
                                              Text('ON'),
                                              SizedBox(width: 20),
                                              CircleAvatar(radius: 5,backgroundColor: Colors.black45),
                                              SizedBox(width: 5),
                                              Text('OFF'),
                                              SizedBox(width: 20),
                                              CircleAvatar(radius: 5,backgroundColor: Colors.orange),
                                              SizedBox(width: 5),
                                              Text('ON IN OFF'),
                                              SizedBox(width: 20),
                                              CircleAvatar(radius: 5,backgroundColor: Colors.redAccent),
                                              SizedBox(width: 5),
                                              Text('OFF IN ON'),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        SizedBox(
                                          width: double.infinity,
                                          height : widget.nodeList[index].rlyStatus.length > 8? 160 : 80,
                                          child: GridView.builder(
                                            itemCount: widget.nodeList[index].rlyStatus.length, // Number of items in the grid
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 8,
                                              crossAxisSpacing: 05.0,
                                              mainAxisSpacing: 05.0,
                                            ),
                                            itemBuilder: (BuildContext context, int indexGv) {
                                              return Column(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor: widget.nodeList[index].rlyStatus[indexGv].Status==0 ? Colors.grey :
                                                    widget.nodeList[index].rlyStatus[indexGv].Status==1 ? Colors.green :
                                                    widget.nodeList[index].rlyStatus[indexGv].Status==2 ? Colors.orange :
                                                    widget.nodeList[index].rlyStatus[indexGv].Status==3 ? Colors.redAccent : Colors.black12, // Avatar background color
                                                    child: Text((widget.nodeList[index].rlyStatus[indexGv].rlyNo).toString(), style: const TextStyle(color: Colors.white)),
                                                  ),
                                                  Text((widget.nodeList[index].rlyStatus[indexGv].name).toString(), style: const TextStyle(color: Colors.black, fontSize: 10)),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      IconButton(tooltip:'Change node name', onPressed: (){}, icon: const Icon(Icons.edit, color: primaryColorDark,)),
                    ],
                  ))),
                ])),
              ),
            )
          ],
        ),
      ),
    );
  }

  void sentToServer(String msg, String payLoad) async
  {
    Map<String, Object> body = {"userId": widget.customerId, "controllerId": widget.controllerId, "messageStatus": msg, "hardware": jsonDecode(payLoad), "createUser": widget.userId};
    final response = await HttpService().postRequest("createUserSentAndReceivedMessageManually", body);
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load data');
    }
  }

  int getNodeListPosition(int srlNo){
    List<NodeData> nodeList = widget.nodeList;
    for (int i = 0; i < nodeList.length; i++) {
      if (nodeList[i].serialNumber == srlNo) {
        return i;
      }
    }
    return -1;
  }

  String formatDateTime(String? dateTimeString) {
    if (dateTimeString == null) {
      return "No feedback received";
    }
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
      return formatter.format(dateTime);
    } catch (e) {
      return "Invalid date format";
    }
  }

  double calculateDynamicHeight(NodeData node) {
    double baseHeight = 110;
    double additionalHeight = 0;

    if (node.rlyStatus.isNotEmpty) {
      additionalHeight += calculateGridHeight(node.rlyStatus.length);
    }
    if (node.sensor.isNotEmpty) {
      additionalHeight += calculateGridHeight(node.sensor.length);
    }
    return baseHeight + additionalHeight;
  }

  double calculateGridHeight(int itemCount) {
    int rows = (itemCount / 5).ceil();
    return rows * 53;
  }

}
