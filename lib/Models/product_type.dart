class ProductType
{
  ProductType({
    this.productTypeId = 0,
    this.product = '',
    this.productDescription = '',
    this.active = '',
  });

  int productTypeId;
  String product, productDescription, active;

  factory ProductType.fromJson(Map<String, dynamic> json) => ProductType(
    productTypeId: json['productTypeId'],
    product: json['product'],
    productDescription: json['productDescription'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'productTypeId': productTypeId,
    'product': product,
    'productDescription': productDescription,
    'active': active,
  };
}