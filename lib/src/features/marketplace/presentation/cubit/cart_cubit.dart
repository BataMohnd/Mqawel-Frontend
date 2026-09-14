import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meqawuel_front/src/features/marketplace/data/models/cart_item_model.dart';
import 'package:meqawuel_front/src/features/marketplace/data/models/product_model.dart';

class CartState {
  final List<CartItemModel> items;
  CartState({required this.items});
  
  double get total => items.fold(0, (sum, item) => sum + item.totalPrice);
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState(items: [])) {
    _loadCart();
  }

  void _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('cart_items');
    if (cartString != null) {
      final List decoded = jsonDecode(cartString);
      final items = decoded.map((e) => CartItemModel.fromJson(e)).toList();
      emit(CartState(items: items));
    }
  }

  void _saveCart(List<CartItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString('cart_items', encoded);
  }

  void addToCart(ProductModel product, int quantity) {
    final items = List<CartItemModel>.from(state.items);
    final existingIndex = items.indexWhere((i) => i.product.id == product.id);
    
    if (existingIndex >= 0) {
      items[existingIndex].quantity += quantity;
    } else {
      items.add(CartItemModel(product: product, quantity: quantity));
    }
    
    _saveCart(items);
    emit(CartState(items: items));
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity < 1) return;
    final items = List<CartItemModel>.from(state.items);
    final index = items.indexWhere((i) => i.product.id == productId);
    if (index >= 0) {
      items[index].quantity = newQuantity;
      _saveCart(items);
      emit(CartState(items: items));
    }
  }

  void removeItem(String productId) {
    final items = List<CartItemModel>.from(state.items);
    items.removeWhere((i) => i.product.id == productId);
    _saveCart(items);
    emit(CartState(items: items));
  }

  void clearCart() {
    _saveCart([]);
    emit(CartState(items: []));
  }
}
