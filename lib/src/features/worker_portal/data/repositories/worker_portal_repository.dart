import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:meqawuel_front/src/core/config/api_config.dart';
import 'package:meqawuel_front/src/core/network/dio_client.dart';
import 'package:meqawuel_front/src/features/client_orders/data/models/order_model.dart'; // Reusing OrderModel

class WorkerPortalRepository {
  final DioClient _dioClient;
  io.Socket? _socket;
  
  final _incomingOrderController = StreamController<OrderModel>.broadcast();
  Stream<OrderModel> get incomingOrderStream => _incomingOrderController.stream;

  WorkerPortalRepository(this._dioClient);

  Future<void> initSocket() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    _socket = io.io(ApiConfig.socketBaseUrl, io.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .setExtraHeaders({'Authorization': 'Bearer $token'})
      .build()
    );

    _socket?.connect();

    _socket?.onConnect((_) {
      debugPrint('Worker Socket.io connected');
      final userId = prefs.getString('user_id');
      if (userId != null && userId.isNotEmpty) _socket?.emit('join', userId);
    });

    _socket?.on('new_order', (data) {
      if (data != null) {
        _incomingOrderController.add(OrderModel.fromJson(data));
      }
    });

    _socket?.on('new_job_request', (data) {
      if (data != null) {
        _incomingOrderController.add(OrderModel.fromJson(data));
      }
    });
  }

  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    _incomingOrderController.close();
  }

  Future<void> toggleAvailability(bool isAvailable) async {
    try {
      await _dioClient.dio.patch('/orders/availability', data: {
        'isAvailable': isAvailable,
      });
    } catch (e) {
      throw Exception('فشل تحديث حالة التواجد');
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _dioClient.dio.patch('/orders/$orderId/status', data: {
        'status': status
      });
    } catch (e) {
      throw Exception('فشل تحديث حالة الطلب');
    }
  }

  Future<void> acceptOrder(String orderId) async {
    try {
      await _dioClient.dio.patch('/orders/$orderId/accept');
    } catch (e) {
      throw Exception('فشل قبول الطلب');
    }
  }

  Future<List<OrderModel>> getMyJobs() async {
    try {
      final response = await _dioClient.dio.get('/orders');
      final List data = response.data['orders'] ?? [];
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('فشل جلب جدول الأعمال');
    }
  }

  Future<Map<String, dynamic>> getPerformanceSummary() async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'jobsCount': 12,
      'rating': 4.8,
      'acceptanceRate': '95%'
    };
  }
}
