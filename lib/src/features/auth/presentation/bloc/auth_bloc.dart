import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meqawuel_front/src/features/auth/data/repositories/auth_repository.dart';
import 'package:meqawuel_front/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:meqawuel_front/src/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<DevLoginEvent>(_onDevLogin);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<SubmitWorkerDocsEvent>(_onSubmitWorkerDocs);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final sent = await authRepository.sendOtp(event.phone, event.role);
      if (!sent) {
        emit(AuthError('تعذر الاتصال بالخادم. تأكد من اتصال الهاتف بالشبكة.'));
        return;
      }
      emit(OtpSentSuccess(
        phone: event.phone,
        role: event.role,
      ));
    } catch (error) {
      emit(AuthError(_message(error)));
    }
  }

  Future<void> _onDevLogin(DevLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      emit(AuthSuccess(await authRepository.createDevSession(event.role)));
    } catch (error) {
      emit(AuthError(_message(error)));
    }
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.verifyOtp(event.phone, event.otp, event.role);
      emit(AuthSuccess(user));
    } catch (error) {
      emit(AuthError(_message(error)));
    }
  }

  Future<void> _onSubmitWorkerDocs(SubmitWorkerDocsEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.submitWorkerDocuments(
        experienceYears: event.experienceYears,
        idFrontPath: event.idFrontPath,
        idBackPath: event.idBackPath,
        criminalRecordPath: event.criminalRecordPath,
        selfiePath: event.selfiePath,
      );
      emit(WorkerDocsSubmittedSuccess());
    } catch (error) {
      emit(AuthError(_message(error)));
    }
  }

  String _message(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '').trim();
    return message.isEmpty ? 'تعذر الاتصال بالخادم. حاول مرة أخرى.' : message;
  }
}
