import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_bloc.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_event.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_state.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/pages/order_tracking_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClientOrdersBloc>().add(LoadMyOrdersEvent());
  }

  Color _getStatusColor(String status) {
    switch(status) {
      case 'pending': return Colors.orange;
      case 'accepted': return Colors.blue;
      case 'in_progress': return Colors.purple;
      case 'completed': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch(status) {
      case 'pending': return 'جاري البحث عن فني';
      case 'accepted': return 'تم القبول';
      case 'in_progress': return 'جاري العمل';
      case 'completed': return 'مكتمل';
      case 'cancelled': return 'ملغي';
      default: return 'غير معروف';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلباتي')),
      body: BlocBuilder<ClientOrdersBloc, ClientOrdersState>(
        builder: (context, state) {
          if (state is ClientOrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MyOrdersLoaded) {
            if (state.orders.isEmpty) {
              return const Center(child: Text('لا يوجد طلبات سابقة'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                final formattedDate = DateFormat('yyyy-MM-dd – hh:mm a').format(order.createdAt);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('طلب ${order.serviceType}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getStatusText(order.status),
                            style: TextStyle(color: _getStatusColor(order.status), fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(formattedDate),
                        if (order.workerName != null) Text('الفني: ${order.workerName}'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderTrackingScreen(order: order)),
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
    );
  }
}
