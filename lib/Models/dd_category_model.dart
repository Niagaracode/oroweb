class DDCategoryModel
{
  int categoryId;
  String categoryName, categoryDescription, active;

  DDCategoryModel({
    this.categoryId = 0,
    this.categoryName = '',
    this.categoryDescription = '',
    this.active = '',
  });

  factory DDCategoryModel.fromJson(Map<String, dynamic> json) => DDCategoryModel(
    categoryId: json['categoryId'],
    categoryName: json['categoryName'],
    categoryDescription: json['categoryDescription'],
    active: json['active'],
  );


}