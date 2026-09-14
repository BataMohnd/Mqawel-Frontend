import 'package:flutter/material.dart';
import 'package:meqawuel_front/src/features/worker_portal/presentation/pages/worker_home_screen.dart';
import 'package:meqawuel_front/src/features/worker_portal/presentation/pages/worker_schedule_screen.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/pages/profile_settings_screen.dart';

class WorkerMainBottomNavScreen extends StatefulWidget {
  const WorkerMainBottomNavScreen({super.key});

  @override
  State<WorkerMainBottomNavScreen> createState() => _WorkerMainBottomNavScreenState();
}

class _WorkerMainBottomNavScreenState extends State<WorkerMainBottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const WorkerHomeScreen(),
    const WorkerScheduleScreen(),
    const ProfileSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'شغلي'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}
