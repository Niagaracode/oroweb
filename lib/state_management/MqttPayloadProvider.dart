import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:oro_irrigation_new/state_management/schedule_view_provider.dart';

import '../Models/Customer/Dashboard/DashboardNode.dart';
import '../Models/PumpControllerModel/pump_controller_data_model.dart';
import '../Models/weather_model.dart';


enum MQTTConnectionState { connected, disconnected, connecting }

class MqttPayloadProvider with ChangeNotifier {
  MQTTConnectionState _appConnectionState = MQTTConnectionState.disconnected;
  String dashBoardPayload = '', schedulePayload = '';
  late ScheduleViewProvider mySchedule;
  Map<String, dynamic> preferencePayload = {};
  WeatherModel weatherModelinstance = WeatherModel();
  dynamic messageFromHw;
  dynamic spa = '';
  int wifiStrength = 0;
  int powerSupply = 0;

  PumpControllerData? pumpControllerData;
  PumpControllerData? get dataModel => pumpControllerData;
  Map<String, dynamic> pumpControllerPayload = {};

  List viewSettingsList = [];
  bool isCommunicatable = false;
  List<dynamic> PrsIn = [];
  List<dynamic> PrsOut = [];
  List<dynamic> nextSchedule = [];
  List<dynamic> upcomingProgram = [];
  List<dynamic> centralFilter = [];
  List<dynamic> localFilter = [];
  List<PumpData> sourcePump = [];
  List<PumpData> irrigationPump = [];
  List<dynamic> centralFertilizer = [];
  List<dynamic> localFertilizer = [];
  List<dynamic> waterMeter = [];
  List<AlarmData> alarmList = [];
  List<IrrigationLinePLD> payloadIrrLine = [];

  List<dynamic> _nodeList = [];
  List<dynamic> get nodeList => _nodeList;

  List<ScheduledProgram> _scheduledProgram = [];
  List<ScheduledProgram> get scheduledProgram => _scheduledProgram;

  List<ProgramQueue> _programQueue = [];
  List<ProgramQueue> get programQueue => _programQueue;

  List<CurrentScheduleModel> _currentSchedule = [];
  List<CurrentScheduleModel> get currentSchedule => _currentSchedule;

  String _syncDateTime = '';
  String get syncDateTime => _syncDateTime;

  bool liveSync = false;
  Duration lastCommunication = Duration.zero;
  bool nodeAndControllerConnection = true;

  List<dynamic> unitList = [];
  List<dynamic> userPermission = [];

  //pump controller payload
  List<CM> _pumpLiveList = [];
  List<CM> get pumpLiveList => _pumpLiveList;
  String sheduleLog = '';
  String uardLog = '';
  String uard0Log = '';
  String uard4Log = '';

  void editMySchedule(ScheduleViewProvider instance){
    mySchedule = instance;
    notifyListeners();
  }

