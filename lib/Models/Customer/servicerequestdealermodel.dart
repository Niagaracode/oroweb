
import 'dart:convert';

ServiceDealerModel serviceDealerModelFromJson(String str) => ServiceDealerModel.fromJson(json.decode(str));

String serviceDealerModelToJson(ServiceDealerModel data) => json.encode(data.toJson());

class ServiceDealerModel {
  int? code;
  String? message;
  List<Datum>? data;

  ServiceDealerModel({
    this.code,
    this.message,
    this.data,
  });

  factory ServiceDealerModel.fromJson(Map<String, dynamic> json) => ServiceDealerModel(
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? requestId;
  int? groupId;
  String? groupName;
  int? controllerId;
  String? deviceName;
  int? requestTypeId;
  String? requestType;
  String? requestDescription;
  DateTime? requestDate;
  String? requestTime;
  String? priority;
  int? responsibleUser;
  String? responsibleUserName;
  DateTime? estimatedDate;
  String? status;
  dynamic closedDate;

  Datum({
    this.requestId,
    this.groupId,
    this.groupName,
    this.controllerId,
    this.deviceName,
    this.requestTypeId,
    this.requestType,
    this.requestDescription,
    this.requestDate,
    this.requestTime,
    this.priority,
    this.responsibleUser,
    this.responsibleUserName,
    this.estimatedDate,
    this.status,
    this.closedDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    requestId: json["requestId"],
    groupId: json["groupId"],
    groupName: json["groupName"],
    controllerId: json["controllerId"],
    deviceName: json["deviceName"],
    requestTypeId: json["requestTypeId"],
    requestType: json["requestType"],
    requestDescription: json["requestDescription"],
    requestDate: json["requestDate"] == null ? null : DateTime.parse(json["requestDate"]),
    requestTime: json["requestTime"],
    priority: json["priority"],
    responsibleUser: json["responsibleUser"],
    responsibleUserName: json["responsibleUserName"],
    estimatedDate: json["estimatedDate"] == null ? null : DateTime.parse(json["estimatedDate"]),
    status: json["status"],
    closedDate: json["closedDate"],
  );

  Map<String, dynamic> toJson() => {
    "requestId": requestId,
    "groupId": groupId,
    "groupName": groupName,
    "controllerId": controllerId,
    "deviceName": deviceName,
    "requestTypeId": requestTypeId,
    "requestType": requestType,
    "requestDescription": requestDescription,
    "requestDate": "${requestDate!.year.toString().padLeft(4, '0')}-${requestDate!.month.toString().padLeft(2, '0')}-${requestDate!.day.toString().padLeft(2, '0')}",
    "requestTime": requestTime,
    "priority": priority,
    "responsibleUser": responsibleUser,
    "responsibleUserName": responsibleUserName,
    "estimatedDate": "${estimatedDate!.year.toString().padLeft(4, '0')}-${estimatedDate!.month.toString().padLeft(2, '0')}-${estimatedDate!.day.toString().padLeft(2, '0')}",
    "status": status,
    "closedDate": closedDate,
  };
}
