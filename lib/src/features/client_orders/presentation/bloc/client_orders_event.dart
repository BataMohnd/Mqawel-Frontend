import 'package:equatable/equatable.dart';

abstract class ClientOrdersEvent extends Equatable {
  const ClientOrdersEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeDataEvent extends ClientOrdersEvent {}

class SearchWorkersEvent extends ClientOrdersEvent {
  final String category;
  const SearchWorkersEvent(this.category);
  @override
  List<Object> get props => [category];
}

class CreateOrderEvent extends ClientOrdersEvent {
  final String category;
  final String serviceType;
  final String description;
  final String urgency;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> photos;
  const CreateOrderEvent({
    required this.category,
    required this.serviceType,
    required this.description,
    required this.urgency,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.photos = const [],
  });
  @override
  List<Object> get props => [category, serviceType, description, urgency, address, latitude, longitude, photos];
}

class LoadContractorsEvent extends ClientOrdersEvent {
  final String orderId;
  const LoadContractorsEvent(this.orderId);
  @override
  List<Object> get props => [orderId];
}

class SelectContractorEvent extends ClientOrdersEvent {
  final String orderId;
  final String contractorId;
  const SelectContractorEvent(this.orderId, this.contractorId);
  @override
  List<Object> get props => [orderId, contractorId];
}

class LoadMyOrdersEvent extends ClientOrdersEvent {}

class RateWorkerEvent extends ClientOrdersEvent {
  final String orderId;
  final double rating;
  final String review;
  const RateWorkerEvent({required this.orderId, required this.rating, required this.review});
  @override
  List<Object> get props => [orderId, rating, review];
}
