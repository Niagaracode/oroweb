class GlobalSettings
{
  GlobalSettings({
    this.menuId = 0,
    this.referenceId = 0,
    this.menuName = '',
    this.active = '',
  });

  int menuId, referenceId;
  String menuName, active;

  factory GlobalSettings.fromJson(Map<String, dynamic> json) => GlobalSettings(
    menuId: json['menuId'],
    referenceId: json['referenceId'],
    menuName: json['menuName'],
    active: json['active'],
  );

}

class DDCategoryList
{
  DDCategoryList({
    this.unitCategoryId = 0,
    this.categoryName = '',
  });

  int unitCategoryId;
  String categoryName;

  factory DDCategoryList.fromJson(Map<String, dynamic> json) => DDCategoryList(
    unitCategoryId: json['unitCategoryId'],
    categoryName: json['categoryName'],
  );

}