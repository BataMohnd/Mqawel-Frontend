import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meqawuel_front/src/core/theme/app_colors.dart';
import 'package:meqawuel_front/src/features/worker_portal/presentation/bloc/worker_portal_bloc.dart';
import 'package:meqawuel_front/src/features/worker_portal/presentation/bloc/worker_portal_event.dart';
import 'package:meqawuel_front/src/features/worker_portal/presentation/bloc/worker_portal_state.dart';
import 'package:meqawuel_front/src/features/worker_portal/presentation/pages/job_details_screen.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkerPortalBloc>().add(LoadWorkerHomeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بوابة الصنايعي'),
      ),
      body: BlocConsumer<WorkerPortalBloc, WorkerPortalState>(
        listener: (context, state) {
          if (state is IncomingOrderState) {
            _showIncomingOrderDialog(context, state);
          } else if (state is WorkerPortalError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        buildWhen: (previous, current) => current is WorkerHomeLoaded || current is WorkerPortalLoading,
        builder: (context, state) {
          if (state is WorkerPortalLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkerHomeLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<WorkerPortalBloc>().add(LoadWorkerHomeEvent());
              },
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.isAvailable ? 'أنت متاح للطلبات الآن' : 'أنت غير متاح',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: state.isAvailable,
                        activeColor: Colors.green,
                        onChanged: (val) {
                          context.read<WorkerPortalBloc>().add(ToggleAvailabilityEvent(val));
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('ملخص الأداء الأسبوعي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'الشغلانات',
                          value: state.summary['jobsCount'].toString(),
                          icon: Icons.handyman,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _SummaryCard(
                          title: 'التقييم',
                          value: state.summary['rating'].toString(),
                          icon: Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _SummaryCard(
                          title: 'نسبة القبول',
                          value: state.summary['acceptanceRate'].toString(),
                          icon: Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showIncomingOrderDialog(BuildContext context, IncomingOrderState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.notifications_active, color: Colors.amber, size: 32),
              SizedBox(width: 8),
              Text('طلب جديد وارد!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الخدمة المطلوبة: ${state.order.serviceType}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('المسافة التقديرية: 3 كم (حوالي 10 دقائق)'),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () {
                context.read<WorkerPortalBloc>().add(IgnoreIncomingOrderEvent());
                Navigator.pop(context);
              },
              child: const Text('رفض/تجاهل', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                context.read<WorkerPortalBloc>().add(AcceptOrderEvent(state.order.id));
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => JobDetailsScreen(order: state.order),
                ));
              },
              child: const Text('قبول الطلب'),
            ),
          ],
        );
      }
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
