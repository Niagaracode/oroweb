class StockModel
{
  int productId, warranty, modelId;
  String categoryName, model, dtOfMnf, imeiNo;

  StockModel({
    this.productId = 0,
    this.categoryName = '',
    this.model = '',
    this.modelId = 0,
    this.imeiNo = '',
    this.dtOfMnf = '',
    this.warranty = 0,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) => StockModel(
    productId: json['productId'],
    categoryName: json['categoryName'],
    model: json['model'],
    modelId: json['modelId'],
    imeiNo: json['imeiNo'],
    dtOfMnf: json['dtOfMnf'],
    warranty: json['warranty'],
  );
}