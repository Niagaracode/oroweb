import 'dart:ui';

class SalesDataModel {
  Map<String, List<Category>>? graph;
  List<Category>? total;

  SalesDataModel({this.graph, this.total});

  factory SalesDataModel.fromJson(Map<String, dynamic> json) {
    Map<String, List<Category>>? graphMap;
    if (json['data'] != null && json['data']['graph'] != null) {
      graphMap = {};
      json['data']['graph'].forEach((key, value) {
        graphMap![key] = (value as List).asMap().entries
            .map((entry) => Category.fromJson(entry.value, entry.key))
            .toList();
      });
    }

    List<Category>? totalList;
    if (json['data'] != null && json['data']['total'] != null) {
      totalList = (json['data']['total'] as List).asMap().entries
          .map((entry) => Category.fromJson(entry.value, entry.key))
          .toList();
    }
    return SalesDataModel(graph: graphMap, total: totalList);
  }
}

class Category {
  int categoryId;
  String categoryName;
  int totalProduct;
  int inStock;
  Color color;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.totalProduct,
    required this.inStock,
    required this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json, int index) {
    return Category(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      totalProduct: json['totalProduct'],
      inStock: json['inStock'],
      color: _parseColor(json['colorCode']),
    );
  }

  static Color _parseColor(String hexString) {
    final color = int.parse(hexString, radix: 16);
    return Color(color).withOpacity(1.0); // Full opacity
  }
}