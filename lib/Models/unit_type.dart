class UnitType
{
  UnitType({
    this.unitTypeId = 0,
    this.unitCategoryId = 0,
    this.categoryName = '',
    this.unitName = '',
    this.unit = '',
    this.unitDescription = '',
    this.active = '',
  });


  int unitTypeId, unitCategoryId;
  String categoryName, unitName, unit, unitDescription, active;

  factory UnitType.fromJson(Map<String, dynamic> json) => UnitType(
    unitTypeId: json['unitTypeId'],
    unitCategoryId: json['unitCategoryId'],
    categoryName: json['categoryName'],
    unitName: json['unitName'],
    unit: json['unit'],
    unitDescription: json['unitDescription'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'unitTypeId': unitTypeId,
    'unitCategoryId': unitCategoryId,
    'categoryName': categoryName,
    'unitName': unitName,
    'unit': unit,
    'unitDescription': unitDescription,
    'active': active,
  };
}

class UnitCategoryModel
{
  UnitCategoryModel({
    this.unitCategoryId = 0,
    this.categoryName = '',
    this.categoryDescription = '',
    this.active = '',
  });

  int unitCategoryId;
  String categoryName, categoryDescription, active;

  factory UnitCategoryModel.fromJson(Map<String, dynamic> json) => UnitCategoryModel(
    unitCategoryId: json['unitCategoryId'],
    categoryName: json['categoryName'],
    categoryDescription: json['categoryDescription'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'unitCategoryId': unitCategoryId,
    'categoryName': categoryName,
    'categoryDescription': categoryDescription,
    'active': active,
  };

}