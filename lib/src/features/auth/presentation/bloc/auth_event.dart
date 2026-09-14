import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String phone;
  final String role;

  const SendOtpEvent({required this.phone, required this.role});

  @override
  List<Object> get props => [phone, role];
}

class DevLoginEvent extends AuthEvent {
  final String role;

  const DevLoginEvent({required this.role});

  @override
  List<Object> get props => [role];
}

class VerifyOtpEvent extends AuthEvent {
  final String phone;
  final String otp;
  final String role;

  const VerifyOtpEvent({required this.phone, required this.otp, required this.role});

  @override
  List<Object> get props => [phone, otp, role];
}

class SubmitWorkerDocsEvent extends AuthEvent {
  final String experienceYears;
  final String idFrontPath;
  final String idBackPath;
  final String criminalRecordPath;
  final String selfiePath;

  const SubmitWorkerDocsEvent({
    required this.experienceYears,
    required this.idFrontPath,
    required this.idBackPath,
    required this.criminalRecordPath,
    required this.selfiePath,
  });
}
