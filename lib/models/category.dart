class Category {
  String? status;
  String? createdAt;
  String? updatedAt;
  String? id;
  String? categoryName;
  String? description;
  String? parentCategoryId; // ✅ Fix: changed from Null? to String?
  String? organizationId;

  Category({
    this.status,
    this.createdAt,
    this.updatedAt,
    this.id,
    this.categoryName,
    this.description,
    this.parentCategoryId,
    this.organizationId,
  });

  Category.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    categoryName = json['categoryName'];
    description = json['description'];
    parentCategoryId = json['parentCategoryId']; // ✅ Accepts null or String
    organizationId = json['organizationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['id'] = id;
    data['categoryName'] = categoryName;
    data['description'] = description;
    data['parentCategoryId'] = parentCategoryId;
    data['organizationId'] = organizationId;
    return data;
  }
}
