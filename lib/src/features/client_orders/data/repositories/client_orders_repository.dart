import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:meqawuel_front/src/core/config/api_config.dart';
import 'package:meqawuel_front/src/core/network/dio_client.dart';
import 'package:meqawuel_front/src/features/client_orders/data/models/order_model.dart';
import 'package:meqawuel_front/src/features/client_orders/data/models/worker_model.dart';

class ClientOrdersRepository {
  final DioClient _dioClient;
  io.Socket? _socket;
  
  // Stream controller to broadcast order status updates globally to the app
  final _orderStatusController = StreamController<OrderModel>.broadcast();
  Stream<OrderModel> get orderStatusStream => _orderStatusController.stream;

  ClientOrdersRepository(this._dioClient);

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
      debugPrint('Socket.io connected');
      final userId = prefs.getString('user_id');
      if (userId != null && userId.isNotEmpty) _socket?.emit('join', userId);
    });

    _socket?.on('order_status_update', (data) {
      if (data != null) {
        _orderStatusController.add(OrderModel.fromJson(data));
      }
    });
  }

  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    _orderStatusController.close();
  }

  // --- API Calls ---

  Future<List<String>> uploadImages(List<String> imagePaths) async {
    if (imagePaths.isEmpty) {
      return [];
    }

    try {
      final formData = FormData();
      for (final path in imagePaths) {
        formData.files.add(MapEntry('images', await MultipartFile.fromFile(path)));
      }

      final response = await _dioClient.dio.post('/orders/upload', data: formData);
      final List data = response.data['photos'] ?? [];
      return data.whereType<String>().toList();
    } catch (e) {
      throw Exception('فشل رفع الصور');
    }
  }

  Future<List<WorkerModel>> getTopWorkers() async {
    // Mocking an API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      WorkerModel(id: '1', name: 'أحمد محمود', speciality: 'سباكة', experienceYears: 10, rating: 4.8, isVerified: true, inspectionPrice: 100),
      WorkerModel(id: '2', name: 'سيد علي', speciality: 'كهرباء', experienceYears: 5, rating: 4.5, isVerified: true, inspectionPrice: 80),
    ];
  }

  Future<List<WorkerModel>> searchWorkers(String category) async {
    throw Exception('لا يمكن البحث عن صنايعية بدون طلب خدمة');
  }

  Future<OrderModel> createOrder({
    required String category,
    required String serviceType,
    required String description,
    required String urgency,
    required String address,
    required double latitude,
    required double longitude,
    List<String> photos = const [],
  }) async {
    try {
      // Temporary stub for MVP coordinates
      final response = await _dioClient.dio.post('/orders', data: {
        'category': category,
        'serviceType': serviceType,
        'description': description,
        'photos': photos,
        'address': address,
        'urgency': urgency,
        'coordinates': [longitude, latitude]
      });
      return OrderModel.fromJson(response.data['order']);
    } catch (e) {
      throw Exception('فشل إنشاء الطلب');
    }
  }

  Future<List<WorkerModel>> getContractors(String orderId) async {
    try {
      final response = await _dioClient.dio.get('/orders/$orderId/contractors');
      final List data = response.data['contractors'] ?? [];
      return data.map((json) => WorkerModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('فشل تحميل الصنايعية المتاحين');
    }
  }

  Future<OrderModel> selectContractor(String orderId, String contractorId) async {
    try {
      final response = await _dioClient.dio.post('/orders/$orderId/select-contractor', data: {'contractorId': contractorId});
      return OrderModel.fromJson(response.data['order']);
    } catch (e) {
      throw Exception('فشل اختيار الصنايعي');
    }
  }

  Future<List<OrderModel>> getMyOrders() async {
    try {
      final response = await _dioClient.dio.get('/orders');
      final List data = response.data['orders'] ?? [];
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('فشل جلب الطلبات');
    }
  }

  Future<void> rateWorker(String orderId, double rating, String review) async {
    try {
      await _dioClient.dio.patch('/orders/$orderId/rating', data: {
        'score': rating,
        'review': review,
      });
    } catch (e) {
      throw Exception('فشل إرسال التقييم');
    }
  }
}
