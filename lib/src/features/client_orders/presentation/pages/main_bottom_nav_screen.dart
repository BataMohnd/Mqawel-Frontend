import 'package:flutter/material.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/pages/client_home_screen.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/pages/my_orders_screen.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/pages/profile_settings_screen.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/pages/marketplace_home_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ClientHomeScreen(),
    const MyOrdersScreen(),
    const MarketplaceHomeScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'طلباتي'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'المتجر'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}
