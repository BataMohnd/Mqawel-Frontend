import 'package:equatable/equatable.dart';
import 'package:meqawuel_front/src/features/auth/data/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSentSuccess extends AuthState {
  final String phone;
  final String role;
  final bool isMock;
  final String? message;

  const OtpSentSuccess({
    required this.phone,
    required this.role,
    this.isMock = false,
    this.message,
  });

  @override
  List<Object?> get props => [phone, role, isMock, message];
}

class AuthSuccess extends AuthState {
  final UserModel user;
  const AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class WorkerDocsSubmittedSuccess extends AuthState {}
