import 'package:flutter/material.dart';
import 'package:meqawuel_front/src/features/client_orders/data/models/worker_model.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/pages/create_order_screen.dart';

class WorkerProfileScreen extends StatelessWidget {
  final WorkerModel worker;
  const WorkerProfileScreen({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بروفايل الصنايعي')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              child: Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  worker.name,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
                ),
                if (worker.isVerified)
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.verified, color: Colors.green),
                  )
              ],
            ),
            Text(worker.speciality, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _InfoCard(title: 'التقييم', value: worker.rating.toString(), icon: Icons.star, iconColor: Colors.amber),
                _InfoCard(title: 'الخبرة', value: '${worker.experienceYears} سنين', icon: Icons.work, iconColor: Colors.blue),
                _InfoCard(title: 'الكشف', value: '${worker.inspectionPrice} ج.م', icon: Icons.payments, iconColor: Colors.green),
              ],
            ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerRight,
              child: Text('تقييمات العملاء', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            // Mock reviews
            Card(
              child: ListTile(
                title: const Text('عميل مميز'),
                subtitle: const Text('شغل نظيف ومحترم جداً وجه في ميعاده'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateOrderScreen(worker: worker)),
            );
          },
          child: const Text('طلب خدمة', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _InfoCard({required this.title, required this.value, required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 32),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
