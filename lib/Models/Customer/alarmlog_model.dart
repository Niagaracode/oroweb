
import 'dart:convert';

AlertLogModel alertLogModelFromJson(String str) => AlertLogModel.fromJson(json.decode(str));

String alertLogModelToJson(AlertLogModel data) => json.encode(data.toJson());

class AlertLogModel {
  int? code;
  String? message;
  List<Datum>? data;

  AlertLogModel({
    this.code,
    this.message,
    this.data,
  });

  factory AlertLogModel.fromJson(Map<String, dynamic> json) => AlertLogModel(
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
  int? sNo;
  String? location;
  String? date;
  String? time;
  String? type;
  String? issue;
  String? objectName;
  String? program;
  String? status;
  String? message;
  String? resetBy;
  String? resetDate;
  String? resetTime;

  Datum({
    this.sNo,
    this.location,
    this.date,
    this.time,
    this.type,
    this.issue,
    this.objectName,
    this.program,
    this.status,
    this.message,
    this.resetBy,
    this.resetDate,
    this.resetTime,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    sNo: json["S_No"],
    location: json["Location"],
    date: json["Date"],
    time: json["Time"],
    type: json["Type"],
    issue: json["Issue"],
    objectName: json["ObjectName"],
    program: json["Program"],
    status: json["Status"],
    message: json["Message"],
    resetBy: json["ResetBy"],
    resetDate: json["ResetDate"],
    resetTime: json["ResetTime"],
  );

  Map<String, dynamic> toJson() => {
    "S_No": sNo,
    "Location": location,
    "Date": date,
    "Time": time,
    "Type": type,
    "Issue": issue,
    "ObjectName": objectName,
    "Program": program,
    "Status": status,
    "Message": message,
    "ResetBy": resetBy,
    "ResetDate": resetDate,
    "ResetTime": resetTime,
  };
}
