import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:meqawuel_front/src/core/widgets/custom_button.dart';
import 'package:meqawuel_front/src/features/client_orders/data/models/order_model.dart';
import 'package:meqawuel_front/src/features/worker_portal/presentation/bloc/worker_portal_bloc.dart';
import 'package:meqawuel_front/src/features/worker_portal/presentation/bloc/worker_portal_event.dart';
import 'package:meqawuel_front/src/features/worker_portal/presentation/bloc/worker_portal_state.dart';

class JobDetailsScreen extends StatefulWidget {
  final OrderModel order;
  const JobDetailsScreen({super.key, required this.order});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  Future<void> _openMaps() async {
    final query = widget.order.latitude != null && widget.order.longitude != null
        ? '${widget.order.latitude},${widget.order.longitude}'
        : (widget.order.address ?? 'القاهرة');

    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _callClient() async {
    final phone = widget.order.workerPhone ?? '01012345678'; // fallback
    final url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: BlocConsumer<WorkerPortalBloc, WorkerPortalState>(
        listener: (context, state) {
          if (state is OrderStatusUpdatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث حالة الطلب')));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('نوع الخدمة', style: TextStyle(color: Colors.grey)),
                Text(widget.order.serviceType, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text('وصف المشكلة', style: TextStyle(color: Colors.grey)),
                Text(widget.order.description.isEmpty ? 'لا يوجد وصف' : widget.order.description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                
                // Map and Call Actions
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.map),
                        label: const Text('الخريطة'),
                        onPressed: _openMaps,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        icon: const Icon(Icons.call),
                        label: const Text('اتصال بالعميل'),
                        onPressed: _callClient,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 48),
                const Text('التحكم اللحظي بحالة الطلب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                CustomButton(
                  text: 'في الطريق',
                  onPressed: () {
                    context.read<WorkerPortalBloc>().add(UpdateOrderStatusEvent(widget.order.id, 'on_the_way'));
                  },
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'وصلت للموقع',
                  isSecondary: true,
                  onPressed: () {
                    context.read<WorkerPortalBloc>().add(UpdateOrderStatusEvent(widget.order.id, 'arrived'));
                  },
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'بدأ الشغل',
                  onPressed: () {
                    context.read<WorkerPortalBloc>().add(UpdateOrderStatusEvent(widget.order.id, 'in_progress'));
                  },
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'إرسال للمراجعة',
                  onPressed: () {
                    context.read<WorkerPortalBloc>().add(UpdateOrderStatusEvent(widget.order.id, 'waiting_customer_approval'));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
