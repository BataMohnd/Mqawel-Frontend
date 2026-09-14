import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meqawuel_front/src/features/marketplace/data/models/store_model.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/bloc/marketplace_event.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/bloc/marketplace_state.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/pages/product_details_screen.dart';

class StoreDetailsScreen extends StatefulWidget {
  final StoreModel store;
  const StoreDetailsScreen({super.key, required this.store});

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MarketplaceBloc>().add(LoadStoreDetailsEvent(widget.store.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.store.name)),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
            child: Row(
              children: [
                Image.network(widget.store.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.store.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('${widget.store.category} • ${widget.store.address}'),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(' ${widget.store.rating} • متاح الآن', style: const TextStyle(color: Colors.green)),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: BlocBuilder<MarketplaceBloc, MarketplaceState>(
              builder: (context, state) {
                if (state is MarketplaceLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is StoreDetailsLoaded) {
                  if (state.products.isEmpty) {
                    return const Center(child: Text('لا توجد منتجات متوفرة حالياً'));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product)));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                  child: Image.network(product.imageUrl, width: double.infinity, fit: BoxFit.cover),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Text('${product.price} ج.م', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is MarketplaceError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
