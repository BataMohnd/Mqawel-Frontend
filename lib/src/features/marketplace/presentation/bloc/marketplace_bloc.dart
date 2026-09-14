import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meqawuel_front/src/features/marketplace/data/repositories/marketplace_repository.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/bloc/marketplace_event.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/bloc/marketplace_state.dart';

class MarketplaceBloc extends Bloc<MarketplaceEvent, MarketplaceState> {
  final MarketplaceRepository repository;

  MarketplaceBloc({required this.repository}) : super(MarketplaceInitial()) {
    on<LoadMarketplaceHomeEvent>(_onLoadMarketplaceHome);
    on<LoadStoreDetailsEvent>(_onLoadStoreDetails);
  }

  Future<void> _onLoadMarketplaceHome(LoadMarketplaceHomeEvent event, Emitter<MarketplaceState> emit) async {
    emit(MarketplaceLoading());
    try {
      final stores = await repository.getStores();
      final products = await repository.getLatestProducts();
      emit(MarketplaceHomeLoaded(stores: stores, latestProducts: products));
    } catch (e) {
      emit(MarketplaceError(e.toString()));
    }
  }

  Future<void> _onLoadStoreDetails(LoadStoreDetailsEvent event, Emitter<MarketplaceState> emit) async {
    emit(MarketplaceLoading());
    try {
      final products = await repository.getStoreProducts(event.storeId);
      emit(StoreDetailsLoaded(products));
    } catch (e) {
      emit(MarketplaceError(e.toString()));
    }
  }
}
