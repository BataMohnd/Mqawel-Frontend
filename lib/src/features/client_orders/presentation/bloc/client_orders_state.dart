import 'package:equatable/equatable.dart';
import 'package:meqawuel_front/src/features/client_orders/data/models/worker_model.dart';
import 'package:meqawuel_front/src/features/client_orders/data/models/order_model.dart';

abstract class ClientOrdersState extends Equatable {
  const ClientOrdersState();

  @override
  List<Object?> get props => [];
}

class ClientOrdersInitial extends ClientOrdersState {}
class ClientOrdersLoading extends ClientOrdersState {}
class ClientOrdersError extends ClientOrdersState {
  final String message;
  const ClientOrdersError(this.message);
  @override
  List<Object> get props => [message];
}

class WorkersLoaded extends ClientOrdersState {
  final List<WorkerModel> topWorkers;
  const WorkersLoaded(this.topWorkers);
  @override
  List<Object> get props => [topWorkers];
}

class SearchWorkersLoaded extends ClientOrdersState {
  final List<WorkerModel> workers;
  const SearchWorkersLoaded(this.workers);
  @override
  List<Object> get props => [workers];
}

class OrderCreatedSuccess extends ClientOrdersState {
  final OrderModel order;
  const OrderCreatedSuccess(this.order);
  @override
  List<Object> get props => [order];
}

class ContractorsLoaded extends ClientOrdersState {
  final List<WorkerModel> contractors;
  const ContractorsLoaded(this.contractors);
  @override
  List<Object> get props => [contractors];
}

class ContractorSelectedSuccess extends ClientOrdersState {
  final OrderModel order;
  const ContractorSelectedSuccess(this.order);
  @override
  List<Object> get props => [order];
}

class MyOrdersLoaded extends ClientOrdersState {
  final List<OrderModel> orders;
  const MyOrdersLoaded(this.orders);
  @override
  List<Object> get props => [orders];
}
