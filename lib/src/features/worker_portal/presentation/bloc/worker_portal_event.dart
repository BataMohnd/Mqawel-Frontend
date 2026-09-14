import 'package:equatable/equatable.dart';
import 'package:meqawuel_front/src/features/client_orders/data/models/order_model.dart';

abstract class WorkerPortalEvent extends Equatable {
  const WorkerPortalEvent();

  @override
  List<Object?> get props => [];
}

class LoadWorkerHomeEvent extends WorkerPortalEvent {}

class ToggleAvailabilityEvent extends WorkerPortalEvent {
  final bool isAvailable;
  const ToggleAvailabilityEvent(this.isAvailable);
  @override
  List<Object> get props => [isAvailable];
}

class NewIncomingOrderReceivedEvent extends WorkerPortalEvent {
  final OrderModel order;
  const NewIncomingOrderReceivedEvent(this.order);
  @override
  List<Object> get props => [order];
}

class IgnoreIncomingOrderEvent extends WorkerPortalEvent {}

class AcceptOrderEvent extends WorkerPortalEvent {
  final String orderId;
  const AcceptOrderEvent(this.orderId);
  @override
  List<Object> get props => [orderId];
}

class UpdateOrderStatusEvent extends WorkerPortalEvent {
  final String orderId;
  final String status; // accepted, in_progress, completed
  const UpdateOrderStatusEvent(this.orderId, this.status);
  @override
  List<Object> get props => [orderId, status];
}

class LoadJobsScheduleEvent extends WorkerPortalEvent {}
