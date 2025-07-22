class Product {
  String? status;
  String? createdAt;
  String? updatedAt;
  String? productId;
  String? productName;
  String? description;
  String? productCode;
  String? productImage;
  int? stock;
  String? categoryId;
  String? organizationId;
  String? supplierId;
  String? wareHouseId;
  String? referenceProductId;

  Product({
    this.status,
    this.createdAt,
    this.updatedAt,
    this.productId,
    this.productName,
    this.description,
    this.productCode,
    this.productImage,
    this.stock,
    this.categoryId,
    this.organizationId,
    this.supplierId,
    this.wareHouseId,
    this.referenceProductId,
  });

  Product.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    productId = json['productId'];
    productName = json['productName'];
    description = json['description'];
    productCode = json['productCode'];
    productImage = json['productImage'];

    // ✅ safe parse for int
    final stockValue = json['stock'];
    stock = stockValue is int
        ? stockValue
        : int.tryParse(stockValue.toString());

    categoryId = json['categoryId'];
    organizationId = json['organizationId'];
    supplierId = json['supplierId'];
    wareHouseId = json['wareHouseId'];
    referenceProductId = json['referenceProductId'];
  }

  get lowStock => null;

 
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['productId'] = productId;
    data['productName'] = productName;
    data['description'] = description;
    data['productCode'] = productCode;
    data['productImage'] = productImage;
    data['stock'] = stock;
    data['categoryId'] = categoryId;
    data['organizationId'] = organizationId;
    data['supplierId'] = supplierId;
    data['wareHouseId'] = wareHouseId;
    data['referenceProductId'] = referenceProductId;
    return data;
  }
}
