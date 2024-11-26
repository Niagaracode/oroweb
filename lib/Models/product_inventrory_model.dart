class ProductListModel
{
  int productId, categoryId, modelId, productStatus, communicationMode, warrantyMonths, buyerId;
  String categoryName, modelName, productDescription, dateOfManufacturing, latestBuyer,deviceId, active;

  ProductListModel({
    this.productId = 0,
    this.categoryId = 0,
    this.categoryName ='',
    this.modelId = 0,
    this.modelName ='',
    this.deviceId = '',
    this.productDescription = '',
    this.dateOfManufacturing = '',
    this.warrantyMonths = 0,
    this.productStatus = 0,
    this.communicationMode = 0,
    this.latestBuyer = '',
    this.buyerId = 0,
    this.active = '',
  });


  factory ProductListModel.fromJson(Map<String, dynamic> json) => ProductListModel(
    productId: json['productId'],
    categoryId: json['categoryId'],
    categoryName: json['categoryName'],
    modelId: json['modelId'],
    modelName: json['modelName'],
    deviceId: json['deviceId'],
    productDescription: json['productDescription'],
    dateOfManufacturing: json['dateOfManufacturing'],
    warrantyMonths: json['warrantyMonths'],
    productStatus: json['productStatus'],
    communicationMode: json['communicationMode'],
    latestBuyer: json['latestBuyer'],
    buyerId: json['buyerId'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'modelId': modelId,
    'modelName': modelName,
    'deviceId': deviceId,
    'productDescription': productDescription,
    'dateOfManufacturing': dateOfManufacturing,
    'warrantyMonths': warrantyMonths,
    'productStatus': productStatus,
    'communicationMode': communicationMode,
    'latestBuyer': latestBuyer,
    'buyerId': buyerId,
    'active': active,
  };
}