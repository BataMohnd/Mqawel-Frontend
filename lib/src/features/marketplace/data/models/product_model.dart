class ProductModel {
  final String id;
  final String storeId;
  final String storeName;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? json['id'] ?? '',
      storeId: json['store']?['_id'] ?? json['storeId'] ?? '',
      storeName: json['store']?['name'] ?? 'متجر',
      name: json['name'] ?? 'منتج',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      stock: json['stock'] ?? 0,
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'storeName': storeName,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'imageUrl': imageUrl,
    };
  }
}
