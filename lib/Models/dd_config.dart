

class DataModelDDConfig {
  final List<Category> categories;
  final Map<String, List<DealerDefinition>> dealerDefinition;

  DataModelDDConfig({
    required this.categories,
    required this.dealerDefinition,
  });

  factory DataModelDDConfig.fromJson(Map<String, dynamic> json) {
    var categoryList = json['data']['category'] as List;
    List<Category> categories =
    categoryList.map((category) => Category.fromJson(category)).toList();

    Map<String, List<DealerDefinition>> dealerDefinition = {};
    var dealerDefinitionData = json['data']['dealerDefinition'];
    dealerDefinitionData.forEach((key, value) {
      var list = value
          .map<DealerDefinition>(
              (item) => DealerDefinition.fromJson(item))
          .toList();
      dealerDefinition[key] = list;
    });

    return DataModelDDConfig(
      categories: categories,
      dealerDefinition: dealerDefinition,
    );
  }
}

class Category {
  final int categoryId;
  final String categoryName;
  final String categoryDescription;
  final String active;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.categoryDescription,
    required this.active,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      categoryDescription: json['categoryDescription'],
      active: json['active'],
    );
  }
}

class DealerDefinition {
  final int dealerDefinitionId;
  final String categoryName;
  final int widgetTypeId;
  final String parameter;
  final String description;
  final String? iconCodePoint;
  final String? iconFontFamily;
  final String? dropdownValues;
  String value;

  DealerDefinition({
    required this.dealerDefinitionId,
    required this.categoryName,
    required this.widgetTypeId,
    required this.parameter,
    required this.description,
    required this.iconCodePoint,
    required this.iconFontFamily,
    required this.dropdownValues,
    required this.value,
  });

  factory DealerDefinition.fromJson(Map<String, dynamic> json) {
    return DealerDefinition(
      dealerDefinitionId: json['dealerDefinitionId'],
      categoryName: json['categoryName'],
      widgetTypeId: json['widgetTypeId'],
      parameter: json['parameter'],
      description: json['description'],
      iconCodePoint: json['iconCodePoint'],
      iconFontFamily: json['iconFontFamily'],
      dropdownValues: json['dropdownValues'],
      value: json['value'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'dealerDefinitionId': dealerDefinitionId,
      'categoryName': categoryName,
      'widgetTypeId': widgetTypeId,
      'parameter': parameter,
      'description': description,
      'iconCodePoint': iconCodePoint,
      'iconFontFamily': iconFontFamily,
      'dropdownValues': dropdownValues,
      'value': value,
    };
  }
}