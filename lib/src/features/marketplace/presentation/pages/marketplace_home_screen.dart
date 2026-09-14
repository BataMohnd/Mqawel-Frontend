import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/bloc/marketplace_event.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/bloc/marketplace_state.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/cubit/cart_cubit.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/pages/store_details_screen.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/pages/product_details_screen.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/pages/cart_screen.dart';

class MarketplaceHomeScreen extends StatefulWidget {
  const MarketplaceHomeScreen({super.key});

  @override
  State<MarketplaceHomeScreen> createState() => _MarketplaceHomeScreenState();
}

class _MarketplaceHomeScreenState extends State<MarketplaceHomeScreen> {
  final List<String> _categories = ['الكل', 'سباكة', 'كهرباء', 'دهانات', 'مواد بناء', 'عدد وأدوات'];
  String _selectedCategory = 'الكل';

  @override
  void initState() {
    super.initState();
    context.read<MarketplaceBloc>().add(LoadMarketplaceHomeEvent());
  }

  Widget _buildShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 100,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سوق الخامات'),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                    },
                  ),
                  if (state.items.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: Text(
                          '${state.items.length}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                ],
              );
            },
          )
        ],
      ),
      body: BlocBuilder<MarketplaceBloc, MarketplaceState>(
        builder: (context, state) {
          if (state is MarketplaceLoading) {
            return Padding(padding: const EdgeInsets.all(16.0), child: _buildShimmer());
          } else if (state is MarketplaceHomeLoaded) {
            final filteredStores = _selectedCategory == 'الكل'
                ? state.stores
                : state.stores.where((s) => s.category == _selectedCategory).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                    child: const TextField(
                      decoration: InputDecoration(icon: Icon(Icons.search), hintText: 'ابحث عن محل أو خامة...', border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Categories
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = cat == _selectedCategory;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(cat, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Stores List
                  const Text('المحلات القريبة منك', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  if (filteredStores.isEmpty)
                    const Text('لا يوجد محلات في هذا القسم حالياً')
                  else
                    ...filteredStores.map((store) => Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: Image.network(store.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(store.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${store.category} • ${store.address}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [const Icon(Icons.star, color: Colors.amber, size: 20), Text(' ${store.rating}')],
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => StoreDetailsScreen(store: store)));
                        },
                      ),
                    )),
                  
                  const SizedBox(height: 24),
                  // Latest Products
                  const Text('أحدث الخامات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: state.latestProducts.length,
                    itemBuilder: (context, index) {
                      final product = state.latestProducts[index];
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
                                    Text(product.storeName, style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                  ),
                ],
              ),
            );
          } else if (state is MarketplaceError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
