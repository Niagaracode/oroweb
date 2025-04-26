import 'dart:convert';

PumpConditionModel pumpConditionModelFromJson(String str) => PumpConditionModel.fromJson(json.decode(str));

String pumpConditionModelToJson(PumpConditionModel data) => json.encode(data.toJson());

class PumpConditionModel {
  int? code;
  String? message;
  Data? data;

  PumpConditionModel({
    this.code,
    this.message,
    this.data,
  });

  factory PumpConditionModel.fromJson(Map<String, dynamic> json) => PumpConditionModel(
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  List<PumpCondition>? pumpCondition;
  String? controllerReadStatus;

  Data({
    this.pumpCondition,
    this.controllerReadStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    pumpCondition: json["pumpCondition"] == null ? [] : List<PumpCondition>.from(json["pumpCondition"]!.map((x) => PumpCondition.fromJson(x))),
    controllerReadStatus: json["controllerReadStatus"],
  );

  Map<String, dynamic> toJson() => {
    "pumpCondition": pumpCondition == null ? [] : List<dynamic>.from(pumpCondition!.map((x) => x.toJson())),
    "controllerReadStatus": controllerReadStatus,
  };
}

class PumpCondition {
  int? sNo;
  String? id;
  String? hid;
  String? name;
  String? location;
  String? type;
  bool? controlGem;
  String? deviceId;
  List<SelectedPump>? selectedPumps;

  PumpCondition({
    this.sNo,
    this.id,
    this.hid,
    this.name,
    this.location,
    this.type,
    this.controlGem,
    this.deviceId,
    this.selectedPumps,
  });

  factory PumpCondition.fromJson(Map<String, dynamic> json) => PumpCondition(
    sNo: json["sNo"],
    id: json["id"],
    hid: json["hid"],
    name: json["name"],
    location: json["location"],
    type: json["type"],
    controlGem: json["controlGem"],
    deviceId: json["deviceId"],
    selectedPumps: json["selectedPumps"] == null ? [] : List<SelectedPump>.from(json["selectedPumps"]!.map((x) => SelectedPump.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sNo": sNo,
    "id": id,
    "hid": hid,
    "name": name,
    "location": location,
    "type": type,
    "controlGem": controlGem,
    "deviceId": deviceId,
    "selectedPumps": selectedPumps == null ? [] : List<dynamic>.from(selectedPumps!.map((x) => x.toJson())),
  };
}

class SelectedPump {
  int? sNo;
  String? id;
  String? hid;

  SelectedPump({
    this.sNo,
    this.id,
    this.hid,
  });

  factory SelectedPump.fromJson(Map<String, dynamic> json) => SelectedPump(
    sNo: json["sNo"],
    id: json["id"],
    hid: json["hid"],
  );

  Map<String, dynamic> toJson() => {
    "sNo": sNo,
    "id": id,
    "hid": hid,
  };
}
