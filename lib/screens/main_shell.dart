import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/navigation/bh_navigation.dart';

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // 5-tab navigation: Dashboard (BHS), Compliance, Advisory, Integrations, Profile
  static const _routes = [
    '/dashboard',
    '/compliance',
    '/ai-advisor',
    '/integrations',
    '/profile',
  ];

  void _onNavTap(int index) {
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);
      context.go(_routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sync index from current location
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _routes.length; i++) {
      if (location.startsWith(_routes[i])) {
        _currentIndex = i;
        break;
      }
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BHBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
