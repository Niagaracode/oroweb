class AlarmGroupData {
  int groupId;
  String groupName;
  List<MasterData> master;

  AlarmGroupData({required this.groupId, required this.groupName, required this.master});

  factory AlarmGroupData.fromJson(Map<String, dynamic> json) {
    return AlarmGroupData(
      groupId: json['groupId'],
      groupName: json['groupName'],
      master: List<MasterData>.from(json['master'].map((item) => MasterData.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'master': master.map((controller) => controller.toJson()).toList(),
    };
  }
}

class MasterData {
  int controllerId;
  String deviceName;
  List<CriticalAlarm> criticalAlarm;

  MasterData({required this.controllerId, required this.deviceName, required this.criticalAlarm});

  factory MasterData.fromJson(Map<String, dynamic> json) {
    return MasterData(
      controllerId: json['controllerId'],
      deviceName: json['deviceName'],
      criticalAlarm: List<CriticalAlarm>.from(json['criticalAlarm'].map((item) => CriticalAlarm.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'controllerId': controllerId,
      'deviceName': deviceName,
      'criticalAlarm': criticalAlarm.map((alarm) => alarm.toJson()).toList(),
    };
  }
}

class CriticalAlarm {
  String sNo;
  String location;
  int alarmType;
  String alarmSet;
  String alarmActual;
  int status;

  CriticalAlarm({
    required this.sNo,
    required this.location,
    required this.alarmType,
    required this.alarmSet,
    required this.alarmActual,
    required this.status,
  });

  factory CriticalAlarm.fromJson(Map<String, dynamic> json) {
    return CriticalAlarm(
      sNo: json['S_No'],
      location: json['Location'],
      alarmType: json['AlarmType'],
      alarmSet: json['AlarmSet'],
      alarmActual: json['AlarmActual'],
      status: json['Status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'S_No': sNo,
      'Location': location,
      'AlarmType': alarmType,
      'AlarmSet': alarmSet,
      'AlarmActual': alarmActual,
      'Status': status,
    };
  }
}

class CriticalAlarmFinal {
  String fmName;
  String dvcName;
  String location;
  String message;

  CriticalAlarmFinal({
    required this.fmName,
    required this.dvcName,
    required this.location,
    required this.message,
  });
}