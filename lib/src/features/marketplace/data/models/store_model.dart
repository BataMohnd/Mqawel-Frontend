class StoreModel {
  final String id;
  final String name;
  final String address;
  final String category;
  final double rating;
  final String imageUrl;

  StoreModel({
    required this.id,
    required this.name,
    required this.address,
    required this.category,
    required this.rating,
    required this.imageUrl,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? 'محل بدون اسم',
      address: json['address'] ?? '',
      category: json['category'] ?? 'عام',
      rating: (json['rating'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
    );
  }
}
