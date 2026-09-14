import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meqawuel_front/src/features/client_orders/data/repositories/client_orders_repository.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_event.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_state.dart';

class ClientOrdersBloc extends Bloc<ClientOrdersEvent, ClientOrdersState> {
  final ClientOrdersRepository repository;

  ClientOrdersBloc({required this.repository}) : super(ClientOrdersInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<SearchWorkersEvent>(_onSearchWorkers);
    on<CreateOrderEvent>(_onCreateOrder);
    on<LoadContractorsEvent>(_onLoadContractors);
    on<SelectContractorEvent>(_onSelectContractor);
    on<LoadMyOrdersEvent>(_onLoadMyOrders);
    on<RateWorkerEvent>(_onRateWorker);
  }

  Future<void> _onLoadHomeData(LoadHomeDataEvent event, Emitter<ClientOrdersState> emit) async {
    emit(ClientOrdersLoading());
    try {
      final workers = await repository.getTopWorkers();
      emit(WorkersLoaded(workers));
    } catch (e) {
      emit(ClientOrdersError(e.toString()));
    }
  }

  Future<void> _onSearchWorkers(SearchWorkersEvent event, Emitter<ClientOrdersState> emit) async {
    emit(ClientOrdersLoading());
    try {
      final workers = await repository.searchWorkers(event.category);
      emit(SearchWorkersLoaded(workers));
    } catch (e) {
      emit(ClientOrdersError(e.toString()));
    }
  }

  Future<void> _onCreateOrder(CreateOrderEvent event, Emitter<ClientOrdersState> emit) async {
    emit(ClientOrdersLoading());
    try {
      final order = await repository.createOrder(
        category: event.category,
        serviceType: event.serviceType,
        description: event.description,
        urgency: event.urgency,
        address: event.address,
        latitude: event.latitude,
        longitude: event.longitude,
        photos: event.photos,
      );
      emit(OrderCreatedSuccess(order));
    } catch (e) {
      emit(ClientOrdersError(e.toString()));
    }
  }

  Future<void> _onLoadContractors(LoadContractorsEvent event, Emitter<ClientOrdersState> emit) async {
    emit(ClientOrdersLoading());
    try {
      emit(ContractorsLoaded(await repository.getContractors(event.orderId)));
    } catch (e) {
      emit(ClientOrdersError(e.toString()));
    }
  }

  Future<void> _onSelectContractor(SelectContractorEvent event, Emitter<ClientOrdersState> emit) async {
    emit(ClientOrdersLoading());
    try {
      emit(ContractorSelectedSuccess(await repository.selectContractor(event.orderId, event.contractorId)));
    } catch (e) {
      emit(ClientOrdersError(e.toString()));
    }
  }

  Future<void> _onLoadMyOrders(LoadMyOrdersEvent event, Emitter<ClientOrdersState> emit) async {
    emit(ClientOrdersLoading());
    try {
      final orders = await repository.getMyOrders();
      emit(MyOrdersLoaded(orders));
    } catch (e) {
      emit(ClientOrdersError(e.toString()));
    }
  }

  Future<void> _onRateWorker(RateWorkerEvent event, Emitter<ClientOrdersState> emit) async {
    emit(ClientOrdersLoading());
    try {
      await repository.rateWorker(event.orderId, event.rating, event.review);
      // Reload orders to reflect rating
      add(LoadMyOrdersEvent());
    } catch (e) {
      emit(ClientOrdersError(e.toString()));
    }
  }
}
