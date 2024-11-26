import 'dart:convert';

import 'package:flutter/material.dart';

import '../Models/PreferenceModel/preferences_model.dart';
import '../constants/http_service.dart';

class PreferencesMainProvider extends ChangeNotifier {
  final HttpService httpService = HttpService();
  late TabController settingsTabController;

  List<String> label1 = ['General', 'Contact', 'Pump', 'Settings', 'Notifications'];
  List<IconData> icons1 = [
    Icons.settings_rounded,
    Icons.connect_without_contact_rounded,
    Icons.waterfall_chart_rounded,
    Icons.settings_applications_rounded,
    Icons.notifications_rounded
  ];

  List<String> label2 = ['General', 'Settings', 'Notifications'];
  List<IconData> icons2 = [
    Icons.settings_rounded,
    Icons.settings_applications_rounded,
    Icons.notifications_rounded
  ];

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  void updateTabIndex(int newIndex) {
    _selectedTabIndex = newIndex;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  Configuration? _configuration;
  Configuration? get configuration => _configuration;

  List<String> totalPumps = [];
  List<String?> totalPumpsName = [];
  List<dynamic> selectedContacts = [];

  void changeTypeForContact(int index, String value) {
    _configuration!.contacts?[index].value = value;
    notifyListeners();
  }

  List<String> label = [];
  List<IconData> icons = [];
  Future<void> preferencesDataFromApi(userId, controllerId) async {
    try{
      final userData = {
        "userId": userId,
        "controllerId": controllerId,
      };
      final getUserPreference = await httpService.postRequest('defaultUserPreference', userData);
      if(getUserPreference.statusCode == 200) {
        final responseJson = getUserPreference.body;
        final convertedJson = jsonDecode(responseJson);
        _configuration = Configuration.fromJson(convertedJson['data']);
        if(_configuration!.irrigationPumpName.isEmpty && _configuration!.sourcePumpName.isEmpty) {
          label = ['General'];
          icons = [Icons.settings_rounded];
        } else {
          if(_configuration!.contactName.isNotEmpty) {
            label = ['General', 'Contact', 'Pump', 'Settings', 'Notifications'];
            icons = [
              Icons.settings_rounded,
              Icons.connect_without_contact_rounded,
              Icons.waterfall_chart_rounded,
              Icons.settings_applications_rounded,
              Icons.notifications_rounded
            ];
          }
          else{
            label = ['General', 'Settings', 'Notifications'];
            icons = [
              Icons.settings_rounded,
              Icons.settings_applications_rounded,
              Icons.notifications_rounded
            ];
          }
        }
      }else {
        print("HTTP Request failed or received an unexpected response.");
      }
    } catch (error) {
      print("Error: $error");
    }

    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  void initContactList() {
    if (_configuration!.contacts!.isEmpty
        || (_configuration!.contacts!.length != _configuration!.contactName.length)) {
      for (var i = 0; i < _configuration!.contactName.length; i++) {
        _configuration!.contacts!.add(ContactItem(
          id: _configuration!.contactName[i].id,
          sNo: _configuration!.contactName[i].sNo,
          name: _configuration!.contactName[i].name,
          deviceId: _configuration!.contactName[i].deviceId,
          hid: _configuration!.contactName[i].hid,
          value: _configuration!.contactType.isNotEmpty ? _configuration!.contactType[0].contactType: '',
        ));
      }
    }
  }

  void initNotifications() {
    if (_configuration!.alarmNotificationsSent.isEmpty
        || (_configuration!.alarmNotificationsSent.length != _configuration!.alarmNotifications.length)) {
      for (var i = 0; i < _configuration!.alarmNotifications.length; i++) {
        _configuration!.alarmNotificationsSent.add(NotificationType(
          notificationTypeId: _configuration!.alarmNotifications[i].notificationTypeId,
          notification: _configuration!.alarmNotifications[i].notification,
          notificationDescription: _configuration!.alarmNotifications[i].notificationDescription,
          iconCodePoint: _configuration!.alarmNotifications[i].iconCodePoint,
          value: _configuration!.alarmNotifications[i].value,
          iconFontFamily: _configuration!.alarmNotifications[i].iconFontFamily,
        ));
      }
    }
    if (_configuration!.eventNotificationsSent.isEmpty
        || (_configuration!.eventNotificationsSent.length != _configuration!.eventNotifications.length)) {
      for (var i = 0; i < _configuration!.eventNotifications.length; i++) {
        _configuration!.eventNotificationsSent.add(NotificationType(
          notificationTypeId: _configuration!.eventNotifications[i].notificationTypeId,
          notification: _configuration!.eventNotifications[i].notification,
          notificationDescription: _configuration!.eventNotifications[i].notificationDescription,
          iconCodePoint: _configuration!.eventNotifications[i].iconCodePoint,
          value: _configuration!.eventNotifications[i].value,
          iconFontFamily: _configuration!.eventNotifications[i].iconFontFamily,
        ));
      }
    }
  }

  void extractPumpInfo() {
    initPumpsList(_configuration?.sourcePumpName ?? []);
    initPumpsList(_configuration?.irrigationPumpName ?? []);
  }

  void initPumpsList(List<dynamic> pumpNames) {
    if (_configuration!.pumps!.isEmpty) {
      _configuration!.pumps!.addAll(List.generate(
        pumpNames.length,
            (index) => PumpItem(
          sNo: pumpNames[index].sNo,
          id: pumpNames[index].id,
          value: initPumpValues(),
        ),
      ));
    } else {
      if(totalPumps.length > _configuration!.pumps!.length){
        _configuration!.pumps!.addAll(List.generate(
          pumpNames.length,
              (index) {
            final pumpId = pumpNames[index].id;
            final sNo = pumpNames[index].sNo;
            final existingPump = _configuration!.pumps!.firstWhere(
                  (pump) => pump.id == pumpId,
              orElse: () => PumpItem(id: pumpId, sNo: sNo, value: initPumpValues()),
            );
            return existingPump;
          },
        ));
      } else if (totalPumps.length < _configuration!.pumps!.length) {
        _configuration!.pumps!.removeWhere((pump) => !totalPumps.any((tp) => tp == pump.id));
      }
    }
  }

  void initializePumpSettings() {
    List<ContactItem> pumpNames = [...configuration!.irrigationPumpName, ...configuration!.sourcePumpName];

    _configuration!.settings!.removeWhere((pump) => !pumpNames.any((tp) => tp.sNo == pump.sNo));

    for (var i in pumpNames) {
      if (_configuration!.settings!.every((element) => element.sNo != i.sNo)) {
        _configuration!.settings!.add(
          PumpSettingModel(
            id: i.id,
            sNo: i.sNo,
            deviceId: i.deviceId,
            pumpSettings: initPumpSettings(),
          ),
        );
      }
    }

    print("pumps ${configuration!.settings!.map((e) => e.deviceId)}");
  }

  void initPumpSettingModel(List<dynamic> pumpNames) {
    if (_configuration!.settings!.isEmpty) {
      print("settings empty");
      _configuration!.settings!.addAll(List.generate(
        pumpNames.length,
            (index) => PumpSettingModel(
          sNo: pumpNames[index].sNo,
          id: pumpNames[index].id,
          deviceId: pumpNames[index].deviceId,
          pumpSettings: initPumpSettings(),
        ),
      ));
    }
    else {
      if (totalPumps.length > _configuration!.settings!.length) {
        _configuration!.settings!.addAll(List.generate(
          pumpNames.length,
              (index) {
            final pumpId = pumpNames[index].id;
            final sNo = pumpNames[index].sNo;
            final deviceId = pumpNames[index].deviceId;
            final existingPump = _configuration!.settings!.firstWhere(
                  (pump) => pump.id == pumpId,
              orElse: () => PumpSettingModel(
                  deviceId: deviceId,
                  id: pumpId, sNo: sNo, pumpSettings: initPumpSettings()),
            );
            return existingPump;
          },
        ));
      }
      else if (totalPumps.length < _configuration!.settings!.length) {
        _configuration!.settings!.removeWhere((pump) =>
        !totalPumps.any((tp) => tp == pump.id));
      }
    }
  }

  List<PumpSettings> initPumpSettings() {
    return _configuration!.pumpSettings.map((e) {
      return PumpSettings(
        type: e?.type ?? "",
        setting: e?.setting.map((setting) {
          if (setting.title == 'RTC TIMER') {
            return WidgetSetting(
              title: setting.title,
              widgetTypeId: setting.widgetTypeId,
              iconCodePoint: setting.iconCodePoint,
              iconFontFamily: setting.iconFontFamily,
              value: setting.value,
              rtcSettings: (setting.value as List).map((rtcItem) {
                return RtcTimeSetting(
                  rtc: rtcItem['rtc'],
                  onTime: rtcItem['onTime'],
                  offTime: rtcItem['offTime'],
                );
              }).toList(),
              hidden: setting.hidden,
            );
          } else {
            return WidgetSetting(
              title: setting.title,
              widgetTypeId: setting.widgetTypeId,
              iconCodePoint: setting.iconCodePoint,
              iconFontFamily: setting.iconFontFamily,
              value: setting.value,
              hidden: setting.hidden,
            );
          }
        }).toList() ?? [],
      );
    }).toList();
  }

  //Todo: PUMP SCREEN PROVIDERS
  List<PumpValue> initPumpValues() {
    return _configuration!.selectedContact.selectedContact.map((e) => PumpValue(
      type: e.type,
      selectedContact: 'None',
    )).toList();
  }

  void extractTotalPumpsInfo() {
    totalPumps = [
      ..._configuration!.irrigationPumpName.map((id) => id.id.toString()),
      ..._configuration!.sourcePumpName.map((id) => id.id.toString()),
    ];
    selectedContacts = _configuration!.selectedContact.selectedContact.map((e) => e.type).toList();
    totalPumpsName = [..._configuration!.irrigationPumpName.map((name) => name.name).toList(), ..._configuration!.sourcePumpName.map((name) => name.name).toList()];
  }

  void updateContactsForPumps(newContact, pump, index, typeIndex) {
    final pumpList = _configuration?.pumps;
    final matchingPump = pumpList?.firstWhere(
          (element) => element.id == pump,
      orElse: () => PumpItem(id: '', value: <PumpValue>[]),
    );

    if (matchingPump != null) {
      // print(matchingPump.value.map((e) => e.type));
      configuration!.pumps!.firstWhere((element) => element.id == pump).value[typeIndex].selectedContact = newContact;
      // print('yes');
      // print('matchingElement${matchingElement.type}');
      // print(newContact);
      notifyListeners();
    }
  }

  void updateControllerName(String newControllerName) {
    if (_configuration != null) {
      _configuration!.general.controllerName = newControllerName != ''
          ? newControllerName
          : _configuration!.general.controllerName;
      notifyListeners();
    }
  }

  void updateSelectedContactType(String contactId, String newContactType) {
    final item2 = _configuration?.contactName.firstWhere((element) =>
    element.id == contactId);
    item2?.value = newContactType;
    notifyListeners();
  }

  int _selectedPumpIndex = 0;

  int get selectedPumpIndex => _selectedPumpIndex;

  void updatePumpIndex(int newIndex) {
    _selectedPumpIndex = newIndex;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  int _selectedPumpIndex2 = 0;

  int get selectedPumpIndex2 => _selectedPumpIndex2;

  void updatePumpIndex2(int newIndex) {
    _selectedPumpIndex2 = newIndex;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  List<Map<String, String>> selectedContactsList = [];
  Map<String, Map<String, String>> selectedContactsForPumps = {};

  void updateSelectedContactForPump(String pump, String type, String newContact) {
    if (!selectedContactsForPumps.containsKey(pump)) {
      selectedContactsForPumps[pump] = {};
    }
    selectedContactsForPumps[pump]?[type] = newContact;

    final index = selectedContactsList.indexWhere((map) => map['pump'] == pump);
    if (index != -1) {
      selectedContactsList[index][type] = newContact;
    } else {
      final contactMap = {'pump': pump};
      selectedContactsForPumps[pump]?.forEach((key, value) {
        contactMap[key] = value;
      });
      selectedContactsList.add(contactMap);
    }

    notifyListeners();
  }

  //Todo: SETTINGS SCREEN PROVIDERS
  int _selectedSetting = 0;

  int get selectedSetting => _selectedSetting;

  void updateSelectedSetting(int newIndex) {
    _selectedSetting = newIndex;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  dynamic getValueForIdentifier2(String title) {
    if (_configuration != null) {
      final item = _configuration!.commonSettings.expand((setting) =>
      setting.setting).firstWhere((setting) => setting.title == title);

      if(item.value is bool){
        return ((item.value != null) || item.value != '') ? item.value : false;
      } else{
        return item.value;
      }
    } else {
      return null;
    }
  }

  dynamic getValueForIdentifier(String title, int pumpId) {
    if (_configuration != null) {
      final item = _configuration!.settings?[pumpId].pumpSettings.expand((setting) =>
      setting.setting).firstWhere((setting) => setting.title == title);

      if(item?.value is bool){
        return ((item!.value != null) || item.value != '') ? item.value : false;
      } else {
        return item?.value;
      }
    } else {
      return null;
    }
  }

  void updateValueForIdentifier(String title, dynamic value, int pumpId) {
    final item = _configuration!.settings?[pumpId].pumpSettings.expand((setting) => setting.setting).firstWhere(
            (setting) => setting.title == title
    );

    item?.value = value;

    notifyListeners();
  }

  void updateValueForIdentifier2(String title, dynamic value,) {
    final item = _configuration!.commonSettings.expand((setting) => setting.setting).firstWhere(
            (setting) => setting.title == title
    );

    item.value = value;

    notifyListeners();
  }

  String getRtcOnTime(String title, int rtc, index) {
    if (_configuration != null) {
      final item = _configuration?.settings?[index].pumpSettings.expand((section) => section.setting).firstWhere(
            (item) => item.title == title,
        orElse: () => throw Exception('Item not found for identifier: $title'),
      );
      if (item?.rtcSettings != null) {
        for (var rtcSetting in item!.rtcSettings!) {
          if (rtcSetting.rtc == rtc) {
            final onTime = rtcSetting.onTime;
            if (onTime != '') {
              return onTime;
            } else {
              return '00:00:00';
            }
          }
        }
      }
    }
    throw Exception('RTC $rtc not found');
  }

  String getRtcOffTime(String title, int rtc, index) {
    final item = _configuration!.settings?[index].pumpSettings.expand((section) =>
    section.setting).firstWhere(
          (item) => item.title == title,
      orElse: () => throw Exception('Item not found for identifier: $title'),
    );
    for (var rtcSetting in item!.rtcSettings!) {
      if (rtcSetting.rtc == rtc) {
        final offTime = rtcSetting.offTime;
        if (offTime != '') {
          return offTime;
        } else {
          return '00:00:00';
        }
      }
    }
    throw Exception('RTC $rtc not found');
  }

  void updateRtcOnTime(String title, int rtc, String newOnTime, index) {
    final item = _configuration!.settings?[index].pumpSettings.expand((section) => section.setting).firstWhere(
          (item) => item.title == title,
      orElse: () => throw Exception('Item not found for identifier: $title'),
    );
    for (var rtcSetting in item!.rtcSettings!) {
      if (rtcSetting.rtc == rtc) {
        rtcSetting.onTime = newOnTime;
        notifyListeners();
        return;
      }
    }
    throw Exception('RTC $rtc not found');
  }

  void updateRtcOffTime(String title, int rtc, String newOffTime, index) {
    final item = _configuration!.settings?[index].pumpSettings.expand((section) => section.setting).firstWhere(
          (item) => item.title == title,
      orElse: () => throw Exception('Item not found for identifier: $title'),
    );
    for (var rtcSetting in item!.rtcSettings!) {
      if (rtcSetting.rtc == rtc) {
        rtcSetting.offTime = newOffTime;
        notifyListeners();
        return;
      }
    }
    throw Exception('RTC $rtc not found');
  }

  //Todo: NOTIFICATION SCREEN PROVIDERS
  int _selectedSegment = 0;

  int get selectedSegment => _selectedSetting;

  void updateSelectedSegment(int newIndex) {
    _selectedSetting = newIndex;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  dynamic getValueForEvent(int notificationTypeId) {
    if (_configuration != null) {
      final item = _configuration!.eventNotificationsSent.firstWhere(
              (notification) => notification.notificationTypeId == notificationTypeId,
          orElse: () => throw Exception('Item not found for identifier: $notificationTypeId',
          ));
      return item.value;
    } else {
      return null;
    }
  }

  dynamic getValueForAlarm(int notificationTypeId) {
    if (_configuration != null) {
      final item = _configuration!.alarmNotificationsSent.firstWhere(
              (notification) => notification.notificationTypeId == notificationTypeId,
          orElse: () => throw Exception('Item not found for identifier: $notificationTypeId',
          ));
      return item.value;
    } else {
      return null;
    }
  }

  void updateValueForEvent(int notificationTypeId, newValue) {
    final item = _configuration!.eventNotificationsSent.firstWhere(
            (notification) => notification.notificationTypeId == notificationTypeId,
        orElse: () => throw Exception('Item not found for identifier: $notificationTypeId',
        ));
    item.value = newValue;
    notifyListeners();
  }

  void updateValueForAlarm(int notificationTypeId, newValue) {
    final item = _configuration!.alarmNotificationsSent.firstWhere(
            (notification) => notification.notificationTypeId == notificationTypeId,
        orElse: () => throw Exception('Item not found for identifier: $notificationTypeId',
        ));
    item.value = newValue;
    notifyListeners();
  }

}
