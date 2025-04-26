import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/Screens/Config/config_maker/irrigation_lines.dart';

class ConfigMakerProvider extends ChangeNotifier {
  List<List<dynamic>> tabs = [
    ['Start', '', Icons.play_circle_filled, 0],
    ['Source', 'Pump', Icons.water, 1],
    ['Irrigation', 'Pump', Icons.waterfall_chart, 2],
    ['Central', 'Dosing', Icons.local_drink, 3],
    ['Central', 'Filtration', Icons.filter_alt, 4],
    ['Irrigation', 'Lines', Icons.timeline, 5],
    ['Local', 'Dosing', Icons.local_hospital, 6],
    ['Local', 'Filtration', Icons.filter_vintage, 7],
    ['Weather', 'Station', Icons.track_changes, 8],
    ['Mapping', 'of Output', Icons.compare_arrows, 9],
    ['Mapping', 'of Input', Icons.compare_arrows, 10],
    ['Finish', '', Icons.check_circle, 11],
  ];

  //batch variables
  var val = '1';
  var wmYesOrNo = false;
  var cdSite = '1';
  var injector = '1';
  var cfSite = '1';
  var filter = '1';
  int wantToSendData = 0;
  bool skip = false;
  bool skipAll = false;
  String messageWhenSendingData = '';

  void editSkip(bool val){
    skip = val;
    notifyListeners();
  }

  void editSkipAll(bool val){
    skipAll = val;
    notifyListeners();
  }

  editWantToSendData(value) {
    wantToSendData = value;
    notifyListeners();
  }

  editMessageWhenSendingData(value) {
    messageWhenSendingData = value;
    notifyListeners();
  }

  editCfSite(value) {
    cfSite = value;
    notifyListeners();
  }

  editFilter(value) {
    filter = value;
    notifyListeners();
  }

  editTotalSite(value) {
    cdSite = value;
    notifyListeners();
  }

  editInjector(value) {
    injector = value;
    notifyListeners();
  }

  editVal(value) {
    val = value;
    notifyListeners();
  }

  editWmYesOrNo(value) {
    wmYesOrNo = value;
    notifyListeners();
  }

  Map<String, dynamic> names = {};
  //new
  List<dynamic> oWeather = [];
  List<dynamic> oWeatherMac = [];
  List<dynamic> oRoWeatherForStation = [];
  int totalTempSensor = 0;
  List<dynamic> connTempSensor = [];
  int totalSoilTempSensor = 0;
  List<dynamic> connSoilTempSensor = [];
  int totalHumidity = 0;
  List<dynamic> connHumidity = [];
  int totalCo2 = 0;
  List<dynamic> connCo2 = [];
  int totalLux = 0;
  List<dynamic> connLux = [];
  int totalLdr = 0;
  List<dynamic> connLdr = [];
  int totalWindSpeed = 0;
  List<dynamic> connWindSpeed = [];
  int totalWindDirection = 0;
  List<dynamic> connWindDirection = [];
  int totalRainGauge = 0;
  List<dynamic> connRainGauge = [];
  int totalLeafWetness = 0;
  List<dynamic> connLeafWetness = [];
  //new
  bool isNew = true;
  String flag = '';
  dynamic oldData = {};
  dynamic serverData = {};
  List<dynamic> totalWaterSource = [];
  int totalWaterMeter = 0;
  int totalSourcePump = 0;
  int totalFloat = 0;
  int totalPowerSupply = 0;
  dynamic totalManualButton = [];
  int totalManualButtonCount = 0;
  dynamic totalCommonPressureSensor = [];
  int totalCommonPressureSensorCount = 0;
  dynamic totalCommonPressureSwitch = [];
  int totalCommonPressureSwitchCount = 0;
  dynamic totalTankFloat = [];
  int totalTankFloatCount = 0;
  int totalIrrigationPump = 0;
  int totalInjector = 0;
  int totalDosingMeter = 0;
  int totalBooster = 0;
  int totalCentralDosing = 0;
  int totalFilter = 0;
  int total_D_s_valve = 0;
  int total_p_sensor = 0;
  int totalCentralFiltration = 0;
  int totalValve = 0;
  int totalMainValve = 0;
  int totalIrrigationLine = 0;
  int totalLocalFiltration = 0;
  int totalLocalDosing = 0;
  int totalRTU = 0;
  int totalRtuPlus = 0;
  int totalOroSwitch = 0;
  int totalOroSense = 0;
  int totalOroSmartRTU = 0;
  int totalOroSmartRtuPlus = 0;
  int totalOroLevel = 0;
  int totalOroPump = 0;
  int totalOroExtend = 0;
  List<dynamic> i_o_types = ['-', 'A-I', 'D-I', 'P-I', 'RS485', '12C'];
  List<dynamic> totalAnalogSensor = [];
  int totalAnalogSensorCount = 0;
  List<dynamic> totalContact = [];
  int totalContactCount = 0;
  List<dynamic> totalAgitator = [];
  int totalAgitatorCount = 0;
  List<dynamic> totalSelector = [];
  int totalSelectorCount = 0;
  int totalPhSensor = 0;
  int totalPressureSwitch = 0;
  int totalDiffPressureSensor = 0;
  int totalEcSensor = 0;
  int totalMoistureSensor = 0;
  int totalLevelSensor = 0;
  int totalFan = 0;
  int totalFogger = 0;
  int totalMisting = 0;
  int totalHeating = 0;
  int totalPesticides = 0;
  int totalLight = 0;
  int totalVent = 0;
  int totalScreen = 0;
  int totalAirCirculation = 0;
  List<dynamic> oRtu = [];
  List<dynamic> oRtuMac = [];
  List<dynamic> oRtuPlus = [];
  List<dynamic> oRtuPlusMac = [];
  List<dynamic> oSrtu = [];
  List<dynamic> oSrtuMac = [];
  List<dynamic> oSrtuPlus = [];
  List<dynamic> oSrtuPlusMac = [];
  List<dynamic> oSwitch = [];
  List<dynamic> oSwitchMac = [];
  List<dynamic> oSense = [];
  List<dynamic> oSenseMac = [];
  List<dynamic> oLevel = [];
  List<dynamic> oLevelMac = [];
  List<dynamic> oPump = [];
  List<dynamic> oPumpMac = [];
  List<dynamic> oPumpPlus = [];
  List<dynamic> oPumpPlusMac = [];
  List<dynamic> oExtend = [];
  List<dynamic> oExtendMac = [];
  bool sourcePumpSelection = false;
  bool sourcePumpSelectAll = false;
  List<dynamic> waterSource = [];
  List<dynamic> sourcePumpUpdated = [];
  List<dynamic> irrigationPumpUpdated = [];
  List<dynamic> centralDosingUpdated = [];
  List<dynamic> centralFiltrationUpdated = [];
  List<dynamic> irrigationLines = [];
  List<dynamic> localDosingUpdated = [];
  List<dynamic> localFiltrationUpdated = [];
  Map<String,dynamic> weatherStation = {};
  bool irrigationPumpSelection = false;
  bool irrigationPumpSelectAll = false;
  bool c_dosingSelection = false;
  bool c_dosingSelectAll = false;
  bool l_dosingSelection = false;
  bool l_dosingSelectAll = false;
  bool l_filtrationSelection = false;
  bool l_filtrationSelectALL = false;
  bool focus = false;
  bool centralFiltrationSelection = false;
  bool centralFiltrationSelectAll = false;
  bool irrigationSelection = false;
  bool irrigationSelectAll = false;
  bool loadIrrigationLine = false;
  List<dynamic> central_dosing_site_list = [
    '-',
  ];
  List<dynamic> central_filtration_site_list = [
    '-',
  ];
  List<dynamic> irrigation_pump_list = [
    '-',
  ];
  List<dynamic> water_source_list = [
    '-',
  ];
  int selection = 0;
  int I_O_autoIncrement = 0;
  int selectedTab = 1;
  List<dynamic> newSnoList = [];
  List<dynamic> oldSnoList = [];
  int categoryId = 0;
  int totalLowerTankLevelSensorCount = 0;
  dynamic totalLowerTankLevelSensor = [];
  int totalUpperTankLevelSensorCount = 0;
  dynamic totalUpperTankLevelSensor = [];

  dynamic emptySensor(data) {
    data['rtu'] = '-';
    data['rfNo'] = '-';
    data['input'] = '-';
    data['input_type'] = '-';
    return data;
  }

  void weatherStationFuntionality(list) {
    switch (list[0]) {
      case ('add'):
        {
          for(var key in weatherStation.keys){
            if(weatherStation[key]['apply'] == false){
              weatherStation[key]['apply'] = true;
              break;
            }
          }
          break;
        }
      case ('delete'):
        {
          weatherStation[list[1]]['apply'] = false;
          weatherStation[list[1]]['irrigationLine'] = '-';
          break;
        }
      case ('sensorUpdate'):
        {
          weatherStation[list[1]][list[2]]['apply'] = !weatherStation[list[1]][list[2]]['apply'];
          break;
        }
    }
    notifyListeners();
  }

  void editSelectedTab(int value) {
    selectedTab = value;
    notifyListeners();
  }
  //Todo: clear config data

  void clearConfig() {
    names = {};
    oWeather = [];
    oWeatherMac = [];
    oRoWeatherForStation = [];
    totalTempSensor = 0;
    connTempSensor = [];
    totalSoilTempSensor = 0;
    connSoilTempSensor = [];
    totalHumidity = 0;
    connHumidity = [];
    totalCo2 = 0;
    connCo2 = [];
    totalLux = 0;
    connLux = [];
    totalLdr = 0;
    connLdr = [];
    totalWindSpeed = 0;
    connWindSpeed = [];
    totalWindDirection = 0;
    connWindDirection = [];
    totalRainGauge = 0;
    connRainGauge = [];
    totalLeafWetness = 0;
    connLeafWetness = [];
    isNew = true;
    flag = '';
    totalWaterSource = [];
    totalWaterMeter = 0;
    totalSourcePump = 0;
    totalFloat = 0;
    totalPowerSupply = 0;
    totalManualButton = [];
    totalCommonPressureSensor = [];
    totalCommonPressureSwitch = [];
    totalTankFloat = [];
    totalIrrigationPump = 0;
    totalInjector = 0;
    totalDosingMeter = 0;
    totalBooster = 0;
    totalCentralDosing = 0;
    totalFilter = 0;
    total_D_s_valve = 0;
    total_p_sensor = 0;
    totalCentralFiltration = 0;
    totalValve = 0;
    totalMainValve = 0;
    totalIrrigationLine = 0;
    totalLocalFiltration = 0;
    totalLocalDosing = 0;
    totalRTU = 0;
    totalRtuPlus = 0;
    totalOroSwitch = 0;
    totalOroSense = 0;
    totalOroSmartRTU = 0;
    totalOroSmartRtuPlus = 0;
    totalOroLevel = 0;
    totalOroPump = 0;
    totalOroExtend = 0;
    i_o_types = ['-', 'A-I', 'D-I', 'P-I', 'RS485', '12C'];
    totalAnalogSensor = [];
    totalContact = [];
    totalAgitator = [];
    totalSelector = [];
    totalPhSensor = 0;
    totalPressureSwitch = 0;
    totalDiffPressureSensor = 0;
    totalEcSensor = 0;
    totalMoistureSensor = 0;
    totalLevelSensor = 0;
    totalFan = 0;
    totalFogger = 0;
    oRtu = [];
    oRtuMac = [];
    oRtuPlus = [];
    oRtuPlusMac = [];
    oSrtu = [];
    oSrtuMac = [];
    oSrtuPlus = [];
    oSrtuPlusMac = [];
    oSwitch = [];
    oSwitchMac = [];
    oSense = [];
    oSenseMac = [];
    oLevel = [];
    oLevelMac = [];
    oPump = [];
    oPumpMac = [];
    oPumpPlus = [];
    oPumpPlusMac = [];
    oExtend = [];
    oExtendMac = [];
    sourcePumpSelection = false;
    sourcePumpSelectAll = false;
    waterSource = [];
    sourcePumpUpdated = [];
    irrigationPumpUpdated = [];
    centralDosingUpdated = [];
    centralFiltrationUpdated = [];
    irrigationLines = [];
    localDosingUpdated = [];
    localFiltrationUpdated = [];
    weatherStation = {};
    irrigationPumpSelection = false;
    irrigationPumpSelectAll = false;
    c_dosingSelection = false;
    c_dosingSelectAll = false;
    l_dosingSelection = false;
    l_dosingSelectAll = false;
    l_filtrationSelection = false;
    l_filtrationSelectALL = false;
    focus = false;
    centralFiltrationSelection = false;
    centralFiltrationSelectAll = false;
    irrigationSelection = false;
    irrigationSelectAll = false;
    loadIrrigationLine = false;
    central_dosing_site_list = [
      '-',
    ];
    central_filtration_site_list = [
      '-',
    ];
    irrigation_pump_list = [
      '-',
    ];
    water_source_list = [
      '-',
    ];
    selection = 0;
    I_O_autoIncrement = 0;
    selectedTab = 1;
    newSnoList = [];
    oldSnoList = [];
    categoryId = 0;
    totalLowerTankLevelSensorCount = 0;
    totalUpperTankLevelSensorCount = 0;
    totalLowerTankLevelSensor = [];
    totalUpperTankLevelSensor = [];
    notifyListeners();
  }

  //Todo: initialize the remaining sensor

  int initialIndex = 0;
  void editInitialIndex(int index) {
    initialIndex = index;
    notifyListeners();
  }

  void cancelSelection() {
    selection = 0;
    notifyListeners();
  }

  //TODO: refersh centralDosing
  void refreshCentralDosingList() {
    central_dosing_site_list = ['-'];
    for (var i = 0; i < centralDosingUpdated.length; i++) {
      central_dosing_site_list.add('${i + 1}');
    }
    for (var i = 0; i < irrigationLines.length; i++) {
      if (!central_dosing_site_list
          .contains(irrigationLines[i]['Central_dosing_site'])) {
        irrigationLines[i]['Central_dosing_site'] = '-';
      }
    }
    notifyListeners();
  }

  //TODO: refersh centralFiltration
  void refreshCentralFiltrationList() {
    central_filtration_site_list = ['-'];
    for (var i = 0; i < centralFiltrationUpdated.length; i++) {
      central_filtration_site_list.add('${i + 1}');
    }
    for (var i = 0; i < irrigationLines.length; i++) {
      if (!central_filtration_site_list
          .contains(irrigationLines[i]['Central_filtration_site'])) {
        irrigationLines[i]['Central_filtration_site'] = '-';
      }
    }
    notifyListeners();
  }

  //TODO: refersh irrigation pump
  void refreshIrrigationPumpList() {
    for (var i = 0; i < irrigationLines.length; i++) {
      for(var pump = 0;pump < irrigationPumpUpdated.length;pump++){
        if(irrigationPumpUpdated[pump]['deleted'] == true){
          if(irrigationLines[i]['irrigationPump'].contains('${pump+1}')){
            var listOfPump = irrigationLines[i]['irrigationPump'].split(',');
            listOfPump.remove('${pump+1}');
            irrigationLines[i]['irrigationPump'] = listOfPump.map((element) => element).join(',');
          }
        }
      }
    }
    notifyListeners();
  }

  //TODO: generating sno
  int returnI_O_AutoIncrement() {
    I_O_autoIncrement += 1;
    int val = I_O_autoIncrement;
    notifyListeners();
    return val;
  }

  //TODO: sourcePumpFunctionality

  void addingPump(List<dynamic> pump, int count, bool src, bool wm) {
    if (count > 0) {
      var add = false;
      var index = 0;
      for (var i in pump) {
        if (i['deleted'] == true) {
          i['deleted'] == false;
          i['rtu'] = '-';
          i['rfNo'] = '-';
          i['output'] = '-';
          i['deleted'] = false;
          i['oro_pump_plus'] = false;
          i['levelSensor'] = {};
          i['bottomTankLevel'] = {};
          i['pressureSensor'] = {};
          i['pressureOut'] = {};
          i['TopTankHigh'] = {};
          i['TopTankLow'] = {};
          i['SumpTankHigh'] = {};
          i['SumpTankLow'] = {};
          i['selection'] = 'unselect';
          if (src == true) i['waterSource'] = '-';
          i['waterMeter'] = {};
          add = true;
          index = pump.indexOf(i);
          break;
        }
      }
      if (add == false) {
        pump.add({
          'sNo': returnI_O_AutoIncrement(),
          'rtu': '-',
          'rfNo': '-',
          'output': '-',
          'deleted': false,
          'oro_pump': false,
          'oro_pump_plus': false,
          'levelSensor': {},
          'bottomTankLevel' : {},
          'pressureSensor': {},
          'pressureOut': {},
          'TopTankHigh': {},
          'TopTankLow': {},
          'SumpTankHigh': {},
          'SumpTankLow': {},
          'selection': 'unselect',
          if (src == true) 'waterSource': '-',
          'waterMeter': {},
          'controlGem' : false
        });
      }
      if (wm == true) {
        if (src == true) {
          sourcePumpFunctionality(
              ['editWaterMeter', add == true ? index : pump.length - 1, true]);
        } else {
          irrigationPumpFunctionality(
              ['editWaterMeter', add == true ? index : pump.length - 1, true]);
        }
      }
      if (src == true) {
        totalSourcePump -= 1;
      } else {
        totalIrrigationPump -= 1;
      }
    }
    notifyListeners();
  }

  dynamic getInputObject(String title, String rfNo,[String? inputType]) {
    var object = {
      'sNo': returnI_O_AutoIncrement(),
      'rtu': title,
      'rfNo': rfNo,
      'input': '-',
      'input_type': inputType == null ? '-' : inputType,
    };
    notifyListeners();
    return object;
  }