  void updateReceivedPayload(String payload) {
    print("payload in provider ==> $payload");
    try {

      Map<String, dynamic> data = jsonDecode(payload);
      if(data.containsKey('4200')){
        messageFromHw = data['4200'][0]['4201'];
        if(data['4200'][0]['4201']['PayloadCode']=='2900'){
          spa = data['4200'][0]['4201'];
          notifyListeners();
        }
      }
      if(data.containsKey('cM')){
        messageFromHw = data;
      }
      //Controller Log

      if(data.containsKey('6600')){
        if(data['6600'].containsKey('6601')){
          if(!sheduleLog.contains(data['6600']['6601'])) {
            sheduleLog += "\n";
            sheduleLog += data['6600']['6601'];
          }
        }
        if(data['6600'].containsKey('6602')){
          if(!uardLog.contains(data['6600']['6602'])){
            uardLog += "\n";
            uardLog += data['6600']['6602'];
          }
        }
        if(data['6600'].containsKey('6603')){
          if(!uard0Log.contains(data['6600']['6603'])){
            uard0Log += "\n";
            uard0Log += data['6600']['6603'];
          }
        }
        if(data['6600'].containsKey('6604')){
          if(!uard4Log.contains(data['6600']['6604'])){
            uard4Log += "\n";
            uard4Log += data['6600']['6604'];
          }
        }
      }


      if(data.containsKey('2400')){
        // live message of gem or gem+
        if (data.containsKey('2400') && data['2400'] != null && data['2400'].isNotEmpty) {
          dashBoardPayload = payload;
          liveSyncCall(false);

          if(data['2400'][0].containsKey('SentTime')) {
            updateLastSync(data['2400'][0]['SentTime']);
          }

          if(data['2400'][0].containsKey('PowerSupply')) {
            updatePowerSupply(data['2400'][0]['PowerSupply']);
          }

          if(data['2400'][0].containsKey('WifiStrength')) {
            updateWifiStrength(data['2400'][0]['WifiStrength']);
          }

          if(data['2400'][0].containsKey('2401')) {
            List<dynamic> nodes = data['2400'][0]['2401'];
            updateNodeList(nodes);
          }

          if(data['2400'][0].containsKey('2402')) {
            List<dynamic> csItems = data['2400'][0]['2402'];
            List<CurrentScheduleModel> cs = csItems.map((cs) => CurrentScheduleModel.fromJson(cs)).toList();
            updateCurrentScheduled(cs);

            if(csItems.isNotEmpty && csItems[0].containsKey('PrsIn')){
              PrsIn = csItems[0]['PrsIn'];
              PrsOut = csItems[0]['PrsOut'];
            }
          }
          if (data['2400'][0].containsKey('2403')) {
            List<dynamic> programList = data['2400'][0]['2403'];
            List<ProgramQueue> pq = programList.map((pq) => ProgramQueue.fromJson(pq)).toList();
            updateProgramQueue(pq);
          }
          if (data['2400'][0].containsKey('2404')) {
            List<dynamic> programList = data['2400'][0]['2404'];
            List<ScheduledProgram> scp = programList.map((sp) => ScheduledProgram.fromJson(sp)).toList();
            updateScheduledProgram(scp);
          }
          if (data['2400'][0].containsKey('2405')) {
            List<dynamic> filtersJson = data['2400'][0]['2405'];
            centralFilter = [];
            localFilter = [];

            for (var filter in filtersJson) {
              if (filter['Type'] == 1) {
                centralFilter.add(filter);
              } else if (filter['Type'] == 2) {
                localFilter.add(filter);
              }
            }
          }

          if (data['2400'][0].containsKey('2406')) {
            List<dynamic> fertilizer = data['2400'][0]['2406'];
            centralFertilizer = fertilizer.where((item) => item['Type'] == 1).toList();
            localFertilizer = fertilizer.where((item) => item['Type'] == 2).toList();
          }

          if (data['2400'][0].containsKey('2407')) {
            List<dynamic> pumps = data['2400'][0]['2407'];
            List<PumpData> pumpList = pumps.map((pl) => PumpData.fromJson(pl)).toList();
            updatePumpPayload(pumpList);
          }

          if (data['2400'][0].containsKey('2408')) {
            List<dynamic> irrLine = data['2400'][0]['2408'];
            List<IrrigationLinePLD> lineList = irrLine.map((il) => IrrigationLinePLD.fromJson(il)).toList();
            updatePayload2408(lineList);
          }

          if (data['2400'][0].containsKey('2409')) {
            List<dynamic> almList = data['2400'][0]['2409'];
            List<AlarmData> alm = almList.map((alm) => AlarmData.fromJson(alm)).toList();
            updateAlarmPayload(alm);
          }

          if (data['2400'][0].containsKey('2410')) {
            waterMeter = data['2400'][0]['2410'];
          }
        }
      }
      else if(data.containsKey('3600') && data['3600'] != null && data['3600'].isNotEmpty){
        mySchedule.dataFromMqttConversion(payload);
        schedulePayload = payload;
      }
      else if(data['mC'] != null && data['mC'].contains("SMS")) {
        preferencePayload = data;
      }
      else if(data['mC'] != null && data["mC"].contains("VIEW")) {
        if (!viewSettingsList.contains(jsonEncode(data['cM']))) {
          viewSettingsList.add(jsonEncode(data["cM"]));
        }
      }
      else if(data.containsKey('5100') && data['5100'] != null && data['5100'].isNotEmpty){
        weatherModelinstance = WeatherModel.fromJson(data);
      }
      else if(data['mC'] != null && data['mC'].contains("LD01")) {
        pumpControllerData = PumpControllerData.fromJson(data, "cM");
        pumpControllerPayload = data;
        // print("pumpControllerData data from provider ==> ${pumpControllerData}");
      }
      else {
        //updateLastSync('0000:00:00 00:00');
        Map<String, dynamic> json = jsonDecode(payload);
        if(json['mC']=='LD01'){

          var liveMessage = json['cM'] != null ? json['cM'] as List : [];
          List<CM> pumpLiveList = liveMessage.isNotEmpty? liveMessage.map((live) => CM.fromJson(live)).toList(): [];
          updatePumpControllerLive(pumpLiveList);
        }
      }

    } catch (e) {
      print('Error parsing JSON: $e');
    }
    notifyListeners();
  }

