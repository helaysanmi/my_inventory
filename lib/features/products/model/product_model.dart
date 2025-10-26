class ProductModel {
  final int? productId;
  final int userId;
  final int productQuantity;
  final String productImage;
  final String productName;
  final double productAmount;
  final String addedBy;

  ProductModel({
    this.productId,
    required this.userId,
    required this.productQuantity,
    required this.productImage,
    required this.productName,
    required this.productAmount,
    required this.addedBy,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['productId'] as int?,
      userId: map['userId'] as int? ?? 0,
      productQuantity: map['productQuantity'] as int? ?? 0,
      productImage: map['productImage'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      productAmount:
          (map['productAmount'] is int)
              ? (map['productAmount'] as int).toDouble()
              : (map['productAmount'] as double? ?? 0.0),
      addedBy: map['addedBy'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'userId': userId,
      'productQuantity': productQuantity,
      'productImage': productImage,
      'productName': productName,
      'productAmount': productAmount,
      'addedBy': addedBy,
    };

    // only include productId if it's not null (for updates)
    if (productId != null) {
      map['productId'] = productId;
    }

    return map;
  }
}
