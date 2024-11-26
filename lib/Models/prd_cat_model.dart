class PrdCateModel
{
  PrdCateModel({
    this.categoryId = 0,
    this.categoryName = '',
    this.smsFormat = '',
    this.inputCount = 0,
    this.outputCount = 0,
    this.active = '',
  });

  int categoryId, inputCount, outputCount;
  String categoryName, smsFormat, active;

  factory PrdCateModel.fromJson(Map<String, dynamic> json) => PrdCateModel(
    categoryId: json['categoryId'],
    categoryName: json['categoryName'],
    smsFormat: json['smsFormat'] ?? 0,
    inputCount: json['inputCount'],
    outputCount: json['outputCount'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'categoryId': categoryId,
    'categoryName': categoryName,
    'smsFormat': smsFormat,
    'inputCount': inputCount,
    'outputCount': outputCount,
    'active': active,
  };
}