class StockModel
{
  int productId, warranty;
  String categoryName, model, dtOfMnf, imeiNo;

  StockModel({
    this.productId = 0,
    this.categoryName = '',
    this.model = '',
    this.imeiNo = '',
    this.dtOfMnf = '',
    this.warranty = 0,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) => StockModel(
    productId: json['productId'],
    categoryName: json['categoryName'],
    model: json['model'],
    imeiNo: json['imeiNo'],
    dtOfMnf: json['dtOfMnf'],
    warranty: json['warranty'],
  );
}