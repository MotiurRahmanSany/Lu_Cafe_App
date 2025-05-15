import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationScaffold extends StatelessWidget {
  NavigationScaffold({
    super.key,
    required this.navigationShell,
  });
  final StatefulNavigationShell navigationShell;

  final _bottomNavigationKey = GlobalKey<CurvedNavigationBarState>();

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        height: 55,
        key: _bottomNavigationKey,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        index: navigationShell.currentIndex,
        onTap: (index) => _goBranch(index),
        items: [
          Icon(Icons.home),
          Icon(Icons.shopping_cart_outlined),
          Icon(Icons.person),
        ],
      ),
    );
  }
}
