class ProductListWithNode {
  final int userGroupId;
  final String groupName;
  final String active;
  final List<Master> master;

  ProductListWithNode({
    required this.userGroupId,
    required this.groupName,
    required this.active,
    required this.master,
  });

  factory ProductListWithNode.fromJson(Map<String, dynamic> json) {
    List<Master> masters = [];
    if (json['master'] != null) {
      masters = List<Master>.from(json['master'].map((masterJson) => Master.fromJson(masterJson)));
    }
    return ProductListWithNode(
      userGroupId: json['userGroupId'],
      groupName: json['groupName'],
      active: json['active'],
      master: masters,
    );
  }
}

class Master {
  final int controllerId;
  final int dealerId;
  final int productId;
  final String deviceId;
  final String deviceName;
  final String productDescription;
  final int? masterId;
  final int productStatus;
  final int categoryId;
  final String categoryName;
  final int modelId;
  final String modelName;
  final String modelDescription;
  final int referenceNumber;
  final int? interfaceTypeId;
  final String? interface;
  final String interfaceInterval;
  final List<Node> nodeList;
  final int outputCount;
  final int inputCount;

  Master({
    required this.controllerId,
    required this.dealerId,
    required this.productId,
    required this.deviceId,
    required this.deviceName,
    required this.productDescription,
    required this.masterId,
    required this.productStatus,
    required this.categoryId,
    required this.categoryName,
    required this.modelId,
    required this.modelName,
    required this.modelDescription,
    required this.referenceNumber,
    required this.interfaceTypeId,
    required this.interface,
    required this.interfaceInterval,
    required this.nodeList,
    required this.outputCount,
    required this.inputCount,
  });

  factory Master.fromJson(Map<String, dynamic> json) {
    List<Node> nodes = [];
    if (json['nodeList'] != null) {
      nodes = List<Node>.from(json['nodeList'].map((nodeJson) => Node.fromJson(nodeJson)));
    }
    return Master(
      controllerId: json['controllerId'],
      dealerId: json['dealerId'],
      productId: json['productId'],
      deviceId: json['deviceId'],
      deviceName: json['deviceName'],
      productDescription: json['productDescription'],
      masterId: json['masterId'],
      productStatus: json['productStatus'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      modelId: json['modelId'],
      modelName: json['modelName'],
      modelDescription: json['modelDescription'],
      referenceNumber: json['referenceNumber'],
      interfaceTypeId: json['interfaceTypeId'],
      interface: json['interface'],
      interfaceInterval: json['interfaceInterval'],
      nodeList: nodes,
      outputCount: json['outputCount'],
      inputCount: json['inputCount'],
    );
  }
}

class Node {
  final int userDeviceListId;
  final int masterId;
  final int productId;
  final String productDescription;
  final int modelId;
  final String modelName;
  final int categoryId;
  final String categoryName;
  final String deviceId;
  final String deviceName;
  final String dateOfManufacturing;
  final int warrantyMonths;
  final int productStatus;
  final int communicationMode;
  final int referenceNumber;
  final int serialNumber;
  late int? interfaceTypeId;
  late String? interface;
  late String interfaceInterval;
  final int inputCount;
  final int outputCount;
  final String active;
  final bool usedInConfig;

  Node({
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

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
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
