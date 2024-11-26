class NodeModel {
  late final int userDeviceListId;
  late final int masterId;
  late int productId;
  late String productDescription;
  late int modelId;
  late String modelName;
  late int categoryId;
  late String categoryName;
  late String deviceId;
  late String deviceName;
  late String dateOfManufacturing;
  late int warrantyMonths;
  late int productStatus;
  late int communicationMode;
  late int referenceNumber;
  late int serialNumber;
  late int? interfaceTypeId;
  late String? interface;
  late String interfaceInterval;
  late int inputCount;
  late int outputCount;
  late String active;
  late bool usedInConfig;

  NodeModel({
    required this.userDeviceListId,
    required this.masterId,
    required this.productId,
    required this.productDescription,
    required this.modelId,
    required this.modelName,
    required this.categoryId,
    required this.categoryName,
    required this.deviceId,
    required this.deviceName,
    required this.dateOfManufacturing,
    required this.warrantyMonths,
    required this.productStatus,
    required this.communicationMode,
    required this.referenceNumber,
    required this.serialNumber,
    required this.interfaceTypeId,
    required this.interface,
    required this.interfaceInterval,
    required this.inputCount,
    required this.outputCount,
    required this.active,
    required this.usedInConfig,
  });

  factory NodeModel.fromJson(Map<String, dynamic> json) {
    return NodeModel(
      userDeviceListId: json['userDeviceListId'],
      masterId: json['masterId'],
      productId: json['productId'],
      productDescription: json['productDescription'],
      modelId: json['modelId'],
      modelName: json['modelName'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      deviceId: json['deviceId'],
      deviceName: json['deviceName'],
      dateOfManufacturing: json['dateOfManufacturing'],
      warrantyMonths: json['warrantyMonths'],
      productStatus: json['productStatus'],
      communicationMode: json['communicationMode'],
      referenceNumber: json['referenceNumber'],
      serialNumber: json['serialNumber'],
      interfaceTypeId: json['interfaceTypeId'],
      interface: json['interface'],
      interfaceInterval: json['interfaceInterval'],
      inputCount: json['inputCount'],
      outputCount: json['outputCount'],
      active: json['active'],
      usedInConfig: json['usedInConfig'],
    );
  }
}
