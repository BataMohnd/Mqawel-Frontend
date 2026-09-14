import 'package:flutter/material.dart';

class ServiceCategory {
  final String id;
  final String name;
  final IconData icon;
  final bool isActive;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.isActive = true,
  });
}

const serviceCategories = <ServiceCategory>[
  ServiceCategory(id: 'electrician', name: 'كهربائي', icon: Icons.electrical_services),
  ServiceCategory(id: 'plumber', name: 'سباك', icon: Icons.plumbing),
  ServiceCategory(id: 'carpenter', name: 'نجار', icon: Icons.handyman),
  ServiceCategory(id: 'painter', name: 'نقاش', icon: Icons.format_paint),
  ServiceCategory(id: 'plasterer', name: 'محارة', icon: Icons.foundation),
  ServiceCategory(id: 'builder', name: 'بناء', icon: Icons.construction),
  ServiceCategory(id: 'ac', name: 'تكييف', icon: Icons.ac_unit),
  ServiceCategory(id: 'appliance_repair', name: 'صيانة أجهزة', icon: Icons.home_repair_service),
  ServiceCategory(id: 'tiler', name: 'سيراميك', icon: Icons.grid_4x4),
  ServiceCategory(id: 'gypsum', name: 'جبس', icon: Icons.architecture),
  ServiceCategory(id: 'aluminum', name: 'ألوميتال', icon: Icons.window),
  ServiceCategory(id: 'blacksmith', name: 'حداد', icon: Icons.hardware),
  ServiceCategory(id: 'cleaning', name: 'تنظيف', icon: Icons.cleaning_services),
  ServiceCategory(id: 'other', name: 'أخرى', icon: Icons.more_horiz),
];
