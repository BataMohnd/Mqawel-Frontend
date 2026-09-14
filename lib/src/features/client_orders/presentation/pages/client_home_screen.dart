import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_bloc.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_event.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_state.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/pages/worker_profile_screen.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/pages/create_order_screen.dart';
import 'package:meqawuel_front/src/features/client_orders/data/models/service_category.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClientOrdersBloc>().add(LoadHomeDataEvent());
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أهلاً بك، مدينتي - B6'), // Mock Location
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'بتدور على فني إيه؟',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_task),
                label: const Text('اطلب خدمة'),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateOrderScreen())),
              ),
            ),
            const SizedBox(height: 24),
            // Categories
            const Text('الخدمات المتاحة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.8,
              ),
              itemCount: serviceCategories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateOrderScreen(initialCategoryId: serviceCategories[index].id),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                        child: Icon(serviceCategories[index].icon, color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(height: 8),
                      Text(serviceCategories[index].name, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // Top Rated
            const Text('الأعلى تقييماً في منطقتك', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            BlocBuilder<ClientOrdersBloc, ClientOrdersState>(
              builder: (context, state) {
                if (state is ClientOrdersLoading) {
                  return _buildShimmer();
                } else if (state is WorkersLoaded) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.topWorkers.length,
                    itemBuilder: (context, index) {
                      final worker = state.topWorkers[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(worker.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${worker.speciality} • كشف المعاينة ${worker.inspectionPrice} ج.م'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 20),
                              Text(' ${worker.rating}'),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WorkerProfileScreen(worker: worker)),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else if (state is ClientOrdersError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
