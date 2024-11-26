class DDModel
{
  int dealerDefinitionId, categoryId, widgetTypeId;
  String categoryName, parameter, description, widget, iconCodePoint, iconFontFamily, dropdownValues, active;

  DDModel({
    this.dealerDefinitionId = 0,
    this.categoryId = 0,
    this.parameter = '',
    this.description = '',
    this.widget = '',
    this.widgetTypeId = 0,
    this.dropdownValues = '',
    this.categoryName = '',
    this.iconCodePoint = '',
    this.iconFontFamily = '',
    this.active = '',
  });

  factory DDModel.fromJson(Map<String, dynamic> json) => DDModel(
    dealerDefinitionId: json['dealerDefinitionId'],
    categoryId: json['categoryId'],
    parameter: json['parameter'],
    description: json['description'],
    widget: json['widget'],
    widgetTypeId: json['widgetTypeId'],
    dropdownValues: json['dropdownValues']??'',
    categoryName: json['categoryName'] ?? '',
    iconCodePoint: json['iconCodePoint'] ?? '',
    iconFontFamily: json['iconFontFamily'] ?? '',
    active: json['active'],
  );

}