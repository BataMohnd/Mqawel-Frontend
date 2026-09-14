import 'package:flutter/material.dart';

class PendingReviewScreen extends StatelessWidget {
  const PendingReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hourglass_empty, size: 100, color: Colors.amber),
            const SizedBox(height: 32),
            Text(
              'طلبك قيد المراجعة',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'سيتم مراجعة مستنداتك من قبل الإدارة وسنوافيك بالرد في أقرب وقت. يمكنك إغلاق التطبيق الآن.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
