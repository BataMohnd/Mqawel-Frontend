class OrderModel {
  final String id;
  final String serviceType;
  final String description;
  final String status;
  final String category;
  final String? address;
  final String urgency;
  final List<String> photos;
  final List<String> problemPhotos;
  final List<String> completionPhotos;
  final String? workerName;
  final String? workerPhone;
  final String? clientPhone;
  final DateTime createdAt;
  final double? price;
  final double? latitude;
  final double? longitude;
  final String paymentStatus;

  OrderModel({
    required this.id,
    required this.serviceType,
    required this.description,
    required this.status,
    this.category = 'other',
    this.address,
    this.urgency = 'normal',
    this.photos = const [],
    this.problemPhotos = const [],
    this.completionPhotos = const [],
    this.workerName,
    this.workerPhone,
    this.clientPhone,
    required this.createdAt,
    this.price,
    this.latitude,
    this.longitude,
    this.paymentStatus = 'unpaid',
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final locationCoordinates = (json['location']?['coordinates'] as List?) ?? const [];

    return OrderModel(
      id: json['_id'] ?? json['id'] ?? '',
      serviceType: json['serviceType'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'pending',
      category: json['category'] ?? json['serviceType'] ?? 'other',
      address: json['address'],
      urgency: json['urgency'] ?? 'normal',
      photos: (json['photos'] as List?)?.whereType<String>().toList() ?? const [],
      problemPhotos: (json['problemPhotos'] as List?)?.whereType<String>().toList() ?? const [],
      completionPhotos: (json['completionPhotos'] as List?)?.whereType<String>().toList() ?? const [],
      workerName: json['worker']?['name'],
      workerPhone: json['worker']?['phone'],
      clientPhone: json['client']?['phone'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      latitude: locationCoordinates.length >= 2 ? (locationCoordinates[1] as num).toDouble() : null,
      longitude: locationCoordinates.length >= 2 ? (locationCoordinates[0] as num).toDouble() : null,
      paymentStatus: json['paymentStatus'] ?? 'unpaid',
    );
  }
}
