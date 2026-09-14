import 'package:meqawuel_front/src/core/network/dio_client.dart';
import 'package:meqawuel_front/src/features/marketplace/data/models/store_model.dart';
import 'package:meqawuel_front/src/features/marketplace/data/models/product_model.dart';

class MarketplaceRepository {
  final DioClient _dioClient;

  MarketplaceRepository(this._dioClient);

  Future<List<StoreModel>> getStores() async {
    try {
      final response = await _dioClient.dio.get('/marketplace/stores');
      final List data = response.data['stores'] ?? [];
      return data.map((json) => StoreModel.fromJson(json)).toList();
    } catch (e) {
      // Return mock data for MVP if backend not fully populated
      await Future.delayed(const Duration(seconds: 1));
      return [
        StoreModel(id: '1', name: 'النجاح للسباكة', address: 'مدينتي - السوق التجاري', category: 'سباكة', rating: 4.5, imageUrl: 'https://via.placeholder.com/150'),
        StoreModel(id: '2', name: 'النور للكهرباء', address: 'الرحاب', category: 'كهرباء', rating: 4.8, imageUrl: 'https://via.placeholder.com/150'),
      ];
    }
  }

  Future<List<ProductModel>> getStoreProducts(String storeId) async {
    try {
      final response = await _dioClient.dio.get('/marketplace/stores/$storeId/products');
      final List data = response.data['products'] ?? [];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      // Mock data
      await Future.delayed(const Duration(seconds: 1));
      return [
        ProductModel(id: 'p1', storeId: storeId, storeName: 'محل النور', name: 'مفتاح كهرباء', description: 'مفتاح بتشينو اصلي', price: 50.0, stock: 100, imageUrl: 'https://via.placeholder.com/150'),
        ProductModel(id: 'p2', storeId: storeId, storeName: 'محل النور', name: 'سلك نحاس 2ملم', description: 'لفة سلك سويدي', price: 800.0, stock: 10, imageUrl: 'https://via.placeholder.com/150'),
      ];
    }
  }

  Future<List<ProductModel>> getLatestProducts() async {
    // Mock latest products
    await Future.delayed(const Duration(seconds: 1));
    return [
      ProductModel(id: 'p3', storeId: '1', storeName: 'النجاح للسباكة', name: 'خلاط مياه', description: 'خلاط جروهي ألماني', price: 1500.0, stock: 5, imageUrl: 'https://via.placeholder.com/150'),
      ProductModel(id: 'p4', storeId: '3', storeName: 'الدهانات الحديثة', name: 'بستلة دهان', description: 'دهان بلاستيك مط', price: 650.0, stock: 20, imageUrl: 'https://via.placeholder.com/150'),
    ];
  }
}
