import 'package:flutter/material.dart';
import 'admin_dashboard_tab.dart';
import 'admin_manajemen_tab.dart';
import 'admin_profil_tab.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 1; // Default to Dashboard

  final List<Widget> _tabs = const [
    AdminManajemenTab(),
    AdminDashboardTab(),
    AdminProfilTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        indicatorColor: const Color(0xFF4FACFE).withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder, color: Color(0xFF0072FF)),
            label: 'Manajemen',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Color(0xFF0072FF)),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFF0072FF)),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

