import 'dart:convert';

FrostProtectionModel frostProtectionModelFromJson(String str) =>
    FrostProtectionModel.fromJson(json.decode(str));

String frostProtectionModelToJson(FrostProtectionModel data) =>
    json.encode(data.toJson());

class FrostProtectionModel {
  List<FrostProtection>? frostProtection;
  List<FrostProtection>? rainDelay;

  FrostProtectionModel({
    this.frostProtection,
    this.rainDelay,
  });

  factory FrostProtectionModel.fromJson(Map<String, dynamic> json) {
    // Check if the 'data' is a list or a map
    print("runtimeType${json["data"].runtimeType}");
    if (json["data"]["frostProtection"] is List) {
      print("runtimeType list");
      // Old format, where 'data' is a list
      return FrostProtectionModel(
        frostProtection: json['data']["frostProtection"] == null
            ? []
            : List<FrostProtection>.from(json['data']["frostProtection"]!
            .map((x) => FrostProtection.fromJson(x))),
        rainDelay: json['data']["rainDelay"] == null
            ? []
            : List<FrostProtection>.from(json['data']["rainDelay"]!
            .map((x) => FrostProtection.fromJson(x))),
      );
    } else if (json["data"]["frostProtection"] is Map) {

      // New format, where 'data' contains a 'backwash' field (which is a list)
      return FrostProtectionModel(
        frostProtection: json['data']["frostProtection"]["frostProtection"] == null
            ? []
            : List<FrostProtection>.from(json['data']["frostProtection"]!["frostProtection"]
            .map((x) => FrostProtection.fromJson(x))),
        rainDelay: json['data']["rainDelay"]["rainDelay"]  == null
            ? []
            : List<FrostProtection>.from(json['data']["rainDelay"]["rainDelay"]!
            .map((x) => FrostProtection.fromJson(x))),
      );
    } else {
      throw Exception("Unexpected JSON format");
    }
  }

  Map<String, dynamic> toJson() => {
    "frostProtection": frostProtection == null
        ? []
        : List<dynamic>.from(frostProtection!.map((x) => x.toJson())),
    "rainDelay": rainDelay == null
        ? []
        : List<dynamic>.from(rainDelay!.map((x) => x.toJson())),
  };
}

class FrostProtection {
  int? sNo;
  String? title;
  int? widgetTypeId;
  String? iconCodePoint;
  String? iconFontFamily;
  String? value;

  FrostProtection({
    this.sNo,
    this.title,
    this.widgetTypeId,
    this.iconCodePoint,
    this.iconFontFamily,
    this.value,
  });

  factory FrostProtection.fromJson(Map<String, dynamic> json) =>
      FrostProtection(
        sNo: json["sNo"],
        title: json["title"],
        widgetTypeId: json["widgetTypeId"],
        iconCodePoint: json["iconCodePoint"],
        iconFontFamily: json["iconFontFamily"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
    "sNo": sNo,
    "title": title,
    "widgetTypeId": widgetTypeId,
    "iconCodePoint": iconCodePoint,
    "iconFontFamily": iconFontFamily,
    "value": value,
  };
}