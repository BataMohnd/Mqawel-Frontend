import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meqawuel_front/src/core/network/dio_client.dart';
import 'package:meqawuel_front/src/features/auth/data/models/user_model.dart';

class AuthRepository {
  final DioClient _dioClient;

  AuthRepository(this._dioClient);

  Future<bool> sendOtp(String phone, String role) async {
    try {
      await _dioClient.dio.post('/auth/register', data: {
        'phone': phone,
        'name': 'مستخدم جديد',
        'role': role,
      });
      return true;
    } on DioException catch (e) {
      throw Exception(_errorMessage(e));
    }
  }

  Future<UserModel> verifyOtp(String phone, String otp, String role) async {
    try {
      final response = await _dioClient.dio.post('/auth/verify-otp', data: {
        'phone': phone,
        'otpCode': otp,
      });

      final token = response.data['token'];
      final userData = response.data['user'];

      // Save token locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      await prefs.setString('user_role', userData['role']);
      await prefs.setString('user_id', userData['id'] ?? userData['_id'] ?? '');

      return UserModel.fromJson(userData);
    } on DioException catch (e) {
      throw Exception(_errorMessage(e));
    }
  }

  /// Development-only helper retained for explicit test environments.
  Future<UserModel> createDevSession(String role) async {
    return _saveDevUser(role == 'worker' ? '01000000002' : '01000000001', role);
  }

  Future<UserModel> _saveDevUser(String phone, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', 'dev-token-$role');
    await prefs.setString('user_role', role);
    await prefs.setString('user_id', 'dev-$role');
    return UserModel(id: 'dev-$role', phone: phone, name: 'مستخدم تجريبي', role: role);
  }

  bool _isConnectionError(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout;
  }

  String _errorMessage(DioException error) {
    if (_isConnectionError(error)) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'انتهت مهلة الاتصال بالخادم. حاول مرة أخرى.';
      }
      return 'تعذر الاتصال بالخادم. تأكد من اتصال الهاتف بالشبكة.';
    }

    final data = error.response?.data;
    if (data is Map && data['message'] is String) return data['message'] as String;
    return 'تعذر إتمام الطلب. حاول مرة أخرى.';
  }

  Future<void> submitWorkerDocuments({
    required String experienceYears,
    required String idFrontPath,
    required String idBackPath,
    required String criminalRecordPath,
    required String selfiePath,
  }) async {
    // Mocking document upload
    await Future.delayed(const Duration(seconds: 2));
    // In real app, use FormData to upload multipart files
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('jwt_token');
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }
}
