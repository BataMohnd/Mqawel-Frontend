import 'package:equatable/equatable.dart';

abstract class MarketplaceEvent extends Equatable {
  const MarketplaceEvent();
  @override
  List<Object> get props => [];
}

class LoadMarketplaceHomeEvent extends MarketplaceEvent {}

class LoadStoreDetailsEvent extends MarketplaceEvent {
  final String storeId;
  const LoadStoreDetailsEvent(this.storeId);
  @override
  List<Object> get props => [storeId];
}
