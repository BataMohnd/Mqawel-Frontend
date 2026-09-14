import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meqawuel_front/src/features/auth/presentation/pages/onboarding_screen.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/pages/main_bottom_nav_screen.dart';
import 'package:meqawuel_front/src/features/worker_portal/presentation/pages/worker_main_bottom_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final hasToken = prefs.containsKey('jwt_token');
    final role = prefs.getString('user_role');

    if (mounted) {
      if (hasToken) {
        if (role == 'worker') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WorkerMainBottomNavScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainBottomNavScreen()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.build_circle, size: 100, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              'مقاول',
              style: theme.textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontSize: 48,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'صنايعي مضمون، خدمة أسهل',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
