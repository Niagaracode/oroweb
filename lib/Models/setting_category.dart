class SettingCategory
{
  SettingCategory({
    this.settingId = 0,
    this.menuId = 0,
    this.menuName = '',
    this.settingName = '',
    this.settingType = '',
    this.settingDescription = '',
    this.active = '',
  });

  int settingId, menuId;
  String menuName,settingName, settingType,settingDescription, active;

  factory SettingCategory.fromJson(Map<String, dynamic> json) => SettingCategory(
    settingId: json['settingId'],
    menuId: json['menuId'],
    menuName: json['menuName'],
    settingName: json['settingName'],
    settingType: json['settingType'],
    settingDescription: json['settingDescription'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'settingId': settingId,
    'menuId': menuId,
    'menuName': menuName,
    'settingName': settingName,
    'settingType': settingType,
    'settingDescription': settingDescription,
    'active': active,
  };
}