  void liveSyncCall(ls){
    liveSync= ls;
    notifyListeners();
  }

  void updatePowerSupply(int val) {
    powerSupply = val;
    notifyListeners();
  }

  void updateWifiStrength(int nds) {
    wifiStrength = nds;
    if (wifiStrength < 0) {
      wifiStrength = 0;
    }
    notifyListeners();
  }

  void updateLastSync(dt){
    _syncDateTime = dt;
    notifyListeners();
    updateLastCommunication(dt);
  }

  void updateLastCommunication(dt) {
    final String lastSyncString = dt;
    DateTime lastSyncDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(lastSyncString);
    DateTime currentDateTime = DateTime.now();
    lastCommunication = currentDateTime.difference(lastSyncDateTime);
    notifyListeners();
  }


  void updateNodeList(List<dynamic> nds) {
    _nodeList = nds;
    notifyListeners();
  }

  void updateCurrentScheduled(List<CurrentScheduleModel> cs) {
    _currentSchedule = cs;
    notifyListeners();
  }

  void updateScheduledProgram(List<ScheduledProgram> schPrograms) {
    _scheduledProgram = schPrograms;
    notifyListeners();
  }

  void updateProgramQueue(List<ProgramQueue> programsQue) {
    _programQueue = programsQue;
    notifyListeners();
  }

  void updatePumpPayload(List<PumpData> pumps) {
    try {
      sourcePump = pumps.where((item) => item.type == 1).toList();
      irrigationPump = pumps.where((item) => item.type == 2).toList();

      sourcePump.sort((a, b) => a.sNo.compareTo(b.sNo));
      irrigationPump.sort((a, b) => a.sNo.compareTo(b.sNo));

      notifyListeners();
    } catch (e) {
      print('Error parsing JSON: $e');
    }
  }


  void updateFilterPayload(String payload) {
    try {
      Map<String, dynamic> data = jsonDecode(payload);
      if (data['2400'][0].containsKey('2405')) {
        List<dynamic> filtersJson = data['2400'][0]['2405'];
        centralFilter = [];
        localFilter = [];

        for (var filter in filtersJson) {
          if (filter['Type'] == 1) {
            centralFilter.add(filter);
          } else if (filter['Type'] == 2) {
            localFilter.add(filter);
          }
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error parsing JSON: $e');
    }
  }

  void updateFertilizerPayload(String payload) {
    try {
      Map<String, dynamic> data = jsonDecode(payload);
      if (data['2400'][0].containsKey('2406')) {
        List<dynamic> fertilizer = data['2400'][0]['2406'];
        centralFertilizer = fertilizer.where((item) => item['Type'] == 1).toList();
        localFertilizer = fertilizer.where((item) => item['Type'] == 2).toList();
      }
      notifyListeners();
    } catch (e) {
      print('Error parsing JSON: $e');
    }
  }

  void updatehttpweather(Map<String, dynamic> payload)
  {
    weatherModelinstance = WeatherModel.fromJson(payload);
    notifyListeners();
  }

 /* void updatePayload2408(List<Payload2408> payload) {
    payload2408 = payload;
    notifyListeners();
  }*/

  void updateFlowMeterPayload(String payload) {
    try {
      Map<String, dynamic> data = jsonDecode(payload);
      if (data['2400'][0].containsKey('2410')) {
        waterMeter = data['2400'][0]['2410'];
      }
      notifyListeners();
    } catch (e) {
      print('Error parsing JSON: $e');
    }
  }

  void updatePayload2408(List<IrrigationLinePLD> payload) {
    payloadIrrLine = payload;
    notifyListeners();
  }

  void updateAlarmPayload(List<AlarmData> payload) {
    alarmList = payload;
    notifyListeners();
  }

  void setAppConnectionState(MQTTConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  void updatePumpControllerLive(List<CM> pl) {
    _pumpLiveList = pl;
    notifyListeners();
  }

  void saveUnits(List<dynamic> units) {
    unitList = units;
  }

  void saveUserPermission(List<dynamic> permission) {
    userPermission = permission;
  }

  void nodeConnection(connection){
    nodeAndControllerConnection = connection;
  }

  String get receivedDashboardPayload => dashBoardPayload;
  String get receivedSchedulePayload => schedulePayload;
  MQTTConnectionState get getAppConnectionState => _appConnectionState;

}