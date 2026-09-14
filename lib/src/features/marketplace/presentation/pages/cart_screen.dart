import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meqawuel_front/src/core/widgets/custom_button.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/cubit/cart_cubit.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/pages/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سلة المشتريات')),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_shopping_cart, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('السلة فارغة', style: TextStyle(fontSize: 20, color: Colors.grey)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('تصفح الخامات'),
                  )
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.network(item.product.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text(item.product.storeName, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                  const SizedBox(height: 8),
                                  Text('${item.product.price} ج.م', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => context.read<CartCubit>().removeItem(item.product.id),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => context.read<CartCubit>().updateQuantity(item.product.id, item.quantity - 1),
                                      child: Container(color: Colors.grey.shade200, padding: const EdgeInsets.all(4), child: const Icon(Icons.remove, size: 16)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                    GestureDetector(
                                      onTap: () => context.read<CartCubit>().updateQuantity(item.product.id, item.quantity + 1),
                                      child: Container(color: Colors.grey.shade200, padding: const EdgeInsets.all(4), child: const Icon(Icons.add, size: 16)),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الإجمالي', style: TextStyle(fontSize: 18)),
                        Text('${state.total} ج.م', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'متابعة الدفع',
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutScreen()));
                      },
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
