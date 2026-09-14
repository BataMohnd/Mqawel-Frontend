import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_bloc.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_event.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_state.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/pages/worker_profile_screen.dart';

class WorkersListScreen extends StatefulWidget {
  final String category;
  final String? orderId;
  const WorkersListScreen({super.key, required this.category, this.orderId});

  @override
  State<WorkersListScreen> createState() => _WorkersListScreenState();
}

class _WorkersListScreenState extends State<WorkersListScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.orderId != null) {
      context.read<ClientOrdersBloc>().add(LoadContractorsEvent(widget.orderId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('فنيين ${widget.category}')),
      body: BlocBuilder<ClientOrdersBloc, ClientOrdersState>(
        builder: (context, state) {
          if (state is ClientOrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchWorkersLoaded || state is ContractorsLoaded) {
            final workers = state is ContractorsLoaded ? state.contractors : (state as SearchWorkersLoaded).workers;
            if (workers.isEmpty) {
              return const Center(child: Text('لا يوجد فنيين متاحين حالياً'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: workers.length,
              itemBuilder: (context, index) {
                final worker = workers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(child: Icon(Icons.person)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(worker.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      if (worker.isVerified)
                                        const Padding(
                                          padding: EdgeInsets.only(right: 4.0),
                                          child: Icon(Icons.verified, color: Colors.green, size: 16),
                                        ),
                                    ],
                                  ),
                                  Text(worker.speciality, style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                            if (widget.orderId != null)
                              ElevatedButton(
                                onPressed: () => context.read<ClientOrdersBloc>().add(
                                  SelectContractorEvent(widget.orderId!, worker.id),
                                ),
                                child: const Text('اختيار'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _InfoChip(icon: Icons.star, label: worker.rating.toStringAsFixed(1)),
                            _InfoChip(icon: Icons.work_history, label: '${worker.completedJobs} أعمال'),
                            _InfoChip(icon: Icons.location_on, label: '${worker.distanceKm.toStringAsFixed(1)} كم'),
                            _InfoChip(icon: Icons.attach_money, label: 'كشف ${worker.inspectionPrice} ج.م'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('خبرة ${worker.experienceYears} سنوات', style: const TextStyle(color: Colors.grey)),
                            Text(worker.isAvailable ? 'متاح الآن' : 'غير متاح', style: TextStyle(color: worker.isAvailable ? Colors.green : Colors.orange)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => WorkerProfileScreen(worker: worker)),
                              );
                            },
                            child: const Text('عرض الملف الشخصي'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ContractorSelectedSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) Navigator.pop(context, state.order);
            });
            return const Center(child: Text('تم اختيار الصنايعي'));
          } else if (state is ClientOrdersError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
    );
  }
}
