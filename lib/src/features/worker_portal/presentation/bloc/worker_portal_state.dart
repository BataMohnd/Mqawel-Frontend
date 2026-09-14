import 'package:equatable/equatable.dart';
import 'package:meqawuel_front/src/features/client_orders/data/models/order_model.dart';

abstract class WorkerPortalState extends Equatable {
  const WorkerPortalState();

  @override
  List<Object?> get props => [];
}

class WorkerPortalInitial extends WorkerPortalState {}
class WorkerPortalLoading extends WorkerPortalState {}

class WorkerHomeLoaded extends WorkerPortalState {
  final bool isAvailable;
  final Map<String, dynamic> summary;
  const WorkerHomeLoaded(this.isAvailable, this.summary);
  @override
  List<Object> get props => [isAvailable, summary];
}

class IncomingOrderState extends WorkerPortalState {
  final OrderModel order;
  const IncomingOrderState(this.order);
  @override
  List<Object> get props => [order];
}

class JobsLoaded extends WorkerPortalState {
  final List<OrderModel> jobs;
  const JobsLoaded(this.jobs);
  @override
  List<Object> get props => [jobs];
}

class OrderStatusUpdatedSuccess extends WorkerPortalState {}

class WorkerPortalError extends WorkerPortalState {
  final String message;
  const WorkerPortalError(this.message);
  @override
  List<Object> get props => [message];
}
