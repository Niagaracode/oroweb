
class PumpSettingsMDL {
  List<CommonPumpSetting>? commonPumpSetting;
  List<IndividualPumpSetting>? individualPumpSetting;

  PumpSettingsMDL({this.commonPumpSetting, this.individualPumpSetting});

  PumpSettingsMDL.fromJson(Map<String, dynamic> json) {
    if (json['commonPumpSetting'] != null) {
      commonPumpSetting = <CommonPumpSetting>[];
      json['commonPumpSetting'].forEach((v) {
        commonPumpSetting!.add(CommonPumpSetting.fromJson(v));
      });
    }
    if (json['individualPumpSetting'] != null) {
      individualPumpSetting = <IndividualPumpSetting>[];
      json['individualPumpSetting'].forEach((v) {
        individualPumpSetting!.add(IndividualPumpSetting.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (commonPumpSetting != null) {
      data['commonPumpSetting'] =
          commonPumpSetting!.map((v) => v.toJson()).toList();
    }
    if (individualPumpSetting != null) {
      data['individualPumpSetting'] =
          individualPumpSetting!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommonPumpSetting {
  int? controllerId;
  String? deviceId;
  String? deviceName;
  int? serialNumber;
  List<SettingList>? settingList;

  CommonPumpSetting(
      {this.controllerId,
        this.deviceId,
        this.deviceName,
        this.serialNumber,
        this.settingList});

  CommonPumpSetting.fromJson(Map<String, dynamic> json) {
    controllerId = json['controllerId'];
    deviceId = json['deviceId'];
    deviceName = json['deviceName'];
    serialNumber = json['serialNumber'];
    if (json['settingList'] != null) {
      settingList = <SettingList>[];
      json['settingList'].forEach((v) {
        settingList!.add(SettingList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['controllerId'] = controllerId;
    data['deviceId'] = deviceId;
    data['deviceName'] = deviceName;
    data['serialNumber'] = serialNumber;
    if (settingList != null) {
      data['settingList'] = settingList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SettingList {
  int? type;
  String? name;
  List<SettingCmm>? setting;

  SettingList({this.type, this.name, this.setting});

  SettingList.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    if (json['setting'] != null) {
      setting = <SettingCmm>[];
      json['setting'].forEach((v) {
        setting!.add(SettingCmm.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    if (setting != null) {
      data['setting'] = setting!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SettingCmm {
  int? sNo;
  String? title;
  int? widgetTypeId;
  String? iconCodePoint;
  String? iconFontFamily;
  dynamic value;
  bool? hidden;

  SettingCmm(
      {this.sNo,
        this.title,
        this.widgetTypeId,
        this.iconCodePoint,
        this.iconFontFamily,
        this.value,
        this.hidden});

  SettingCmm.fromJson(Map<String, dynamic> json) {

    sNo = json['sNo'];
    title = json['title'];
    widgetTypeId = json['widgetTypeId'];
    iconCodePoint = json['iconCodePoint'];
    iconFontFamily = json['iconFontFamily'];
    value = json['value'];
    hidden = json['hidden'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sNo'] = sNo;
    data['title'] = title;
    data['widgetTypeId'] = widgetTypeId;
    data['iconCodePoint'] = iconCodePoint;
    data['iconFontFamily'] = iconFontFamily;
    data['value'] = value;
    data['hidden'] = hidden;
    return data;
  }
}

class IndividualPumpSetting {
  int? sNo;
  String? id;
  String? hid;
  String? name;
  String? location;
  String? type;
  String? deviceId;
  List<SettingList>? settingList;

  IndividualPumpSetting(
      {this.sNo,
        this.id,
        this.hid,
        this.name,
        this.location,
        this.type,
        this.deviceId,
        this.settingList});

  IndividualPumpSetting.fromJson(Map<String, dynamic> json) {
    sNo = json['sNo'];
    id = json['id'];
    hid = json['hid'];
    name = json['name'];
    location = json['location'];
    type = json['type'];
    deviceId = json['deviceId'];
    if (json['settingList'] != null) {
      settingList = <SettingList>[];
      json['settingList'].forEach((v) {
        settingList!.add(SettingList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sNo'] = sNo;
    data['id'] = id;
    data['hid'] = hid;
    data['name'] = name;
    data['location'] = location;
    data['type'] = type;
    data['deviceId'] = deviceId;
    if (settingList != null) {
      data['settingList'] = settingList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Setting {
  int? sNo;
  String? title;
  int? widgetTypeId;
  String? iconCodePoint;
  String? iconFontFamily;
  String? value;
  bool? hidden;

  Setting(
      {this.sNo,
        this.title,
        this.widgetTypeId,
        this.iconCodePoint,
        this.iconFontFamily,
        this.value,
        this.hidden});

  Setting.fromJson(Map<String, dynamic> json) {
    sNo = json['sNo'];
    title = json['title'];
    widgetTypeId = json['widgetTypeId'];
    iconCodePoint = json['iconCodePoint'];
    iconFontFamily = json['iconFontFamily'];
    value = json['value'];
    hidden = json['hidden'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sNo'] = sNo;
    data['title'] = title;
    data['widgetTypeId'] = widgetTypeId;
    data['iconCodePoint'] = iconCodePoint;
    data['iconFontFamily'] = iconFontFamily;
    data['value'] = value;
    data['hidden'] = hidden;
    return data;
  }
}
