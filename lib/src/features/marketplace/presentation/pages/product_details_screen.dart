import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meqawuel_front/src/core/widgets/custom_button.dart';
import 'package:meqawuel_front/src/features/marketplace/data/models/product_model.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/cubit/cart_cubit.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.product.imageUrl, width: double.infinity, height: 250, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(widget.product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                      Text('${widget.product.price} ج.م', style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('البائع: ${widget.product.storeName}', style: const TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 24),
                  const Text('وصف المنتج', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(widget.product.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                  const SizedBox(height: 24),
                  const Text('الكمية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (_quantity > 1) setState(() => _quantity--);
                        },
                      ),
                      Text('$_quantity', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          if (_quantity < widget.product.stock) setState(() => _quantity++);
                        },
                      ),
                      const SizedBox(width: 16),
                      Text('المتاح: ${widget.product.stock}', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          text: 'أضف إلى السلة (${widget.product.price * _quantity} ج.م)',
          onPressed: () {
            context.read<CartCubit>().addToCart(widget.product, _quantity);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت الإضافة للسلة')));
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