  void sourcePumpFunctionality(List<dynamic> list) {
    switch (list[0]) {
      case ('addSourcePump'):
        {
          addingPump(sourcePumpUpdated, totalSourcePump, true, false);
          break;
        }
      case ('editPressureSensor'):
        {
          if (list[2] == true) {
            total_p_sensor -= 1;
            sourcePumpUpdated[list[1]]['pressureSensor'] = {
              'sNo': returnI_O_AutoIncrement(),
              'rtu': sourcePumpUpdated[list[1]]['rtu'],
              'rfNo': sourcePumpUpdated[list[1]]['rfNo'],
              'input': '-',
              'input_type': 'A-I',
            };
          } else {
            total_p_sensor += 1;
            sourcePumpUpdated[list[1]]['pressureSensor'] = {};
          }
          break;
        }
      case ('editLevelSensor'):
        {
          if (list[2] == true) {
            totalLevelSensor -= 1;
            sourcePumpUpdated[list[1]]['levelSensor'] = {
              'sNo': returnI_O_AutoIncrement(),
              'rtu': sourcePumpUpdated[list[1]]['rtu'],
              'rfNo': sourcePumpUpdated[list[1]]['rfNo'],
              'input': '-',
              'input_type': 'A-I',
            };
          } else {
            totalLevelSensor += 1;
            sourcePumpUpdated[list[1]]['levelSensor'] = {};
          }
          break;
        }
      case ('editBottomTankLevel'):
        {
          if (list[2] == true) {
            totalLevelSensor -= 1;
            sourcePumpUpdated[list[1]]['bottomTankLevel'] = {
              'sNo': returnI_O_AutoIncrement(),
              'rtu': sourcePumpUpdated[list[1]]['rtu'],
              'rfNo': sourcePumpUpdated[list[1]]['rfNo'],
              'input': '-',
              'input_type': 'A-I',
            };
          } else {
            totalLevelSensor += 1;
            sourcePumpUpdated[list[1]]['bottomTankLevel'] = {};
          }
          break;
        }
      case ('addBatch'):
        {
          for (var i = 0; i < int.parse(list[1]); i++) {
            addingPump(sourcePumpUpdated, totalSourcePump, true, list[2]);
          }
          break;
        }
      case ('editsourcePumpSelection'):
        {
          sourcePumpSelection = list[1];
          if (list[1] == true) {
            for (var i = 0; i < sourcePumpUpdated.length; i++) {
              sourcePumpUpdated[i]['selection'] = 'unselect';
            }
          }
          break;
        }
      case ('editsourcePumpSelectAll'):
        {
          sourcePumpSelectAll = list[1];
          if (list[1] == true) {
            selection = 0;
            for (var i = 0; i < sourcePumpUpdated.length; i++) {
              selection = selection + 1;
              sourcePumpUpdated[i]['selection'] = 'select';
            }
          } else {
            selection = 0;
            for (var i = 0; i < sourcePumpUpdated.length; i++) {
              sourcePumpUpdated[i]['selection'] = 'unselect';
            }
          }
          break;
        }
      case ('reOrderPump'):
        {
          var data = sourcePumpUpdated[list[1]];
          sourcePumpUpdated.removeAt(list[1]);
          sourcePumpUpdated.insert(list[2], data);
          break;
        }
      case ('editWaterMeter'):
        {
          if (totalWaterMeter > 0) {
            if (list[2] == true) {
              sourcePumpUpdated[list[1]]['waterMeter'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
            } else {
              sourcePumpUpdated[list[1]]['waterMeter'] = {};
            }
            if (list[2] == true) {
              totalWaterMeter = totalWaterMeter - 1;
            } else {
              totalWaterMeter = totalWaterMeter + 1;
            }
          }
          if (totalWaterMeter == 0) {
            if (list[2] == false) {
              sourcePumpUpdated[list[1]]['waterMeter'] = {};
              totalWaterMeter = totalWaterMeter + 1;
            }
          }
          break;
        }
      case ('editRefNo_sp'):
        {
          if (sourcePumpUpdated[list[1]]['rfNo'] != list[2]) {
            sourcePumpUpdated[list[1]]['input'] = '-';
            if (sourcePumpUpdated[list[1]]['levelSensor'].isNotEmpty) {
              sourcePumpUpdated[list[1]]['levelSensor'] = {};
              totalLevelSensor += 1;
            }
            if (sourcePumpUpdated[list[1]]['pressureSensor'].isNotEmpty) {
              sourcePumpUpdated[list[1]]['pressureSensor'] = {};
              total_p_sensor += 1;
            }
            if (sourcePumpUpdated[list[1]]['TopTankHigh'].isNotEmpty) {
              sourcePumpUpdated[list[1]]['TopTankHigh'] = {};
              totalFloat += 1;
            }
            if (sourcePumpUpdated[list[1]]['TopTankLow'].isNotEmpty) {
              sourcePumpUpdated[list[1]]['TopTankLow'] = {};
              totalFloat += 1;
            }
            if (sourcePumpUpdated[list[1]]['SumpTankHigh'].isNotEmpty) {
              sourcePumpUpdated[list[1]]['SumpTankHigh'] = {};
              totalFloat += 1;
            }
            if (sourcePumpUpdated[list[1]]['SumpTankLow'].isNotEmpty) {
              sourcePumpUpdated[list[1]]['SumpTankLow'] = {};
              totalFloat += 1;
            }
          }
          sourcePumpUpdated[list[1]]['rfNo'] = list[2];
        }
      case ('editTopTankHigh'):
        {
          if (list[2] == true) {
            totalFloat -= 1;
            sourcePumpUpdated[list[1]]['TopTankHigh'] = getInputObject(
                sourcePumpUpdated[list[1]]['rtu'],
                sourcePumpUpdated[list[1]]['rfNo'],'D-I',);
          } else {
            sourcePumpUpdated[list[1]]['TopTankHigh'] = {};
            totalFloat += 1;
          }
          break;
        }
      case ('editTopTankLow'):
        {
          if (list[2] == true) {
            totalFloat -= 1;
            sourcePumpUpdated[list[1]]['TopTankLow'] = getInputObject(
                sourcePumpUpdated[list[1]]['rtu'],
                sourcePumpUpdated[list[1]]['rfNo'],
                'D-I',
            );
          } else {
            totalFloat += 1;
            sourcePumpUpdated[list[1]]['TopTankLow'] = {};
          }
          break;
        }
      case ('editSumpTankHigh'):
        {
          if (list[2] == true) {
            totalFloat -= 1;
            sourcePumpUpdated[list[1]]['SumpTankHigh'] = getInputObject(
                sourcePumpUpdated[list[1]]['rtu'],
                sourcePumpUpdated[list[1]]['rfNo'],'D-I',);
          } else {
            totalFloat += 1;
            sourcePumpUpdated[list[1]]['SumpTankHigh'] = {};
          }
          break;
        }
      case ('editSumpTankLow'):
        {
          if (list[2] == true) {
            totalFloat -= 1;
            sourcePumpUpdated[list[1]]['SumpTankLow'] = getInputObject(
                sourcePumpUpdated[list[1]]['rtu'],
                sourcePumpUpdated[list[1]]['rfNo'],'D-I',);
          } else {
            totalFloat += 1;
            sourcePumpUpdated[list[1]]['SumpTankLow'] = {};
          }
          break;
        }
      case ('editOroPump'):
        {
          if (list[2] == true) {
            sourcePumpUpdated[list[1]]['rtu'] = 'ORO Pump';
            sourcePumpUpdated[list[1]]['rfNo'] = '-';
            sourcePumpUpdated[list[1]]['output'] = '-';
            if (sourcePumpUpdated[list[1]]['oro_pump_plus'] == true) {
              sourcePumpFunctionality(['editOroPumpPlus', list[1], false,list[3]]);
            }
            if (sourcePumpUpdated[list[1]]['levelSensor'].isNotEmpty) {
              sourcePumpUpdated[list[1]]['levelSensor'] = {};
              totalLevelSensor += 1;
            }
            if (sourcePumpUpdated[list[1]]['pressureSensor'].isNotEmpty) {
              sourcePumpUpdated[list[1]]['pressureSensor'] = {};
              total_p_sensor += 1;
            }
            if (sourcePumpUpdated[list[1]]['TopTankHigh'].isNotEmpty) {
              sourcePumpUpdated[list[1]]['TopTankHigh'] = {};
              totalFloat += 1;
            }
            if (sourcePumpUpdated[list[1]]['TopTankLow'].isNotEmpty) {
              sourcePumpUpdated[list[1]]['TopTankLow'] = {};
              totalFloat += 1;
            }
            if (sourcePumpUpdated[list[1]]['SumpTankHigh'].isNotEmpty) {
              sourcePumpUpdated[list[1]]['SumpTankHigh'] = {};
              totalFloat += 1;
            }
            if (sourcePumpUpdated[list[1]]['SumpTankLow'].isNotEmpty) {
              sourcePumpUpdated[list[1]]['SumpTankLow'] = {};
              totalFloat += 1;
            }
          } else {
            sourcePumpUpdated[list[1]]['output'] = '-';
            sourcePumpUpdated[list[1]]['rfNo'] = '-';
            sourcePumpUpdated[list[1]]['rtu'] = list[3];
          }
          sourcePumpUpdated[list[1]]['oro_pump'] = list[2];
          break;
        }
      case ('editOroPumpPlus'):
        {
          if (list[2] == true) {
            if (sourcePumpUpdated[list[1]]['oro_pump'] == true) {
              sourcePumpFunctionality(['editOroPump', list[1], false,list[3]]);
            }
            if (sourcePumpUpdated[list[1]]['TopTankHigh'].isNotEmpty) {
              totalFloat += 1;
            }
            sourcePumpUpdated[list[1]]['TopTankHigh'] = {};
            if (sourcePumpUpdated[list[1]]['TopTankLow'].isNotEmpty) {
              totalFloat += 1;
            }
            sourcePumpUpdated[list[1]]['TopTankLow'] = {};
            if (sourcePumpUpdated[list[1]]['SumpTankHigh'].isNotEmpty) {
              totalFloat += 1;
            }
            sourcePumpUpdated[list[1]]['SumpTankHigh'] = {};
            if (sourcePumpUpdated[list[1]]['SumpTankLow'].isNotEmpty) {
              totalFloat += 1;
            }
            sourcePumpUpdated[list[1]]['SumpTankLow'] = {};
            sourcePumpUpdated[list[1]]['rtu'] = 'O-Pump-Plus';
            sourcePumpUpdated[list[1]]['rfNo'] = '-';
            sourcePumpUpdated[list[1]]['output'] = '-';
          } else {
            sourcePumpUpdated[list[1]]['rtu'] = list[3];
            sourcePumpUpdated[list[1]]['rfNo'] = '-';
            sourcePumpUpdated[list[1]]['output'] = '-';
            if (sourcePumpUpdated[list[1]]['TopTankHigh'].isNotEmpty) {
              totalFloat += 1;
            }
            sourcePumpUpdated[list[1]]['TopTankHigh'] = {};
            if (sourcePumpUpdated[list[1]]['TopTankLow'].isNotEmpty) {
              totalFloat += 1;
            }
            sourcePumpUpdated[list[1]]['TopTankLow'] = {};
            if (sourcePumpUpdated[list[1]]['SumpTankHigh'].isNotEmpty) {
              totalFloat += 1;
            }
            sourcePumpUpdated[list[1]]['SumpTankHigh'] = {};
            if (sourcePumpUpdated[list[1]]['SumpTankLow'].isNotEmpty) {
              totalFloat += 1;
            }
            sourcePumpUpdated[list[1]]['SumpTankLow'] = {};
            if (sourcePumpUpdated[list[1]]['levelSensor'].isNotEmpty) {
              totalLevelSensor += 1;
            }
            sourcePumpUpdated[list[1]]['levelSensor'] = {};
            if (sourcePumpUpdated[list[1]]['pressureSensor'].isNotEmpty) {
              total_p_sensor += 1;
            }
            sourcePumpUpdated[list[1]]['pressureSensor'] = {};
          }
          sourcePumpUpdated[list[1]]['oro_pump_plus'] = list[2];
          break;
        }
      case ('editWaterSource_sp'):
        {
          sourcePumpUpdated[list[1]]['waterSource'] = list[2];
          break;
        }
      case ('selectSourcePump'):
        {
          if (list[2] == true) {
            sourcePumpUpdated[list[1]]['selection'] = 'select';
            selection = selection + 1;
          } else {
            sourcePumpUpdated[list[1]]['selection'] = 'unselect';
            selection = selection - 1;
          }
          break;
        }
      case ('deleteSourcePump'):
        {
          List<Map<String, dynamic>> selectedPumps = [];
          for (var i = sourcePumpUpdated.length - 1; i >= 0; i--) {
            if (sourcePumpUpdated[i]['selection'] == 'select') {
              for(var irr in irrigationLines){
                if(irr['sourcePump'].contains('${i+1}')){
                  var seperator = ',';
                  if(irr['sourcePump'].contains('_')){
                    seperator = '_';
                  }
                  var listOfPump = irr['sourcePump'].split(seperator).where((element) => element != '${i+1}').join(',');
                  irr['sourcePump'] = listOfPump;
                }
              }
              selectedPumps.add(sourcePumpUpdated[i]);

              if (sourcePumpUpdated[i]['waterMeter'].isNotEmpty) {
                totalWaterMeter = totalWaterMeter + 1;
              }
              if (sourcePumpUpdated[i]['TopTankHigh'] != null) {
                if (sourcePumpUpdated[i]['TopTankHigh'].isNotEmpty) {
                  totalFloat += 1;
                }
              }
              if (sourcePumpUpdated[i]['TopTankLow'] != null) {
                if (sourcePumpUpdated[i]['TopTankLow'].isNotEmpty) {
                  totalFloat += 1;
                }
              }
              if (sourcePumpUpdated[i]['SumpTankHigh'] != null) {
                if (sourcePumpUpdated[i]['SumpTankHigh'].isNotEmpty) {
                  totalFloat += 1;
                }
              }
              if (sourcePumpUpdated[i]['SumpTankLow'] != null) {
                if (sourcePumpUpdated[i]['SumpTankLow'].isNotEmpty) {
                  totalFloat += 1;
                }
              }
              if (sourcePumpUpdated[i]['levelSensor'].isNotEmpty) {
                totalLevelSensor = totalLevelSensor + 1;
                sourcePumpUpdated[i]['levelSensor'] = {};
              }
              if (sourcePumpUpdated[i]['pressureSensor'].isNotEmpty) {
                total_p_sensor = total_p_sensor + 1;
                sourcePumpUpdated[i]['pressureSensor'] = {};
              }

              totalSourcePump = totalSourcePump + 1;
            }
          }
          for (var selectedPump in selectedPumps) {
            if (isNew == false) {
              sourcePumpUpdated[sourcePumpUpdated.indexOf(selectedPump)]
                  ['deleted'] = true;
            } else {
              sourcePumpUpdated.remove(selectedPump);
            }
          }
          sourcePumpSelectAll = false;
          sourcePumpSelection = false;
          break;
        }
      default:
        {
          break;
        }
    }

    notifyListeners();
  }

  //TODO: irrigationPumpFunctionality
  void irrigationPumpFunctionality(List<dynamic> list) {
    switch (list[0]) {
      case 'addIrrigationPump':
        {
          addingPump(irrigationPumpUpdated, totalIrrigationPump, false, false);
          break;
        }
      case ('addBatch'):
        {
          for (var i = 0; i < int.parse(list[1]); i++) {
            addingPump(
                irrigationPumpUpdated, totalIrrigationPump, false, list[2]);
          }
          break;
        }
      case ('editLevelSensor'):
        {
          if (list[2] == true) {
            totalLevelSensor -= 1;
            irrigationPumpUpdated[list[1]]['levelSensor'] = {
              'sNo': returnI_O_AutoIncrement(),
              'rtu': irrigationPumpUpdated[list[1]]['rtu'],
              'rfNo': irrigationPumpUpdated[list[1]]['rfNo'],
              'input': '-',
              'input_type': '-',
            };
          } else {
            totalLevelSensor += 1;
            irrigationPumpUpdated[list[1]]['levelSensor'] = {};
          }
          break;
        }
      case ('editBottomTankLevel'):
        {
          if (list[2] == true) {
            totalLevelSensor -= 1;
            irrigationPumpUpdated[list[1]]['bottomTankLevel'] = {
              'sNo': returnI_O_AutoIncrement(),
              'rtu': irrigationPumpUpdated[list[1]]['rtu'],
              'rfNo': irrigationPumpUpdated[list[1]]['rfNo'],
              'input': '-',
              'input_type': 'A-I',
            };
          } else {
            totalLevelSensor += 1;
            irrigationPumpUpdated[list[1]]['bottomTankLevel'] = {};
          }
          break;
        }
      case ('editPressureSensor'):
        {
          if (list[2] == true) {
            total_p_sensor -= 1;
            irrigationPumpUpdated[list[1]]['pressureSensor'] = {
              'sNo': returnI_O_AutoIncrement(),
              'rtu': irrigationPumpUpdated[list[1]]['rtu'],
              'rfNo': irrigationPumpUpdated[list[1]]['rfNo'],
              'input': '-',
              'input_type': '-',
            };
          } else {
            total_p_sensor += 1;
            irrigationPumpUpdated[list[1]]['pressureSensor'] = {};
          }
          break;
        }
      case 'editIrrigationPumpSelection':
        {
          irrigationPumpSelection = list[1];
          if (list[1] == true) {
            for (var i = 0; i < irrigationPumpUpdated.length; i++) {
              irrigationPumpUpdated[i]['selection'] = 'unselect';
            }
          }
          break;
        }
      case 'editIrrigationPumpSelectAll':
        {
          irrigationPumpSelectAll = list[1];
          if (list[1] == true) {
            selection = 0;
            for (var i = 0; i < irrigationPumpUpdated.length; i++) {
              irrigationPumpUpdated[i]['selection'] = 'select';
              selection += 1;
            }
          } else {
            for (var i = 0; i < irrigationPumpUpdated.length; i++) {
              irrigationPumpUpdated[i]['selection'] = 'unselect';
              selection = 0;
            }
          }
          break;
        }
      case ('reOrderPump'):
        {
          var data = irrigationPumpUpdated[list[1]];
          irrigationPumpUpdated.removeAt(list[1]);
          irrigationPumpUpdated.insert(list[2], data);
          break;
        }
      case 'editWaterMeter':
        {
          if (totalWaterMeter > 0) {
            if (list[2] == true) {
              irrigationPumpUpdated[list[1]]['waterMeter'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
            } else {
              irrigationPumpUpdated[list[1]]['waterMeter'] = {};
            }
            if (list[2] == true) {
              totalWaterMeter = totalWaterMeter - 1;
            } else {
              totalWaterMeter = totalWaterMeter + 1;
            }
          }
          if (totalWaterMeter == 0) {
            if (list[2] == false) {
              irrigationPumpUpdated[list[1]]['waterMeter'] = {};
              totalWaterMeter = totalWaterMeter + 1;
            }
          }
          break;
        }
      case ('editRefNo_ip'):
        {
          if (irrigationPumpUpdated[list[1]]['rfNo'] != list[2]) {
            irrigationPumpUpdated[list[1]]['input'] = '-';
            if (irrigationPumpUpdated[list[1]]['levelSensor'].isNotEmpty) {
              irrigationPumpUpdated[list[1]]['levelSensor'] = {};
              totalLevelSensor += 1;
            }
            if (irrigationPumpUpdated[list[1]]['pressureSensor'].isNotEmpty) {
              irrigationPumpUpdated[list[1]]['pressureSensor'] = {};
              total_p_sensor += 1;
            }
            if (irrigationPumpUpdated[list[1]]['TopTankHigh'].isNotEmpty) {
              irrigationPumpUpdated[list[1]]['TopTankHigh'] = {};
              totalFloat += 1;
            }
            if (irrigationPumpUpdated[list[1]]['TopTankLow'].isNotEmpty) {
              irrigationPumpUpdated[list[1]]['TopTankLow'] = {};
              totalFloat += 1;
            }
            if (irrigationPumpUpdated[list[1]]['SumpTankHigh'].isNotEmpty) {
              irrigationPumpUpdated[list[1]]['SumpTankHigh'] = {};
              totalFloat += 1;
            }
            if (irrigationPumpUpdated[list[1]]['SumpTankLow'].isNotEmpty) {
              irrigationPumpUpdated[list[1]]['SumpTankLow'] = {};
              totalFloat += 1;
            }
          }
          irrigationPumpUpdated[list[1]]['rfNo'] = list[2];
        }
      case 'selectIrrigationPump':
        {
          if (irrigationPumpUpdated[list[1]]['selection'] == 'select') {
            irrigationPumpUpdated[list[1]]['selection'] = 'unselect';
            selection -= 1;
          } else {
            irrigationPumpUpdated[list[1]]['selection'] = 'select';
            selection += 1;
          }
          break;
        }
      case 'deleteIrrigationPump':
        {
          List<Map<String, dynamic>> selectedPumps = [];
          for (var i = irrigationPumpUpdated.length - 1; i >= 0; i--) {
            if (irrigationPumpUpdated[i]['selection'] == 'select') {
              for(var irr in irrigationLines){
                if(irr['irrigationPump'].contains('${i+1}')){
                  var seperator = ',';
                  if(irr['irrigationPump'].contains('_')){
                    seperator = '_';
                  }
                  var listOfPump = irr['irrigationPump'].split(seperator).where((element) => element != '${i+1}').join(',');
                  irr['irrigationPump'] = listOfPump;
                }
              }
              selectedPumps.add(irrigationPumpUpdated[i]);

              if (irrigationPumpUpdated[i]['waterMeter'].isNotEmpty) {
                totalWaterMeter = totalWaterMeter + 1;
              }
              if (irrigationPumpUpdated[i]['TopTankHigh'] != null) {
                if (irrigationPumpUpdated[i]['TopTankHigh'].isNotEmpty) {
                  totalFloat += 1;
                }
              }
              if (irrigationPumpUpdated[i]['TopTankLow'] != null) {
                if (irrigationPumpUpdated[i]['TopTankLow'].isNotEmpty) {
                  totalFloat += 1;
                }
              }
              if (irrigationPumpUpdated[i]['SumpTankHigh'] != null) {
                if (irrigationPumpUpdated[i]['SumpTankHigh'].isNotEmpty) {
                  totalFloat += 1;
                }
              }
              if (irrigationPumpUpdated[i]['SumpTankLow'] != null) {
                if (irrigationPumpUpdated[i]['SumpTankLow'].isNotEmpty) {
                  totalFloat += 1;
                }
              }
              if (irrigationPumpUpdated[i]['levelSensor'].isNotEmpty) {
                totalLevelSensor = totalLevelSensor + 1;
                irrigationPumpUpdated[i]['levelSensor'] = {};
              }
              if (irrigationPumpUpdated[i]['pressureSensor'].isNotEmpty) {
                total_p_sensor = total_p_sensor + 1;
                irrigationPumpUpdated[i]['pressureSensor'] = {};
              }

              totalIrrigationPump = totalIrrigationPump + 1;
            }
          }
          for (var selectedPump in selectedPumps) {
            if (isNew == false) {
              irrigationPumpUpdated[irrigationPumpUpdated.indexOf(selectedPump)]
                  ['deleted'] = true;
            } else {
              irrigationPumpUpdated.remove(selectedPump);
            }
          }
          irrigationPumpSelection = false;
          irrigationPumpSelectAll = false;
          refreshIrrigationPumpList();
          break;
        }
      case ('editTopTankHigh'):
        {
          if (list[2] == true) {
            totalFloat -= 1;
            irrigationPumpUpdated[list[1]]['TopTankHigh'] = getInputObject(
                irrigationPumpUpdated[list[1]]['rtu'],
                irrigationPumpUpdated[list[1]]['rfNo'],'D-I',);
          } else {
            irrigationPumpUpdated[list[1]]['TopTankHigh'] = {};
            totalFloat += 1;
          }
          break;
        }
      case ('editTopTankLow'):
        {
          if (list[2] == true) {
            totalFloat -= 1;
            irrigationPumpUpdated[list[1]]['TopTankLow'] = getInputObject(
                irrigationPumpUpdated[list[1]]['rtu'],
                irrigationPumpUpdated[list[1]]['rfNo'],'D-I',);
          } else {
            totalFloat += 1;
            irrigationPumpUpdated[list[1]]['TopTankLow'] = {};
          }
          break;
        }
      case ('editSumpTankHigh'):
        {
          if (list[2] == true) {
            totalFloat -= 1;
            irrigationPumpUpdated[list[1]]['SumpTankHigh'] = getInputObject(
                irrigationPumpUpdated[list[1]]['rtu'],
                irrigationPumpUpdated[list[1]]['rfNo'],'D-I',);
          } else {
            totalFloat += 1;
            irrigationPumpUpdated[list[1]]['SumpTankHigh'] = {};
          }
          break;
        }
      case ('editSumpTankLow'):
        {
          if (list[2] == true) {
            totalFloat -= 1;
            irrigationPumpUpdated[list[1]]['SumpTankLow'] = getInputObject(
                irrigationPumpUpdated[list[1]]['rtu'],
                irrigationPumpUpdated[list[1]]['rfNo'],'D-I',);
          } else {
            totalFloat += 1;
            irrigationPumpUpdated[list[1]]['SumpTankLow'] = {};
          }
          break;
        }
      case ('editOroPump'):
        {
          if (list[2] == true) {
            irrigationPumpUpdated[list[1]]['rtu'] = 'ORO Pump';
            irrigationPumpUpdated[list[1]]['rfNo'] = '-';
            irrigationPumpUpdated[list[1]]['output'] = '-';
            if (irrigationPumpUpdated[list[1]]['oro_pump_plus'] == true) {
              irrigationPumpFunctionality(['editOroPumpPlus', list[1], false]);
            }
            if (irrigationPumpUpdated[list[1]]['levelSensor'].isNotEmpty) {
              irrigationPumpUpdated[list[1]]['levelSensor'] = {};
              totalLevelSensor += 1;
            }
            if (irrigationPumpUpdated[list[1]]['pressureSensor'].isNotEmpty) {
              irrigationPumpUpdated[list[1]]['pressureSensor'] = {};
              total_p_sensor += 1;
            }
            if (irrigationPumpUpdated[list[1]]['TopTankHigh'].isNotEmpty) {
              irrigationPumpUpdated[list[1]]['TopTankHigh'] = {};
              totalFloat += 1;
            }
            if (irrigationPumpUpdated[list[1]]['TopTankLow'].isNotEmpty) {
              irrigationPumpUpdated[list[1]]['TopTankLow'] = {};
              totalFloat += 1;
            }
            if (irrigationPumpUpdated[list[1]]['SumpTankHigh'].isNotEmpty) {
              irrigationPumpUpdated[list[1]]['SumpTankHigh'] = {};
              totalFloat += 1;
            }
            if (irrigationPumpUpdated[list[1]]['SumpTankLow'].isNotEmpty) {
              irrigationPumpUpdated[list[1]]['SumpTankLow'] = {};
              totalFloat += 1;
            }
          } else {
            irrigationPumpUpdated[list[1]]['output'] = '-';
            irrigationPumpUpdated[list[1]]['rfNo'] = '-';
            irrigationPumpUpdated[list[1]]['rtu'] = '-';
          }
          irrigationPumpUpdated[list[1]]['oro_pump'] = list[2];
          break;
        }
      case ('editOroPumpPlus'):
        {
          if (list[2] == true) {
            if (irrigationPumpUpdated[list[1]]['oro_pump'] == true) {
              irrigationPumpFunctionality(['editOroPump', list[1], false]);
            }
            if (irrigationPumpUpdated[list[1]]['TopTankHigh'].isNotEmpty) {
              totalFloat += 1;
            }
            irrigationPumpUpdated[list[1]]['TopTankHigh'] = {};
            if (irrigationPumpUpdated[list[1]]['TopTankLow'].isNotEmpty) {
              totalFloat += 1;
            }
            irrigationPumpUpdated[list[1]]['TopTankLow'] = {};
            if (irrigationPumpUpdated[list[1]]['SumpTankHigh'].isNotEmpty) {
              totalFloat += 1;
            }
            irrigationPumpUpdated[list[1]]['SumpTankHigh'] = {};
            if (irrigationPumpUpdated[list[1]]['SumpTankLow'].isNotEmpty) {
              totalFloat += 1;
            }
            irrigationPumpUpdated[list[1]]['SumpTankLow'] = {};
            irrigationPumpUpdated[list[1]]['rtu'] = 'O-Pump-Plus';
            irrigationPumpUpdated[list[1]]['rfNo'] = '-';
            irrigationPumpUpdated[list[1]]['output'] = '-';
          } else {
            irrigationPumpUpdated[list[1]]['rtu'] = '-';
            irrigationPumpUpdated[list[1]]['rfNo'] = '-';
            irrigationPumpUpdated[list[1]]['output'] = '-';
            if (irrigationPumpUpdated[list[1]]['TopTankHigh'].isNotEmpty) {
              totalFloat += 1;
            }
            irrigationPumpUpdated[list[1]]['TopTankHigh'] = {};
            if (irrigationPumpUpdated[list[1]]['TopTankLow'].isNotEmpty) {
              totalFloat += 1;
            }
            irrigationPumpUpdated[list[1]]['TopTankLow'] = {};
            if (irrigationPumpUpdated[list[1]]['SumpTankHigh'].isNotEmpty) {
              totalFloat += 1;
            }
            irrigationPumpUpdated[list[1]]['SumpTankHigh'] = {};
            if (irrigationPumpUpdated[list[1]]['SumpTankLow'].isNotEmpty) {
              totalFloat += 1;
            }
            irrigationPumpUpdated[list[1]]['SumpTankLow'] = {};
            if (irrigationPumpUpdated[list[1]]['levelSensor'].isNotEmpty) {
              totalLevelSensor += 1;
            }
            irrigationPumpUpdated[list[1]]['levelSensor'] = {};
            if (irrigationPumpUpdated[list[1]]['pressureSensor'].isNotEmpty) {
              total_p_sensor += 1;
            }
            irrigationPumpUpdated[list[1]]['pressureSensor'] = {};
          }
          irrigationPumpUpdated[list[1]]['oro_pump_plus'] = list[2];
          break;
        }
      default:
        {
          break;
        }
    }
    refreshIrrigationPumpList();
    notifyListeners();
  }

  //TODO: addBatch injector
  List<Map<String, dynamic>> addBatchInjector(int count) {
    List<Map<String, dynamic>> injector = [];
    for (var i = 0; i < count; i++) {
      injector.add({
        'sNo': returnI_O_AutoIncrement(),
        'Which_Booster_Pump': '-',
        'rtu': '-',
        'rfNo': '-',
        'output': '-',
        'output_type': '1',
        'dosingMeter': {},
        'levelSensor': {},
        'injectorType': 'Venturi',
      });
      totalInjector = totalInjector - 1;
    }
    return injector;
  }

  //TODO: centralDosingFunctionality
  void centralDosingFunctionality(List<dynamic> list) {
    switch (list[0]) {
      case ('deleteFromMapio'):
        {
          if (list[2] == 'injector') {
            if (centralDosingUpdated[list[1]]['injector'].length != 1) {
              if (remover(centralDosingUpdated, list[1], 'injector', list[3])) {
                totalInjector += 1;
              }
            }
          } else if (list[2] == 'ecConnection') {
            if (remover(
                centralDosingUpdated, list[1], 'ecConnection', list[3], 'ec')) {
              totalEcSensor += 1;
            }
          } else if (list[2] == 'phConnection') {
            if (remover(
                centralDosingUpdated, list[1], 'phConnection', list[3], 'ph')) {
              totalPhSensor += 1;
            }
          } else if (list[2] == 'boosterConnection') {
            if (remover(centralDosingUpdated, list[1], 'boosterConnection',
                list[3], 'boosterPump')) {
              totalBooster += 1;
            }
            for (var inj in centralDosingUpdated[list[1]]['injector']) {
              if (centralDosingUpdated[list[1]]['boosterConnection'].isEmpty) {
                inj['Which_Booster_Pump'] = '-';
                inj['injectorType'] = 'Venturi';
              } else {
                if (inj['Which_Booster_Pump'] == '-') {
                  inj['Which_Booster_Pump'] = 'BP 1';
                }
              }
            }
          }
          break;
        }
      case ('editAgitator') : {
        centralDosingUpdated[list[1]]['agitator'] = list[2];
      }
      case ('addCentralDosing'):
        {
          if (totalCentralDosing > 0 && totalInjector > 0) {
            var add = false;
            for (var i in centralDosingUpdated) {
              if (i['deleted'] == true) {
                i['deleted'] = false;
                i['selection'] = 'unselect';
                i['injector'] = [
                  {
                    'sNo': returnI_O_AutoIncrement(),
                    'Which_Booster_Pump': '-',
                    'rtu': '-',
                    'rfNo': '-',
                    'output': '-',
                    'output_type': '1',
                    'dosingMeter': {},
                    'levelSensor': {},
                    'injectorType': 'Electrical',
                  }
                ];
                i['boosterPump'] = '';
                i['boosterConnection'] = [];
                i['ec'] = '';
                i['ecConnection'] = [];
                i['ph'] = '';
                i['phConnection'] = [];
                i['pressureSwitch'] = {};
                i['agitator'] = '-';
                add = true;
                break;
              }
            }
            if (add == false) {
              centralDosingUpdated.add({
                'sNo': returnI_O_AutoIncrement(),
                'selection': 'unselect',
                'deleted': false,
                'injector': [
                  {
                    'sNo': returnI_O_AutoIncrement(),
                    'Which_Booster_Pump': '-',
                    'rtu': '-',
                    'rfNo': '-',
                    'output': '-',
                    'output_type': '1',
                    'dosingMeter': {},
                    'levelSensor': {},
                    'injectorType': 'Electrical',
                  }
                ],
                'boosterPump': '',
                'boosterConnection': [],
                'ec': '',
                'ecConnection': [],
                'ph': '',
                'phConnection': [],
                'pressureSwitch': {},
                'agitator' : '-',
              });
            }
            totalCentralDosing = totalCentralDosing - 1;
            totalInjector = totalInjector - 1;
            // refreshCentralDosingList();
          }
          break;
        }
      case ('addBatch_CD'):
        {
          if (totalCentralDosing > 0 && totalInjector > 0) {
            for (var i = 0; i < list[1]; i++) {
              var useOld = false;
              totalCentralDosing -= 1;
              check:
              for (var cd in centralDosingUpdated) {
                if (cd['deleted'] == true) {
                  cd['deleted'] = false;
                  cd['selection'] = 'unselect';
                  cd['injector'] = addBatchInjector(list[2]);
                  cd['boosterPump'] = '';
                  cd['boosterConnection'] = [];
                  cd['ec'] = '';
                  cd['ecConnection'] = [];
                  cd['ph'] = '';
                  cd['phConnection'] = [];
                  cd['pressureSwitch'] = {};
                  cd['agitator'] = '-';
                  useOld = true;
                  break check;
                }
              }
              if (useOld == false) {
                centralDosingUpdated.add({
                  'sNo': returnI_O_AutoIncrement(),
                  'selection': 'unselect',
                  'injector': addBatchInjector(list[2]),
                  'boosterPump': '',
                  'boosterConnection': [],
                  'ec': '',
                  'ecConnection': [],
                  'ph': '',
                  'phConnection': [],
                  'pressureSwitch': {},
                  'deleted': false,
                  'agitator': '-',
                });
              }
            }
          }
          break;
        }
      case ('c_dosingSelection'):
        {
          c_dosingSelection = list[1];
          break;
        }
      case ('c_dosingSelectAll'):
        {
          c_dosingSelectAll = list[1];
          if (list[1] == true) {
            selection = 0;
            for (var i = 0; i < centralDosingUpdated.length; i++) {
              centralDosingUpdated[i]['selection'] = 'select';
              selection += 1;
            }
          } else {
            for (var i = 0; i < centralDosingUpdated.length; i++) {
              centralDosingUpdated[i]['selection'] = 'unselect';
              selection = 0;
            }
          }
          break;
        }
      case ('reOrderCdSite'):
        {
          var data = centralDosingUpdated[list[1]];
          centralDosingUpdated.removeAt(list[1]);
          centralDosingUpdated.insert(list[2], data);
          break;
        }
      case ('editInjectorType'):
        {
          centralDosingUpdated[list[1]]['injector'][list[2]]['injectorType'] =
              list[3];
          break;
        }
      case ('editLevelSensor'):
        {
          if (totalLevelSensor > 0) {
            if (list[3] == true) {
              centralDosingUpdated[list[1]]['injector'][list[2]]
                  ['levelSensor'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
              totalLevelSensor = totalLevelSensor - 1;
            } else {
              centralDosingUpdated[list[1]]['injector'][list[2]]
                  ['levelSensor'] = {};
              totalLevelSensor = totalLevelSensor + 1;
            }
          }
          if (totalLevelSensor == 0) {
            if (list[3] == false) {
              centralDosingUpdated[list[1]]['injector'][list[2]]
                  ['levelSensor'] = {};
              totalLevelSensor = totalLevelSensor + 1;
            }
          }
          break;
        }
      case ('editDosingMeter'):
        {
          if (totalDosingMeter > 0) {
            if (list[3] == true) {
              centralDosingUpdated[list[1]]['injector'][list[2]]
                  ['dosingMeter'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
              totalDosingMeter = totalDosingMeter - 1;
            } else {
              centralDosingUpdated[list[1]]['injector'][list[2]]
                  ['dosingMeter'] = {};
              totalDosingMeter = totalDosingMeter + 1;
            }
          }
          if (totalDosingMeter == 0) {
            if (list[3] == false) {
              centralDosingUpdated[list[1]]['injector'][list[2]]
                  ['dosingMeter'] = {};
              totalDosingMeter = totalDosingMeter + 1;
            }
          }
          break;
        }
      case ('editPressureSwitch'):
        {
          if (totalPressureSwitch > 0) {
            if (list[2] == true) {
              centralDosingUpdated[list[1]]['pressureSwitch'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
              totalPressureSwitch = totalPressureSwitch - 1;
            } else {
              centralDosingUpdated[list[1]]['pressureSwitch'] = {};
              totalPressureSwitch = totalPressureSwitch + 1;
            }
          }
          if (totalPressureSwitch == 0) {
            if (list[2] == false) {
              centralDosingUpdated[list[1]]['pressureSwitch'] = {};
              totalPressureSwitch = totalPressureSwitch + 1;
            }
          }
          break;
        }
      case ('selectCentralDosing'):
        {
          if (centralDosingUpdated[list[1]]['selection'] == 'unselect') {
            centralDosingUpdated[list[1]]['selection'] = 'select';
            selection += 1;
          } else {
            centralDosingUpdated[list[1]]['selection'] = 'unselect';
            selection -= 1;
          }
          break;
        }
      case ('deleteCentralDosing'):
        {
          List<Map<String, dynamic>> selectedSite = [];
          for (var i = centralDosingUpdated.length - 1; i >= 0; i--) {
            if (centralDosingUpdated[i]['selection'] == 'select') {
              selectedSite.add(centralDosingUpdated[i]);
            }
          }
          for (var cdSite in selectedSite) {
            totalInjector = totalInjector + cdSite['injector'].length as int;
            totalBooster =
                totalBooster + cdSite['boosterConnection'].length as int;
            totalEcSensor =
                totalEcSensor + cdSite['ecConnection'].length as int;
            totalPhSensor =
                totalPhSensor + cdSite['phConnection'].length as int;
            if (cdSite['pressureSwitch'].isNotEmpty) {
              totalPressureSwitch = totalPressureSwitch + 1;
            }
            for (var i in cdSite['injector']) {
              if (i['dosingMeter'].isNotEmpty) {
                totalDosingMeter = totalDosingMeter + 1;
              }
            }
            if (isNew == false) {
              centralDosingUpdated[centralDosingUpdated.indexOf(cdSite)]
                  ['deleted'] = true;
            } else {
              centralDosingUpdated.remove(cdSite);
            }
            totalCentralDosing = totalCentralDosing + 1;
          }
          refreshCentralDosingList();
          break;
        }
      case ('editBoosterPumpSelection'):
        {
          if (centralDosingUpdated[list[1]]['boosterPump'] == '') {
            centralDosingUpdated[list[1]]['boosterConnection'] = [];
            for (var inj = 0;
                inj < centralDosingUpdated[list[1]]['injector'].length;
                inj++) {
              centralDosingUpdated[list[1]]['injector'][inj]
                  ['Which_Booster_Pump'] = '-';
              centralDosingUpdated[list[1]]['injector'][inj]['injectorType'] =
                  'Venturi';
            }
          } else {
            if (int.parse(centralDosingUpdated[list[1]]['boosterPump']) >
                centralDosingUpdated[list[1]]['boosterConnection'].length) {
              int count =
                  (int.parse(centralDosingUpdated[list[1]]['boosterPump']) -
                      centralDosingUpdated[list[1]]['boosterConnection']
                          .length) as int;
              for (var inj = 0;
                  inj < centralDosingUpdated[list[1]]['injector'].length;
                  inj++) {
                if (centralDosingUpdated[list[1]]['injector'][inj]
                        ['Which_Booster_Pump'] ==
                    '-') {
                  centralDosingUpdated[list[1]]['injector'][inj]
                      ['Which_Booster_Pump'] = 'BP 1';
                }
              }

              for (var i = 0; i < count; i++) {
                centralDosingUpdated[list[1]]['boosterConnection'].add({
                  'sNo': returnI_O_AutoIncrement(),
                  'rtu': '-',
                  'rfNo': '-',
                  'output': '-',
                  'output_type': '1',
                });
              }
            } else {
              int count =
                  (centralDosingUpdated[list[1]]['boosterConnection'].length -
                      int.parse(centralDosingUpdated[list[1]]['boosterPump']));
              for (var i = 0; i < count; i++) {
                for (var inj = 0;
                    inj < centralDosingUpdated[list[1]]['injector'].length;
                    inj++) {
                  if (centralDosingUpdated[list[1]]['injector'][inj]
                          ['Which_Booster_Pump']
                      .contains(
                          '${centralDosingUpdated[list[1]]['boosterConnection'].length}')) {
                    centralDosingUpdated[list[1]]['injector'][inj]
                        ['Which_Booster_Pump'] = 'BP 1';
                  }
                }
                centralDosingUpdated[list[1]]['boosterConnection'].removeLast();
              }
            }
          }
          break;
        }
      case ('editEcSelection'):
        {
          if (centralDosingUpdated[list[1]]['ec'] == '') {
            centralDosingUpdated[list[1]]['ecConnection'] = [];
          } else {
            if (int.parse(centralDosingUpdated[list[1]]['ec']) >
                centralDosingUpdated[list[1]]['ecConnection'].length) {
              int count = (int.parse(centralDosingUpdated[list[1]]['ec']) -
                  centralDosingUpdated[list[1]]['ecConnection'].length) as int;
              for (var i = 0; i < count; i++) {
                centralDosingUpdated[list[1]]['ecConnection'].add({
                  'sNo': returnI_O_AutoIncrement(),
                  'rtu': 'O-Smart-Plus',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': 'A-I',
                });
              }
            } else {
              int count =
                  (centralDosingUpdated[list[1]]['ecConnection'].length -
                      int.parse(centralDosingUpdated[list[1]]['ec']));
              for (var i = 0; i < count; i++) {
                centralDosingUpdated[list[1]]['ecConnection'].removeLast();
              }
            }
          }
          break;
        }
      case ('editPhSelection'):
        {
          if (centralDosingUpdated[list[1]]['ph'] == '') {
            centralDosingUpdated[list[1]]['phConnection'] = [];
          } else {
            if (int.parse(centralDosingUpdated[list[1]]['ph']) >
                centralDosingUpdated[list[1]]['phConnection'].length) {
              int count = (int.parse(centralDosingUpdated[list[1]]['ph']) -
                  centralDosingUpdated[list[1]]['phConnection'].length) as int;
              for (var i = 0; i < count; i++) {
                centralDosingUpdated[list[1]]['phConnection'].add({
                  'sNo': returnI_O_AutoIncrement(),
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': 'A-I',
                });
              }
            } else {
              int count =
                  (centralDosingUpdated[list[1]]['phConnection'].length -
                      int.parse(centralDosingUpdated[list[1]]['ph']));
              for (var i = 0; i < count; i++) {
                centralDosingUpdated[list[1]]['phConnection'].removeLast();
              }
            }
          }
          break;
        }
      case ('editBoosterPump'):
        {
          if (totalBooster > -1) {
            if (centralDosingUpdated[list[1]]['boosterPump'] != '') {
              totalBooster = totalBooster +
                  int.parse(centralDosingUpdated[list[1]]['boosterPump']);
              if (list[2] == '') {
                totalBooster = totalBooster - 0;
              } else {
                if (list[2] == '0') {
                  totalBooster = totalBooster - 1;
                } else {
                  totalBooster = totalBooster - int.parse(list[2]);
                }
              }
            } else {
              if (list[2] == '0') {
                totalBooster = totalBooster - 1;
              } else {
                totalBooster = totalBooster - int.parse(list[2]);
              }
            }
            centralDosingUpdated[list[1]]['boosterPump'] = list[2];
          }
          break;
        }
      case ('boosterSelectionForInjector'):
        {
          centralDosingUpdated[list[1]]['injector'][list[2]]
              ['Which_Booster_Pump'] = list[3];
          break;
        }
      case ('editEcSensor'):
        {
          if (totalEcSensor > -1) {
            if (centralDosingUpdated[list[1]]['ec'] != '') {
              totalEcSensor = totalEcSensor +
                  int.parse(centralDosingUpdated[list[1]]['ec']);
              if (list[2] == '') {
                totalEcSensor = totalEcSensor - 0;
              } else {
                if (list[2] == '0') {
                  totalEcSensor = totalEcSensor - 1;
                } else {
                  totalEcSensor = totalEcSensor - int.parse(list[2]);
                }
              }
            } else {
              if (list[2] == '0') {
                totalEcSensor = totalEcSensor - 1;
              } else {
                totalEcSensor = totalEcSensor - int.parse(list[2]);
              }
            }
            centralDosingUpdated[list[1]]['ec'] = list[2];
          }
          break;
        }
      case ('editPhSensor'):
        {
          if (totalPhSensor > -1) {
            if (centralDosingUpdated[list[1]]['ph'] != '') {
              totalPhSensor = totalPhSensor +
                  int.parse(centralDosingUpdated[list[1]]['ph']);
              if (list[2] == '') {
                totalPhSensor = totalPhSensor - 0;
              } else {
                if (list[2] == '0') {
                  totalPhSensor = totalPhSensor - 1;
                } else {
                  totalPhSensor = totalPhSensor - int.parse(list[2]);
                }
              }
            } else {
              if (list[2] == '0') {
                totalPhSensor = totalPhSensor - 1;
              } else {
                totalPhSensor = totalPhSensor - int.parse(list[2]);
              }
            }
            centralDosingUpdated[list[1]]['ph'] = list[2];
          }
          break;
        }

      default:
        {
          break;
        }
    }
    refreshCentralDosingList();
    notifyListeners();
  }

  //TODO: centralFiltrationFunctionality
  void centralFiltrationFunctionality(List<dynamic> list) {
    switch (list[0]) {
      case ('deleteFromMapio'):
        {
          if (list[2] == 'filterConnection') {
            if (centralFiltrationUpdated[list[1]]['filterConnection'].length !=
                1) {
              if (remover(centralFiltrationUpdated, list[1], 'filterConnection',
                  list[3], 'filter')) {
                totalFilter += 1;
              }
            }
          }
          break;
        }
      case ('addCentralFiltration'):
        {
          if (totalCentralFiltration > 0 && totalFilter > 0) {
            var add = false;
            for (var i in centralFiltrationUpdated) {
              if (i['deleted'] == true) {
                i['deleted'] = false;
                i['selection'] = 'unselect';
                i['filter'] = '1';
                i['filterConnection'] = [
                  {
                    'sNo': returnI_O_AutoIncrement(),
                    'rtu': '-',
                    'rfNo': '-',
                    'output': '-',
                    'output_type': '1',
                  }
                ];
                i['dv'] = {};
                i['pressureIn'] = {};
                i['pressureOut'] = {};
                i['pressureSwitch'] = {};
                i['diffPressureSensor'] = {};
                add = true;
                break;
              }
            }
            if (add == false) {
              centralFiltrationUpdated.add({
                'sNo': returnI_O_AutoIncrement(),
                'selection': 'unselect',
                'filter': '1',
                'filterConnection': [
                  {
                    'sNo': returnI_O_AutoIncrement(),
                    'rtu': '-',
                    'rfNo': '-',
                    'output': '-',
                    'output_type': '1',
                  }
                ],
                'dv': {},
                'pressureIn': {},
                'pressureOut': {},
                'pressureSwitch': {},
                'diffPressureSensor': {},
                'deleted': false,
              });
            }
            totalCentralFiltration = totalCentralFiltration - 1;
            totalFilter = totalFilter - 1;
          }
          break;
        }
      case ('addBatch_CF'):
        {
          for (var i = 0; i < list[1]; i++) {
            if (totalCentralFiltration > 0 && totalFilter > 0) {
              var add = false;
              var flList = [];
              for (var count = 0; count < list[2]; count++) {
                flList.add({
                  'sNo': returnI_O_AutoIncrement(),
                  'rtu': '-',
                  'rfNo': '-',
                  'output': '-',
                  'output_type': '1',
                });
              }
              for (var i in centralFiltrationUpdated) {
                if (i['deleted'] == true) {
                  i['deleted'] = false;
                  i['selection'] = 'unselect';
                  i['filter'] = '${list[2]}';
                  i['filterConnection'] = flList;
                  i['dv'] = {};
                  i['pressureIn'] = {};
                  i['pressureOut'] = {};
                  i['pressureSwitch'] = {};
                  i['diffPressureSensor'] = {};
                  add = true;
                  break;
                }
              }
              if (add == false) {
                centralFiltrationUpdated.add({
                  'sNo': returnI_O_AutoIncrement(),
                  'selection': 'unselect',
                  'filter': '${list[2]}',
                  'filterConnection': flList,
                  'dv': {},
                  'pressureIn': {},
                  'pressureOut': {},
                  'pressureSwitch': {},
                  'diffPressureSensor': {},
                  'deleted': false,
                });
              }
              totalCentralFiltration = totalCentralFiltration - 1;
              totalFilter = totalFilter - (list[2] as int);
            }
          }

          break;
        }
      case ('editPressureSwitch'):
        {
          if (totalPressureSwitch > 0) {
            if (list[2] == true) {
              centralFiltrationUpdated[list[1]]['pressureSwitch'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
              totalPressureSwitch = totalPressureSwitch - 1;
            } else {
              centralFiltrationUpdated[list[1]]['pressureSwitch'] = {};
              totalPressureSwitch = totalPressureSwitch + 1;
            }
          }
          if (totalPressureSwitch == 0) {
            if (list[2] == false) {
              centralFiltrationUpdated[list[1]]['pressureSwitch'] = {};
              totalPressureSwitch = totalPressureSwitch + 1;
            }
          }
          break;
        }
      case ('editDiffPressureSensor'):
        {
          if (totalDiffPressureSensor > 0) {
            if (list[2] == true) {
              centralFiltrationUpdated[list[1]]['diffPressureSensor'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
              totalDiffPressureSensor = totalDiffPressureSensor - 1;
            } else {
              centralFiltrationUpdated[list[1]]['diffPressureSensor'] = {};
              totalDiffPressureSensor = totalDiffPressureSensor + 1;
            }
          }
          if (totalDiffPressureSensor == 0) {
            if (list[2] == false) {
              centralFiltrationUpdated[list[1]]['diffPressureSensor'] = {};
              totalDiffPressureSensor = totalDiffPressureSensor + 1;
            }
          }
          break;
        }
      case ('centralFiltrationSelection'):
        {
          centralFiltrationSelection = list[1];
          break;
        }
      case ('editFocus'):
        {
          focus = list[1];
          break;
        }
      case ('reOrderCfSite'):
        {
          var data = centralFiltrationUpdated[list[1]];
          centralFiltrationUpdated.removeAt(list[1]);
          centralFiltrationUpdated.insert(list[2], data);
          break;
        }
      case ('centralFiltrationSelectAll'):
        {
          centralFiltrationSelectAll = list[1];
          if (list[1] == true) {
            for (var i = 0; i < centralFiltrationUpdated.length; i++) {
              centralFiltrationUpdated[i]['selection'] = 'select';
            }
          } else {
            for (var i = 0; i < centralFiltrationUpdated.length; i++) {
              centralFiltrationUpdated[i]['selection'] = 'unselect';
            }
          }
          break;
        }
      case ('editFilter'):
        {
          if (totalFilter > -1) {
            if (centralFiltrationUpdated[list[1]]['filter'] != '') {
              totalFilter = totalFilter +
                  int.parse(centralFiltrationUpdated[list[1]]['filter']);
              if (list[2] == '') {
                totalFilter = totalFilter - 0;
              } else {
                if (list[2] == '0') {
                  totalFilter = totalFilter - 1;
                } else {
                  totalFilter = totalFilter - int.parse(list[2]);
                }
              }
            } else {
              if (list[2] == '0') {
                totalFilter = totalFilter - 1;
              } else {
                totalFilter = totalFilter - int.parse(list[2]);
              }
            }
            centralFiltrationUpdated[list[1]]['filter'] = list[2];
          }
          break;
        }
      case ('editFilterSelection'):
        {
          if (centralFiltrationUpdated[list[1]]['filter'] == '') {
            centralFiltrationUpdated[list[1]]['filterConnection'] = [];
          } else {
            if (int.parse(centralFiltrationUpdated[list[1]]['filter']) >
                centralFiltrationUpdated[list[1]]['filterConnection'].length) {
              int count =
                  (int.parse(centralFiltrationUpdated[list[1]]['filter']) -
                      centralFiltrationUpdated[list[1]]['filterConnection']
                          .length) as int;
              for (var i = 0; i < count; i++) {
                centralFiltrationUpdated[list[1]]['filterConnection'].add({
                  'sNo': returnI_O_AutoIncrement(),
                  'rtu': '-',
                  'rfNo': '-',
                  'output': '-',
                  'output_type': '1',
                });
              }
            } else {
              int count = (centralFiltrationUpdated[list[1]]['filterConnection']
                      .length -
                  int.parse(centralFiltrationUpdated[list[1]]['filter']));
              for (var i = 0; i < count; i++) {
                centralFiltrationUpdated[list[1]]['filterConnection']
                    .removeLast();
              }
            }
          }
          break;
        }
      case ('editDownStreamValve'):
        {
          if (total_D_s_valve > 0) {
            if (list[2] == true) {
              centralFiltrationUpdated[list[1]]['dv'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'output': '-',
                'output_type': '1',
              };
              total_D_s_valve = total_D_s_valve - 1;
            } else {
              centralFiltrationUpdated[list[1]]['dv'] = {};
              total_D_s_valve = total_D_s_valve + 1;
            }
          }
          if (total_D_s_valve == 0) {
            if (list[2] == false) {
              centralFiltrationUpdated[list[1]]['dv'] = {};
              total_D_s_valve = total_D_s_valve + 1;
            }
          }
          break;
        }
      case ('editPressureSensor'):
        {
          if (total_p_sensor > 0) {
            if (list[2] == true) {
              centralFiltrationUpdated[list[1]]['pressureIn'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
              total_p_sensor = total_p_sensor - 1;
            } else {
              centralFiltrationUpdated[list[1]]['pressureIn'] = {};
              total_p_sensor = total_p_sensor + 1;
            }
          }
          if (total_p_sensor == 0) {
            if (list[2] == false) {
              centralFiltrationUpdated[list[1]]['pressureIn'] = {};
              total_p_sensor = total_p_sensor + 1;
            }
          }
          break;
        }
      case ('editPressureSensor_out'):
        {
          if (total_p_sensor > 0) {
            if (list[2] == true) {
              centralFiltrationUpdated[list[1]]['pressureOut'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
              total_p_sensor = total_p_sensor - 1;
            } else {
              centralFiltrationUpdated[list[1]]['pressureOut'] = {};
              total_p_sensor = total_p_sensor + 1;
            }
          }
          if (total_p_sensor == 0) {
            if (list[2] == false) {
              centralFiltrationUpdated[list[1]]['pressureOut'] = {};
              total_p_sensor = total_p_sensor + 1;
            }
          }
          break;
        }
      case ('selectCentralFiltration'):
        {
          if (centralFiltrationUpdated[list[1]]['selection'] == 'select') {
            centralFiltrationUpdated[list[1]]['selection'] = 'unselect';
          } else {
            centralFiltrationUpdated[list[1]]['selection'] = 'select';
          }
          break;
        }
      case ('deleteCentralFiltration'):
        {
          List<Map<String, dynamic>> selectedSite = [];
          for (var i = centralFiltrationUpdated.length - 1; i >= 0; i--) {
            if (centralFiltrationUpdated[i]['selection'] == 'select') {
              selectedSite.add(centralFiltrationUpdated[i]);
            }
          }
          for (var cfSite in selectedSite) {
            if (cfSite['dv'].isNotEmpty) {
              total_D_s_valve = total_D_s_valve + 1;
            }
            if (cfSite['pressureIn'].isNotEmpty) {
              total_p_sensor = total_p_sensor + 1;
            }
            if (cfSite['pressureOut'].isNotEmpty) {
              total_p_sensor = total_p_sensor + 1;
            }
            if (cfSite['pressureSwitch'].isNotEmpty) {
              totalPressureSwitch = totalPressureSwitch + 1;
            }
            if (cfSite['diffPressureSensor'].isNotEmpty) {
              totalDiffPressureSensor = totalDiffPressureSensor + 1;
            }
            if (cfSite['filter'] != '') {
              totalFilter = totalFilter + int.parse(cfSite['filter']);
            }
            if (isNew == false) {
              centralFiltrationUpdated[centralFiltrationUpdated.indexOf(cfSite)]
                  ['deleted'] = true;
            } else {
              centralFiltrationUpdated.remove(cfSite);
            }
            totalCentralFiltration = totalCentralFiltration + 1;
          }
          centralFiltrationSelectAll = false;
          centralFiltrationSelection = false;
          break;
        }
      default:
        {
          break;
        }
    }
    refreshCentralFiltrationList();
    notifyListeners();
  }

  bool remover(data, lineIndex, connection, sno, [value]) {
    bool delete = false;
    for (var i in data[lineIndex][connection]) {
      if (i['sNo'] == sno) {
        if (connection == 'injector') {
          if (i['levelSensor'].isNotEmpty) {
            totalLevelSensor += 1;
          }
          if (i['dosingMeter'].isNotEmpty) {
            totalDosingMeter += 1;
          }
        }
        data[lineIndex][connection].remove(i);
        if (value != null) {
          data[lineIndex][value] = '${int.parse(data[lineIndex][value]) - 1}';
          data[lineIndex][value] =
              data[lineIndex][value] == '0' ? '' : data[lineIndex][value];
        }
        delete = true;
        break;
      }
    }
    notifyListeners();
    return delete;
  }


  //TODO: irrigationLinesFunctionality
  void irrigationLinesFunctionality(List<dynamic> list) {
    var passingParameter = list[0].split('_');
    switch (passingParameter[0]) {
      case ('deleteFromMapio'):
        {
          if (list[2] == 'valveConnection') {
            if (irrigationLines[list[1]]['valveConnection'].length != 1) {
              if (remover(irrigationLines, list[1], 'valveConnection', list[3],
                  'valve')) {
                totalValve += 1;
              }
            }
          } else if (list[2] == 'main_valveConnection') {
            if (remover(irrigationLines, list[1], 'main_valveConnection',
                list[3], 'main_valve')) {
              totalMainValve += 1;
            }
          } else if (list[2] == 'foggerConnection') {
            if (remover(irrigationLines, list[1], 'foggerConnection', list[3],
                'fogger')) {
              totalFogger += 1;
            }
          } else if (list[2] == 'fanConnection') {
            if (remover(
                irrigationLines, list[1], 'fanConnection', list[3], 'fan')) {
              totalFan += 1;
            }
          } else if (list[2] == 'moistureSensorConnection') {
            if (remover(irrigationLines, list[1], 'moistureSensorConnection',
                list[3], 'moistureSensor')) {
              totalMoistureSensor += 1;
            }
          } else if (list[2] == 'levelSensorConnection') {
            if (remover(irrigationLines, list[1], 'levelSensorConnection',
                list[3], 'levelSensor')) {
              totalMoistureSensor += 1;
            }
          } else if (list[2] == 'injector') {
            for (var i in localDosingUpdated) {
              if (i['sNo'] == irrigationLines[list[1]]['sNo']) {
                if (i['injector'].length != 1) {
                  if (remover(localDosingUpdated, localDosingUpdated.indexOf(i),
                      'injector', list[3])) {
                    totalInjector += 1;
                  }
                }
              }
            }
          } else if (list[2] == 'boosterConnection') {
            for (var i in localDosingUpdated) {
              if (i['sNo'] == irrigationLines[list[1]]['sNo']) {
                if (remover(localDosingUpdated, localDosingUpdated.indexOf(i),
                    'boosterConnection', list[3], 'boosterPump')) {
                  totalBooster += 1;
                }
              }
              for (var inj in i['injector']) {
                if (i['boosterConnection'].isEmpty) {
                  inj['Which_Booster_Pump'] = '-';
                } else {
                  if (inj['Which_Booster_Pump']
                      .contains('${i['boosterConnection'].length + 1}')) {
                    inj['Which_Booster_Pump'] = '-';
                  }
                }
              }
            }
          } else if (list[2] == 'filterConnection') {
            for (var i in localFiltrationUpdated) {
              if (i['sNo'] == irrigationLines[list[1]]['sNo']) {
                if (i['filterConnection'].length != 1) {
                  if (remover(
                      localFiltrationUpdated,
                      localFiltrationUpdated.indexOf(i),
                      'filterConnection',
                      list[3],
                      'filter')) {
                    totalFilter += 1;
                  }
                }
              }
            }
          }
          break;
        }
      case ('addIrrigationLine'):
        {
          if (totalIrrigationLine > 0) {
            var add = false;
            for (var i in irrigationLines) {
              if (i['deleted'] == true) {
                i['deleted'] = false;
                i['valve'] = '';
                i['valveConnection'] = [
                  // {
                  //   'sNo': returnI_O_AutoIncrement(),
                  //   'rtu': '-',
                  //   'rfNo': '-',
                  //   'output': '-',
                  //   'output_type': '1',
                  // }
                ];
                i['main_valve'] = '';
                i['main_valveConnection'] = [];
                i['moistureSensor'] = '';
                i['moistureSensorConnection'] = [];
                i['levelSensor'] = '';
                i['levelSensorConnection'] = [];
                i['fogger'] = '';
                i['foggerConnection'] = [];
                i['fan'] = '';
                i['fanConnection'] = [];
                i['misting'] = '';
                i['mistingConnection'] = [];
                i['heating'] = '';
                i['heatingConnection'] = [];
                i['pesticides'] = '';
                i['pesticidesConnection'] = [];
                i['light'] = '';
                i['lightConnection'] = [];
                i['vent'] = '';
                i['ventConnection'] = [];
                i['screen'] = '';
                i['screenConnection'] = [];
                i['airCirculation'] = '';
                i['airCirculationConnection'] = [];
                i['co2'] = '';
                i['co2Connection'] = [];
                i['temperature'] = '';
                i['temperatureConnection'] = [];
                i['soilTemperature'] = '';
                i['soilTemperatureConnection'] = [];
                i['humidity'] = '';
                i['humidityConnection'] = [];
                i['Central_dosing_site'] = '-';
                i['Central_filtration_site'] = '-';
                i['Local_dosing_site'] = false;
                i['local_filtration_site'] = false;
                i['pressureIn'] = {};
                i['pressureOut'] = {};
                i['irrigationPump'] = '-';
                i['sourcePump'] = '-';
                i['agitator'] = '-';
                i['water_meter'] = {};
                i['powerSupply'] = {};
                i['pressureSwitch'] = {};
                i['isSelected'] = 'unselect';
                add = true;
                break;
              }
            }
            if (add == false) {
              irrigationLines.add(
                {
                  'sNo': returnI_O_AutoIncrement(),
                  'valve': '',
                  'deleted': false,
                  'valveConnection': [
                    // {
                    //   'sNo': returnI_O_AutoIncrement(),
                    //   'rtu': '-',
                    //   'rfNo': '-',
                    //   'output': '-',
                    //   'output_type': '1',
                    // }
                  ],
                  'main_valve': '',
                  'main_valveConnection': [],
                  'moistureSensor': '',
                  'moistureSensorConnection': [],
                  'levelSensor': '',
                  'levelSensorConnection': [],
                  'fogger': '',
                  'foggerConnection': [],
                  'fan': '',
                  'fanConnection': [],
                  'misting': '',
                  'mistingConnection': [],
                  'heating': '',
                  'heatingConnection': [],
                  'pesticides': '',
                  'pesticidesConnection': [],
                  'light': '',
                  'lightConnection': [],
                  'vent': '',
                  'ventConnection': [],
                  'screen': '',
                  'screenConnection': [],
                  'airCirculation': '',
                  'airCirculationConnection': [],
                  'co2': '',
                  'co2Connection': [],
                  'temperature': '',
                  'temperatureConnection': [],
                  'soilTemperature': '',
                  'soilTemperatureConnection': [],
                  'humidity': '',
                  'humidityConnection': [],
                  'Central_dosing_site': '-',
                  'Central_filtration_site': '-',
                  'Local_dosing_site': false,
                  'local_filtration_site': false,
                  'pressureIn': {},
                  'pressureOut': {},
                  'irrigationPump': '-',
                  'sourcePump': '-',
                  'agitator' : '-',
                  'water_meter': {},
                  'powerSupply': {},
                  'pressureSwitch': {},
                  'isSelected': 'unselect',
                },
              );
            }
            totalIrrigationLine = totalIrrigationLine - 1;
            // totalValve = totalValve - 1;
          }
          break;
        }
      case ('updateAI'):
        {
          irrigationLines[list[1]]['sNo'] = list[2];
          break;
        }
      case ('editIrrigationSelectAll'):
        {
          irrigationSelectAll = list[1];
          if (list[1] == true) {
            selection = 0;
            for (var i = 0; i < irrigationLines.length; i++) {
              irrigationLines[i]['isSelected'] = 'select';
              selection += 1;
            }
          } else {
            selection = 0;
            for (var i = 0; i < irrigationLines.length; i++) {
              irrigationLines[i]['isSelected'] = 'unselect';
            }
          }

          break;
        }
      case ('editIrrigationSelection'):
        {
          irrigationSelection = list[1];
          break;
        }
      case ('selectIrrigationLine'):
        {
          if (list[2] == true) {
            irrigationLines[list[1]]['isSelected'] = 'select';
            selection += 1;
          } else {
            irrigationLines[list[1]]['isSelected'] = 'unselect';
            selection -= 1;
          }
          break;
        }
      case 'deleteIrrigationLine':
        {
          List<int> ld = [];
          List<int> lf = [];
          irrigationSelection = false;
          irrigationSelectAll = false;
          for (var i = irrigationLines.length - 1; i >= 0; i--) {
            if (irrigationLines[i]['isSelected'] == 'select') {
              total_p_sensor = total_p_sensor +
                  (irrigationLines[i]['pressureIn'].isEmpty ? 0 : 1);
              total_p_sensor = total_p_sensor +
                  (irrigationLines[i]['pressureOut'].isEmpty ? 0 : 1);
              totalWaterMeter = totalWaterMeter +
                  (irrigationLines[i]['water_meter'].isEmpty ? 0 : 1);
              totalPowerSupply = totalPowerSupply +
                  (irrigationLines[i]['powerSupply'].isEmpty ? 0 : 1);
              totalMainValve = totalMainValve +
                  irrigationLines[i]['main_valveConnection'].length as int;
              totalMoistureSensor = totalMoistureSensor +
                  irrigationLines[i]['moistureSensorConnection'].length as int;
              totalLevelSensor = totalLevelSensor +
                  irrigationLines[i]['levelSensorConnection'].length as int;
              totalFogger = totalFogger +
                  irrigationLines[i]['foggerConnection'].length as int;
              totalFan =
                  totalFan + irrigationLines[i]['fanConnection'].length as int;
              totalValve = totalValve + int.parse(irrigationLines[i]['valve']);
              totalIrrigationLine = totalIrrigationLine + 1;
              ld.add(irrigationLines[i]['sNo']);
              lf.add(irrigationLines[i]['sNo']);
              if (isNew == false) {
                irrigationLines[i]['deleted'] = true;
              } else {
                irrigationLines.removeAt(i);
              }
            }
          }
          for (var i in ld) {
            localDosingFunctionality(['deleteLocalDosingFromLine', i]);
          }
          for (var i in lf) {
            localFiltrationFunctionality(['deleteLocalFiltrationFromLine', i]);
          }
          break;
        }
      case ('reOrderIl'):
        {
          var data = irrigationLines[list[1]];
          irrigationLines.removeAt(list[1]);
          irrigationLines.insert(list[2], data);
          break;
        }
      case ('editValveConnection'):
        {
          if (irrigationLines[list[1]]['valve'] == '') {
            irrigationLines[list[1]]['valveConnection'] = [];
          } else {
            if (int.parse(irrigationLines[list[1]]['valve']) >
                irrigationLines[list[1]]['valveConnection'].length) {
              int count = (int.parse(irrigationLines[list[1]]['valve']) -
                  irrigationLines[list[1]]['valveConnection'].length) as int;
              for (var i = 0; i < count; i++) {
                irrigationLines[list[1]]['valveConnection'].add({
                  'sNo': returnI_O_AutoIncrement(),
                  'rtu': '-',
                  'rfNo': '-',
                  'output': '-',
                  'output_type': '1',
                });
              }
            } else {
              int count = (irrigationLines[list[1]]['valveConnection'].length -
                  int.parse(irrigationLines[list[1]]['valve']));
              for (var i = 0; i < count; i++) {
                irrigationLines[list[1]]['valveConnection'].removeLast();
              }
            }
          }
          break;
        }
      case ('editValve'):
        {
          if (totalValve > -1) {
            if (irrigationLines[list[1]]['valve'] != '') {
              totalValve =
                  totalValve + int.parse(irrigationLines[list[1]]['valve']);
              if (list[2] == '') {
                totalValve = totalValve - 0;
              } else {
                if (list[2] == '0') {
                  totalValve = totalValve - 1;
                } else {
                  totalValve = totalValve - int.parse(list[2]);
                }
              }
            } else {
              if (list[2] == '0') {
                totalValve = totalValve - 1;
              } else {
                totalValve = totalValve - int.parse(list[2]);
              }
            }
            irrigationLines[list[1]]['valve'] = list[2];
          }
          break;
        }
      case ('editMainValveConnection'):
        {
          if (irrigationLines[list[1]]['main_valve'] == '') {
            irrigationLines[list[1]]['main_valveConnection'] = [];
          } else {
            if (int.parse(irrigationLines[list[1]]['main_valve']) >
                irrigationLines[list[1]]['main_valveConnection'].length) {
              int count = (int.parse(irrigationLines[list[1]]['main_valve']) -
                      irrigationLines[list[1]]['main_valveConnection'].length)
                  as int;
              for (var i = 0; i < count; i++) {
                irrigationLines[list[1]]['main_valveConnection'].add({
                  'sNo': returnI_O_AutoIncrement(),
                  'rtu': '-',
                  'rfNo': '-',
                  'output': '-',
                  'output_type': '-',
                });
              }
            } else {
              int count =
                  (irrigationLines[list[1]]['main_valveConnection'].length -
                      int.parse(irrigationLines[list[1]]['main_valve']));
              for (var i = 0; i < count; i++) {
                irrigationLines[list[1]]['main_valveConnection'].removeLast();
              }
            }
          }
          break;
        }
      case ('editMainValve'):
        {
          if (totalMainValve > -1) {
            if (irrigationLines[list[1]]['main_valve'] != '') {
              totalMainValve = totalMainValve +
                  int.parse(irrigationLines[list[1]]['main_valve']);
              if (list[2] == '') {
                totalMainValve = totalMainValve - 0;
              } else {
                if (list[2] == '0') {
                  totalMainValve = totalMainValve - 1;
                } else {
                  totalMainValve = totalMainValve - int.parse(list[2]);
                }
              }
            } else {
              if (list[2] == '0') {
                totalMainValve = totalMainValve - 1;
              } else {
                totalMainValve = totalMainValve - int.parse(list[2]);
              }
            }
            irrigationLines[list[1]]['main_valve'] = list[2];
          }
          break;
        }
      case ('editGreenHouseConnection'):
        {
          if (irrigationLines[list[1]][passingParameter[1]] == '') {
            irrigationLines[list[1]][passingParameter[2]] = [];
          } else {
            if (int.parse(irrigationLines[list[1]][passingParameter[1]]) >
                irrigationLines[list[1]][passingParameter[2]].length) {
              int count =
              (int.parse(irrigationLines[list[1]][passingParameter[1]]) -
                  irrigationLines[list[1]][passingParameter[2]]
                      .length) as int;
              for (var i = 0; i < count; i++) {
                irrigationLines[list[1]][passingParameter[2]].add({
                  'sNo': returnI_O_AutoIncrement(),
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': passingParameter[3],
                });
              }
            } else {
              int count =
              (irrigationLines[list[1]][passingParameter[2]].length -
                  int.parse(irrigationLines[list[1]][passingParameter[1]]));
              for (var i = 0; i < count; i++) {
                irrigationLines[list[1]][passingParameter[2]]
                    .removeLast();
              }
            }
          }
          break;
        }
      case ('editGreenHouseCount'):
        {
          var update = {
            'moistureSensor' : {'setter' : (value) => totalMoistureSensor = value, 'getter' : ()=> totalMoistureSensor},
            'levelSensor' : {'setter' : (value) => totalLevelSensor = value, 'getter' : ()=> totalLevelSensor},
            'fogger' : {'setter' : (value) => totalFogger = value, 'getter' : ()=> totalFogger},
            'fan' : {'setter' : (value) => totalFan = value, 'getter' : ()=> totalFan},
            'misting' : {'setter' : (value) => totalMisting = value, 'getter' : ()=> totalMisting},
            'heating' : {'setter' : (value) => totalHeating = value, 'getter' : ()=> totalHeating},
            'pesticides' : {'setter' : (value) => totalPesticides = value, 'getter' : ()=> totalPesticides},
            'light' : {'setter' : (value) => totalLight = value, 'getter' : ()=> totalLight},
            'vent' : {'setter' : (value) => totalVent = value, 'getter' : ()=> totalVent},
            'screen' : {'setter' : (value) => totalScreen = value, 'getter' : ()=> totalScreen},
            'airCirculation' : {'setter' : (value) => totalAirCirculation = value, 'getter' : ()=> totalAirCirculation},
            'co2' : {'setter' : (value) => totalCo2 = value, 'getter' : ()=> totalCo2},
            'temperature' : {'setter' : (value) => totalTempSensor = value, 'getter' : ()=> totalTempSensor},
            'soilTemperature' : {'setter' : (value) => totalSoilTempSensor = value, 'getter' : ()=> totalSoilTempSensor},
            'humidity' : {'setter' : (value) => totalHumidity = value, 'getter' : ()=> totalHumidity}
          };
          if (update[passingParameter[1]]!['getter']!()! > -1) {
            if (irrigationLines[list[1]][passingParameter[1]] != '') {
              update[passingParameter[1]]!['setter']!(
                  update[passingParameter[1]]!['getter']!()! + int.parse(irrigationLines[list[1]][passingParameter[1]])
              );
              if (list[2] == '') {
                update[passingParameter[1]]!['setter']!(
                    update[passingParameter[1]]!['getter']!()! - 0
                );
              } else {
                if (list[2] == '0') {
                  update[passingParameter[1]]!['setter']!(
                      update[passingParameter[1]]!['getter']!()! - 1
                  );
                } else {
                  update[passingParameter[1]]!['setter']!(
                      update[passingParameter[1]]!['getter']!()! - int.parse(list[2])
                  );
                }
              }
            } else {
              if (list[2] == '0') {
                update[passingParameter[1]]!['setter']!(
                    update[passingParameter[1]]!['getter']!()! - 1
                );
              } else {
                update[passingParameter[1]]!['setter']!(
                    update[passingParameter[1]]!['getter']!()! - int.parse(list[2])
                );
              }
            }
            irrigationLines[list[1]][passingParameter[1]] = list[2];
          }
          break;
        }
      case ('editMoistureSensorConnection'):
        {
          if (irrigationLines[list[1]]['moistureSensor'] == '') {
            irrigationLines[list[1]]['moistureSensorConnection'] = [];
          } else {
            if (int.parse(irrigationLines[list[1]]['moistureSensor']) >
                irrigationLines[list[1]]['moistureSensorConnection'].length) {
              int count =
                  (int.parse(irrigationLines[list[1]]['moistureSensor']) -
                      irrigationLines[list[1]]['moistureSensorConnection']
                          .length) as int;
              for (var i = 0; i < count; i++) {
                irrigationLines[list[1]]['moistureSensorConnection'].add({
                  'sNo': returnI_O_AutoIncrement(),
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': 'M-I',
                });
              }
            } else {
              int count =
                  (irrigationLines[list[1]]['moistureSensorConnection'].length -
                      int.parse(irrigationLines[list[1]]['moistureSensor']));
              for (var i = 0; i < count; i++) {
                irrigationLines[list[1]]['moistureSensorConnection']
                    .removeLast();
              }
            }
          }
          break;
        }
      case ('editMoistureSensor'):
        {
          if (totalMoistureSensor > -1) {
            if (irrigationLines[list[1]]['moistureSensor'] != '') {
              totalMoistureSensor = totalMoistureSensor +
                  int.parse(irrigationLines[list[1]]['moistureSensor']);
              if (list[2] == '') {
                totalMoistureSensor = totalMoistureSensor - 0;
              } else {
                if (list[2] == '0') {
                  totalMoistureSensor = totalMoistureSensor - 1;
                } else {
                  totalMoistureSensor =
                      totalMoistureSensor - int.parse(list[2]);
                }
              }
            } else {
              if (list[2] == '0') {
                totalMoistureSensor = totalMoistureSensor - 1;
              } else {
                totalMoistureSensor = totalMoistureSensor - int.parse(list[2]);
              }
            }
            irrigationLines[list[1]]['moistureSensor'] = list[2];
          }
          break;
        }
      case ('editLevelSensorConnection'):
        {
          if (irrigationLines[list[1]]['levelSensor'] == '') {
            irrigationLines[list[1]]['levelSensorConnection'] = [];
          } else {
            if (int.parse(irrigationLines[list[1]]['levelSensor']) >
                irrigationLines[list[1]]['levelSensorConnection'].length) {
              int count = (int.parse(irrigationLines[list[1]]['levelSensor']) -
                      irrigationLines[list[1]]['levelSensorConnection'].length)
                  as int;
              for (var i = 0; i < count; i++) {
                irrigationLines[list[1]]['levelSensorConnection'].add({
                  'sNo': returnI_O_AutoIncrement(),
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': '-',
                });
              }
            } else {
              int count =
                  (irrigationLines[list[1]]['levelSensorConnection'].length -
                      int.parse(irrigationLines[list[1]]['levelSensor']));
              for (var i = 0; i < count; i++) {
                irrigationLines[list[1]]['levelSensorConnection'].removeLast();
              }
            }
          }
          break;
        }
      case ('editLevelSensor'):
        {
          if (totalLevelSensor > -1) {
            if (irrigationLines[list[1]]['levelSensor'] != '') {
              totalLevelSensor = totalLevelSensor +
                  int.parse(irrigationLines[list[1]]['levelSensor']);
              if (list[2] == '') {
                totalLevelSensor = totalLevelSensor - 0;
              } else {
                if (list[2] == '0') {
                  totalLevelSensor = totalLevelSensor - 1;
                } else {
                  totalLevelSensor = totalLevelSensor - int.parse(list[2]);
                }
              }
            } else {
              if (list[2] == '0') {
                totalLevelSensor = totalLevelSensor - 1;
              } else {
                totalLevelSensor = totalLevelSensor - int.parse(list[2]);
              }
            }
            irrigationLines[list[1]]['levelSensor'] = list[2];
          }
          break;
        }
      case ('editFoggerConnection'):
        {
          if (irrigationLines[list[1]]['fogger'] == '') {
            irrigationLines[list[1]]['foggerConnection'] = [];
          } else {
            if (int.parse(irrigationLines[list[1]]['fogger']) >
                irrigationLines[list[1]]['foggerConnection'].length) {
              int count = (int.parse(irrigationLines[list[1]]['fogger']) -
                  irrigationLines[list[1]]['foggerConnection'].length) as int;
              for (var i = 0; i < count; i++) {
                irrigationLines[list[1]]['foggerConnection'].add({
                  'sNo': returnI_O_AutoIncrement(),
                  'rtu': '-',
                  'rfNo': '-',
                  'output': '-',
                  'output_type': '-',
                });
              }
            } else {
              int count = (irrigationLines[list[1]]['foggerConnection'].length -
                  int.parse(irrigationLines[list[1]]['fogger']));
              for (var i = 0; i < count; i++) {
                irrigationLines[list[1]]['foggerConnection'].removeLast();
              }
            }
          }
          break;
        }
      case ('editFogger'):
        {
          if (totalFogger > -1) {
            if (irrigationLines[list[1]]['fogger'] != '') {
              totalFogger =
                  totalFogger + int.parse(irrigationLines[list[1]]['fogger']);
              if (list[2] == '') {
                totalFogger = totalFogger - 0;
              } else {
                if (list[2] == '0') {
                  totalFogger = totalFogger - 1;
                } else {
                  totalFogger = totalFogger - int.parse(list[2]);
                }
              }
            } else {
              if (list[2] == '0') {
                totalFogger = totalFogger - 1;
              } else {
                totalFogger = totalFogger - int.parse(list[2]);
              }
            }
            irrigationLines[list[1]]['fogger'] = list[2];
          }
          break;
        }
      case ('editFanConnection'):
        {
          if (irrigationLines[list[1]]['fan'] == '') {
            irrigationLines[list[1]]['fanConnection'] = [];
          } else {
            if (int.parse(irrigationLines[list[1]]['fan']) >
                irrigationLines[list[1]]['fanConnection'].length) {
              int count = (int.parse(irrigationLines[list[1]]['fan']) -
                  irrigationLines[list[1]]['fanConnection'].length) as int;
              for (var i = 0; i < count; i++) {
                irrigationLines[list[1]]['fanConnection'].add({
                  'sNo': returnI_O_AutoIncrement(),
                  'rtu': '-',
                  'rfNo': '-',
                  'output': '-',
                  'output_type': '-',
                });
              }
            } else {
              int count = (irrigationLines[list[1]]['fanConnection'].length -
                  int.parse(irrigationLines[list[1]]['fan']));
              for (var i = 0; i < count; i++) {
                irrigationLines[list[1]]['fanConnection'].removeLast();
              }
            }
          }
          break;
        }
      case ('editFan'):
        {
          if (totalFan > -1) {
            if (irrigationLines[list[1]]['fan'] != '') {
              totalFan = totalFan + int.parse(irrigationLines[list[1]]['fan']);
              if (list[2] == '') {
                totalFan = totalFan - 0;
              } else {
                if (list[2] == '0') {
                  totalFan = totalFan - 1;
                } else {
                  totalFan = totalFan - int.parse(list[2]);
                }
              }
            } else {
              if (list[2] == '0') {
                totalFan = totalFan - 1;
              } else {
                totalFan = totalFan - int.parse(list[2]);
              }
            }
            irrigationLines[list[1]]['fan'] = list[2];
          }
          break;
        }
      case ('connectionLoss'):
        {
          for (var val in list[1]) {
            if (val.isNotEmpty) {
              if (val['rtu'] == list[2]) {
                val['rfNo'] = '-';
                if (list[3] == 'input') {
                  val['input'] = '-';
                } else {
                  val['output'] = '-';
                }
                val['rtu'] = '-';
              }
            }
          }
        }
      case ('editLocalDosing'):
        {
          irrigationLines[list[1]]['Local_dosing_site'] = list[2];
          if (list[2] == true) {
            localDosingFunctionality([
              'addLocalDosing',
              irrigationLines[list[1]]['sNo'],
              list[4],
              list[5],
              list[6]
            ]);
          } else {
            localDosingFunctionality(
                ['deleteLocalDosingFromLine', irrigationLines[list[1]]['sNo']]);
          }
          break;
        }
      case ('editLocalFiltration'):
        {
          irrigationLines[list[1]]['local_filtration_site'] = list[2];
          if (list[2] == true) {
            localFiltrationFunctionality(
                ['addFiltrationDosing', irrigationLines[list[1]]['sNo']]);
          } else {
            localFiltrationFunctionality([
              'deleteLocalFiltrationFromLine',
              irrigationLines[list[1]]['sNo']
            ]);
          }
          break;
        }
      case ('editPressureSensorInConnection'):
        {
          if (total_p_sensor > 0) {
            if (list[2] == true) {
              irrigationLines[list[1]]['pressureIn'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
              total_p_sensor = total_p_sensor - 1;
            } else {
              irrigationLines[list[1]]['pressureIn'] = {};
              total_p_sensor = total_p_sensor + 1;
            }
          }
          if (total_p_sensor == 0) {
            if (list[2] == false) {
              irrigationLines[list[1]]['pressureIn'] = {};
              total_p_sensor = total_p_sensor + 1;
            }
          }
          break;
        }
      case ('editPressureSensorOutConnection'):
        {
          if (total_p_sensor > 0) {
            if (list[2] == true) {
              irrigationLines[list[1]]['pressureOut'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
              total_p_sensor = total_p_sensor - 1;
            } else {
              irrigationLines[list[1]]['pressureOut'] = {};
              total_p_sensor = total_p_sensor + 1;
            }
          }
          if (total_p_sensor == 0) {
            if (list[2] == false) {
              irrigationLines[list[1]]['pressureOut'] = {};
              total_p_sensor = total_p_sensor + 1;
            }
          }
          break;
        }
      case ('editCentralDosing'):
        {
          irrigationLines[list[1]]['Central_dosing_site'] = list[2];
          break;
        }
      case ('editCentralFiltration'):
        {
          irrigationLines[list[1]]['Central_filtration_site'] = list[2];
          break;
        }
      case ('editAssigningParameterForLine'):
        {
          var key = ('${list[2]}' == '${AssigningParameterForLine.sourcePump}') ? 'sourcePump' : ('${list[2]}' == '${AssigningParameterForLine.irrigationPump}') ? 'irrigationPump' : 'agitator';
          irrigationLines[list[1]][key] = list[3];
          break;
        }
      case ('editWaterMeter'):
        {
          if (totalWaterMeter > 0) {
            if (list[2] == true) {
              irrigationLines[list[1]]['water_meter'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': 'P-I',
              };
              totalWaterMeter = totalWaterMeter - 1;
            } else {
              irrigationLines[list[1]]['water_meter'] = {};
              totalWaterMeter = totalWaterMeter + 1;
            }
          }
          if (totalWaterMeter == 0) {
            if (list[2] == false) {
              irrigationLines[list[1]]['water_meter'] = {};
              totalWaterMeter = totalWaterMeter + 1;
            }
          }
          break;
        }
      case ('editTotalPowerSupply'):
        {
          if (totalPowerSupply > 0) {
            if (list[2] == true) {
              irrigationLines[list[1]]['powerSupply'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': 'O-Smart-Plus',
                'rfNo': '-',
                'input': '-',
                'input_type': 'A-I',
              };
              totalPowerSupply = totalPowerSupply - 1;
            } else {
              irrigationLines[list[1]]['powerSupply'] = {};
              totalPowerSupply = totalPowerSupply + 1;
            }
          }
          if (totalPowerSupply == 0) {
            if (list[2] == false) {
              irrigationLines[list[1]]['powerSupply'] = {};
              totalPowerSupply = totalPowerSupply + 1;
            }
          }
          break;
        }
      case ('editTotalPressureSwitch'):
        {
          if (totalPressureSwitch > 0) {
            if (list[2] == true) {
              irrigationLines[list[1]]['pressureSwitch'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': 'O-Smart-Plus',
                'rfNo': '-',
                'input': '-',
                'input_type': 'D-I',
              };
              totalPressureSwitch = totalPressureSwitch - 1;
            } else {
              irrigationLines[list[1]]['pressureSwitch'] = {};
              totalPressureSwitch = totalPressureSwitch + 1;
            }
          }
          if (totalPressureSwitch == 0) {
            if (list[2] == false) {
              irrigationLines[list[1]]['pressureSwitch'] = {};
              totalPressureSwitch = totalPressureSwitch + 1;
            }
          }

          break;
        }
    }
    notifyListeners();
  }

  //TODO: setLine
  int setLine(int autoIncrement) {
    int value = 0;
    for (var i in irrigationLines) {
      if (i['sNo'] == autoIncrement) {
        value = irrigationLines.indexOf(i);
      }
    }
    return value;
  }

  //TODO: localDosingFunctionality
  void localDosingFunctionality(List<dynamic> list) {
    switch (list[0]) {
      case ('addLocalDosing'):
        {
          if (totalInjector > 0) {
            localDosingUpdated.add({
              'line': setLine(list[1]) + 1,
              'sNo': list[1],
              'selection': 'unselect',
              'injector': addBatchInjector(list[2]),
              'boosterPump': '',
              'boosterConnection': [],
              'ec': '',
              'ecConnection': [],
              'ph': '',
              'phConnection': [],
              'pressureSwitch': {},
              'agitator': '-',
            });
          }
          localDosingUpdated.sort((a, b) => a['line'].compareTo(b['line']));
          break;
        }
      case ('editAgitator') : {
        localDosingUpdated[list[1]]['agitator'] = list[2];
      }
      case ('edit_l_DosingSelection'):
        {
          l_dosingSelection = list[1];
          break;
        }
      case ('edit_l_DosingSelectAll'):
        {
          l_dosingSelectAll = list[1];
          for (var i in localDosingUpdated) {
            i['selection'] = list[1] == true ? 'select' : 'unselect';
          }
          break;
        }
      case ('editDosingMeter'):
        {
          if (totalDosingMeter > 0) {
            if (list[3] == true) {
              localDosingUpdated[list[1]]['injector'][list[2]]
                  ['dosingMeter'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
              totalDosingMeter = totalDosingMeter - 1;
            } else {
              localDosingUpdated[list[1]]['injector'][list[2]]
                  ['dosingMeter'] = {};
              totalDosingMeter = totalDosingMeter + 1;
            }
          }
          if (totalDosingMeter == 0) {
            if (list[3] == false) {
              localDosingUpdated[list[1]]['injector'][list[2]]
                  ['dosingMeter'] = {};
              totalDosingMeter = totalDosingMeter + 1;
            }
          }
          break;
        }
      case ('editLevelSensor'):
        {
          if (totalLevelSensor > 0) {
            if (list[3] == true) {
              localDosingUpdated[list[1]]['injector'][list[2]]
                  ['levelSensor'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
              totalLevelSensor = totalLevelSensor - 1;
            } else {
              localDosingUpdated[list[1]]['injector'][list[2]]
                  ['levelSensor'] = {};
              totalLevelSensor = totalLevelSensor + 1;
            }
          }
          if (totalLevelSensor == 0) {
            if (list[3] == false) {
              localDosingUpdated[list[1]]['injector'][list[2]]
                  ['levelSensor'] = {};
              totalLevelSensor = totalLevelSensor + 1;
            }
          }
          break;
        }
      case ('editInjectorType'):
        {
          localDosingUpdated[list[1]]['injector'][list[2]]['injectorType'] =
              list[3];
          break;
        }
      case ('editPressureSwitch'):
        {
          if (totalPressureSwitch > 0) {
            if (list[2] == true) {
              localDosingUpdated[list[1]]['pressureSwitch'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
              totalPressureSwitch = totalPressureSwitch - 1;
            } else {
              localDosingUpdated[list[1]]['pressureSwitch'] = {};
              totalPressureSwitch = totalPressureSwitch + 1;
            }
          }
          if (totalPressureSwitch == 0) {
            if (list[2] == false) {
              localDosingUpdated[list[1]]['pressureSwitch'] = {};
              totalPressureSwitch = totalPressureSwitch + 1;
            }
          }
          break;
        }
      case ('selectLocalDosing'):
        {
          if (localDosingUpdated[list[1]]['selection'] == 'unselect') {
            localDosingUpdated[list[1]]['selection'] = 'select';
            selection += 1;
          } else {
            localDosingUpdated[list[1]]['selection'] = 'unselect';
            selection -= 1;
          }
          break;
        }
      case ('deleteLocalDosing'):
        {
          List<Map<String, dynamic>> selectedSite = [];
          for (var i = localDosingUpdated.length - 1; i >= 0; i--) {
            if (localDosingUpdated[i]['selection'] == 'select') {
              selectedSite.add(localDosingUpdated[i]);
            }
          }
          for (var i in selectedSite) {
            totalInjector = totalInjector + i['injector'].length as int;
            totalBooster = totalBooster + i['boosterConnection'].length as int;
            totalEcSensor = totalEcSensor + i['ecConnection'].length as int;
            totalPhSensor = totalPhSensor + i['phConnection'].length as int;
            if (i['pressureSwitch'].isNotEmpty) {
              totalPressureSwitch = totalPressureSwitch + 1;
            }
            for (var inj in i['injector']) {
              if (inj['dosingMeter'].isNotEmpty) {
                totalDosingMeter = totalDosingMeter + 1;
              }
            }
            for (var irr in irrigationLines) {
              if (irr['sNo'] == i['sNo']) {
                irr['Local_dosing_site'] = false;
              }
            }
            localDosingUpdated.remove(i);
          }
          break;
        }
      case ('editBoosterPumpSelection'):
        {
          if (localDosingUpdated[list[1]]['boosterPump'] == '') {
            localDosingUpdated[list[1]]['boosterConnection'] = [];
            for (var inj = 0;
                inj < localDosingUpdated[list[1]]['injector'].length;
                inj++) {
              localDosingUpdated[list[1]]['injector'][inj]
                  ['Which_Booster_Pump'] = '-';
              localDosingUpdated[list[1]]['injector'][inj]['injectorType'] =
                  'Venturi';
            }
          } else {
            if (int.parse(localDosingUpdated[list[1]]['boosterPump']) >
                localDosingUpdated[list[1]]['boosterConnection'].length) {
              int count =
                  (int.parse(localDosingUpdated[list[1]]['boosterPump']) -
                      localDosingUpdated[list[1]]['boosterConnection']
                          .length) as int;
              for (var inj = 0;
                  inj < localDosingUpdated[list[1]]['injector'].length;
                  inj++) {
                if (localDosingUpdated[list[1]]['injector'][inj]
                        ['Which_Booster_Pump'] ==
                    '-') {
                  localDosingUpdated[list[1]]['injector'][inj]
                      ['Which_Booster_Pump'] = 'BP 1';
                }
              }

              for (var i = 0; i < count; i++) {
                localDosingUpdated[list[1]]['boosterConnection'].add({
                  'sNo': returnI_O_AutoIncrement(),
                  'rtu': '-',
                  'rfNo': '-',
                  'output': '-',
                  'output_type': '1',
                });
              }
            } else {
              int count =
                  (localDosingUpdated[list[1]]['boosterConnection'].length -
                      int.parse(localDosingUpdated[list[1]]['boosterPump']));
              for (var i = 0; i < count; i++) {
                for (var inj = 0;
                    inj < localDosingUpdated[list[1]]['injector'].length;
                    inj++) {
                  if (localDosingUpdated[list[1]]['injector'][inj]
                          ['Which_Booster_Pump']
                      .contains(
                          '${localDosingUpdated[list[1]]['boosterConnection'].length}')) {
                    localDosingUpdated[list[1]]['injector'][inj]
                        ['Which_Booster_Pump'] = 'BP 1';
                  }
                }
                localDosingUpdated[list[1]]['boosterConnection'].removeLast();
              }
            }
          }
          break;
        }
      case ('editEcSelection'):
        {
          if (localDosingUpdated[list[1]]['ec'] == '') {
            localDosingUpdated[list[1]]['ecConnection'] = [];
          } else {
            if (int.parse(localDosingUpdated[list[1]]['ec']) >
                localDosingUpdated[list[1]]['ecConnection'].length) {
              int count = (int.parse(localDosingUpdated[list[1]]['ec']) -
                  localDosingUpdated[list[1]]['ecConnection'].length) as int;
              for (var i = 0; i < count; i++) {
                localDosingUpdated[list[1]]['ecConnection'].add({
                  'sNo': returnI_O_AutoIncrement(),
                  'rtu': 'O-Smart-Plus',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': 'A-I',
                });
              }
            } else {
              int count = (localDosingUpdated[list[1]]['ecConnection'].length -
                  int.parse(localDosingUpdated[list[1]]['ec']));
              for (var i = 0; i < count; i++) {
                localDosingUpdated[list[1]]['ecConnection'].removeLast();
              }
            }
          }
          break;
        }
      case ('editPhSelection'):
        {
          if (localDosingUpdated[list[1]]['ph'] == '') {
            localDosingUpdated[list[1]]['phConnection'] = [];
          } else {
            if (int.parse(localDosingUpdated[list[1]]['ph']) >
                localDosingUpdated[list[1]]['phConnection'].length) {
              int count = (int.parse(localDosingUpdated[list[1]]['ph']) -
                  localDosingUpdated[list[1]]['phConnection'].length) as int;
              for (var i = 0; i < count; i++) {
                localDosingUpdated[list[1]]['phConnection'].add({
                  'sNo': returnI_O_AutoIncrement(),
                  'rtu': '-',
                  'rfNo': '-',
                  'input': '-',
                  'input_type': 'A-I',
                });
              }
            } else {
              int count = (localDosingUpdated[list[1]]['phConnection'].length -
                  int.parse(localDosingUpdated[list[1]]['ph']));
              for (var i = 0; i < count; i++) {
                localDosingUpdated[list[1]]['phConnection'].removeLast();
              }
            }
          }
          break;
        }
      case ('editBoosterPump'):
        {
          if (totalBooster > -1) {
            if (localDosingUpdated[list[1]]['boosterPump'] != '') {
              totalBooster = totalBooster +
                  int.parse(localDosingUpdated[list[1]]['boosterPump']);
              if (list[2] == '') {
                totalBooster = totalBooster - 0;
              } else {
                if (list[2] == '0') {
                  totalBooster = totalBooster - 1;
                } else {
                  totalBooster = totalBooster - int.parse(list[2]);
                }
              }
            } else {
              if (list[2] == '0') {
                totalBooster = totalBooster - 1;
              } else {
                totalBooster = totalBooster - int.parse(list[2]);
              }
            }
            localDosingUpdated[list[1]]['boosterPump'] = list[2];
          }
          break;
        }
      case ('boosterSelectionForInjector'):
        {
          localDosingUpdated[list[1]]['injector'][list[2]]
              ['Which_Booster_Pump'] = list[3];
          break;
        }
      case ('editEcSensor'):
        {
          if (totalEcSensor > -1) {
            if (localDosingUpdated[list[1]]['ec'] != '') {
              totalEcSensor =
                  totalEcSensor + int.parse(localDosingUpdated[list[1]]['ec']);
              if (list[2] == '') {
                totalEcSensor = totalEcSensor - 0;
              } else {
                if (list[2] == '0') {
                  totalEcSensor = totalEcSensor - 1;
                } else {
                  totalEcSensor = totalEcSensor - int.parse(list[2]);
                }
              }
            } else {
              if (list[2] == '0') {
                totalEcSensor = totalEcSensor - 1;
              } else {
                totalEcSensor = totalEcSensor - int.parse(list[2]);
              }
            }
            localDosingUpdated[list[1]]['ec'] = list[2];
          }
          break;
        }
      case ('editPhSensor'):
        {
          if (totalPhSensor > -1) {
            if (localDosingUpdated[list[1]]['ph'] != '') {
              totalPhSensor =
                  totalPhSensor + int.parse(localDosingUpdated[list[1]]['ph']);
              if (list[2] == '') {
                totalPhSensor = totalPhSensor - 0;
              } else {
                if (list[2] == '0') {
                  totalPhSensor = totalPhSensor - 1;
                } else {
                  totalPhSensor = totalPhSensor - int.parse(list[2]);
                }
              }
            } else {
              if (list[2] == '0') {
                totalPhSensor = totalPhSensor - 1;
              } else {
                totalPhSensor = totalPhSensor - int.parse(list[2]);
              }
            }
            localDosingUpdated[list[1]]['ph'] = list[2];
          }
          break;
        }
      case ('deleteLocalDosingFromLine'):
        {
          List<Map<String, dynamic>> Deletelist = [];
          for (var i = 0; i < localDosingUpdated.length; i++) {
            if (localDosingUpdated[i]['sNo'] == list[1]) {
              Deletelist.add(localDosingUpdated[i]);
            }
          }
          for (var i in Deletelist) {
            if (localDosingUpdated.contains(i)) {
              totalInjector = totalInjector + i['injector'].length as int;
              totalBooster =
                  totalBooster + i['boosterConnection'].length as int;
              totalEcSensor = totalEcSensor + i['ecConnection'].length as int;
              totalPhSensor = totalPhSensor + i['phConnection'].length as int;
              if (i['pressureSwitch'].isNotEmpty) {
                totalPressureSwitch = totalPressureSwitch + 1;
              }
              for (var i in i['injector']) {
                if (i['dosingMeter'].isNotEmpty) {
                  totalDosingMeter = totalDosingMeter + 1;
                }
              }
              localDosingUpdated.remove(i);
            }
          }
          for (var i in localDosingUpdated) {
            i['line'] = setLine(i['sNo']) + 1;
          }
          break;
        }
      default:
        {
          break;
        }
    }
    notifyListeners();
  }

  //TODO: localFiltrationFunctionality
  void localFiltrationFunctionality(List<dynamic> list) {
    switch (list[0]) {
      case ('addFiltrationDosing'):
        {
          totalFilter -= 1;
          localFiltrationUpdated.add({
            'line': setLine(list[1]) + 1,
            'sNo': list[1],
            'selection': 'unselect',
            'filter': '1',
            'filterConnection': [
              {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'output': '-',
                'output_type': '1',
              }
            ],
            'dv': {},
            'pressureIn': {},
            'pressureOut': {},
            'pressureSwitch': {},
            'diffPressureSensor': {},
          });
          localFiltrationUpdated.sort((a, b) => a['line'].compareTo(b['line']));

          break;
        }
      case ('editPressureSwitch'):
        {
          if (totalPressureSwitch > 0) {
            if (list[2] == true) {
              localFiltrationUpdated[list[1]]['pressureSwitch'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
              totalPressureSwitch = totalPressureSwitch - 1;
            } else {
              localFiltrationUpdated[list[1]]['pressureSwitch'] = {};
              totalPressureSwitch = totalPressureSwitch + 1;
            }
          }
          if (totalPressureSwitch == 0) {
            if (list[2] == false) {
              localFiltrationUpdated[list[1]]['pressureSwitch'] = {};
              totalPressureSwitch = totalPressureSwitch + 1;
            }
          }

          break;
        }
      case ('editDiffPressureSensor'):
        {
          if (totalDiffPressureSensor > 0) {
            if (list[2] == true) {
              localFiltrationUpdated[list[1]]['diffPressureSensor'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
              totalDiffPressureSensor = totalDiffPressureSensor - 1;
            } else {
              localFiltrationUpdated[list[1]]['diffPressureSensor'] = {};
              totalDiffPressureSensor = totalDiffPressureSensor + 1;
            }
          }
          if (totalDiffPressureSensor == 0) {
            if (list[2] == false) {
              localFiltrationUpdated[list[1]]['diffPressureSensor'] = {};
              totalDiffPressureSensor = totalDiffPressureSensor + 1;
            }
          }
          break;
        }
      case ('edit_l_filtrationSelection'):
        {
          l_filtrationSelection = list[1];
          break;
        }
      case ('edit_l_filtrationSelectALL'):
        {
          if (list[1] == true) {
            for (var i in localFiltrationUpdated) {
              i['selection'] = 'select';
            }
          } else {
            for (var i in localFiltrationUpdated) {
              i['selection'] = 'unselect';
            }
          }
          l_filtrationSelectALL = list[1];
          break;
        }
      case ('editFilter'):
        {
          if (totalFilter > -1) {
            if (localFiltrationUpdated[list[1]]['filter'] != '') {
              totalFilter = totalFilter +
                  int.parse(localFiltrationUpdated[list[1]]['filter']);
              if (list[2] == '') {
                totalFilter = totalFilter - 0;
              } else {
                if (list[2] == '0') {
                  totalFilter = totalFilter - 1;
                } else {
                  totalFilter = totalFilter - int.parse(list[2]);
                }
              }
            } else {
              if (list[2] == '0') {
                totalFilter = totalFilter - 1;
              } else {
                totalFilter = totalFilter - int.parse(list[2]);
              }
            }
            localFiltrationUpdated[list[1]]['filter'] = list[2];
          }
          break;
        }
      case ('editFilterSelection'):
        {
          if (localFiltrationUpdated[list[1]]['filter'] == '') {
            localFiltrationUpdated[list[1]]['filterConnection'] = [];
          } else {
            if (int.parse(localFiltrationUpdated[list[1]]['filter']) >
                localFiltrationUpdated[list[1]]['filterConnection'].length) {
              int count =
                  (int.parse(localFiltrationUpdated[list[1]]['filter']) -
                      localFiltrationUpdated[list[1]]['filterConnection']
                          .length) as int;
              for (var i = 0; i < count; i++) {
                localFiltrationUpdated[list[1]]['filterConnection'].add({
                  'sNo': returnI_O_AutoIncrement(),
                  'rtu': '-',
                  'rfNo': '-',
                  'output': '-',
                  'output_type': '1',
                });
              }
            } else {
              int count =
                  (localFiltrationUpdated[list[1]]['filterConnection'].length -
                      int.parse(localFiltrationUpdated[list[1]]['filter']));
              for (var i = 0; i < count; i++) {
                localFiltrationUpdated[list[1]]['filterConnection']
                    .removeLast();
              }
            }
          }
          break;
        }
      case ('editDownStreamValve'):
        {
          if (total_D_s_valve > 0) {
            if (list[2] == true) {
              localFiltrationUpdated[list[1]]['dv'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'output': '-',
                'output_type': '1',
              };
              total_D_s_valve = total_D_s_valve - 1;
            } else {
              localFiltrationUpdated[list[1]]['dv'] = {};
              total_D_s_valve = total_D_s_valve + 1;
            }
          }
          if (total_D_s_valve == 0) {
            if (list[2] == false) {
              localFiltrationUpdated[list[1]]['dv'] = {};
              total_D_s_valve = total_D_s_valve + 1;
            }
          }
          break;
        }
      case ('editPressureSensor'):
        {
          if (total_p_sensor > 0) {
            if (list[2] == true) {
              localFiltrationUpdated[list[1]]['pressureIn'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
              total_p_sensor = total_p_sensor - 1;
            } else {
              localFiltrationUpdated[list[1]]['pressureIn'] = {};
              total_p_sensor = total_p_sensor + 1;
            }
          }
          if (total_p_sensor == 0) {
            if (list[2] == false) {
              localFiltrationUpdated[list[1]]['pressureIn'] = {};
              total_p_sensor = total_p_sensor + 1;
            }
          }
          break;
        }
      case ('editPressureSensor_out'):
        {
          if (total_p_sensor > 0) {
            if (list[2] == true) {
              localFiltrationUpdated[list[1]]['pressureOut'] = {
                'sNo': returnI_O_AutoIncrement(),
                'rtu': '-',
                'rfNo': '-',
                'input': '-',
                'input_type': '-',
              };
              total_p_sensor = total_p_sensor - 1;
            } else {
              localFiltrationUpdated[list[1]]['pressureOut'] = {};
              total_p_sensor = total_p_sensor + 1;
            }
          }
          if (total_p_sensor == 0) {
            if (list[2] == false) {
              localFiltrationUpdated[list[1]]['pressureOut'] = {};
              total_p_sensor = total_p_sensor + 1;
            }
          }
          break;
        }
      case ('selectLocalFiltration'):
        {
          if (localFiltrationUpdated[list[1]]['selection'] == 'select') {
            localFiltrationUpdated[list[1]]['selection'] = 'unselect';
            selection -= 1;
          } else {
            localFiltrationUpdated[list[1]]['selection'] = 'select';
            selection += 1;
          }
          break;
        }
      case ('localFiltrationSelectAll'):
        {
          if (list[1] == true) {
            for (var i in localDosingUpdated) {
              i['selection'] = 'select';
            }
          } else {
            for (var i in localDosingUpdated) {
              i['selection'] = 'unselect';
            }
          }
          break;
        }
      case ('deleteLocalFiltrationFromLine'):
        {
          List<Map<String, dynamic>> selectedSite = [];
          for (var i in localFiltrationUpdated) {
            if (i['sNo'] == list[1]) {
              selectedSite.add(i);
            }
          }
          for (var i in selectedSite) {
            if (localFiltrationUpdated.contains(i)) {
              totalFilter += i['filterConnection'].length as int;
              if (i['dv'].isNotEmpty) {
                total_D_s_valve += 1;
              }
              if (i['pressureIn'].isNotEmpty) {
                total_p_sensor += 1;
              }
              if (i['pressureOut'].isNotEmpty) {
                total_p_sensor += 1;
              }
              if (i['pressureSwitch'].isNotEmpty) {
                totalPressureSwitch += 1;
              }
              if (i['diffPressureSensor'].isNotEmpty) {
                totalDiffPressureSensor += 1;
              }
              localFiltrationUpdated.remove(i);
            }
          }
          for (var i in localFiltrationUpdated) {
            i['line'] = setLine(i['sNo']) + 1;
          }
          break;
        }
      case ('deleteLocalFiltration'):
        {
          List<Map<String, dynamic>> selectedSite = [];
          for (var i = localFiltrationUpdated.length - 1; i >= 0; i--) {
            if (localFiltrationUpdated[i]['selection'] == 'select') {
              selectedSite.add(localFiltrationUpdated[i]);
            }
          }
          for (var cfSite in selectedSite) {
            if (cfSite['dv'].isNotEmpty) {
              total_D_s_valve = total_D_s_valve + 1;
            }
            if (cfSite['pressureIn'].isNotEmpty) {
              total_p_sensor = total_p_sensor + 1;
            }
            if (cfSite['pressureOut'].isNotEmpty) {
              total_p_sensor = total_p_sensor + 1;
            }
            if (cfSite['pressureSwitch'].isNotEmpty) {
              totalPressureSwitch = totalPressureSwitch + 1;
            }
            if (cfSite['diffPressureSensor'].isNotEmpty) {
              totalDiffPressureSensor += 1;
            }
            if (cfSite['filter'] != '') {
              totalFilter = totalFilter + int.parse(cfSite['filter']);
            }
            for (var irr in irrigationLines) {
              if (irr['sNo'] == cfSite['sNo']) {
                irr['local_filtration_site'] = false;
              }
            }
            localFiltrationUpdated.remove(cfSite);
          }

          l_filtrationSelectALL = false;
          l_filtrationSelection = false;

          break;
        }
      default:
        {
          break;
        }
    }
    notifyListeners();
  }

  //TODO: mappingOfOutputsFunctionality
  void mappingOfOutputsFunctionality(List<dynamic> list) {
    switch (list[0]) {
      case ('m_o_line'):
        {
          if (list[4] == 'rtu') {
            if (irrigationLines[list[1]][list[2]][list[3]][list[4]] !=
                list[5]) {
              irrigationLines[list[1]][list[2]][list[3]]['rfNo'] = '-';
              irrigationLines[list[1]][list[2]][list[3]]['output'] = '-';
            }
          } else if (list[4] == 'rfNo') {
            if (irrigationLines[list[1]][list[2]][list[3]][list[4]] !=
                list[5]) {
              irrigationLines[list[1]][list[2]][list[3]]['output'] = '-';
            }
          }
          irrigationLines[list[1]][list[2]][list[3]][list[4]] = list[5];
          break;
        }
      case ('m_o_localDosing'):
        {
          if (list[4] == 'rtu') {
            if (localDosingUpdated[list[1]][list[2]][list[3]][list[4]] !=
                list[5]) {
              localDosingUpdated[list[1]][list[2]][list[3]]['rfNo'] = '-';
              localDosingUpdated[list[1]][list[2]][list[3]]['output'] = '-';
            }
          } else if (list[4] == 'rfNo') {
            if (localDosingUpdated[list[1]][list[2]][list[3]][list[4]] !=
                list[5]) {
              localDosingUpdated[list[1]][list[2]][list[3]]['output'] = '-';
            }
          } else if (list[4] == 'output') {}
          localDosingUpdated[list[1]][list[2]][list[3]][list[4]] = list[5];
          break;
        }
      case ('m_o_centralDosing'):
        {
          if (list[4] == 'rtu') {
            if (centralDosingUpdated[list[1]][list[2]][list[3]][list[4]] !=
                list[5]) {
              centralDosingUpdated[list[1]][list[2]][list[3]]['rfNo'] = '-';
              centralDosingUpdated[list[1]][list[2]][list[3]]['output'] = '-';
            }
          } else if (list[4] == 'rfNo') {
            if (centralDosingUpdated[list[1]][list[2]][list[3]][list[4]] !=
                list[5]) {
              centralDosingUpdated[list[1]][list[2]][list[3]]['output'] = '-';
            }
          } else if (list[4] == 'output') {}
          centralDosingUpdated[list[1]][list[2]][list[3]][list[4]] = list[5];
          break;
        }
      case ('m_o_localFiltration'):
        {
          if (list[4] == 'rtu') {
            if (list[3] == -1) {
              if (localFiltrationUpdated[list[1]][list[2]][list[4]] !=
                  list[5]) {
                localFiltrationUpdated[list[1]][list[2]]['rfNo'] = '-';
                localFiltrationUpdated[list[1]][list[2]]['output'] = '-';
              }
            } else {
            if (localFiltrationUpdated[list[1]][list[2]][list[3]][list[4]] !=
                  list[5]) {
                localFiltrationUpdated[list[1]][list[2]][list[3]]['rfNo'] = '-';
                localFiltrationUpdated[list[1]][list[2]][list[3]]['output'] =
                    '-';
              }
            }
          } else if (list[4] == 'rfNo') {
            if (list[3] == -1) {
              if (localFiltrationUpdated[list[1]][list[2]][list[4]] !=
                  list[5]) {
                localFiltrationUpdated[list[1]][list[2]]['output'] = '-';
              }
            } else {
              if (localFiltrationUpdated[list[1]][list[2]][list[3]][list[4]] !=
                  list[5]) {
                localFiltrationUpdated[list[1]][list[2]][list[3]]['output'] =
                    '-';
              }
            }
          }
          if (list[3] == -1) {
            localFiltrationUpdated[list[1]][list[2]][list[4]] = list[5];
          } else {
            localFiltrationUpdated[list[1]][list[2]][list[3]][list[4]] =
                list[5];
          }
          break;
        }
      case ('m_o_centralFiltration'):
        {
          if (list[4] == 'rtu') {
            if (list[3] == -1) {
              if (centralFiltrationUpdated[list[1]][list[2]][list[4]] !=
                  list[5]) {
                centralFiltrationUpdated[list[1]][list[2]]['rfNo'] = '-';
                centralFiltrationUpdated[list[1]][list[2]]['output'] = '-';
              }
            } else {
              if (centralFiltrationUpdated[list[1]][list[2]][list[3]]
                      [list[4]] !=
                  list[5]) {
                centralFiltrationUpdated[list[1]][list[2]][list[3]]['rfNo'] =
                    '-';
                centralFiltrationUpdated[list[1]][list[2]][list[3]]['output'] =
                    '-';
              }
            }
          } else if (list[4] == 'rfNo') {
            if (list[3] == -1) {
              if (centralFiltrationUpdated[list[1]][list[2]][list[4]] !=
                  list[5]) {
                centralFiltrationUpdated[list[1]][list[2]]['output'] = '-';
              }
            } else {
              if (centralFiltrationUpdated[list[1]][list[2]][list[3]]
                      [list[4]] !=
                  list[5]) {
                centralFiltrationUpdated[list[1]][list[2]][list[3]]['output'] =
                    '-';
              }
            }
          }
          if (list[3] == -1) {
            centralFiltrationUpdated[list[1]][list[2]][list[4]] = list[5];
          } else {
            centralFiltrationUpdated[list[1]][list[2]][list[3]][list[4]] =
                list[5];
          }
          break;
        }
      case ('m_o_sourcePump'):
        {
          if (list[2] == 'rfNo') {
            if (sourcePumpUpdated[list[1]][list[2]] != list[3]) {
              sourcePumpUpdated[list[1]]['output'] = '-';
            }
          }
          sourcePumpUpdated[list[1]][list[2]] = list[3];
          break;
        }
      case ('m_o_irrigationPump'):
        {
          if (list[2] == 'rfNo') {
            if (irrigationPumpUpdated[list[1]][list[2]] != list[3]) {
              irrigationPumpUpdated[list[1]]['output'] = '-';
            }
          }
          irrigationPumpUpdated[list[1]][list[2]] = list[3];
          break;
        }
      case ('m_o_agitator'):
        {
          if (list[4] == 'rtu') {
            if (totalAgitator[list[3]][list[4]] != list[5]) {
              totalAgitator[list[3]]['rfNo'] = '-';
              totalAgitator[list[3]]['output'] = '-';
            }
          } else if (list[4] == 'rfNo') {
            if (totalAgitator[list[3]][list[4]] != list[5]) {
              totalAgitator[list[3]]['output'] = '-';
            }
          }
          totalAgitator[list[3]][list[4]] = list[5];
          break;
        }
      case ('agitatorDelete'):
        {
          totalAgitator.removeAt(list[1]);
          totalAgitatorCount += 1;
          for(var cd in centralDosingUpdated){
            if(cd['agitator'] != '-'){
              if(int.parse(cd['agitator'].split('.')[1]) > totalAgitator.length){
                cd['agitator'] = '-';
              }
            }
          }
          for(var ld in localDosingUpdated){
            if(ld['agitator'] != '-'){
              if(int.parse(ld['agitator'].split('.')[1]) > totalAgitator.length){
                ld['agitator'] = '-';
              }
            }
          }
          break;
        }
      case ('selectorDelete'):
        {
          totalSelector.removeAt(list[1]);
          totalSelectorCount += 1;
          break;
        }
      case ('m_o_selector'):
        {
          if (list[4] == 'rtu') {
            if (totalSelector[list[3]][list[4]] != list[5]) {
              totalSelector[list[3]]['rfNo'] = '-';
              totalSelector[list[3]]['output'] = '-';
            }
          } else if (list[4] == 'rfNo') {
            if (totalSelector[list[3]][list[4]] != list[5]) {
              totalSelector[list[3]]['output'] = '-';
            }
          }
          totalSelector[list[3]][list[4]] = list[5];
          break;
        }
    }
    notifyListeners();
  }

  //TODO: mappingOfInputsFunctionality
  void mappingOfInputsFunctionality(List<dynamic> list) {
    switch (list[0]) {
      case ('m_i_line'):
        {
          if (list[4] == 'rtu') {
            if (list[3] == -1) {
              if (irrigationLines[list[1]][list[2]][list[4]] != list[5]) {
                irrigationLines[list[1]][list[2]]['rfNo'] = '-';
                irrigationLines[list[1]][list[2]]['input'] = '-';
              }
            } else {
              if (irrigationLines[list[1]][list[2]][list[3]][list[4]] !=
                  list[5]) {
                if(!['moistureSensorConnection'].contains(list[2])){
                  irrigationLines[list[1]][list[2]][list[3]]['input_type'] = '-';
                }
                irrigationLines[list[1]][list[2]][list[3]]['rfNo'] = '-';
                irrigationLines[list[1]][list[2]][list[3]]['input'] = '-';
              }
            }
          } else if (list[4] == 'rfNo') {
            if (list[3] == -1) {
              if (irrigationLines[list[1]][list[2]][list[4]] != list[5]) {
                irrigationLines[list[1]][list[2]]['input'] = '-';
                if(!['powerSupply','pressureSwitch','water_meter'].contains(list[2])){
                  irrigationLines[list[1]][list[2]]['input_type'] = '-';
                }
              }
            } else {
              if (irrigationLines[list[1]][list[2]][list[3]][list[4]] !=
                  list[5]) {
                if(!['moistureSensorConnection'].contains(list[2])){
                  irrigationLines[list[1]][list[2]][list[3]]['input_type'] = '-';
                }
                irrigationLines[list[1]][list[2]][list[3]]['input'] = '-';

              }
            }
          } else if (list[4] == 'input_type') {
            if (list[3] == -1) {
              if (irrigationLines[list[1]][list[2]][list[4]] != list[5]) {
                irrigationLines[list[1]][list[2]]['input'] = '-';
              }
            } else {
              if (irrigationLines[list[1]][list[2]][list[3]][list[4]] !=
                  list[5]) {
                irrigationLines[list[1]][list[2]][list[3]]['input'] = '-';
              }
            }
          }
          if (list[3] == -1) {
            irrigationLines[list[1]][list[2]][list[4]] = list[5];
          } else {
            irrigationLines[list[1]][list[2]][list[3]][list[4]] = list[5];
          }
          break;
        }
      case ('m_i_centralDosing'):
        {
          if (list[4] == 'rtu') {
            if (list[2].contains('-')) {
              if (centralDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                      [list[2].split('-')[1]][list[4]] !=
                  list[5]) {
                centralDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                    [list[2].split('-')[1]]['rfNo'] = '-';
                centralDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                    [list[2].split('-')[1]]['input'] = '-';
                centralDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                    [list[2].split('-')[1]]['input_type'] = '-';
              }
            } else if (list[2] == 'pressureSwitch') {
              if (centralDosingUpdated[list[1]][list[2]][list[4]] != list[5]) {
                centralDosingUpdated[list[1]][list[2]]['rfNo'] = '-';
                centralDosingUpdated[list[1]][list[2]]['input'] = '-';
                centralDosingUpdated[list[1]][list[2]]['input_type'] = '-';
              }
            } else {
              if (centralDosingUpdated[list[1]][list[2]][list[3]][list[4]] !=
                  list[5]) {
                centralDosingUpdated[list[1]][list[2]][list[3]]['rfNo'] = '-';
                if(list[2] != 'phConnection'){
                  centralDosingUpdated[list[1]][list[2]][list[3]]['input_type'] = '-';
                }
                centralDosingUpdated[list[1]][list[2]][list[3]]['input'] = '-';
              }
            }
          } else if (list[4] == 'rfNo') {
            if (list[2].contains('-')) {
              if (centralDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                      [list[2].split('-')[1]][list[4]] !=
                  list[5]) {
                centralDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                    [list[2].split('-')[1]]['input'] = '-';
                centralDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                    [list[2].split('-')[1]]['input_type'] = '-';
              }
            } else if (list[2] == 'pressureSwitch') {
              if (centralDosingUpdated[list[1]][list[2]][list[4]] != list[5]) {
                centralDosingUpdated[list[1]][list[2]]['input'] = '-';
                centralDosingUpdated[list[1]][list[2]]['input_type'] = '-';
              }
            } else {
              if (centralDosingUpdated[list[1]][list[2]][list[3]][list[4]] !=
                  list[5]) {
                if(!['ecConnection','phConnection'].contains(list[2])){
                  centralDosingUpdated[list[1]][list[2]][list[3]]['input_type'] = '-';
                }
                centralDosingUpdated[list[1]][list[2]][list[3]]['input'] = '-';
              }
            }
          } else if (list[4] == 'input_type') {
            if (list[2].contains('-')) {
              if (centralDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                      [list[2].split('-')[1]][list[4]] !=
                  list[5]) {
                centralDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                    [list[2].split('-')[1]]['input'] = '-';
              }
            } else if (list[2] == 'pressureSwitch') {
              if (centralDosingUpdated[list[1]][list[2]][list[4]] != list[5]) {
                centralDosingUpdated[list[1]][list[2]]['input'] = '-';
              }
            } else {
              if (centralDosingUpdated[list[1]][list[2]][list[3]][list[4]] !=
                  list[5]) {
                centralDosingUpdated[list[1]][list[2]][list[3]]['input'] = '-';
              }
            }
          }
          if (list[2].contains('-')) {
            centralDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                [list[2].split('-')[1]][list[4]] = list[5];
          } else if (list[2] == 'pressureSwitch') {
            centralDosingUpdated[list[1]][list[2]][list[4]] = list[5];
          } else {
            centralDosingUpdated[list[1]][list[2]][list[3]][list[4]] = list[5];
          }
          break;
        }
      case ('m_i_localDosing'):
        {
          if (list[4] == 'rtu') {
            if (list[2].contains('-')) {
              if (localDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                      [list[2].split('-')[1]][list[4]] !=
                  list[5]) {
                localDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                    [list[2].split('-')[1]]['rfNo'] = '-';
                localDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                    [list[2].split('-')[1]]['input'] = '-';
                if(list[2] != 'phConnection'){
                  localDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                  [list[2].split('-')[1]]['input_type'] = '-';
                }

              }
            } else if (list[2] == 'pressureSwitch') {
              if (localDosingUpdated[list[1]][list[2]][list[4]] != list[5]) {
                localDosingUpdated[list[1]][list[2]]['rfNo'] = '-';
                localDosingUpdated[list[1]][list[2]]['input'] = '-';

                localDosingUpdated[list[1]][list[2]]['input_type'] = '-';
              }
            } else {
              if (localDosingUpdated[list[1]][list[2]][list[3]][list[4]] !=
                  list[5]) {
                localDosingUpdated[list[1]][list[2]][list[3]]['rfNo'] = '-';
                localDosingUpdated[list[1]][list[2]][list[3]]['input'] = '-';
                if(list[2] != 'phConnection'){
                  localDosingUpdated[list[1]][list[2]][list[3]]['input_type'] =
                  '-';
                }

              }
            }
          } else if (list[4] == 'rfNo') {
            if (list[2].contains('-')) {
              if (localDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                      [list[2].split('-')[1]][list[4]] !=
                  list[5]) {
                localDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                    [list[2].split('-')[1]]['input'] = '-';
                localDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                    [list[2].split('-')[1]]['input_type'] = '-';
              }
            } else if (list[2] == 'pressureSwitch') {
              if (localDosingUpdated[list[1]][list[2]][list[4]] != list[5]) {
                localDosingUpdated[list[1]][list[2]]['input'] = '-';
                localDosingUpdated[list[1]][list[2]]['input_type'] = '-';
              }
            } else {
              if (localDosingUpdated[list[1]][list[2]][list[3]][list[4]] !=
                  list[5]) {
                if(!['ecConnection','phConnection'].contains(list[2])){
                  localDosingUpdated[list[1]][list[2]][list[3]]['input_type'] = '-';
                }
                localDosingUpdated[list[1]][list[2]][list[3]]['input'] = '-';
              }
            }
          } else if (list[4] == 'input_type') {
            if (list[2].contains('-')) {
              if (localDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                      [list[2].split('-')[1]][list[4]] !=
                  list[5]) {
                localDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                    [list[2].split('-')[1]]['input'] = '-';
              }
            } else if (list[2] == 'pressureSwitch') {
              if (localDosingUpdated[list[1]][list[2]][list[4]] != list[5]) {
                localDosingUpdated[list[1]][list[2]]['input'] = '-';
              }
            } else {
              if (localDosingUpdated[list[1]][list[2]][list[3]][list[4]] !=
                  list[5]) {
                localDosingUpdated[list[1]][list[2]][list[3]]['input'] = '-';
              }
            }
          }
          if (list[2].contains('-')) {
            localDosingUpdated[list[1]][list[2].split('-')[0]][list[3]]
                [list[2].split('-')[1]][list[4]] = list[5];
          } else if (list[2] == 'pressureSwitch') {
            localDosingUpdated[list[1]][list[2]][list[4]] = list[5];
          } else {
            localDosingUpdated[list[1]][list[2]][list[3]][list[4]] = list[5];
          }
          break;
        }
      case ('m_i_sourcePump'):
        {
          if (list[4] == 'rtu') {
            if (sourcePumpUpdated[list[1]][list[2]][list[4]] != list[5]) {
              sourcePumpUpdated[list[1]][list[2]]['rfNo'] = '-';
              sourcePumpUpdated[list[1]][list[2]]['input'] = '-';
              sourcePumpUpdated[list[1]][list[2]]['input_type'] = '-';
            }
          } else if (list[4] == 'rfNo') {
            if (sourcePumpUpdated[list[1]][list[2]][list[4]] != list[5]) {
              if(!['levelSensor','pressureSensor','TopTankLow','TopTankHigh','SumpTankLow','SumpTankHigh'].contains(list[2])){
                sourcePumpUpdated[list[1]][list[2]]['input_type'] = '-';
              }
              sourcePumpUpdated[list[1]][list[2]]['input'] = '-';
            }
          } else if (list[4] == 'input_type') {
            if (sourcePumpUpdated[list[1]][list[2]][list[4]] != list[5]) {
              sourcePumpUpdated[list[1]][list[2]]['input'] = '-';
            }
          }
          sourcePumpUpdated[list[1]][list[2]][list[4]] = list[5];
          break;
        }
      case ('m_i_irrigationPump'):
        {
          if (list[4] == 'rtu') {
            if (irrigationPumpUpdated[list[1]][list[2]][list[4]] != list[5]) {
              irrigationPumpUpdated[list[1]][list[2]]['rfNo'] = '-';
              irrigationPumpUpdated[list[1]][list[2]]['input'] = '-';
              irrigationPumpUpdated[list[1]][list[2]]['input_type'] = '-';
            }
          } else if (list[4] == 'rfNo') {
            if (irrigationPumpUpdated[list[1]][list[2]][list[4]] != list[5]) {
              if(!['levelSensor','pressureSensor','TopTankLow','TopTankHigh','SumpTankLow','SumpTankHigh'].contains(list[2])){
                irrigationPumpUpdated[list[1]][list[2]]['input_type'] = '-';
              }
              irrigationPumpUpdated[list[1]][list[2]]['input'] = '-';
            }
          } else if (list[4] == 'input_type') {
            if (irrigationPumpUpdated[list[1]][list[2]][list[4]] != list[5]) {
              irrigationPumpUpdated[list[1]][list[2]]['input'] = '-';
            }
          }
          irrigationPumpUpdated[list[1]][list[2]][list[4]] = list[5];
          break;
        }
      case ('m_i_localFiltration'):
        {
          if (list[4] == 'rtu') {
            if (list[3] == -1) {
              if (localFiltrationUpdated[list[1]][list[2]][list[4]] !=
                  list[5]) {
                localFiltrationUpdated[list[1]][list[2]]['rfNo'] = '-';
                localFiltrationUpdated[list[1]][list[2]]['input'] = '-';
                localFiltrationUpdated[list[1]][list[2]]['input_type'] = '-';
              }
            }
          } else if (list[4] == 'rfNo') {
            if (list[3] == -1) {
              if (localFiltrationUpdated[list[1]][list[2]][list[4]] !=
                  list[5]) {
                localFiltrationUpdated[list[1]][list[2]]['input'] = '-';
                localFiltrationUpdated[list[1]][list[2]]['input_type'] = '-';
              }
            }
          } else if (list[4] == 'input_type') {
            if (list[3] == -1) {
              if (localFiltrationUpdated[list[1]][list[2]][list[4]] !=
                  list[5]) {
                localFiltrationUpdated[list[1]][list[2]]['input'] = '-';
              }
            }
          }
          if (list[3] == -1) {
            localFiltrationUpdated[list[1]][list[2]][list[4]] = list[5];
          }
          break;
        }
      case ('m_i_centralFiltration'):
        {
          if (list[4] == 'rtu') {
            if (list[3] == -1) {
              if (centralFiltrationUpdated[list[1]][list[2]][list[4]] !=
                  list[5]) {
                centralFiltrationUpdated[list[1]][list[2]]['rfNo'] = '-';
                centralFiltrationUpdated[list[1]][list[2]]['input'] = '-';
                centralFiltrationUpdated[list[1]][list[2]]['input_type'] = '-';
              }
            }
          } else if (list[4] == 'rfNo') {
            if (list[3] == -1) {
              if (centralFiltrationUpdated[list[1]][list[2]][list[4]] !=
                  list[5]) {
                centralFiltrationUpdated[list[1]][list[2]]['input'] = '-';
                centralFiltrationUpdated[list[1]][list[2]]['input_type'] = '-';
              }
            }
          } else if (list[4] == 'input_type') {
            if (list[3] == -1) {
              if (centralFiltrationUpdated[list[1]][list[2]][list[4]] !=
                  list[5]) {
                centralFiltrationUpdated[list[1]][list[2]]['input'] = '-';
              }
            }
          }
          if (list[3] == -1) {
            centralFiltrationUpdated[list[1]][list[2]][list[4]] = list[5];
          }
          break;
        }
      case ('m_i_analogSensor'):
        {
          if (list[4] == 'rtu') {
            if (totalAnalogSensor[list[3]][list[4]] != list[5]) {
              totalAnalogSensor[list[3]]['rfNo'] = '-';
              totalAnalogSensor[list[3]]['input'] = '-';
              totalAnalogSensor[list[3]]['input_type'] = '-';
            }
          } else if (list[4] == 'rfNo') {
            if (totalAnalogSensor[list[3]][list[4]] != list[5]) {
              totalAnalogSensor[list[3]]['input'] = '-';
              totalAnalogSensor[list[3]]['input_type'] = '-';
            }
          } else if (list[4] == 'input_type') {
            if (totalAnalogSensor[list[3]][list[4]] != list[5]) {
              totalAnalogSensor[list[3]]['input'] = '-';
            }
          }
          totalAnalogSensor[list[3]][list[4]] = list[5];
          break;
        }
      case ('m_i_totalCommonPressureSensor'):
        {
          if (list[4] == 'rtu') {
            if (totalCommonPressureSensor[list[3]][list[4]] != list[5]) {
              totalCommonPressureSensor[list[3]]['rfNo'] = '-';
              totalCommonPressureSensor[list[3]]['input'] = '-';
              totalCommonPressureSensor[list[3]]['input_type'] = '-';
            }
          } else if (list[4] == 'rfNo') {
            if (totalCommonPressureSensor[list[3]][list[4]] != list[5]) {
              totalCommonPressureSensor[list[3]]['input'] = '-';
              totalCommonPressureSensor[list[3]]['input_type'] = '-';
            }
          } else if (list[4] == 'input_type') {
            if (totalCommonPressureSensor[list[3]][list[4]] != list[5]) {
              totalCommonPressureSensor[list[3]]['input'] = '-';
            }
          }
          totalCommonPressureSensor[list[3]][list[4]] = list[5];
          break;
        }
      case ('m_i_totalCommonPressureSwitch'):
        {
          if (list[4] == 'rtu') {
            if (totalCommonPressureSwitch[list[3]][list[4]] != list[5]) {
              totalCommonPressureSwitch[list[3]]['rfNo'] = '-';
              totalCommonPressureSwitch[list[3]]['input'] = '-';
              totalCommonPressureSwitch[list[3]]['input_type'] = '-';
            }
          } else if (list[4] == 'rfNo') {
            if (totalCommonPressureSwitch[list[3]][list[4]] != list[5]) {
              totalCommonPressureSwitch[list[3]]['input'] = '-';
              totalCommonPressureSwitch[list[3]]['input_type'] = '-';
            }
          } else if (list[4] == 'input_type') {
            if (totalCommonPressureSwitch[list[3]][list[4]] != list[5]) {
              totalCommonPressureSwitch[list[3]]['input'] = '-';
            }
          }
          totalCommonPressureSwitch[list[3]][list[4]] = list[5];
          break;
        }
      case ('m_i_totalTankFloat'):
        {
          if (list[4] == 'rtu') {
            if (totalTankFloat[list[3]][list[4]] != list[5]) {
              totalTankFloat[list[3]]['rfNo'] = '-';
              totalTankFloat[list[3]]['input'] = '-';
            }
          } else if (list[4] == 'rfNo') {
            if (totalTankFloat[list[3]][list[4]] != list[5]) {
              totalTankFloat[list[3]]['input'] = '-';
            }
          } else if (list[4] == 'input_type') {
            if (totalTankFloat[list[3]][list[4]] != list[5]) {
              totalTankFloat[list[3]]['input'] = '-';
            }
          }
          totalTankFloat[list[3]][list[4]] = list[5];
          break;
        }
      case ('m_i_totalManualButton'):
        {
          if (list[4] == 'rtu') {
            if (totalManualButton[list[3]][list[4]] != list[5]) {
              totalManualButton[list[3]]['rfNo'] = '-';
              totalManualButton[list[3]]['input'] = '-';
            }
          } else if (list[4] == 'rfNo') {
            if (totalManualButton[list[3]][list[4]] != list[5]) {
              totalManualButton[list[3]]['input'] = '-';
            }
          } else if (list[4] == 'input_type') {
            if (totalManualButton[list[3]][list[4]] != list[5]) {
              totalManualButton[list[3]]['input'] = '-';
            }
          }
          totalManualButton[list[3]][list[4]] = list[5];
          break;
        }
      case ('m_i_totalLowerTankLevelSensor'):
        {
          if (list[4] == 'rtu') {
            if (totalLowerTankLevelSensor[list[3]][list[4]] != list[5]) {
              totalLowerTankLevelSensor[list[3]]['rfNo'] = '-';
              totalLowerTankLevelSensor[list[3]]['input'] = '-';
            }
          } else if (list[4] == 'rfNo') {
            if (totalLowerTankLevelSensor[list[3]][list[4]] != list[5]) {
              totalLowerTankLevelSensor[list[3]]['input'] = '-';
            }
          } else if (list[4] == 'input_type') {
            if (totalLowerTankLevelSensor[list[3]][list[4]] != list[5]) {
              totalLowerTankLevelSensor[list[3]]['input'] = '-';
            }
          }
          totalLowerTankLevelSensor[list[3]][list[4]] = list[5];
          break;
        }
      case ('m_i_totalUpperTankLevelSensor'):
        {
          if (list[4] == 'rtu') {
            if (totalUpperTankLevelSensor[list[3]][list[4]] != list[5]) {
              totalUpperTankLevelSensor[list[3]]['rfNo'] = '-';
              totalUpperTankLevelSensor[list[3]]['input'] = '-';
            }
          } else if (list[4] == 'rfNo') {
            if (totalUpperTankLevelSensor[list[3]][list[4]] != list[5]) {
              totalUpperTankLevelSensor[list[3]]['input'] = '-';
            }
          } else if (list[4] == 'input_type') {
            if (totalUpperTankLevelSensor[list[3]][list[4]] != list[5]) {
              totalUpperTankLevelSensor[list[3]]['input'] = '-';
            }
          }
          totalUpperTankLevelSensor[list[3]][list[4]] = list[5];
          break;
        }
      case ('co2Delete'):
        {
          connCo2.removeAt(list[1]);
          break;
        }
      case ('humidityDelete'):
        {
          connHumidity.removeAt(list[1]);
          break;
        }
      case ('temperatureDelete'):
        {
          connTempSensor.removeAt(list[1]);
          break;
        }
      case ('soilTemperatureDelete'):
        {
          connSoilTempSensor.removeAt(list[1]);
          break;
        }
      case ('m_i_temperature'):
        {
          editSensor(list, connTempSensor,true);
          break;
        }
      case ('m_i_soilTemperature'):
        {
          editSensor(list, connSoilTempSensor,true);
          break;
        }
      case ('m_i_rainGauge'):
        {
          editSensor(list, connRainGauge);
          break;
        }
      case ('m_i_leafWetness'):
        {
          editSensor(list, connLeafWetness);
          break;
        }
      case ('m_i_windSpeed'):
        {
          editSensor(list, connWindSpeed);
          break;
        }
      case ('m_i_windDirection'):
        {
          editSensor(list, connWindDirection);
          break;
        }
      case ('m_i_co2'):
        {
          editSensor(list, connCo2,true);
          break;
        }
      case ('m_i_lux'):
        {
          editSensor(list, connLux);
          break;
        }
      case ('m_i_ldr'):
        {
          editSensor(list, connLdr);
          break;
        }
      case ('m_i_humidity'):
        {
          editSensor(list, connHumidity,true);
          break;
        }
      case ('m_i_contact'):
        {
          if (list[4] == 'rtu') {
            if (totalContact[list[3]][list[4]] != list[5]) {
              totalContact[list[3]]['rfNo'] = '-';
              totalContact[list[3]]['input'] = '-';
              totalContact[list[3]]['input_type'] = '-';
            }
          } else if (list[4] == 'rfNo') {
            if (totalContact[list[3]][list[4]] != list[5]) {
              totalContact[list[3]]['input'] = '-';
              totalContact[list[3]]['input_type'] = '-';
            }
          } else if (list[4] == 'input_type') {
            if (totalContact[list[3]][list[4]] != list[5]) {
              totalContact[list[3]]['input'] = '-';
            }
          }
          totalContact[list[3]][list[4]] = list[5];
          break;
        }
    }
    notifyListeners();
  }

  void clearMacAddress(){
    oLevelMac = [];
    oSrtuMac = [];
    oRtuMac = [];
    oSenseMac = [];
    if([1,2].contains(categoryId)){
      oPumpPlusMac = [];
      oPumpMac = [];
    }
    oExtendMac = [];
    oWeatherMac = [];
    oSrtuPlusMac = [];
    oRtuPlusMac = [];
    notifyListeners();
  }

  editSensor(list, connection, [bool? check]) {
    if (list[4] == 'rtu') {
      if (connection[list[3]][list[4]] != list[5]) {
        connection[list[3]]['rfNo'] = '-';
        connection[list[3]]['input'] = '-';
        // connection[list[3]]['input_type'] = '-';
      }
    } else if (list[4] == 'rfNo') {
      if (connection[list[3]][list[4]] != list[5]) {
        connection[list[3]]['input'] = '-';
        if(check == null){
          // connection[list[3]]['input_type'] = '-';
        }
      }
    } else if (list[4] == 'input_type') {
      if (connection[list[3]][list[4]] != list[5]) {
        connection[list[3]]['input'] = '-';
      }
    }
    connection[list[3]][list[4]] = list[5];
    notifyListeners();
  }

  //TODO: returnDeviceType
  String returnDeviceType(String title) {
    if (title == 'ORO Smart') {
      return '2';
    } else if (title == 'ORO RTU') {
      return '3';
    } else if (title == 'ORO Switch') {
      return '5';
    } else if (title == 'ORO Sense') {
      return '7';
    } else {
      return '-';
    }
  }

  //TODO: fetchAll data from server
  void fetchAll(dynamic data, [bool? newData]) {
    serverData = data;
    tabs = [];
    tabs.add(['Start', '', Icons.play_circle_filled, 0]);
    tabs.add(['Mapping', 'of Output', Icons.compare_arrows, 9]);
    tabs.add(['Mapping', 'of Input', Icons.compare_arrows, 10]);
    tabs.add(['Finish', '', Icons.check_circle, 11]);
    for (var i in data.entries) {
      if (newData == null) {
        if (i.key == 'configMaker') {
          oldData = i.value;
          fetchFromServer();
        }
      }
      if (newData == null) {
        if (i.key == 'names') {
          for(var nameKeys in i.value.keys){
            if(i.value[nameKeys] != null){
              for (var nm in i.value[nameKeys]) {
                names['${nm['sNo']}'] = nm['name'];
              }
            }
          }
        }
      }
      if (i.key == 'configMaker') {
        categoryId = i.value['categoryId'];
        flag = i.value['controllerReadStatus'] ?? '0';
        if(categoryId == 3){
          serverData['referenceNo']['3'] = [];
          serverData['referenceNo']['3'].add({
            "deviceId": i.value['deviceId'],
            "referenceNumber": '1',
          });
          oPump = [];
          oPump.add('1');
          oPumpMac.add(i.value['deviceId']);
        }
        if(categoryId == 4){
          serverData['referenceNo']['4'] = [];
          serverData['referenceNo']['4'].add({
            "deviceId": i.value['deviceId'],
            "referenceNumber": '1',
          });
          oPumpPlus = [];
          oPumpPlus.add('1');
          oPumpPlusMac.add(i.value['deviceId']);

        }
      }
      if (newData == true) {
        print('new config maker ...........................................................................................');
        if (i.key == 'referenceNo') {
          clearMacAddress();
          oLevel = [];
          oSrtu = [];
          oRtu = [];
          oSense = [];
          oPump = [];
          oPumpPlus = [];
          oExtend = [];
          oWeather = [];
          oSrtuPlus = [];
          oRtuPlus = [];

          for (var rf in i.value.entries) {
            if (rf.key == '6') {
              totalOroLevel = rf.value.length;
              for (var i in rf.value) {
                oLevel.add('${i['referenceNumber']}');
                oLevelMac.add('${i['deviceId']}');
              }
            } else if (rf.key == '12') {
              totalOroSmartRTU = rf.value.length;
              for (var i in rf.value) {
                oSrtu.add('${i['referenceNumber']}');
                oSrtuMac.add('${i['deviceId']}');
              }
            } else if (rf.key == '9') {
              totalOroSwitch = rf.value.length;
              for (var i in rf.value) {
                oSwitch.add('${i['referenceNumber']}');
                oSwitchMac.add('${i['deviceId']}');
              }
            } else if (rf.key == '13') {
              totalRTU = rf.value.length;
              for (var i in rf.value) {
                oRtu.add('${i['referenceNumber']}');
                oRtuMac.add('${i['deviceId']}');
              }
            } else if (rf.key == '10') {
              totalOroSense = rf.value.length;
              for (var i in rf.value) {
                oSense.add('${i['referenceNumber']}');
                oSenseMac.add('${i['deviceId']}');
              }
            } else if (rf.key == '3') {
              totalOroPump = rf.value.length;
              for (var i in rf.value) {
                oPump.add('${i['referenceNumber']}');
                oPumpMac.add('${i['deviceId']}');
              }
            } else if (rf.key == '11') {
              totalOroExtend = rf.value.length;
              for (var i in rf.value) {
                oExtend.add('${i['referenceNumber']}');
                oExtendMac.add('${i['deviceId']}');
              }
            } else if (rf.key == '5') {
              if (rf.value.length != 0) {
                tabs.add(['Weather', 'Station', Icons.track_changes, 8]);
              }
              for (var i in rf.value) {
                oWeather.add('${i['referenceNumber']}');
                oWeatherMac.add('${i['deviceId']}');
                oRoWeatherForStation.add('${i['referenceNumber']}');
              }
              for(var key in oWeather){
                if(weatherStation['$key'] == null){
                  weatherStation['$key'] = {};
                  weatherStation['$key']['apply'] = false;
                  weatherStation['$key']['irrigationLine'] = '-';
                  weatherStation['$key']['soilMoisture1'] = getWeatherSensorStructure(1);
                  weatherStation['$key']['soilMoisture2'] = getWeatherSensorStructure(2);
                  weatherStation['$key']['soilMoisture3'] = getWeatherSensorStructure(3);
                  weatherStation['$key']['soilMoisture4'] = getWeatherSensorStructure(4);
                  weatherStation['$key']['soilTemperature'] = getWeatherSensorStructure(5);
                  weatherStation['$key']['humidity'] = getWeatherSensorStructure(6);
                  weatherStation['$key']['temperature'] = getWeatherSensorStructure(7);
                  weatherStation['$key']['atmospherePressure'] = getWeatherSensorStructure(8);
                  weatherStation['$key']['co2'] = getWeatherSensorStructure(9);
                  weatherStation['$key']['ldr'] = getWeatherSensorStructure(10);
                  weatherStation['$key']['lux'] = getWeatherSensorStructure(11);
                  weatherStation['$key']['windDirection'] = getWeatherSensorStructure(12);
                  weatherStation['$key']['windSpeed'] = getWeatherSensorStructure(13);
                  weatherStation['$key']['rainFall'] = getWeatherSensorStructure(14);
                  weatherStation['$key']['leafWetness'] = getWeatherSensorStructure(15);
                }
              }
            } else if (rf.key == '7') {
              totalOroSmartRtuPlus = rf.value.length;
              for (var i in rf.value) {
                oSrtuPlus.add('${i['referenceNumber']}');
                oSrtuPlusMac.add('${i['deviceId']}');
              }
            } else if (rf.key == '8') {
              totalRtuPlus = rf.value.length;
              for (var i in rf.value) {
                oRtuPlus.add('${i['referenceNumber']}');
                oRtuPlusMac.add('${i['deviceId']}');
              }
            } else if (rf.key == '4') {
              for (var i in rf.value) {
                oPumpPlus.add('${i['referenceNumber']}');
                oPumpPlusMac.add('${i['deviceId']}');
              }
            }
          }
        }
        if (i.key == 'productLimit') {
          for (var j in i.value) {
            switch (j['productTypeId']) {
              case 1:
                totalSourcePump = j['quantity'];
                if (j['quantity'] != 0) {
                  tabs.add(['Source', 'Pump', Icons.water, 1]);
                }
                break;
              case 2:
                if (j['quantity'] != 0) {
                  tabs.add(['Irrigation', 'Pump', Icons.waterfall_chart, 2]);
                }
                totalIrrigationPump = j['quantity'];
                break;
              case 3:
                totalBooster = j['quantity'];
                break;
              case 4:
                totalInjector = j['quantity'];
                break;
              case 5:
                totalFilter = j['quantity'];
                break;
              case 6:
                totalValve = j['quantity'];
                break;
              case 7:
                totalMainValve = j['quantity'];
                break;
              case 8:
                total_D_s_valve = j['quantity'];
              case 9:
                totalFan = j['quantity'];
                break;
              case 10:
                totalFogger = j['quantity'];
                break;
              case 11:
                totalAgitatorCount = j['quantity'];
                break;
              case 12:
                totalSelectorCount = j['quantity'];
                break;
              case 13:
                totalWaterMeter = j['quantity'];
                break;
              case 14:
                totalDosingMeter = j['quantity'];
                break;
              case 15:
                totalPressureSwitch = j['quantity'];
                break;
              case 16:
                total_p_sensor = j['quantity'];
                break;
              case 17:
                totalDiffPressureSensor = j['quantity'];
                break;
              case 18:
                totalMoistureSensor = j['quantity'];
                break;
              case 19:
                totalLevelSensor = j['quantity'];
                break;
              case 20:
                totalAnalogSensorCount = j['quantity'];
                break;
              case 21:
                totalEcSensor = j['quantity'];
                break;
              case 22:
                totalPhSensor = j['quantity'];
                break;
              case 23:
                totalTempSensor = j['quantity'];
                break;
              case 24:
                totalSoilTempSensor = j['quantity'];
                break;
              case 25:
                totalWindDirection = j['quantity'];

                break;
              case 26:
                totalWindSpeed = j['quantity'];
                break;
              case 27:
                totalCo2 = j['quantity'];
                break;
              case 28:
                totalLux = j['quantity'];
                 break;
              case 29:
                totalLdr = j['quantity'];
                break;
              case 30:
                totalHumidity = j['quantity'];
                  break;
              case 31:
                totalLeafWetness = j['quantity'];
                break;
              case 32:
                totalRainGauge = j['quantity'];
                break;
              case 33:
                totalContactCount = j['quantity'];
                break;
              case 34:
                if (j['quantity'] != 0) {
                  tabs.add(['Irrigation', 'Lines', Icons.timeline, 5]);
                }
                totalIrrigationLine = j['quantity'];
                break;
              case 35:
                if (j['quantity'] != 0) {
                  tabs.add(['Central', 'Dosing', Icons.local_drink, 3]);
                }
                if (totalInjector != 0 && totalIrrigationLine != 0) {
                  tabs.add(['Local', 'Dosing', Icons.local_hospital, 6]);
                }
                totalCentralDosing = j['quantity'];
                break;
              case 36:
                if (j['quantity'] != 0) {
                  tabs.add(['Central', 'Filtration', Icons.filter_alt, 4]);
                }
                if (totalFilter != 0 && totalIrrigationLine != 0) {
                  tabs.add(['Local', 'Filtration', Icons.filter_vintage, 7]);
                }
                totalCentralFiltration = j['quantity'];
                break;
              case 45:
                var src = [
                  'A',
                  'B',
                  'C',
                  'D',
                  'E',
                  'F',
                  'G',
                  'H',
                  'I',
                  'J',
                  'K',
                  'L',
                  'M',
                  'N',
                  'O',
                  'P'
                ];
                waterSource = [];
                waterSource.add('-');
                for (var i = 0; i < j['quantity']; i++) {
                  totalWaterSource.add({
                    'sNo': returnI_O_AutoIncrement(),
                    'id': 'WS${i + 1}',
                    'name': 'Water Source ${src[i]}',
                    'location': ''
                  });
                  waterSource.add(src[i]);
                }
                break;
              case 46:
                totalFloat = j['quantity'];
                break;
              case 47:
                totalCommonPressureSensorCount = j['quantity'];
                                break;
              case 49:
                totalCommonPressureSwitchCount = j['quantity'];
                                break;
              case 50:
                totalTankFloatCount = j['quantity'];

                break;
              case 53:
                totalPowerSupply = j['quantity'];
                break;
              case 54:
                totalManualButtonCount = j['quantity'];
                break;
              case 55:
                totalLowerTankLevelSensorCount = j['quantity'];
                break;
              case 56:
                totalUpperTankLevelSensorCount = j['quantity'];
                break;
              case 57:
                totalMisting = j['quantity'];
                break;
              case 58:
                totalHeating = j['quantity'];
                break;
              case 59:
                totalPesticides = j['quantity'];
                break;
              case 60:
                totalLight = j['quantity'];
                break;
              case 61:
                totalVent = j['quantity'];
                break;
              case 62:
                totalScreen = j['quantity'];
                break;
              case 63:
                totalAirCirculation = j['quantity'];
                break;
            }
          }
        }
      }
    }
    tabs.sort((a, b) => (a[3] as int).compareTo(b[3] as int));
    notifyListeners();
  }

  //TODO: returnDeviceType_HW
  String returnDeviceType_HW(String title) {
    if (title == 'ORO Smart') {
      return '12';
    } else if (title == 'O-Smart-Plus') {
      return '7';
    } else if (title == 'ORO RTU') {
      return '13';
    } else if (title == 'O-RTU-Plus') {
      return '8';
    } else if (title == 'ORO Switch') {
      return '9';
    } else if (title == 'ORO Sense') {
      return '10';
    } else if (title == 'ORO Pump') {
      return '3';
    } else if (title == 'O-Pump-Plus') {
      return '4';
    } else if (title == 'ORO Level') {
      return '6';
    } else {
      return '0';
    }
  }

  String convertStringForOutput(dynamic data) {
    String myData = '';
    if (data != null) {
      if (data.isNotEmpty) {
        myData =
            '${data['sNo']},${returnDeviceType_HW(data['rtu'])},${data['rfNo']},${data['output']},1';
      }
    }
    return myData;
  }

  String convertStringForOutputHW(String title, dynamic data) {
    String myData = '';
    if (data != null) {
      if (data.isNotEmpty) {
        newSnoList.add(data['sNo']);
        myData =
            '${data['sNo']},$title,${returnDeviceType_HW(data['rtu'])},${refOutCheck(data['rfNo'])},${refOutCheck(data['output'])},1';
      }
    }
    notifyListeners();
    return myData;
  }

  String convertStringForInput(dynamic data) {
    String myData = '';
    if (data != null) {
      if (data.isNotEmpty) {
        newSnoList.add(data['sNo']);
        myData =
            '${data['sNo']},${returnDeviceType_HW(data['rtu'])},${data['rfNo']},${data['input'].split('-')[1]},${data['input_type']}';
      }
    }
    notifyListeners();
    return myData;
  }

  String refOutCheck(String rfandOutput) {
    if (rfandOutput == '-') {
      return '-';
    } else if (rfandOutput.contains('R')) {
      return rfandOutput.split('R')[1];
    } else {
      return rfandOutput;
    }
  }

  String refInCheck(String rfandOutput) {
    if (rfandOutput == '-') {
      return '-';
    } else if (rfandOutput.contains('-')) {
      return rfandOutput.split('-')[1];
    } else {
      return rfandOutput;
    }
  }

  String checkInputType(String input) {
    switch (input) {
      case ('A-I'):
        {
          return '2';
        }
      case ('D-I'):
        {
          return '3';
        }
      case ('P-I'):
        {
          return '4';
        }
      case ('RS485'):
        {
          return '5';
        }
      case ('I2C'):
        {
          return '6';
        }
      case ('M-I'):
        {
          return '7';
        }
      default:
        {
          return '0';
        }
    }
  }

  String convertStringForInputHW(String title, dynamic data) {
    String myData = '';
    if (data != null) {
      if (data.isNotEmpty) {
        myData =
            '${data['sNo']},$title,${returnDeviceType_HW(data['rtu'])},${refOutCheck(data['rfNo'])},${refInCheck(data['input'])},${checkInputType(data['input_type'])}';
      }
    }
    return myData;
  }

  String insertHardwareData(String title, dynamic data, String io) {
    String myData = '';
    if (data == null || data.isEmpty) {
      myData = '';
    } else {
      if (io == 'output') {
        myData = convertStringForOutputHW(title, data);
      } else {
        myData = convertStringForInputHW(title, data);
      }
    }
    return myData;
  }

  String putEnd(String data) {
    if (data == '') {
      return '';
    } else {
      if (data[data.length - 1] != ';') {
        return ';';
      } else {
        return '';
      }
    }
  }

  //TODO: sendData for hardware
  dynamic sendData() {
    newSnoList = [];
    Map<String, dynamic> configData = {
      '200': [
        {'201': ''},
        {'202': ''},
        {'203': ''},
        {'204': ''},
        {'205': ''},
        {'206': ''},
        {'207': ''},
        {'208': ''},

      ],
    };
    if (sourcePumpUpdated.isNotEmpty) {
      for (var i = 0; i < sourcePumpUpdated.length; i++) {
        if (!sourcePumpUpdated[i]['deleted']) {
          var usedInLines = irrigationLines.where((element) => element['sourcePump'].contains('${i+1}')).map((e) => 'IL.${(irrigationLines.indexOf(e) + 1)}').join('_');
          configData['200'][0]['201'] +=
              '${putEnd(configData['200'][0]['201'])}'
              '${sourcePumpUpdated[i]['sNo']},'
                  '${1},'
                  '${i + 1},'
              '${sourcePumpUpdated[i]['waterMeter'].isEmpty ? 0 : 1},'
              '${sourcePumpUpdated[i]['rtu'] == 'ORO Pump' ? 1 : 0},'
              '${sourcePumpUpdated[i]['rtu'] == 'O-Pump-Plus' ? 1 : 0},'
              '${(sourcePumpUpdated[i]['relayCount'] != null && sourcePumpUpdated[i]['relayCount'] == '-') ? 0 : (sourcePumpUpdated[i]['relayCount'] != null && sourcePumpUpdated[i]['relayCount'] != '-') ? int.parse(sourcePumpUpdated[i]['relayCount']) : 0},'
              '${(sourcePumpUpdated[i]['levelType'] != null && sourcePumpUpdated[i]['levelType'] == '-') ? 0 : (sourcePumpUpdated[i]['levelType'] != null && sourcePumpUpdated[i]['levelType'] == 'ADC level') ? 1 : (sourcePumpUpdated[i]['levelType'] != null && sourcePumpUpdated[i]['levelType'] == 'float level') ? 2 : (sourcePumpUpdated[i]['levelType'] != null && sourcePumpUpdated[i]['levelType'] == 'both') ? 3 : 0},'
              '${sourcePumpUpdated[i]['pressureSensor'].isEmpty ? 0 : 1},'
              '${sourcePumpUpdated[i]['TopTankHigh'] == null ? 0 : sourcePumpUpdated[i]['TopTankHigh'].isEmpty ? 0 : 1},'
              '${sourcePumpUpdated[i]['TopTankLow'] == null ? 0 : sourcePumpUpdated[i]['TopTankLow'].isEmpty ? 0 : 1},'
              '${sourcePumpUpdated[i]['SumpTankHigh'] == null ? 0 : sourcePumpUpdated[i]['SumpTankHigh'].isEmpty ? 0 : 1},'
              '${sourcePumpUpdated[i]['SumpTankLow'] == null ? 0 : sourcePumpUpdated[i]['SumpTankLow'].isEmpty ? 0 : 1},'
                  '$usedInLines,'
                  '${sourcePumpUpdated[i]['waterMeter'].isNotEmpty ? 'SW.${i + 1}' : ''},'
                  '${sourcePumpUpdated[i]['levelSensor'].isNotEmpty ? 'LS.${i + 1}' : ''},'
                  '${sourcePumpUpdated[i]['pressureSensor'].isNotEmpty ? 'SPP.${i + 1}' : ''},'
                  '${sourcePumpUpdated[i]['TopTankHigh'].isNotEmpty ? 'SF.${i + 1}.1.2' : ''},'
                  '${sourcePumpUpdated[i]['TopTankLow'].isNotEmpty ? 'SF.${i + 1}.1.1' : ''},'
                  '${sourcePumpUpdated[i]['SumpTankHigh'].isNotEmpty ? 'SF.${i + 1}.2.2' : ''},'
                  '${sourcePumpUpdated[i]['SumpTankLow'].isNotEmpty ? 'SF.${i + 1}.2.1' : ''},'
                  '${sourcePumpUpdated[i]['controlGem'] ? '1' : '0'}'
                  ';';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('SP.${i + 1}', sourcePumpUpdated[i], 'output')}';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('SW.${i + 1}', sourcePumpUpdated[i]['waterMeter'], 'input')}';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('LS.${i + 1}', sourcePumpUpdated[i]['levelSensor'], 'input')}';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('SPP.${i + 1}', sourcePumpUpdated[i]['pressureSensor'], 'input')}';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('SF.${i + 1}.1.1', sourcePumpUpdated[i]['TopTankLow'], 'input')}';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('SF.${i + 1}.1.2', sourcePumpUpdated[i]['TopTankHigh'], 'input')}';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('SF.${i + 1}.2.1', sourcePumpUpdated[i]['SumpTankLow'], 'input')}';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('SF.${i + 1}.2.2', sourcePumpUpdated[i]['SumpTankHigh'], 'input')}';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('SC.${i + 1}.1', sourcePumpUpdated[i]['c1'], 'input')}';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('SC.${i + 1}.2', sourcePumpUpdated[i]['c2'], 'input')}';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('SC.${i + 1}.3', sourcePumpUpdated[i]['c3'], 'input')}';
        }

      }
    }
    if (irrigationPumpUpdated.isNotEmpty) {
      for (var i = 0; i < irrigationPumpUpdated.length; i++) {
        if (!irrigationPumpUpdated[i]['deleted']) {
          var usedInLines = irrigationLines.where((element) => element['irrigationPump'].contains('${i+1}')).map((e) => 'IL.${(irrigationLines.indexOf(e) + 1)}').join('_');
          configData['200'][0]['201'] +=
              '${putEnd(configData['200'][0]['201'])}'
              '${irrigationPumpUpdated[i]['sNo']},'
                  '${2},'
                  '${i + 1},'
              '${irrigationPumpUpdated[i]['waterMeter'].isEmpty ? 0 : 1},'
              '${irrigationPumpUpdated[i]['rtu'] == 'ORO Pump' ? 1 : 0},'
              '${irrigationPumpUpdated[i]['rtu'] == 'O-Pump-Plus' ? 1 : 0},'
              '${(irrigationPumpUpdated[i]['relayCount'] != null && irrigationPumpUpdated[i]['relayCount'] == '-') ? 0 : (irrigationPumpUpdated[i]['relayCount'] != null && irrigationPumpUpdated[i]['relayCount'] != '-') ? int.parse(irrigationPumpUpdated[i]['relayCount']) : 0},'
              '${(irrigationPumpUpdated[i]['levelType'] != null && irrigationPumpUpdated[i]['levelType'] == '-') ? 0 : (irrigationPumpUpdated[i]['levelType'] != null && irrigationPumpUpdated[i]['levelType'] == 'ADC level') ? 1 : (irrigationPumpUpdated[i]['levelType'] != null && irrigationPumpUpdated[i]['levelType'] == 'float level') ? 2 : (irrigationPumpUpdated[i]['levelType'] != null && irrigationPumpUpdated[i]['levelType'] == 'both') ? 3 : 0},'
              '${irrigationPumpUpdated[i]['pressureSensor'].isEmpty ? 0 : 1},'
              '${irrigationPumpUpdated[i]['TopTankHigh'] == null ? 0 : irrigationPumpUpdated[i]['TopTankHigh'].isEmpty ? 0 : 1},'
              '${irrigationPumpUpdated[i]['TopTankLow'] == null ? 0 : irrigationPumpUpdated[i]['TopTankLow'].isEmpty ? 0 : 1},'
              '${irrigationPumpUpdated[i]['SumpTankHigh'] == null ? 0 : irrigationPumpUpdated[i]['SumpTankHigh'].isEmpty ? 0 : 1},'
              '${irrigationPumpUpdated[i]['SumpTankLow'] == null ? 0 : irrigationPumpUpdated[i]['SumpTankLow'].isEmpty ? 0 : 1},'
              '$usedInLines,'
              '${irrigationPumpUpdated[i]['waterMeter'].isNotEmpty ? 'IW.${i + 1}' : ''},'
              '${irrigationPumpUpdated[i]['levelSensor'].isNotEmpty ? 'LP.${i + 1}' : ''},'
              '${irrigationPumpUpdated[i]['pressureSensor'].isNotEmpty ? 'IPP.${i + 1}' : ''},'
              '${irrigationPumpUpdated[i]['TopTankHigh'].isNotEmpty ? 'IF.${i + 1}.1.2' : ''},'
              '${irrigationPumpUpdated[i]['TopTankLow'].isNotEmpty ? 'IF.${i + 1}.1.1' : ''},'
              '${irrigationPumpUpdated[i]['SumpTankHigh'].isNotEmpty ? 'IF.${i + 1}.2.2' : ''},'
              '${irrigationPumpUpdated[i]['SumpTankLow'].isNotEmpty ? 'IF.${i + 1}.2.1' : ''},'
                  '${irrigationPumpUpdated[i]['controlGem'] ? '1' : '0'}'
                  ';';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('IP.${i + 1}', irrigationPumpUpdated[i], 'output')}';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('IW.${i + 1}', irrigationPumpUpdated[i]['waterMeter'], 'input')}';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('LP.${i + 1}', irrigationPumpUpdated[i]['levelSensor'], 'input')}';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('IPP.${i + 1}', irrigationPumpUpdated[i]['pressureSensor'], 'input')}';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('IF.${i + 1}.1.1', irrigationPumpUpdated[i]['TopTankLow'], 'input')}';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('IF.${i + 1}.1.2', irrigationPumpUpdated[i]['TopTankHigh'], 'input')}';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('IF.${i + 1}.2.1', irrigationPumpUpdated[i]['SumpTankLow'], 'input')}';
          configData['200'][5]['206'] +=
              '${putEnd(configData['200'][5]['206'])}${insertHardwareData('IF.${i + 1}.2.2', irrigationPumpUpdated[i]['SumpTankHigh'], 'input')}';
        }
      }
    }
    if (centralDosingUpdated.isNotEmpty) {
      for (var i = 0; i < centralDosingUpdated.length; i++) {
        var agitator = '';
        var usedInLines = irrigationLines.where((element) => element['Central_dosing_site'] == '${i+1}').map((e) => 'IL.${(irrigationLines.indexOf(e) + 1)}').join('_');
        if (!centralDosingUpdated[i]['deleted']) {
          if(['','-'].contains(centralDosingUpdated[i]['agitator'])){
            agitator = '0';
          }else if(centralDosingUpdated[i]['agitator'].contains(',')){
            agitator = centralDosingUpdated[i]['agitator'].split(',').join('_');
          }else{
            agitator = centralDosingUpdated[i]['agitator'];
          }
          if(agitator.isNotEmpty){
            agitator = agitator.split('_').map((item) => 'AG.$item').join('_');
          }
          for (var inj = 0;
              inj < centralDosingUpdated[i]['injector'].length;
              inj++) {
            configData['200'][2]['203'] +=
                '${putEnd(configData['200'][2]['203'])}'
                '${centralDosingUpdated[i]['injector'][inj]['sNo']},'
                '1.${i + 1},'
                '${centralDosingUpdated[i]['boosterConnection'].length},'
                '${centralDosingUpdated[i]['ecConnection'].length},'
                '${centralDosingUpdated[i]['phConnection'].length},'
                '${centralDosingUpdated[i]['pressureSwitch'].isEmpty ? 0 : 1},'
                '${inj + 1},'
                '${centralDosingUpdated[i]['injector'][inj]['dosingMeter'].isEmpty ? 0 : 1},'
                '${centralDosingUpdated[i]['injector'][inj]['levelSensor'].isEmpty ? 0 : 1},'
                '${centralDosingUpdated[i]['injector'][inj]['injectorType'] == 'Venturi' ? 1 : 2},'
                '${centralDosingUpdated[i]['injector'][inj]['Which_Booster_Pump'] == '-' ? '' : 'FB.1.${i + 1}.${centralDosingUpdated[i]['injector'][inj]['Which_Booster_Pump'].split('BP ')[1]}'},'
                    '$usedInLines,'
                    '$agitator';

            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('FC.1.${i + 1}.${inj + 1}', centralDosingUpdated[i]['injector'][inj], 'output')}';
            if (centralDosingUpdated[i]['injector'][inj]['dosingMeter']
                .isNotEmpty) {
              configData['200'][5]['206'] +=
                  '${putEnd(configData['200'][5]['206'])}${insertHardwareData('FM.1.${i + 1}.${inj + 1}', centralDosingUpdated[i]['injector'][inj]['dosingMeter'], 'input')}';
            }
            if (centralDosingUpdated[i]['injector'][inj]['levelSensor']
                .isNotEmpty) {
              configData['200'][5]['206'] +=
                  '${putEnd(configData['200'][5]['206'])}${insertHardwareData('LS.1.${i + 1}.${inj + 1}', centralDosingUpdated[i]['injector'][inj]['levelSensor'], 'input')}';
            }
          }
          for (var bp = 0;
              bp < centralDosingUpdated[i]['boosterConnection'].length;
              bp++) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('FB.1.${i + 1}.${bp + 1}', centralDosingUpdated[i]['boosterConnection'][bp], 'output')}';
          }
          if (centralDosingUpdated[i]['pressureSwitch'].isNotEmpty) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('PSW.1.${i + 1}', centralDosingUpdated[i]['pressureSwitch'], 'input')}';
          }
          for (var bp = 0;
              bp < centralDosingUpdated[i]['ecConnection'].length;
              bp++) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('EC.1.${i + 1}.${bp + 1}', centralDosingUpdated[i]['ecConnection'][bp], 'input')}';
          }
          for (var bp = 0;
              bp < centralDosingUpdated[i]['phConnection'].length;
              bp++) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('PH.1.${i + 1}.${bp + 1}', centralDosingUpdated[i]['phConnection'][bp], 'input')}';
          }
        }
      }
    }
    if (centralFiltrationUpdated.isNotEmpty) {
      for (var i = 0; i < centralFiltrationUpdated.length; i++) {
        var usedInLines = irrigationLines.where((element) => element['Central_filtration_site'] == '${i+1}').map((e) => 'IL.${(irrigationLines.indexOf(e) + 1)}').join('_');
        if (!centralFiltrationUpdated[i]['deleted']) {
          configData['200'][3]['204'] +=
              '${putEnd(configData['200'][3]['204'])}'
              '${centralFiltrationUpdated[i]['sNo']},'
              '1.${i + 1},'
              '${centralFiltrationUpdated[i]['filterConnection'].length},'
              '${centralFiltrationUpdated[i]['dv'].isEmpty ? 0 : 1},'
              '${centralFiltrationUpdated[i]['pressureIn'].isEmpty ? 0 : 1},'
              '${centralFiltrationUpdated[i]['pressureOut'].isEmpty ? 0 : 1},'
              '${centralFiltrationUpdated[i]['pressureSwitch'].isEmpty ? 0 : 1},'
              '${centralFiltrationUpdated[i]['diffPressureSensor'].isEmpty ? 0 : 1},'
              '$usedInLines';
          for (var fl = 0;
              fl < centralFiltrationUpdated[i]['filterConnection'].length;
              fl++) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('FL.1.${i + 1}.${fl + 1}', centralFiltrationUpdated[i]['filterConnection'][fl], 'output')}';
          }
          if (centralFiltrationUpdated[i]['pressureSwitch'].isNotEmpty) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('PSW.1.${i + 1}', centralFiltrationUpdated[i]['pressureSwitch'], 'input')}';
          }
          if (centralFiltrationUpdated[i]['diffPressureSensor'].isNotEmpty) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('DPS.1.${i + 1}', centralFiltrationUpdated[i]['diffPressureSensor'], 'input')}';
          }
          if (centralFiltrationUpdated[i]['dv'].isNotEmpty) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('DV.1.${i + 1}', centralFiltrationUpdated[i]['dv'], 'output')}';
          }
          if (centralFiltrationUpdated[i]['pressureIn'].isNotEmpty) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('FI.1.${i + 1}', centralFiltrationUpdated[i]['pressureIn'], 'input')}';
          }
          if (centralFiltrationUpdated[i]['pressureOut'].isNotEmpty) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('FO.1.${i + 1}', centralFiltrationUpdated[i]['pressureOut'], 'input')}';
          }
        }
      }
    }
    if (irrigationLines.isNotEmpty) {
      for (var i = 0; i < irrigationLines.length; i++) {
        if (!irrigationLines[i]['deleted']) {
          var irrPump = '';
          var srcPump = '';
          var agitator = '';
          if(['','-'].contains(irrigationLines[i]['irrigationPump'])){
            irrPump = '0';
          }else if(irrigationLines[i]['irrigationPump'].contains(',')){
            irrPump = irrigationLines[i]['irrigationPump'].split(',').join('_');
          }else{
            irrPump = irrigationLines[i]['irrigationPump'];
          }
          if(['','-'].contains(irrigationLines[i]['sourcePump'])){
            srcPump = '0';
          }else if(irrigationLines[i]['sourcePump'].contains(',')){
            srcPump = irrigationLines[i]['sourcePump'].split(',').join('_');
          }else{
            srcPump = irrigationLines[i]['sourcePump'];
          }
          if(['','-'].contains(irrigationLines[i]['agitator'])){
            agitator = '0';
          }else if(irrigationLines[i]['agitator'].contains(',')){
            agitator = irrigationLines[i]['agitator'].split(',').join('_');
          }else{
            agitator = irrigationLines[i]['agitator'];
          }
          if(agitator.isNotEmpty){
            agitator = agitator.split('_').map((item) => 'AG.$item').join('_');
          }
          configData['200'][1]['202'] +=
              '${putEnd(configData['200'][1]['202'])}'
              '${irrigationLines[i]['sNo']},'
              'IL.${i + 1},'
              '${irrigationLines[i]['valve'] == '' ? 0 : int.parse(irrigationLines[i]['valve'])},'
              '${irrigationLines[i]['main_valve'] == '' ? 0 : int.parse(irrigationLines[i]['main_valve'])},'
              '${irrigationLines[i]['moistureSensor'] == '' ? 0 : int.parse(irrigationLines[i]['moistureSensor'])},'
              '${irrigationLines[i]['levelSensor'] == '' ? 0 : int.parse(irrigationLines[i]['levelSensor'])},'
              '${irrigationLines[i]['fogger'] == '' ? 0 : int.parse(irrigationLines[i]['fogger'])},'
              '${irrigationLines[i]['fan'] == '' ? 0 : int.parse(irrigationLines[i]['fan'])},'
              '${irrigationLines[i]['Central_dosing_site'] == '-' ? 0 : 'CFESI.${int.parse(irrigationLines[i]['Central_dosing_site'])}'},'
              '${irrigationLines[i]['Central_filtration_site'] == '-' ? 0 : 'CFISI.${int.parse(irrigationLines[i]['Central_filtration_site'])}'},'
              '${irrigationLines[i]['Local_dosing_site'] == true ? 1 : 0},'
              '${irrigationLines[i]['local_filtration_site'] == true ? 1 : 0},'
              '${irrigationLines[i]['pressureIn'].isEmpty ? 0 : 1},'
              '${irrigationLines[i]['pressureOut'].isEmpty ? 0 : 1},'
              '$irrPump,'
              '${irrigationLines[i]['water_meter'].isEmpty ? 0 : 1},'
                  '${irrigationLines[i]['powerSupply'].isEmpty ? 0 : 1},'
                  '${irrigationLines[i]['pressureSwitch'].isEmpty ? '' : 'PSW.${i + 1}'},'
                  '${[for(var ls = 0;ls < irrigationLines[i]['levelSensorConnection'].length;ls++) 'LV.${i + 1}.${ls + 1}'].join('_')},'
                  '$agitator'
          ;
          for (var il = 0;
              il < irrigationLines[i]['valveConnection'].length;
              il++) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('VL.${i + 1}.${il + 1}', irrigationLines[i]['valveConnection'][il], 'output')}';
          }
          for (var il = 0;
              il < irrigationLines[i]['main_valveConnection'].length;
              il++) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('MV.${i + 1}.${il + 1}', irrigationLines[i]['main_valveConnection'][il], 'output')}';
          }
          for (var il = 0;
              il < irrigationLines[i]['moistureSensorConnection'].length;
              il++) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('SM.${i + 1}.${il + 1}', irrigationLines[i]['moistureSensorConnection'][il], 'input')}';
          }
          for (var il = 0;
              il < irrigationLines[i]['levelSensorConnection'].length;
              il++) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('LV.${i + 1}.${il + 1}', irrigationLines[i]['levelSensorConnection'][il], 'input')}';
          }
          for (var il = 0;
              il < irrigationLines[i]['foggerConnection'].length;
              il++) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('FG.${i + 1}.${il + 1}', irrigationLines[i]['foggerConnection'][il], 'output')}';
          }
          for (var il = 0;
              il < irrigationLines[i]['fanConnection'].length;
              il++) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('FN.${i + 1}.${il + 1}', irrigationLines[i]['fanConnection'][il], 'output')}';
          }
          if (irrigationLines[i]['pressureIn'].isNotEmpty) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('LI.${i + 1}', irrigationLines[i]['pressureIn'], 'input')}';
          }
          if (irrigationLines[i]['pressureOut'].isNotEmpty) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('LO.${i + 1}', irrigationLines[i]['pressureOut'], 'input')}';
          }
          if (irrigationLines[i]['water_meter'].isNotEmpty) {
            configData['200'][5]['206'] +=
                '${putEnd(configData['200'][5]['206'])}${insertHardwareData('LW.${i + 1}', irrigationLines[i]['water_meter'], 'input')}';
          }
          if (irrigationLines[i]['powerSupply'].isNotEmpty) {
            configData['200'][5]['206'] +=
            '${putEnd(configData['200'][5]['206'])}${insertHardwareData('PSP.${i + 1}', irrigationLines[i]['powerSupply'], 'input')}';
          }
          if (irrigationLines[i]['pressureSwitch'].isNotEmpty) {
            configData['200'][5]['206'] +=
            '${putEnd(configData['200'][5]['206'])}${insertHardwareData('PSW.${i + 1}', irrigationLines[i]['pressureSwitch'], 'input')}';
          }
          if (irrigationLines[i]['Local_dosing_site'] == true) {
            for (var ld = 0; ld < localDosingUpdated.length; ld++) {
              if (localDosingUpdated[ld]['sNo'] == irrigationLines[i]['sNo']) {
                var agitator = '';
                if(['','-'].contains(localDosingUpdated[ld]['agitator'])){
                  agitator = '0';
                }else if(localDosingUpdated[ld]['agitator'].contains(',')){
                  agitator = localDosingUpdated[ld]['agitator'].split(',').join('_');
                }else{
                  agitator = localDosingUpdated[ld]['agitator'];
                }
                if(agitator.isNotEmpty){
                  agitator = agitator.split('_').map((item) => 'AG.$item').join('_');
                }
                for (var bp = 0;
                    bp < localDosingUpdated[ld]['boosterConnection'].length;
                    bp++) {
                  configData['200'][5]['206'] +=
                      '${putEnd(configData['200'][5]['206'])}${insertHardwareData('FB.2.${i + 1}.${bp + 1}', localDosingUpdated[ld]['boosterConnection'][bp], 'output')}';
                }
                for (var inj = 0;
                    inj < localDosingUpdated[ld]['injector'].length;
                    inj++) {
                  configData['200'][2]['203'] +=
                      '${putEnd(configData['200'][2]['203'])}'
                      '${localDosingUpdated[ld]['injector'][inj]['sNo']},'
                      '2.${i + 1},'
                      '${localDosingUpdated[ld]['boosterConnection'].length},'
                      '${localDosingUpdated[ld]['ecConnection'].length},'
                      '${localDosingUpdated[ld]['phConnection'].length},'
                      '${localDosingUpdated[ld]['pressureSwitch'].isEmpty ? 0 : 1},'
                      '${inj + 1},'
                      '${localDosingUpdated[ld]['injector'][inj]['dosingMeter'].isEmpty ? 0 : 1},'
                      '${localDosingUpdated[ld]['injector'][inj]['levelSensor'].isEmpty ? 0 : 1},'
                      '${localDosingUpdated[ld]['injector'][inj]['injectorType'] == 'Venturi' ? 1 : 2},'
                      '${localDosingUpdated[ld]['injector'][inj]['Which_Booster_Pump'] == '-' ? '' : 'FB.2.${i + 1}.${localDosingUpdated[ld]['injector'][inj]['Which_Booster_Pump'].split('BP ')[1]}'},'
                          'IL.${i + 1},'
                          '$agitator';
                  configData['200'][5]['206'] +=
                      '${putEnd(configData['200'][5]['206'])}${insertHardwareData('FC.2.${i + 1}.${inj + 1}', localDosingUpdated[ld]['injector'][inj], 'output')}';
                  if (localDosingUpdated[ld]['injector'][inj]['dosingMeter']
                      .isNotEmpty) {
                    configData['200'][5]['206'] +=
                        '${putEnd(configData['200'][5]['206'])}${insertHardwareData('FM.2.${i + 1}.${inj + 1}', localDosingUpdated[ld]['injector'][inj]['dosingMeter'], 'input')}';
                  }
                  if (localDosingUpdated[ld]['injector'][inj]['levelSensor']
                      .isNotEmpty) {
                    configData['200'][5]['206'] +=
                        '${putEnd(configData['200'][5]['206'])}${insertHardwareData('LS.2.${i + 1}.${inj + 1}', localDosingUpdated[ld]['injector'][inj]['levelSensor'], 'input')}';
                  }
                }
                if (localDosingUpdated[ld]['pressureSwitch'].isNotEmpty) {
                  configData['200'][5]['206'] +=
                      '${putEnd(configData['200'][5]['206'])}${insertHardwareData('PSW.2.${i + 1}', localDosingUpdated[ld]['pressureSwitch'], 'input')}';
                }
                for (var bp = 0;
                    bp < localDosingUpdated[ld]['ecConnection'].length;
                    bp++) {
                  configData['200'][5]['206'] +=
                      '${putEnd(configData['200'][5]['206'])}${insertHardwareData('EC.2.${i + 1}.${bp + 1}', localDosingUpdated[ld]['ecConnection'][bp], 'input')}';
                }
                for (var bp = 0;
                    bp < localDosingUpdated[ld]['phConnection'].length;
                    bp++) {
                  configData['200'][5]['206'] +=
                      '${putEnd(configData['200'][5]['206'])}${insertHardwareData('PH.2.${i + 1}.${bp + 1}', localDosingUpdated[ld]['phConnection'][bp], 'input')}';
                }
              }
            }
          }
          if (irrigationLines[i]['local_filtration_site'] == true) {
            for (var lf = 0; lf < localFiltrationUpdated.length; lf++) {
              if (localFiltrationUpdated[lf]['sNo'] ==
                  irrigationLines[i]['sNo']) {
                configData['200'][3]['204'] +=
                    '${putEnd(configData['200'][3]['204'])}'
                    '${localFiltrationUpdated[lf]['sNo']},2.${i + 1},'
                    '${localFiltrationUpdated[lf]['filterConnection'].length},'
                    '${localFiltrationUpdated[lf]['dv'].isEmpty ? 0 : 1},'
                    '${localFiltrationUpdated[lf]['pressureIn'].isEmpty ? 0 : 1},'
                    '${localFiltrationUpdated[lf]['pressureOut'].isEmpty ? 0 : 1},'
                    '${localFiltrationUpdated[lf]['pressureSwitch'].isEmpty ? 0 : 1},'
                    '${localFiltrationUpdated[lf]['diffPressureSensor'].isEmpty ? 0 : 1},'
                        'IL.${i + 1}';
                for (var fl = 0;
                    fl < localFiltrationUpdated[lf]['filterConnection'].length;
                    fl++) {
                  configData['200'][5]['206'] +=
                      '${putEnd(configData['200'][5]['206'])}${insertHardwareData('FL.2.${i + 1}.${fl + 1}', localFiltrationUpdated[lf]['filterConnection'][fl], 'output')}';
                }
                if (localFiltrationUpdated[lf]['pressureSwitch'].isNotEmpty) {
                  configData['200'][5]['206'] +=
                      '${putEnd(configData['200'][5]['206'])}${insertHardwareData('PSW.2.${i + 1}', localFiltrationUpdated[lf]['pressureSwitch'], 'input')}';
                }
                if (localFiltrationUpdated[lf]['diffPressureSensor']
                    .isNotEmpty) {
                  configData['200'][5]['206'] +=
                      '${putEnd(configData['200'][5]['206'])}${insertHardwareData('DPS.2.${i + 1}', localFiltrationUpdated[lf]['diffPressureSensor'], 'input')}';
                }
                if (localFiltrationUpdated[lf]['dv'].isNotEmpty) {
                  configData['200'][5]['206'] +=
                      '${putEnd(configData['200'][5]['206'])}${insertHardwareData('DV.2.${i + 1}', localFiltrationUpdated[lf]['dv'], 'output')}';
                }
                if (localFiltrationUpdated[lf]['pressureIn'].isNotEmpty) {
                  configData['200'][5]['206'] +=
                      '${putEnd(configData['200'][5]['206'])}${insertHardwareData('FI.2.${i + 1}', localFiltrationUpdated[lf]['pressureIn'], 'input')}';
                }
                if (localFiltrationUpdated[lf]['pressureOut'].isNotEmpty) {
                  configData['200'][5]['206'] +=
                      '${putEnd(configData['200'][5]['206'])}${insertHardwareData('FO.2.${i + 1}', localFiltrationUpdated[lf]['pressureOut'], 'input')}';
                }
              }
            }
          }
        }
      }
    }
    var weatherData = '';
    for (var key in weatherStation.keys) {
      if(weatherStation[key]['apply'] == true){
        for(var sensor in weatherStation[key].keys){
          if(!['apply','irrigationLine'].contains(sensor)){
            var sns = weatherStation[key][sensor];
            weatherData += '${weatherData.isNotEmpty ? ';' : ''}'
                '${sns['sNo']},$key,${sns['code']},${sns['apply'] == true ? 1 : 0},${weatherStation[key]['irrigationLine']}' ;
          }
        }
      }
      configData['200'][4]['205'] = weatherData;
    }

    configData['200'][7]['208'] = '';

    dynamic sensorObject = [
      {'data' : totalAgitator,'objectId' : 'AG','mode': 1},
      {'data' : totalSelector,'objectId' : 'SL','mode': 1},
      {'data' : totalAnalogSensor,'objectId' : 'AS','mode': 2},
      {'data' : totalContact,'objectId' : 'CN','mode': 2},
      {'data' : totalCommonPressureSensor,'objectId' : 'CPS','mode': 2},
      {'data' : totalCommonPressureSwitch,'objectId' : 'CPSW','mode': 2},
      {'data' : totalTankFloat,'objectId' : 'TFL','mode': 2},
      {'data' : totalManualButton,'objectId' : 'MB','mode': 2},
      {'data' : connTempSensor,'objectId' : 'AT','mode': 2},
      {'data' : connSoilTempSensor,'objectId' : 'ST','mode': 2},
      {'data' : connCo2,'objectId' : 'CO','mode': 2},
      {'data' : connHumidity,'objectId' : 'AH','mode': 2},
      {'data' : connWindDirection,'objectId' : 'WD','mode': 2},
      {'data' : connLux,'objectId' : 'LUX','mode': 2},
      {'data' : connLeafWetness,'objectId' : 'LW','mode': 2},
      {'data' : connWindSpeed,'objectId' : 'WSP','mode': 2},
      {'data' : connLdr,'objectId' : 'LDR','mode': 2},
      {'data' : connRainGauge,'objectId' : 'RF','mode': 2},
      {'data' : totalLowerTankLevelSensor,'objectId' : 'LLS','mode': 2},
      {'data' : totalUpperTankLevelSensor,'objectId' : 'ULS','mode': 2},
    ];
    for(var so in sensorObject){
      for (var i = 0; i < so['data'].length; i++) {
        if(so['data'][i][so['mode'] == 1 ? 'output' :'input']!= '-'){
          configData['200'][5]['206'] +=
          '${putEnd(configData['200'][5]['206'])}${insertHardwareData('${so['objectId']}.${i + 1}', so['data'][i], so['mode'] == 1 ? 'output' :'input')}';
        }
      }
    }
    for (var element in oldSnoList) {
      if (newSnoList.contains(element)) {
      } else {
        isNew = true;
        break;
      }
    }
    configData['200'][6]['207'] = '${isNew == true ? 1 : 0}';
    notifyListeners();
    print('hw : ${jsonEncode(configData)}');
    //TODO : print hw payload

    return configData;
  }

  int editLimit({required data, required dynamic oldInt, required int newInt,bool? check}) {
    dynamic val = data;
    if(check == true){
    }
    var oldInteger = oldInt ?? 0;
    if (oldInteger < newInt) {
      val += newInt - oldInteger;
      if(check == true){
      }
    }else {
      val -= oldInteger - newInt;
      if(check == true){
      }
    }
    return val;
  }

  List<dynamic> getRfNo({required List<dynamic> newList, required List<dynamic> oldList}) {
    var list = [...oldList];
    var newListDupicate = [];
    for (var i in newList) {
      newListDupicate.add('${i['referenceNumber']}');
      if (!list.contains('${i['referenceNumber']}')) {
        list.add('${i['referenceNumber']}');
      }
    }
    for (var i = list.length - 1; i > -1; i--) {
      if (!newListDupicate.contains(list[i])) {
        list.removeAt(i);
      }
    }
    return list;
  }

  //TODO: sendData for hardware
  void fetchFromServer() {
    isNew = false;
    oldSnoList = oldData['productLimit']['newSnoList'];
    oWeather = oldData['productLimit']['oWeather'];
    oRoWeatherForStation = oldData['productLimit']['oRoWeatherForStation'];
    totalTempSensor = oldData['productLimit']['totalTempSensor'];
    connTempSensor = oldData['productLimit']['connTempSensor'];
    totalSoilTempSensor = oldData['productLimit']['totalSoilTempSensor'];
    connSoilTempSensor = oldData['productLimit']['connSoilTempSensor'];
    totalHumidity = oldData['productLimit']['totalHumidity'];
    connHumidity = oldData['productLimit']['connHumidity'];
    totalCo2 = oldData['productLimit']['totalCo2'];
    connCo2 = oldData['productLimit']['connCo2'];
    totalLux = oldData['productLimit']['totalLux'];
    connLux = oldData['productLimit']['connLux'];
    totalLdr = oldData['productLimit']['totalLdr'];
    connLdr = oldData['productLimit']['connLdr'];
    totalWindSpeed = oldData['productLimit']['totalWindSpeed'];
    connWindSpeed = oldData['productLimit']['connWindSpeed'];
    totalWindDirection = oldData['productLimit']['totalWindDirection'];
    connWindDirection = oldData['productLimit']['connWindDirection'];
    totalRainGauge = oldData['productLimit']['totalRainGauge'];
    connRainGauge = oldData['productLimit']['connRainGauge'];
    totalLeafWetness = oldData['productLimit']['totalLeafWetness'];
    connLeafWetness = oldData['productLimit']['connLeafWetness'];
    totalPressureSwitch = oldData['productLimit']['totalPressureSwitch'];
    totalDiffPressureSensor = oldData['productLimit']['totalDiffPressureSensor'];
    totalWaterSource = oldData['productLimit']['totalWaterSource'];
    totalFloat = oldData['productLimit']['totalFloat'] ?? 0;
    totalWaterMeter = oldData['productLimit']['totalWaterMeter'];
    totalPowerSupply = oldData['productLimit']?['totalPowerSupply'] ?? 0;
    totalSourcePump = oldData['productLimit']['totalSourcePump'];
    totalIrrigationPump = oldData['productLimit']['totalIrrigationPump'];
    totalInjector = oldData['productLimit']['totalInjector'];
    totalDosingMeter = oldData['productLimit']['totalDosingMeter'];
    totalBooster = oldData['productLimit']['totalBooster'];
    totalCentralDosing = oldData['productLimit']['totalCentralDosing'];
    totalFilter = oldData['productLimit']['totalFilter'];
    total_D_s_valve = oldData['productLimit']['total_D_s_valve'];
    total_p_sensor = oldData['productLimit']['total_p_sensor'];
    totalCentralFiltration = oldData['productLimit']['totalCentralFiltration'];
    totalValve = oldData['productLimit']['totalValve'];
    totalMainValve = oldData['productLimit']['totalMainValve'];
    totalIrrigationLine = oldData['productLimit']['totalIrrigationLine'];
    totalLocalFiltration = oldData['productLimit']['totalLocalFiltration'];
    totalLocalDosing = oldData['productLimit']['totalLocalDosing'];
    totalRTU = oldData['productLimit']['totalRTU'];
    totalRtuPlus = oldData['productLimit']['totalRtuPlus'];
    totalOroSwitch = oldData['productLimit']['totalOroSwitch'];
    totalOroSense = oldData['productLimit']['totalOroSense'];
    totalOroSmartRTU = oldData['productLimit']['totalOroSmartRTU'];
    totalOroSmartRtuPlus = oldData['productLimit']['totalOroSmartRtuPlus'];
    totalOroLevel = oldData['productLimit']['totalOroLevel'];
    totalOroPump = oldData['productLimit']['totalOroPump'];
    totalOroExtend = oldData['productLimit']['totalOroExtend'];
    i_o_types = oldData['productLimit']['i_o_types'];
    totalPhSensor = oldData['productLimit']['totalPhSensor'];
    totalEcSensor = oldData['productLimit']['totalEcSensor'];
    totalMoistureSensor = oldData['productLimit']['totalMoistureSensor'];
    totalLevelSensor = oldData['productLimit']['totalLevelSensor'];
    totalFan = oldData['productLimit']['totalFan'];
    totalFogger = oldData['productLimit']['totalFogger'];
    oRtu = oldData['productLimit']['oRtu'];
    oRtuPlus = oldData['productLimit']['oRtuPlus'];
    oSrtu = oldData['productLimit']['oSrtu'];
    oSrtuPlus = oldData['productLimit']['oSrtuPlus'];
    oSwitch = oldData['productLimit']['oSwitch'];
    oSense = oldData['productLimit']['oSense'];
    oLevel = oldData['productLimit']['oLevel'];
    oPump = oldData['productLimit']['oPump'];
    oPumpPlus = oldData['productLimit']['oPumpPlus'];
    oExtend = oldData['productLimit']['oExtend'];
    waterSource = oldData['productLimit']['waterSource'];
    if(oldData['productLimit']['weatherStation'].runtimeType == List<dynamic>){
      weatherStation = {};
    }else{
      weatherStation = oldData['productLimit']['weatherStation'];
      for(var key in weatherStation.keys){
        if(!weatherStation[key].containsKey('irrigationLine')){
          weatherStation[key]['irrigationLine'] = '-';
        }
      }
    }
    central_dosing_site_list =
        oldData['productLimit']['central_dosing_site_list'];
    central_filtration_site_list =
        oldData['productLimit']['central_filtration_site_list'];
    irrigation_pump_list = oldData['productLimit']['irrigation_pump_list'];
    water_source_list = oldData['productLimit']['water_source_list'];
    I_O_autoIncrement = oldData['productLimit']['I_O_autoIncrement'];
    List<Map<String,dynamic>> addedCountVariables = [
      {'key':'totalManualButtonCount','variable' : () => totalManualButtonCount, 'setter' : (value) => totalManualButtonCount = value, 'listName' : 'totalManualButton','list' : () => totalManualButton, 'listSetter' : (value) => totalManualButton = value},
      {'key':'totalTankFloatCount','variable' : () => totalTankFloatCount, 'setter' : (value) => totalTankFloatCount = value, 'listName' : 'totalTankFloat','list' : () => totalTankFloat, 'listSetter' : (value) => totalTankFloat = value},
      {'key':'totalCommonPressureSwitchCount','variable' : () => totalCommonPressureSwitchCount, 'setter' : (value) => totalCommonPressureSwitchCount = value, 'listName' : 'totalCommonPressureSwitch','list' : () => totalCommonPressureSwitch, 'listSetter' : (value) => totalCommonPressureSwitch = value},
      {'key':'totalCommonPressureSensorCount','variable' : () => totalCommonPressureSensorCount, 'setter' : (value) => totalCommonPressureSensorCount = value, 'listName' : 'totalCommonPressureSensor','list' : () => totalCommonPressureSensor, 'listSetter' : (value) => totalCommonPressureSensor = value},
      {'key':'totalContactCount','variable' : () => totalContactCount, 'setter' : (value) => totalContactCount = value, 'listName' : 'totalContact','list' : () => totalContact, 'listSetter' : (value) => totalContact = value},
      {'key':'totalAnalogSensorCount','variable' : () => totalAnalogSensorCount, 'setter' : (value) => totalAnalogSensorCount = value, 'listName' : 'totalAnalogSensor','list' : () => totalAnalogSensor, 'listSetter' : (value) => totalAnalogSensor = value},
      {'key':'totalSelectorCount','variable' : () => totalSelectorCount, 'setter' : (value) => totalSelectorCount = value, 'listName' : 'totalSelector','list' : () => totalSelector, 'listSetter' : (value) => totalSelector = value},
      {'key':'totalAgitatorCount','variable' : () => totalAgitatorCount, 'setter' : (value) => totalAgitatorCount = value, 'listName' : 'totalAgitator','list' : () => totalAgitator, 'listSetter' : (value) => totalAgitator = value},
      {'key':'totalLowerTankLevelSensorCount','variable' : () => totalLowerTankLevelSensorCount, 'setter' : (value) => totalLowerTankLevelSensorCount = value, 'listName' : 'totalLowerTankLevelSensor','list' : () => totalLowerTankLevelSensor, 'listSetter' : (value) => totalLowerTankLevelSensor = value},
      {'key':'totalUpperTankLevelSensorCount','variable' : () => totalUpperTankLevelSensorCount, 'setter' : (value) => totalUpperTankLevelSensorCount = value, 'listName' : 'totalUpperTankLevelSensor','list' : () => totalUpperTankLevelSensor, 'listSetter' : (value) => totalUpperTankLevelSensor = value}
    ];
    for (var acv in addedCountVariables) {
      if (oldData['productLimit'][acv['key']] == null) {
        acv ;
      } else {
        acv['setter'](oldData['productLimit'][acv['key']]);
      }
      if (oldData['productLimit'][acv['listName']] == null) {
        acv['listSetter']([]);
      } else {
        acv['listSetter'](oldData['productLimit'][acv['listName']]);
      }
    }
    sourcePumpUpdated = oldData['sourcePump'];
    for(var sp in sourcePumpUpdated){
      if(!sp.containsKey('controlGem')){
        sp['controlGem'] = false;
      }
      if(!sp.containsKey('bottomTankLevel')){
        sp['bottomTankLevel'] = {};
      }
      if(!sp.containsKey('pressureOut')){
        sp['pressureOut'] = {};
      }
    }
    print('sourcePump : ${sourcePumpUpdated}');

    irrigationPumpUpdated = oldData['irrigationPump'];
    for(var ip in irrigationPumpUpdated){
      if(!ip.containsKey('controlGem')){
        ip['controlGem'] = false;
      }
      if(!ip.containsKey('bottomTankLevel')){
        ip['bottomTankLevel'] = {};
      }
      if(!ip.containsKey('pressureOut')){
        ip['pressureOut'] = {};
      }
    }

    centralDosingUpdated = oldData['centralFertilizer'];
    for(var cd in centralDosingUpdated){
      if(!cd.containsKey('agitator')){
        cd['agitator'] = '-';
      }
    }
    centralFiltrationUpdated = oldData['centralFilter'];
    irrigationLines = oldData['irrigationLine'];
    for(var i in irrigationLines){
      if(i['powerSupply'] == null){
        i['powerSupply'] = {};
      }
      if(i['pressureSwitch'] == null){
        i['pressureSwitch'] = {};
      }
      if(i['sourcePump'] == null){
        i['sourcePump'] = '-';
      }
      if(i['agitator'] == null){
        i['agitator'] = '-';
      }
      for(var greenHouseParameter in ['misting', 'heating', 'pesticides', 'light', 'vent', 'screen', 'airCirculation',
        'co2', 'temperature', 'soilTemperature', 'humidity']){
        if(i[greenHouseParameter] == null){
          i[greenHouseParameter] = '';
        }
      }
      for(var greenHouseParameter in ['mistingConnection', 'heatingConnection', 'pesticidesConnection', 'lightConnection', 'ventConnection', 'screenConnection', 'airCirculationConnection',
        'co2Connection', 'temperatureConnection', 'soilTemperatureConnection', 'humidityConnection']){
        if(i[greenHouseParameter] == null){
          i[greenHouseParameter] = [];
        }
      }
    }
    localDosingUpdated = oldData['localFertilizer'];
    for(var ld in localDosingUpdated){
      if(!ld.containsKey('agitator')){
        ld['agitator'] = '-';
      }
    }
    localFiltrationUpdated = oldData['localFilter'];
    tabs = [];
    tabs.add(['Start', '', Icons.play_circle_filled, 0]);
    tabs.add(['Mapping', 'of Output', Icons.compare_arrows, 9]);
    tabs.add(['Mapping', 'of Input', Icons.compare_arrows, 10]);
    tabs.add(['Finish', '', Icons.check_circle, 11]);
    for (var i in serverData.entries) {
      if (i.key == 'productLimit') {
        var oldLimit = {};
        for (var i in oldData['productLimit']['oldData']) {
          oldLimit[i['productTypeId']] = i['quantity'];
        }
        for (var j in i.value) {
          switch (j['productTypeId']) {
            case 1:
              if (j['quantity'] != 0 || sourcePumpUpdated.isNotEmpty) {
                tabs.add(['Source', 'Pump', Icons.water, 1]);
              }
              totalSourcePump = editLimit(
                  data: totalSourcePump,
                  oldInt: oldLimit[1],
                  newInt: j['quantity']);
              break;
            case 2:
              if (j['quantity'] != 0 || irrigationPumpUpdated.isNotEmpty) {
                tabs.add(['Irrigation', 'Pump', Icons.waterfall_chart, 2]);
              }
              totalIrrigationPump = editLimit(
                  data: totalIrrigationPump,
                  oldInt: oldLimit[2],
                  newInt: j['quantity']);
              break;
            case 3:
              totalBooster = editLimit(
                  data: totalBooster,
                  oldInt: oldLimit[3],
                  newInt: j['quantity'],check:  true);
              break;
            case 4:
              if (j['quantity'] != 0 || centralDosingUpdated.isNotEmpty) {
                tabs.add(['Local', 'Dosing', Icons.local_hospital, 6]);
              }
              totalInjector = editLimit(
                  data: totalInjector,
                  oldInt: oldLimit[4],
                  newInt: j['quantity']);
              break;
            case 5:
              if (j['quantity'] != 0 || centralFiltrationUpdated.isNotEmpty) {
                tabs.add(['Local', 'Filtration', Icons.filter_vintage, 7]);
              }
              totalFilter = editLimit(
                  data: totalFilter,
                  oldInt: oldLimit[5],
                  newInt: j['quantity']);
              break;
            case 6:
              totalValve = editLimit(
                  data: totalValve, oldInt: oldLimit[6], newInt: j['quantity'],check: true);
              break;
            case 7:
              totalMainValve = editLimit(
                  data: totalMainValve,
                  oldInt: oldLimit[7],
                  newInt: j['quantity']);
              break;
            case 8:
              total_D_s_valve = editLimit(
                  data: total_D_s_valve,
                  oldInt: oldLimit[8],
                  newInt: j['quantity']);
            case 9:
              totalFan = editLimit(
                  data: totalFan, oldInt: oldLimit[9], newInt: j['quantity']);
              break;
            case 10:
              totalFogger = editLimit(
                  data: totalFan, oldInt: oldLimit[10], newInt: j['quantity']);
              break;
            case 11:
              totalAgitatorCount = editLimit(
                  data: totalAgitatorCount, oldInt: oldLimit[11], newInt: j['quantity']);
              break;
            case 12:
              totalSelectorCount = editLimit(
                  data: totalSelectorCount, oldInt: oldLimit[12], newInt: j['quantity']);
              break;
            case 13:
              totalWaterMeter = editLimit(
                  data: totalWaterMeter,
                  oldInt: oldLimit[13],
                  newInt: j['quantity']);
              break;
            case 14:
              totalDosingMeter = editLimit(
                  data: totalDosingMeter,
                  oldInt: oldLimit[14],
                  newInt: j['quantity']);
              break;
            case 15:
              totalPressureSwitch = editLimit(
                  data: totalPressureSwitch,
                  oldInt: oldLimit[15],
                  newInt: j['quantity']);
              break;
            case 16:
              total_p_sensor = editLimit(
                  data: total_p_sensor,
                  oldInt: oldLimit[16],
                  newInt: j['quantity']);
              break;
            case 17:
              totalDiffPressureSensor = editLimit(
                  data: totalDiffPressureSensor,
                  oldInt: oldLimit[17],
                  newInt: j['quantity']);
              break;
            case 18:
              totalMoistureSensor = editLimit(
                  data: totalMoistureSensor,
                  oldInt: oldLimit[18],
                  newInt: j['quantity']);
              break;
            case 19:
              totalLevelSensor = editLimit(
                  data: totalLevelSensor,
                  oldInt: oldLimit[19],
                  newInt: j['quantity']);
              break;
            case 20:
              totalAnalogSensorCount = editLimit(
                  data: totalAnalogSensorCount, oldInt: oldLimit[20], newInt: j['quantity']);
              break;
            case 21:
              totalEcSensor = editLimit(
                  data: totalEcSensor,
                  oldInt: oldLimit[21],
                  newInt: j['quantity']);
              break;
            case 22:
              totalPhSensor = editLimit(
                  data: totalPhSensor,
                  oldInt: oldLimit[22],
                  newInt: j['quantity']);
              break;
            case 23:
              totalTempSensor = editLimit(
                  data: totalTempSensor, oldInt: oldLimit[23], newInt: j['quantity']);
              break;
            case 24:
              totalSoilTempSensor = editLimit(
                  data: totalSoilTempSensor, oldInt: oldLimit[24], newInt: j['quantity']);
              break;
            case 25:
              totalWindDirection = editLimit(
                  data: totalWindDirection, oldInt: oldLimit[25], newInt: j['quantity']);
              break;
            case 26:
              totalWindSpeed = editLimit(
                  data: totalWindSpeed, oldInt: oldLimit[26], newInt: j['quantity']);
              break;
            case 27:
              totalCo2 = editLimit(
                  data: totalCo2, oldInt: oldLimit[27], newInt: j['quantity']);
              break;
            case 28:
              totalLux = editLimit(
                  data: totalLux, oldInt: oldLimit[28], newInt: j['quantity']);
              break;
            case 29:
              totalLdr = editLimit(
                  data: totalLdr, oldInt: oldLimit[29], newInt: j['quantity']);
              break;
            case 30:
              totalHumidity = editLimit(
                  data: totalHumidity, oldInt: oldLimit[30], newInt: j['quantity']);
              break;
            case 31:
              totalLeafWetness = editLimit(
                  data: totalLeafWetness, oldInt: oldLimit[31], newInt: j['quantity']);
              break;
            case 32:
              totalRainGauge = editLimit(
                  data: totalRainGauge, oldInt: oldLimit[32], newInt: j['quantity']);
              break;
            case 33:
              totalContactCount = editLimit(
                  data: totalContactCount, oldInt: oldLimit[33], newInt: j['quantity']);
              break;
            case 34:
              if (j['quantity'] != 0 || irrigationLines.isNotEmpty) {
                tabs.add(['Irrigation', 'Lines', Icons.timeline, 5]);
              }
              totalIrrigationLine = editLimit(
                  data: totalIrrigationLine,
                  oldInt: oldLimit[34],
                  newInt: j['quantity']);
              break;
            case 35:
              if (j['quantity'] != 0 || centralDosingUpdated.isNotEmpty) {
                tabs.add(['Central', 'Dosing', Icons.local_drink, 3]);
              }
              totalCentralDosing = editLimit(
                  data: totalCentralDosing,
                  oldInt: oldLimit[35],
                  newInt: j['quantity']);
              break;
            case 36:
              if (j['quantity'] != 0 || centralFiltrationUpdated.isNotEmpty) {
                tabs.add(['Central', 'Filtration', Icons.filter_alt, 4]);
              }
              totalCentralFiltration = editLimit(
                  data: totalCentralFiltration,
                  oldInt: oldLimit[36],
                  newInt: j['quantity']);
              break;
            case 45:
              var src = [
                'A',
                'B',
                'C',
                'D',
                'E',
                'F',
                'G',
                'H',
                'I',
                'J',
                'K',
                'L',
                'M',
                'N',
                'O',
                'P'
              ];
              if (oldLimit[45] < j['quantity']) {
                for (var i = 0; i < j['quantity'] - oldLimit[45]; i++) {
                  totalWaterSource.add({
                    'sNo': returnI_O_AutoIncrement(),
                    'id': 'WS${i + 1}',
                    'name': 'Water Source ${src[i]}',
                    'location': ''
                  });
                  for (var s in src) {
                    if (!waterSource.contains(s)) {
                      waterSource.add(s);
                      break;
                    }
                  }
                }
              } else {
                for (var k = 0; k < oldLimit[45] - j['quantity']; k++) {
                  totalWaterSource.removeLast();
                  waterSource.removeLast();
                }
              }
              break;
            case 46:
              totalFloat = editLimit(
                  data: totalFloat,
                  oldInt: oldLimit[46],
                  newInt: j['quantity'],
                check: true
              );
              break;
            case 47:
              totalCommonPressureSensorCount = editLimit(
                  data: totalCommonPressureSensorCount, oldInt: oldLimit[47], newInt: j['quantity']);
              break;
            case 49:
              totalCommonPressureSwitchCount = editLimit(
                  data: totalCommonPressureSwitchCount, oldInt: oldLimit[49], newInt: j['quantity']);
              break;
            case 50:
              totalTankFloatCount = editLimit(
                  data: totalTankFloatCount, oldInt: oldLimit[50], newInt: j['quantity']);
              break;
            case 53:
              totalPowerSupply = editLimit(
                  data: totalPowerSupply,
                  oldInt: oldLimit[53],
                  newInt: j['quantity']);
              break;
            case 54:
              totalManualButtonCount = editLimit(
                  data: totalManualButtonCount, oldInt: oldLimit[54], newInt: j['quantity']);
              break;
            case 55:
              totalLowerTankLevelSensorCount = editLimit(
                  data: totalLowerTankLevelSensorCount, oldInt: oldLimit[55], newInt: j['quantity']);
              break;
            case 56:
              totalUpperTankLevelSensorCount = editLimit(
                  data: totalUpperTankLevelSensorCount, oldInt: oldLimit[56], newInt: j['quantity']);
              break;
            case 57:
              editLimit(
                  data: totalMisting, oldInt: oldLimit[57], newInt: j['quantity']);
              break;
            case 58:
              editLimit(
                  data: totalHeating, oldInt: oldLimit[58], newInt: j['quantity']);
              break;
            case 59:
              editLimit(
                  data: totalPesticides, oldInt: oldLimit[59], newInt: j['quantity']);
              break;
            case 60:
              editLimit(
                  data: totalLight, oldInt: oldLimit[60], newInt: j['quantity']);
              break;
            case 61:
              editLimit(
                  data: totalVent, oldInt: oldLimit[61], newInt: j['quantity']);
              break;
            case 62:
              editLimit(
                  data: totalScreen, oldInt: oldLimit[62], newInt: j['quantity']);
              break;
            case 63:
              editLimit(
                  data: totalAirCirculation, oldInt: oldLimit[63], newInt: j['quantity']);
              break;
          }
        }
      }
      if (i.key == 'referenceNo') {
        clearMacAddress();
        try{
          oLevel = i.value['6'] != null ? i.value['6'].map((e) => e['referenceNumber'].toString()).toList() : [];
          oLevelMac = i.value['6'] != null ? i.value['6'].map((e) => e['deviceId']).toList() : [];
          oSrtu = i.value['12'] != null ? i.value['12'].map((e) => e['referenceNumber'].toString()).toList() : [];
          oSrtuMac = i.value['12'] != null ? i.value['12'].map((e) => e['deviceId']).toList() : [];
          oSwitch = i.value['9'] != null ? i.value['9'].map((e) => e['referenceNumber'].toString()).toList() : [];
          oSwitchMac = i.value['9'] != null ? i.value['9'].map((e) => e['deviceId']).toList() : [];
          oRtu = i.value['13'] != null ? i.value['13'].map((e) => e['referenceNumber'].toString()).toList() : [];
          oRtuMac = i.value['13'] != null ? i.value['13'].map((e) => e['deviceId']).toList() : [];
          oSense = i.value['10'] != null ? i.value['10'].map((e) => e['referenceNumber'].toString()).toList() : [];
          oSenseMac = i.value['10'] != null ? i.value['10'].map((e) => e['deviceId']).toList() : [];
          if(![3,4].contains(categoryId)){
            oPump = i.value['3'] != null ? i.value['3'].map((e) => e['referenceNumber'].toString()).toList() : [];
            oPumpMac = i.value['3'] != null ? i.value['3'].map((e) => e['deviceId']).toList() : [];
          }
          oExtend = i.value['11'] != null ? i.value['11'].map((e) => e['referenceNumber'].toString()).toList() : [];
          oExtendMac = i.value['11'] != null ? i.value['11'].map((e) => e['deviceId']).toList() : [];
          if(i.value['5'] != null){
            if(weatherStation.runtimeType == List<dynamic>){
              weatherStation = {};
            }
            oWeather = i.value['5'] != null ? i.value['5'].map((e) => e['referenceNumber'].toString()).toList() : [];
            oWeatherMac = i.value['5'] != null ? i.value['5'].map((e) => e['deviceId']).toList() : [];
            for(var key in oWeather){
              if(weatherStation['$key'] == null){
                weatherStation['$key'] = {};
                weatherStation['$key']['apply'] = false;
                weatherStation['$key']['soilMoisture1'] = getWeatherSensorStructure(1);
                weatherStation['$key']['soilMoisture2'] = getWeatherSensorStructure(2);
                weatherStation['$key']['soilMoisture3'] = getWeatherSensorStructure(3);
                weatherStation['$key']['soilMoisture4'] = getWeatherSensorStructure(4);
                weatherStation['$key']['soilTemperature'] = getWeatherSensorStructure(5);
                weatherStation['$key']['humidity'] = getWeatherSensorStructure(6);
                weatherStation['$key']['temperature'] = getWeatherSensorStructure(7);
                weatherStation['$key']['atmospherePressure'] = getWeatherSensorStructure(8);
                weatherStation['$key']['co2'] = getWeatherSensorStructure(9);
                weatherStation['$key']['ldr'] = getWeatherSensorStructure(10);
                weatherStation['$key']['lux'] = getWeatherSensorStructure(11);
                weatherStation['$key']['windDirection'] = getWeatherSensorStructure(12);
                weatherStation['$key']['windSpeed'] = getWeatherSensorStructure(13);
                weatherStation['$key']['rainFall'] = getWeatherSensorStructure(14);
                weatherStation['$key']['leafWetness'] = getWeatherSensorStructure(15);
              }
            }
            if (oWeather.isNotEmpty) {
              tabs.add(['Weather', 'Station', Icons.track_changes, 8]);
            }
          }
          oSrtuPlus = i.value['7'] != null ? i.value['7'].map((e) => e['referenceNumber'].toString()).toList() : [];
          oSrtuPlusMac = i.value['7'] != null ? i.value['7'].map((e) => e['deviceId']).toList() : [];
          oRtuPlus = i.value['8'] != null ? i.value['8'].map((e) => e['referenceNumber'].toString()).toList() : [];
          oRtuPlusMac = i.value['8'] != null ? i.value['8'].map((e) => e['deviceId']).toList() : [];
          if(![3,4].contains(categoryId)){
            oPumpPlus = i.value['4'] != null ? i.value['4'].map((e) => e['referenceNumber'].toString()).toList() : [];
            oPumpPlusMac = i.value['4'] != null ? i.value['4'].map((e) => e['deviceId']).toList() : [];
          }
        }catch(e){
          print('old data ref is some problem');
        }
      }
    }
    tabs.sort((a, b) => (a[3] as int).compareTo(b[3] as int));
    notifyListeners();
  }

  dynamic getWeatherSensorStructure(int code){
    var data = {};
    data['sNo'] = returnI_O_AutoIncrement();
    data['apply'] = false;
    data['code'] = code;
    return data;
  }

  //TODO: generating names
  dynamic configFinish() {
    bool isCopy = false;
    if(serverData['configMaker']['isNewConfig'] != null){
      if(serverData['configMaker']['isNewConfig'] == '2'){
        isCopy = true;
      }
    }

    Map<String, dynamic> name = {
      'SP': [],'IP': [],'WM': [],'CFESI': [],'CFEI': [],'LFEI': [],'CFEM': [],'LFEM': [],
      'ECS': [], 'PHS': [], 'CFISI': [], 'CFI': [], 'LFI': [], 'PS': [], 'IL': [], 'VL': [], 'MVL': [], 'MS': [],
      'LS': [], 'FOG': [], 'FAN': [], 'OROSEN': [], 'OROLVL': [], 'AS': [], 'MB': [],
      'CONT': [], 'AG': [], 'WS': [], 'FL': [], 'SEL': [], 'BP': [], 'TS' : [], 'STS' : [],
      'WDS' : [], 'WSS' : [], 'CO2S' : [], 'LUXS' : [], 'LDRS' : [], 'LTLS' : [], 'UTLS' : [],
      'HDS' : [], 'LWS' : [], 'RFS' : [], 'PWS' : [], 'PSW' : [], 'APS' : [], 'TFL' : [], 'CPS' : [],'CPS' : [],
    };

    dynamic weatherSensorData = [
      {'key' : 'soilMoisture1','id' : 'MS','hid' : '','num' : '.1','name' : 'soil Moisture','bucket' : 'MS','objectId' : 'CPS',},
      {'key' : 'soilMoisture2','id' : 'MS','hid' : '','num' : '.2','name' : 'soil Moisture','bucket' : 'MS','objectId' : 'TFL',},
      {'key' : 'soilMoisture3','id' : 'MS','hid' : '','num' : '.3','name' : 'soil Moisture','bucket' : 'MS','objectId' : 'ST',},
      {'key' : 'soilMoisture4','id' : 'MS','hid' : '','num' : '.4','name' : 'soil Moisture','bucket' : 'MS','objectId' : 'AT',},
      {'key' : 'soilTemperature','id' : 'STS','hid' : '','num' : '.1','name' : 'Soil Temperature','bucket' : 'STS','objectId' : 'CO',},
      {'key' : 'humidity','id' : 'HDS','hid' : '','num' : '.1','name' : 'Humidity','bucket' : 'HDS','objectId' : 'AH',},
      {'key' : 'temperature','id' : 'TS','hid' : '','num' : '.1','name' : 'Temperature','bucket' : 'TS','objectId' : 'WD',},
      {'key' : 'atmospherePressure','id' : 'APS','hid' : '','num' : '.1','name' : 'Atm Pressure','bucket' : 'APS','objectId' : 'LUX',},
      {'key' : 'co2','id' : 'CO2S','hid' : '','num' : '.1','name' : 'Co2','bucket' : 'CO2S','objectId' : 'LW',},
      {'key' : 'ldr','id' : 'LDRS','hid' : '','num' : '.1','name' : 'Ldr','bucket' : 'LDRS','objectId' : 'LDRS',},
      {'key' : 'lux','id' : 'LUXS','hid' : '','num' : '.1','name' : 'Lux','bucket' : 'LUXS','objectId' : 'LUXS',},
      {'key' : 'windDirection','id' : 'WDS','hid' : '','num' : '.1','name' : 'Wind Direction','bucket' : 'WDS','objectId' : 'WDS',},
      {'key' : 'windSpeed','id' : 'WSS','hid' : '','num' : '.1','name' : 'Wind Speed','bucket' : 'WSS','objectId' : 'WSS',},
      {'key' : 'rainFall','id' : 'RFS','hid' : '','num' : '.1','name' : 'Rain Fall','bucket' : 'RFS','objectId' : 'RF',},
      {'key' : 'leafWetness','id' : 'LWS','hid' : '','num' : '.1','name' : 'Leaf Wetness','bucket' : 'LWS','objectId' : 'RF',},
    ];

    for(var key in oWeather){
      if( weatherStation['$key']['apply'] == true){
        for(var wsd in weatherSensorData){
          if(weatherStation['$key'][wsd['key']]['apply'] == true){
            name[wsd['bucket']].add({
              'sNo': weatherStation['$key'][wsd['key']]['sNo'],
              'id': '${wsd['id']}.W.$key.${wsd['num']}',
              'hid': '${wsd['id']}.W.$key.${wsd['num']}',
              'name': (isNew||isCopy)
                  ? '${wsd['name']}.W.$key.${wsd['num']}'
                  : names['${weatherStation['$key'][wsd['key']]['sNo']}'] ??
                  '${wsd['name']}.W.$key.${wsd['num']}',
              'location': 'OWS 1',
              'type': '2'
            });
          }
        }
      }
    }

    dynamic sensorData = [
      {'data' : totalContact,'id' : 'CONT','name' : 'Contact','bucket' : 'CONT','objectId' : 'CONT',},
      {'data' : totalSelector,'id' : 'SEL','name' : 'Selector','bucket' : 'SEL','objectId' : 'SL',},
      {'data' : totalManualButton,'id' : 'MB','name' : 'Manual Button','bucket' : 'MB','objectId' : 'MB',},
      {'data' : totalWaterSource,'id' : 'WS','name' : 'Analog Sensor','bucket' : 'WS','objectId' : 'WS',},
      {'data' : totalAnalogSensor,'id' : 'AS','name' : 'Water Src','bucket' : 'AS','objectId' : 'AS',},
      {'data' : totalCommonPressureSensor,'id' : 'CPS','name' : 'Common PS','bucket' : 'CPS','objectId' : 'CPS',},
      {'data' : totalTankFloat,'id' : 'TF','name' : 'Tank Float','bucket' : 'TFL','objectId' : 'TFL',},
      {'data' : connSoilTempSensor,'id' : 'ST','name' : 'Soil Temperature','bucket' : 'STS','objectId' : 'ST',},
      {'data' : connTempSensor,'id' : 'TS','name' : 'Temperature Sensor','bucket' : 'TS','objectId' : 'AT',},
      {'data' : connCo2,'id' : 'CO2S','name' : 'CO2 Sensor','bucket' : 'CO2S','objectId' : 'CO',},
      {'data' : connHumidity,'id' : 'HDS','name' : 'Humidity Sensor','bucket' : 'HDS','objectId' : 'AH',},
      {'data' : connWindDirection,'id' : 'WDS','name' : 'Wind Direction Sensor','bucket' : 'WDS','objectId' : 'WD',},
      {'data' : connLux,'id' : 'LUXS','name' : 'LUX Sensor','bucket' : 'LUXS','objectId' : 'LUX',},
      {'data' : connLeafWetness,'id' : 'LWS','name' : 'Leaf Wetness Sensor','bucket' : 'LWS','objectId' : 'LW',},
      {'data' : connWindSpeed,'id' : 'WSS','name' : 'Wind Speed Sensor','bucket' : 'WSS','objectId' : 'WSP',},
      {'data' : connLdr,'id' : 'LDRS','name' : 'LDR Sensor','bucket' : 'LDRS','objectId' : 'LDR',},
      {'data' : connRainGauge,'id' : 'RFS','name' : 'Rain Fall Sensor','bucket' : 'RFS','objectId' : 'RF',},
      {'data' : totalLowerTankLevelSensor,'id' : 'LTLS','name' : 'L.Level Sensor','bucket' : 'LTLS','objectId' : 'LLS',},
      {'data' : totalUpperTankLevelSensor,'id' : 'UTLS','name' : 'U.Level Sensor','bucket' : 'UTLS','objectId' : 'ULS',},
    ];
    for(var i in sensorData){
      for(var sensor = 0;sensor < i['data'].length;sensor++){
        name['${i['bucket']}'].add({
          'sNo': i['data'][sensor]['sNo'],
          'id': '${i['id']}.${sensor+1}',
          'hid': '${i['objectId']}.${sensor+1}',
          'name': (isNew||isCopy)
              ? '${i['name']}.${sensor+1}'
              : names['${i['data'][sensor]['sNo']}'] ??
              '${i['name']}.${sensor+1}',
          'location': '',
          'type': '2'
        });
      }
    }
    for(var ag = 0; ag < totalAgitator.length;ag++){
      var location = [];
      int skip = 0;
      for(var il = 0;il < irrigationLines.length;il++){
        if(!irrigationLines[il]['deleted']){
          if(irrigationLines[il]['agitator'].contains('${ag+1}')){
            location.add('IL.${il+1-skip}');
          }
        }else{
          skip += 1;
        }
      }
      name['AG'].add({
        'sNo': totalAgitator[ag]['sNo'],
        'id': 'AG.${ag + 1}',
        'hid': 'AG.${ag + 1}',
        'name': (isNew||isCopy)
            ? 'Agitator ${ag + 1}'
            : names['${totalAgitator[ag]['sNo']}'] ?? 'Agitator ${ag + 1}',
        'location': location.join('_'),
        'type': '1',
      });
    }
    dynamic sourcePumpData = [
      {'key' : 'waterMeter','dataType' : 'Map','num' : '','id' : 'WMSP','name' : 'Water Meter SP','bucket' : 'WM','objectId' : 'SW','checkType' : true},
      {'key' : 'levelSensor','dataType' : 'Map','num' : '','id' : 'LS','name' : 'SP Level Sensor','bucket' : 'LS','objectId' : 'LS','checkType' : true},
      {'key' : 'TopTankLow','dataType' : 'Map','num' : '.1.1','id' : 'SF','name' : 'SP TTL','bucket' : 'FL','objectId' : 'SF','checkType' : true},
      {'key' : 'TopTankHigh','dataType' : 'Map','num' : '.1.2','id' : 'SF','name' : 'SP TTH','bucket' : 'FL','objectId' : 'SF','checkType' : true},
      {'key' : 'SumpTankLow','dataType' : 'Map','num' : '.2.1','id' : 'SF','name' : 'SP STL','bucket' : 'FL','objectId' : 'SF','checkType' : true},
      {'key' : 'SumpTankHigh','dataType' : 'Map','num' : '.2.2','id' : 'SF','name' : 'SP STH','bucket' : 'FL','objectId' : 'SF','checkType' : true},
    ];
    for (var i = 0; i < sourcePumpUpdated.length; i++) {
      if (!sourcePumpUpdated[i]['deleted']) {
        name['SP'].add({
          'sNo': sourcePumpUpdated[i]['sNo'],
          'id': 'SP.${i + 1}',
          'hid': 'SP.${i + 1}',
          'name': (isNew||isCopy)
              ? 'Source Pump ${i + 1}'
              : names['${sourcePumpUpdated[i]['sNo']}'] ?? 'Source Pump ${i + 1}',
          'location': '',
          'type': '1',
          'controlGem' : sourcePumpUpdated[i]['controlGem'],
          if(sourcePumpUpdated[i]['rtu'] == 'ORO Pump')
            'deviceId' : sourcePumpUpdated[i]['rfNo'] != '-' ? oPumpMac[oPump.indexOf(sourcePumpUpdated[i]['rfNo'])] : '',
          if(sourcePumpUpdated[i]['rtu'] == 'O-Pump-Plus')
            'deviceId' : sourcePumpUpdated[i]['rfNo'] != '-' ? oPumpPlusMac[oPumpPlus.indexOf(sourcePumpUpdated[i]['rfNo'])] : '',
          'rfNo' : sourcePumpUpdated[i]['rfNo'],
          'output' : sourcePumpUpdated[i]['output'],
        });
        for(var pd in sourcePumpData){
          if (sourcePumpUpdated[i][pd['key']].isNotEmpty) {
            name[pd['bucket']].add({
              'sNo': sourcePumpUpdated[i][pd['key']]['sNo'],
              'id': '${pd['id']}.${i + 1}${pd['num']}',
              'hid': '${pd['objectId']}.${i + 1}${pd['num']}',
              'name': (isNew||isCopy)
                  ? '${pd['name']} ${i + 1}'
                  : names['${sourcePumpUpdated[i][pd['key']]['sNo']}'] ??
                  '${pd['name']} ${i + 1}',
              'location': 'SP.${i + 1}',
              'type':
              checkInputType(sourcePumpUpdated[i][pd['key']]['input_type'])
            });
          }
        }
      }
    }
    dynamic irrigationPumpData = [
      {'key' : 'waterMeter','dataType' : 'Map','num' : '','id' : 'WMIP','name' : 'Water Meter IP','bucket' : 'WM','objectId' : 'IW','checkType' : true},
      {'key' : 'levelSensor','dataType' : 'Map','num' : '','id' : 'LP','name' : 'IP Level Sensor','bucket' : 'LS','objectId' : 'LP','checkType' : true},
      {'key' : 'TopTankLow','dataType' : 'Map','num' : '.1.1','id' : 'IF','name' : 'IP TTL','bucket' : 'FL','objectId' : 'IF','checkType' : true},
      {'key' : 'TopTankHigh','dataType' : 'Map','num' : '.1.2','id' : 'IF','name' : 'IP TTH','bucket' : 'FL','objectId' : 'IF','checkType' : true},
      {'key' : 'SumpTankLow','dataType' : 'Map','num' : '.2.1','id' : 'IF','name' : 'IP STL','bucket' : 'FL','objectId' : 'IF','checkType' : true},
      {'key' : 'SumpTankHigh','dataType' : 'Map','num' : '.2.2','id' : 'IF','name' : 'IP STH','bucket' : 'FL','objectId' : 'IF','checkType' : true},
    ];
    for (var i = 0; i < irrigationPumpUpdated.length; i++) {
      var location = irrigationLines.where((element) => element['irrigationPump'].contains('${i+1}')).map((e) => 'IL.${(irrigationLines.indexOf(e) + 1)}').join('_');
      if (!irrigationPumpUpdated[i]['deleted']) {
        name['IP'].add({
          'sNo': irrigationPumpUpdated[i]['sNo'],
          'id': 'IP.${i + 1}',
          'hid': 'IP.${i + 1}',
          'name': (isNew||isCopy)
              ? 'Irrigation Pump ${i + 1}'
              : names['${irrigationPumpUpdated[i]['sNo']}'] ??
              'Irrigation Pump ${i + 1}',
          'location': location,
          'type': '1',
          'controlGem' : irrigationPumpUpdated[i]['controlGem'],
          if(irrigationPumpUpdated[i]['rtu'] == 'ORO Pump')
            'deviceId' : irrigationPumpUpdated[i]['rfNo'] != '-' ? oPumpMac[oPump.indexOf(irrigationPumpUpdated[i]['rfNo'])] : '',
          if(irrigationPumpUpdated[i]['rtu'] == 'O-Pump-Plus')
            'deviceId' : irrigationPumpUpdated[i]['rfNo'] != '-' ? oPumpPlusMac[oPumpPlus.indexOf(irrigationPumpUpdated[i]['rfNo'])] : '',
          'rfNo' : irrigationPumpUpdated[i]['rfNo'],
          'output' : irrigationPumpUpdated[i]['output'],
        });
        for(var pd in irrigationPumpData){
          if (irrigationPumpUpdated[i][pd['key']].isNotEmpty) {
            name[pd['bucket']].add({
              'sNo': irrigationPumpUpdated[i][pd['key']]['sNo'],
              'id': '${pd['id']}.${i + 1}${pd['num']}',
              'hid': '${pd['objectId']}.${i + 1}${pd['num']}',
              'name': (isNew||isCopy)
                  ? '${pd['name']} ${i + 1}'
                  : names['${irrigationPumpUpdated[i][pd['key']]['sNo']}'] ??
                  '${pd['name']} ${i + 1}',
              'location': 'IP.${i + 1}',
              'type':
              checkInputType(irrigationPumpUpdated[i][pd['key']]['input_type'])
            });
          }
        }
      }
    }
    for (var i = 0; i < centralDosingUpdated.length; i++) {
      var location = '';
      for (var irr = 0; irr < irrigationLines.length; irr++) {
        if (irrigationLines[irr]['Central_dosing_site'] == '${i + 1}') {
          location += '${location.isNotEmpty ? '&' : ''}IL.${irr + 1}';
        }
      }
      if (!centralDosingUpdated[i]['deleted']) {
        name['CFESI'].add({
          'sNo': centralDosingUpdated[i]['sNo'],
          'id': 'CFESI.${i + 1}',
          'hid': 'CFESI.${i + 1}',
          'name': (isNew||isCopy)
              ? 'Central Fertilizer Site ${i + 1}'
              : names['${centralDosingUpdated[i]['sNo']}'] ??
              'Central Fertilizer Site ${i + 1}',
          'location': location,
          'type': ''
        });
        if (centralDosingUpdated[i]['pressureSwitch']
            .isNotEmpty) {
          name['PWS'].add({
            'sNo': centralDosingUpdated[i]['pressureSwitch']['sNo'],
            'id': 'PSW.1.${i + 1}',
            'hid': 'PSW.1.${i + 1}',
            'name': (isNew||isCopy)
                ? 'Pressure Switch C. ${i + 1}'
                : names['${centralDosingUpdated[i]['pressureSwitch']['sNo']}'] ??
                'Pressure Switch C. ${i + 1}',
            'location': 'CFESI.${i + 1}',
            'type': checkInputType(centralDosingUpdated[i]['pressureSwitch']['input_type'])
          });
        }
        for (var j = 0; j < centralDosingUpdated[i]['injector'].length; j++) {
          name['CFEI'].add({
            'sNo': centralDosingUpdated[i]['injector'][j]['sNo'],
            'id': 'CFEI.${i + 1}.${j + 1}',
            'hid': 'FC.1.${i + 1}.${j + 1}',
            'name': (isNew||isCopy)
                ? 'Central Fertilizer Injector ${i + 1}.${j + 1}'
                : names['${centralDosingUpdated[i]['injector'][j]['sNo']}'] ??
                'Central Fertilizer Injector ${i + 1}.${j + 1}',
            'location': 'CFESI.${i + 1}',
            'type': '1'
          });
          if (centralDosingUpdated[i]['injector'][j]['dosingMeter']
              .isNotEmpty) {
            name['CFEM'].add({
              'sNo': centralDosingUpdated[i]['injector'][j]['dosingMeter']
              ['sNo'],
              'id': 'CFEFM.${i + 1}.${j + 1}',
              'hid': 'FM.1.${i + 1}.${j + 1}',
              'name': (isNew||isCopy)
                  ? 'Central Fertilizer Meter ${i + 1}.${j + 1}'
                  : names['${centralDosingUpdated[i]['injector'][j]['dosingMeter']['sNo']}'] ??
                  'Central Fertilizer Meter ${i + 1}.${j + 1}',
              'location': 'CFEI.${i + 1}.${j + 1}',
              'type': checkInputType(centralDosingUpdated[i]['injector'][j]
              ['dosingMeter']['input_type'])
            });
          }
          if (centralDosingUpdated[i]['injector'][j]['levelSensor']
              .isNotEmpty) {
            name['CFEM'].add({
              'sNo': centralDosingUpdated[i]['injector'][j]['levelSensor']
              ['sNo'],
              'id': 'LS.1.${i + 1}.${j + 1}',
              'hid': 'LS.1.${i + 1}.${j + 1}',
              'name': (isNew||isCopy)
                  ? 'Level Sensor C. ${i + 1}.${j + 1}'
                  : names['${centralDosingUpdated[i]['injector'][j]['levelSensor']['sNo']}'] ??
                  'Level Sensor C. ${i + 1}.${j + 1}',
              'location': 'CFEI.${i + 1}.${j + 1}',
              'type': checkInputType(centralDosingUpdated[i]['injector'][j]
              ['levelSensor']['input_type'])
            });
          }
        }
        for (var j = 0;
        j < centralDosingUpdated[i]['ecConnection'].length;
        j++) {
          if (centralDosingUpdated[i]['ecConnection'][j].isNotEmpty) {
            name['ECS'].add({
              'sNo': centralDosingUpdated[i]['ecConnection'][j]['sNo'],
              'id': 'ECSCFESI.${i + 1}.${j + 1}',
              'hid': 'EC.1.${i + 1}.${j + 1}',
              'name': (isNew||isCopy)
                  ? 'EC Sensor CFESI ${i + 1}.${j + 1}'
                  : names['${centralDosingUpdated[i]['ecConnection'][j]['sNo']}'] ??
                  'EC Sensor CFESI ${i + 1}.${j + 1}',
              'location': 'CFESI.${i + 1}',
              'deviceId': '${centralDosingUpdated[i]['ecConnection'][j]['rtu'] == 'O-Smart-Plus' ? (oSrtuPlusMac[oSrtuPlus.indexOf(centralDosingUpdated[i]['ecConnection'][j]['rfNo'])]) : ''}',
              'type': checkInputType(
                  centralDosingUpdated[i]['ecConnection'][j]['input_type'])
            });
          }
        }
        for (var j = 0;
        j < centralDosingUpdated[i]['phConnection'].length;
        j++) {
          if (centralDosingUpdated[i]['phConnection'][j].isNotEmpty) {
            name['PHS'].add({
              'sNo': centralDosingUpdated[i]['phConnection'][j]['sNo'],
              'id': 'PHSCFESI.${i + 1}.${j + 1}',
              'hid': 'PH.1.${i + 1}.${j + 1}',
              'name': (isNew||isCopy)
                  ? 'PH Sensor CFESI ${i + 1}.${j + 1}'
                  : names['${centralDosingUpdated[i]['phConnection'][j]['sNo']}'] ??
                  'PH Sensor CFESI ${i + 1}.${j + 1}',
              'location': 'CFESI.${i + 1}',
              'deviceId': '${centralDosingUpdated[i]['phConnection'][j]['rtu'] == 'O-Smart-Plus' ? (oSrtuPlusMac[oSrtuPlus.indexOf(centralDosingUpdated[i]['phConnection'][j]['rfNo'])]) : centralDosingUpdated[i]['phConnection'][j]['rtu'] == 'ORO Smart' ? (oSrtuMac[oSrtu.indexOf(centralDosingUpdated[i]['phConnection'][j]['rfNo'])]) : ''}',
              'type': checkInputType(
                  centralDosingUpdated[i]['phConnection'][j]['input_type'])
            });
          }
        }
        for (var j = 0;
        j < centralDosingUpdated[i]['boosterConnection'].length;
        j++) {
          if (centralDosingUpdated[i]['boosterConnection'][j].isNotEmpty) {
            name['BP'].add({
              'sNo': centralDosingUpdated[i]['boosterConnection'][j]['sNo'],
              'id': 'BPC.${i + 1}.${j + 1}',
              'hid': 'FB.1.${i + 1}.${j + 1}',
              'name': (isNew||isCopy)
                  ? 'Central Booster Pump ${i + 1}.${j + 1}'
                  : names['${centralDosingUpdated[i]['boosterConnection'][j]['sNo']}'] ??
                  'Central Booster Pump ${i + 1}.${j + 1}',
              'location': 'CFESI.${i + 1}',
              'type': '1'
            });
          }
        }
      }
    }
    dynamic centralFilterData = [
      {'key' : 'filterConnection','dataType' : 'List','id' : 'CFI','objectId' : 'FL.1','name' : 'Central Filter','bucket' : 'CFI','checkType' : false},
      {'key' : 'pressureIn','dataType' : 'Map','id' : 'PSICFI','objectId' : 'FI.1','name' : 'Pressure Sensor In CFI','bucket' : 'PS','checkType' : true},
      {'key' : 'pressureOut','dataType' : 'Map','id' : 'PSOCFI','objectId' : 'FO.1','name' : 'Pressure Sensor Out CFI','bucket' : 'PS','checkType' : true},
      {'key' : 'diffPressureSensor','dataType' : 'Map','id' : 'DPSCFI','objectId' : 'DV.1','name' : 'Diff. Pressure Sensor CFI','bucket' : 'PS','checkType' : true},
      {'key' : 'pressureSwitch','dataType' : 'Map','id' : 'PSW.1','objectId' : 'PSW.1','name' : 'Pressure Switch 1','bucket' : 'PSW','checkType' : true},
    ];
    for (var i = 0; i < centralFiltrationUpdated.length; i++) {
      centralFiltrationUpdated[i]['id'] = 'CFISI${i + 1}';
      centralFiltrationUpdated[i]['name'] = 'Central Filtration Site ${i + 1}';
      var location = '';
      if (!centralFiltrationUpdated[i]['deleted']) {
        for (var irr = 0; irr < irrigationLines.length; irr++) {
          if (irrigationLines[irr]['Central_filtration_site'] == '${i + 1}') {
            location += '${location.isNotEmpty ? '&' : ''}IL.${irr + 1}';
          }
        }
        name['CFISI'].add({
          'sNo': centralFiltrationUpdated[i]['sNo'],
          'id': 'CFISI.${i + 1}',
          'hid': 'CFISI.${i + 1}',
          'name': (isNew||isCopy)
              ? 'Central Filtration Site ${i + 1}'
              : names['${centralFiltrationUpdated[i]['sNo']}'] ??
              'Central Filtration Site ${i + 1}',
          'location': location,
          'type': ''
        });
        for(var cfld in centralFilterData){
          if(cfld['dataType'] == 'List'){
            for (var j = 0;j < centralFiltrationUpdated[i][cfld['key']].length;j++) {
              name[cfld['bucket']].add({
                'sNo': centralFiltrationUpdated[i][cfld['key']][j]['sNo'],
                'id': '${cfld['id']}.${i + 1}.${j + 1}',
                'hid': '${cfld['objectId']}.${i + 1}.${j + 1}',
                'name': (isNew||isCopy)
                    ? '${cfld['name']} ${i + 1}.${j + 1}'
                    : names['${centralFiltrationUpdated[i][cfld['key']][j]['sNo']}'] ??
                    '${cfld['name']} ${i + 1}.${j + 1}',
                'location': 'CFISI.${i + 1}',
                'type': '1'
              });
            }
          }else{
            if (centralFiltrationUpdated[i][cfld['key']].isNotEmpty) {
              name['PS'].add({
                'sNo': centralFiltrationUpdated[i][cfld['key']]['sNo'],
                'id': '${cfld['id']}.${i + 1}.1',
                'hid': '${cfld['objectId']}.${i + 1}',
                'name': (isNew||isCopy)
                    ? '${cfld['name']} ${i + 1}.1'
                    : names['${centralFiltrationUpdated[i][cfld['key']]['sNo']}'] ??
                    '${cfld['name']} ${i + 1}.1',
                'location': 'CFISI.${i + 1}',
                'type': cfld['checkType'] ? checkInputType(
                    centralFiltrationUpdated[i][cfld['key']]['input_type']) : '1'
              });
            }
          }
        }
      }
    }
    dynamic lineData = [
      {'key' : 'valveConnection','dataType' : 'List','id' : 'VL','name' : 'Valve','bucket' : 'VL','objectId' : 'VL','checkType' : false},
      {'key' : 'main_valveConnection','dataType' : 'List','id' : 'MVL','name' : 'Main Valve','bucket' : 'MVL','objectId' : 'MV','checkType' : false},
      {'key' : 'moistureSensorConnection','dataType' : 'List','id' : 'MS','name' : 'Moisture Sensor','bucket' : 'MS','objectId' : 'SM','checkType' : true},
      {'key' : 'levelSensorConnection','dataType' : 'List','id' : 'LS','name' : 'Level Sensor','bucket' : 'LS','objectId' : 'LV','checkType' : true},
      {'key' : 'foggerConnection','dataType' : 'List','id' : 'FG','name' : 'Fogger','bucket' : 'FOG','objectId' : 'FG','checkType' : false},
      {'key' : 'fanConnection','dataType' : 'List','id' : 'FN','name' : 'Fan','bucket' : 'FAN','objectId' : 'FN','checkType' : false},
      {'key' : 'pressureIn','dataType' : 'Map','id' : 'PSIIL','name' : 'Press Sens In Il','bucket' : 'PS','objectId' : 'LI','checkType' : true},
      {'key' : 'pressureOut','dataType' : 'Map','id' : 'PSOIL','name' : 'Press Sens Out Il','bucket' : 'PS','objectId' : 'LO','checkType' : true},
      {'key' : 'water_meter','dataType' : 'Map','id' : 'WMIL','name' : 'Water Meter Il','bucket' : 'WM','objectId' : 'LW','checkType' : true},
      {'key' : 'powerSupply','dataType' : 'Map','id' : 'PWS','name' : 'Power Supply','bucket' : 'PWS','objectId' : 'PSP','checkType' : true},
      {'key' : 'pressureSwitch','dataType' : 'Map','id' : 'PSW','name' : 'Pressure Switch','bucket' : 'PSW','objectId' : 'PSW','checkType' : true},
    ];
    dynamic localFilterData = [
      {'key' : 'filterConnection','dataType' : 'List','id' : 'LFI','objectId' : 'FL.2','name' : 'Local Filter','bucket' : 'LFI','checkType' : false},
      {'key' : 'pressureIn','dataType' : 'Map','id' : 'PSILFI','objectId' : 'FI.2','name' : 'Pressure Sensor In LFI','bucket' : 'PS','checkType' : true},
      {'key' : 'pressureOut','dataType' : 'Map','id' : 'PSOLFI','objectId' : 'FO.2','name' : 'Pressure Sensor Out LFI','bucket' : 'PS','checkType' : true},
      {'key' : 'diffPressureSensor','dataType' : 'Map','id' : 'DPSLFI','objectId' : 'DV.2','name' : 'Diff. Pressure Sensor LFI','bucket' : 'PS','checkType' : true},
      {'key' : 'pressureSwitch','dataType' : 'Map','id' : 'PSW.2','objectId' : 'PSW.2','name' : 'Pressure Switch 2','bucket' : 'PSW','checkType' : true},
    ];
    for (var i = 0; i < irrigationLines.length; i++) {
      if (!irrigationLines[i]['deleted']) {
        name['IL'].add({
          'sNo': irrigationLines[i]['sNo'],
          'id': 'IL.${i + 1}',
          'hid': 'IL.${i + 1}',
          'name': (isNew||isCopy)
              ? 'Irrigation Line ${i + 1}'
              : names['${irrigationLines[i]['sNo']}'] ?? 'Irrigation Line ${i + 1}',
          'location': '',
          'type': ''
        });
        for(var ld in lineData){
          if(ld['dataType'] == 'List'){
            for (var j = 0; j < irrigationLines[i][ld['key']].length; j++) {
              name[ld['bucket']].add({
                'sNo': irrigationLines[i][ld['key']][j]['sNo'],
                'id': '${ld['id']}.${i + 1}.${j + 1}',
                'hid': '${ld['objectId']}.${i + 1}.${j + 1}',
                'name': (isNew||isCopy)
                    ? '${ld['name']} ${i + 1}.${j + 1}'
                    : names['${irrigationLines[i][ld['key']][j]['sNo']}'] ??
                    '${ld['name']} ${i + 1}.${j + 1}',
                'location': 'IL.${i + 1}',
                'type': ld['checkType'] ? checkInputType(
                    irrigationLines[i][ld['key']][j]['input_type']) : '1'
              });
            }
          }else{
            if (irrigationLines[i][ld['key']].isNotEmpty) {
              name[ld['bucket']].add({
                'sNo': irrigationLines[i][ld['key']]['sNo'],
                'id': '${ld['id']}.${i + 1}.1',
                'hid': '${ld['objectId']}.${i + 1}',
                'name': (isNew||isCopy)
                    ? '${ld['name']} ${i + 1}.1'
                    : names['${irrigationLines[i][ld['key']]['sNo']}'] ??
                    '${ld['name']} ${i + 1}.1',
                'location': 'IL.${i + 1}',
                'type':  ld['checkType'] ?
                checkInputType(irrigationLines[i][ld['key']]['input_type']) : '1'
              });
            }
          }
        }
        if (irrigationLines[i]['Local_dosing_site'] == true) {
          for (var ld in localDosingUpdated) {
            if (ld['sNo'] == irrigationLines[i]['sNo']) {
              for (var j = 0; j < ld['injector'].length; j++) {
                name['LFEI'].add({
                  'sNo': ld['injector'][j]['sNo'],
                  'id': 'LFEI.${i + 1}.${j + 1}',
                  'hid': 'FC.2.${i + 1}.${j + 1}',
                  'name': (isNew||isCopy)
                      ? 'Local Fertilizer Injector ${i + 1}.${j + 1}'
                      : names['${ld['injector'][j]['sNo']}'] ??
                      'Local Fertilizer Injector ${i + 1}.${j + 1}',
                  'location': 'IL.${i + 1}',
                  'type': '1'
                });
                if (ld['injector'][j]['dosingMeter'].isNotEmpty) {
                  name['LFEM'].add({
                    'sNo': ld['injector'][j]['dosingMeter']['sNo'],
                    'id': 'LFEM.${i + 1}.${j + 1}',
                    'hid': 'FM.2.${i + 1}.${j + 1}',
                    'name': (isNew||isCopy)
                        ? 'Local Fertilizer Meter ${i + 1}.${j + 1}'
                        : names['${ld['injector'][j]['dosingMeter']['sNo']}'] ??
                        'Local Fertilizer Meter ${i + 1}.${j + 1}',
                    'location': 'LFEI.${i + 1}.${j + 1}',
                    'type': checkInputType(
                        ld['injector'][j]['dosingMeter']['input_type'])
                  });
                }
              }
              for (var j = 0; j < ld['boosterConnection'].length; j++) {
                if (ld['boosterConnection'][j].isNotEmpty) {
                  name['BP'].add({
                    'sNo': ld['boosterConnection'][j]['sNo'],
                    'id': 'BPL.${i + 1}.${j + 1}',
                    'hid': 'FB.2.${i + 1}.${j + 1}',
                    'name': (isNew||isCopy)
                        ? 'Local Booster Pump ${i + 1}.${j + 1}'
                        : names['${ld['boosterConnection'][j]['sNo']}'] ??
                        'Local Booster Pump ${i + 1}.${j + 1}',
                    'location': 'IL.${i + 1}',
                    'type': '1'
                  });
                }
              }
              for (var j = 0; j < ld['ecConnection'].length; j++) {
                if (ld['ecConnection'][j].isNotEmpty) {
                  name['ECS'].add({
                    'sNo': ld['ecConnection'][j]['sNo'],
                    'id': 'ECSIL.${i + 1}.${j + 1}',
                    'hid': 'EC.2.${i + 1}.${j + 1}',
                    'name': (isNew||isCopy)
                        ? 'EC Sensor IL ${i + 1}.${j + 1}'
                        : names['${ld['ecConnection'][j]['sNo']}'] ??
                        'EC Sensor IL ${i + 1}.${j + 1}',
                    'location': 'IL.${i + 1}',
                    'deviceId': '${ld['ecConnection'][j]['rtu'] == 'O-Smart-Plus' ? (oSrtuPlusMac[oSrtuPlus.indexOf(ld['ecConnection'][j]['rfNo'])]) : ''}',
                    'type': checkInputType(ld['ecConnection'][j]['input_type'])
                  });
                }
              }
              for (var j = 0; j < ld['phConnection'].length; j++) {
                if (ld['phConnection'][j].isNotEmpty) {
                  name['PHS'].add({
                    'sNo': ld['phConnection'][j]['sNo'],
                    'id': 'PHSIL.${i + 1}.${j + 1}',
                    'hid': 'PH.2.${i + 1}.${j + 1}',
                    'name': (isNew||isCopy)
                        ? 'PH Sensor IL ${i + 1}.${j + 1}'
                        : names['${ld['phConnection'][j]['sNo']}'] ??
                        'PH Sensor IL ${i + 1}.${j + 1}',
                    'location': 'IL.${i + 1}',
                    'deviceId': '${ld['phConnection'][j]['rtu'] == 'O-Smart-Plus' ? (oSrtuPlusMac[oSrtuPlus.indexOf(ld['phConnection'][j]['rfNo'])]) : ld['phConnection'][j]['rtu'] == 'ORO Smart' ? (oSrtuMac[oSrtu.indexOf(ld['phConnection'][j]['rfNo'])]) : ''}',
                    'type': checkInputType(ld['phConnection'][j]['input_type'])
                  });
                }
              }
            }
          }
        }
        if (irrigationLines[i]['local_filtration_site'] == true) {
          for (var lf in localFiltrationUpdated) {
            if (lf['sNo'] == irrigationLines[i]['sNo']) {
              for(var lfld in localFilterData){
                if(lfld['dataType'] == 'List'){
                  for (var j = 0; j < lf[lfld['key']].length; j++) {
                    name[lfld['bucket']].add({
                      'sNo': lf[lfld['key']][j]['sNo'],
                      'id': '${lfld['id']}.${i + 1}.${j + 1}',
                      'hid': '${lfld['objectId']}.${i + 1}.${j + 1}',
                      'name': (isNew||isCopy)
                          ? '${lfld['name']} ${i + 1}.${j + 1}'
                          : names['${lf[lfld['key']][j]['sNo']}'] ??
                          '${lfld['name']} ${i + 1}.${j + 1}',
                      'location': 'IL.${i + 1}',
                      'type': '1'
                    });
                  }
                }else{
                  if (lf[lfld['key']].isNotEmpty) {
                    name[lfld['bucket']].add({
                      'sNo': lf[lfld['key']]['sNo'],
                      'id': '${lfld['id']}.${i + 1}.1',
                      'hid': '${lfld['objectId']}.${i + 1}',
                      'name': (isNew||isCopy)
                          ? '${lfld['name']} ${i + 1}.1'
                          : names['${lf[lfld['key']]['sNo']}'] ??
                          '${lfld['name']} ${i + 1}.1',
                      'location': 'IL.${i + 1}',
                      'type': lfld['checkType'] ? checkInputType(lf['pressureIn']['input_type']) : '1'
                    });
                  }
                }
              }
            }
          }
        }
      }
    }
    notifyListeners();
    if (kDebugMode) {
      print('names : ${name}');
    }
    return name;
  }
}