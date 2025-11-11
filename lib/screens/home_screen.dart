import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'ar_view_screen.dart';
import 'badges_screen.dart';
import 'missions_screen.dart';
import 'profile_screen.dart';

/// Main home screen with navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ARViewScreen(),
    const MissionsScreen(),
    const BadgesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.camera_alt),
            label: 'AR Scan',
          ),
          NavigationDestination(
            icon: Icon(Icons.flag),
            label: 'Missions',
          ),
          NavigationDestination(
            icon: Icon(Icons.workspace_premium),
            label: 'Badges',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
