import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meqawuel_front/src/features/worker_portal/data/repositories/worker_portal_repository.dart';
import 'package:meqawuel_front/src/features/worker_portal/presentation/bloc/worker_portal_event.dart';
import 'package:meqawuel_front/src/features/worker_portal/presentation/bloc/worker_portal_state.dart';

class WorkerPortalBloc extends Bloc<WorkerPortalEvent, WorkerPortalState> {
  final WorkerPortalRepository repository;
  late StreamSubscription _incomingOrdersSub;
  
  bool _isAvailable = false;
  Map<String, dynamic> _summary = {};

  WorkerPortalBloc({required this.repository}) : super(WorkerPortalInitial()) {
    on<LoadWorkerHomeEvent>(_onLoadWorkerHome);
    on<ToggleAvailabilityEvent>(_onToggleAvailability);
    on<NewIncomingOrderReceivedEvent>(_onNewIncomingOrderReceived);
    on<IgnoreIncomingOrderEvent>(_onIgnoreIncomingOrder);
    on<AcceptOrderEvent>(_onAcceptOrder);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
    on<LoadJobsScheduleEvent>(_onLoadJobsSchedule);

    _incomingOrdersSub = repository.incomingOrderStream.listen((order) {
      if (_isAvailable) {
        add(NewIncomingOrderReceivedEvent(order));
      }
    });
  }

  @override
  Future<void> close() {
    _incomingOrdersSub.cancel();
    repository.dispose();
    return super.close();
  }

  Future<void> _onLoadWorkerHome(LoadWorkerHomeEvent event, Emitter<WorkerPortalState> emit) async {
    emit(WorkerPortalLoading());
    try {
      _summary = await repository.getPerformanceSummary();
      emit(WorkerHomeLoaded(_isAvailable, _summary));
    } catch (e) {
      emit(WorkerPortalError(e.toString()));
    }
  }

  Future<void> _onToggleAvailability(ToggleAvailabilityEvent event, Emitter<WorkerPortalState> emit) async {
    emit(WorkerPortalLoading());
    try {
      await repository.toggleAvailability(event.isAvailable);
      _isAvailable = event.isAvailable;
      emit(WorkerHomeLoaded(_isAvailable, _summary));
    } catch (e) {
      emit(WorkerPortalError(e.toString()));
    }
  }

  void _onNewIncomingOrderReceived(NewIncomingOrderReceivedEvent event, Emitter<WorkerPortalState> emit) {
    emit(IncomingOrderState(event.order));
  }

  void _onIgnoreIncomingOrder(IgnoreIncomingOrderEvent event, Emitter<WorkerPortalState> emit) {
    emit(WorkerHomeLoaded(_isAvailable, _summary));
  }

  Future<void> _onAcceptOrder(AcceptOrderEvent event, Emitter<WorkerPortalState> emit) async {
    emit(WorkerPortalLoading());
    try {
      await repository.acceptOrder(event.orderId);
      emit(OrderStatusUpdatedSuccess());
      add(LoadJobsScheduleEvent());
    } catch (e) {
      emit(WorkerPortalError(e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(UpdateOrderStatusEvent event, Emitter<WorkerPortalState> emit) async {
    emit(WorkerPortalLoading());
    try {
      await repository.updateOrderStatus(event.orderId, event.status);
      emit(OrderStatusUpdatedSuccess());
      add(LoadJobsScheduleEvent()); // Refresh schedule
    } catch (e) {
      emit(WorkerPortalError(e.toString()));
    }
  }

  Future<void> _onLoadJobsSchedule(LoadJobsScheduleEvent event, Emitter<WorkerPortalState> emit) async {
    emit(WorkerPortalLoading());
    try {
      final jobs = await repository.getMyJobs();
      emit(JobsLoaded(jobs));
    } catch (e) {
      emit(WorkerPortalError(e.toString()));
    }
  }
}
