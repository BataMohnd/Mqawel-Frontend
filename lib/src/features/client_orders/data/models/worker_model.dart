class WorkerModel {
  final String id;
  final String name;
  final String speciality;
  final int experienceYears;
  final double rating;
  final bool isVerified;
  final double inspectionPrice;
  final double startingPrice;
  final int completedJobs;
  final int warrantyDays;
  final double distanceKm;
  final bool isAvailable;

  WorkerModel({
    required this.id,
    required this.name,
    required this.speciality,
    required this.experienceYears,
    required this.rating,
    required this.isVerified,
    required this.inspectionPrice,
    this.startingPrice = 0,
    this.completedJobs = 0,
    this.warrantyDays = 0,
    this.distanceKm = 0,
    this.isAvailable = true,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? 'فني بدون اسم',
      speciality: json['speciality'] ?? json['serviceType'] ?? 'عام',
      experienceYears: (json['experienceYears'] ?? 0) as int,
      rating: (json['rating'] ?? 0.0).toDouble(),
      isVerified: json['isVerified'] ?? false,
      inspectionPrice: (json['inspectionPrice'] ?? 50.0).toDouble(),
      startingPrice: (json['startingPrice'] ?? 0).toDouble(),
      completedJobs: (json['completedJobs'] ?? 0) as int,
      warrantyDays: (json['warrantyDays'] ?? 0) as int,
      distanceKm: (json['distanceKm'] ?? 0).toDouble(),
      isAvailable: json['isAvailable'] ?? false,
    );
  }
}
