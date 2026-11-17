import 'package:flutter/material.dart';
import 'supervisor_beranda_tab.dart';
import 'supervisor_tugas_tab.dart';
import 'supervisor_nilai_tab.dart';
import 'supervisor_profil_tab.dart';

class SupervisorMainScreen extends StatefulWidget {
  const SupervisorMainScreen({super.key});

  @override
  State<SupervisorMainScreen> createState() => _SupervisorMainScreenState();
}

class _SupervisorMainScreenState extends State<SupervisorMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    SupervisorBerandaTab(),
    SupervisorTugasTab(),
    SupervisorNilaiTab(),
    SupervisorProfilTab(),
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
        indicatorColor: const Color(0xFFFF416C).withOpacity(0.18),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color(0xFFFF416C)),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment, color: Color(0xFFFF416C)),
            label: 'Tugas',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_rtl_outlined),
            selectedIcon: Icon(Icons.checklist_rtl, color: Color(0xFFFF416C)),
            label: 'Nilai',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFFFF416C)),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

