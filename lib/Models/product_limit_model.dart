class MdlProductLimit
{
  int productTypeId, quantity;
  String product, productDescription, connectionType;

  MdlProductLimit({
    this.productTypeId = 0,
    this.product = '',
    this.productDescription = '',
    this.quantity = 0,
    this.connectionType = '',
  });

  factory MdlProductLimit.fromJson(Map<String, dynamic> json) => MdlProductLimit(
    productTypeId: json['productTypeId'],
    product: json['product'],
    productDescription: json['productDescription'],
    connectionType: json['connectionType'],
    quantity: json['quantity'],
  );

  Map<String, dynamic> toJson() => {
    'productTypeId': productTypeId,
    'product': product,
    'productDescription': productDescription,
    'connectionType': connectionType,
    'quantity': quantity,
  };
}