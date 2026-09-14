import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meqawuel_front/src/features/worker_portal/presentation/bloc/worker_portal_bloc.dart';
import 'package:meqawuel_front/src/features/worker_portal/presentation/bloc/worker_portal_event.dart';
import 'package:meqawuel_front/src/features/worker_portal/presentation/bloc/worker_portal_state.dart';
import 'package:meqawuel_front/src/features/worker_portal/presentation/pages/job_details_screen.dart';

class WorkerScheduleScreen extends StatefulWidget {
  const WorkerScheduleScreen({super.key});

  @override
  State<WorkerScheduleScreen> createState() => _WorkerScheduleScreenState();
}

class _WorkerScheduleScreenState extends State<WorkerScheduleScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkerPortalBloc>().add(LoadJobsScheduleEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('جدول أعمالي (شغلي)')),
      body: BlocBuilder<WorkerPortalBloc, WorkerPortalState>(
        buildWhen: (previous, current) => current is JobsLoaded || current is WorkerPortalLoading,
        builder: (context, state) {
          if (state is WorkerPortalLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JobsLoaded) {
            if (state.jobs.isEmpty) {
              return const Center(child: Text('لا توجد أعمال مجدولة'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.jobs.length,
              itemBuilder: (context, index) {
                final job = state.jobs[index];
                final formattedDate = DateFormat('yyyy-MM-dd').format(job.createdAt);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text('طلب ${job.serviceType} - $formattedDate', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('الحالة: ${job.status}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => JobDetailsScreen(order: job),
                      ));
                    },
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
