import 'package:flutter/material.dart';
import 'package:meqawuel_front/src/features/auth/presentation/pages/phone_login_screen.dart';
import 'package:meqawuel_front/src/core/theme/app_colors.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أنت بتستخدم التطبيق كـ؟'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: _RoleCard(
                icon: Icons.person_search,
                title: 'أنا عميل',
                subtitle: 'أبحث عن فني لإصلاح أعطال بمنزلي',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const PhoneLoginScreen(role: 'client'),
                  ));
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _RoleCard(
                icon: Icons.engineering,
                title: 'أنا صنايعي',
                subtitle: 'أريد استقبال طلبات وزيادة دخلي',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const PhoneLoginScreen(role: 'worker'),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryLight, width: 2),
          borderRadius: BorderRadius.circular(16),
          color: AppColors.surface,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.secondaryDark),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
