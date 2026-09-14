import 'package:equatable/equatable.dart';
import 'package:meqawuel_front/src/features/marketplace/data/models/store_model.dart';
import 'package:meqawuel_front/src/features/marketplace/data/models/product_model.dart';

abstract class MarketplaceState extends Equatable {
  const MarketplaceState();
  @override
  List<Object> get props => [];
}

class MarketplaceInitial extends MarketplaceState {}
class MarketplaceLoading extends MarketplaceState {}

class MarketplaceHomeLoaded extends MarketplaceState {
  final List<StoreModel> stores;
  final List<ProductModel> latestProducts;

  const MarketplaceHomeLoaded({required this.stores, required this.latestProducts});
  @override
  List<Object> get props => [stores, latestProducts];
}

class StoreDetailsLoaded extends MarketplaceState {
  final List<ProductModel> products;
  const StoreDetailsLoaded(this.products);
  @override
  List<Object> get props => [products];
}

class MarketplaceError extends MarketplaceState {
  final String message;
  const MarketplaceError(this.message);
  @override
  List<Object> get props => [message];
}
