import 'package:flutter/material.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';

/// Full 5-tab nav matching the design system. All 5 tabs are wired to a
/// real screen.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  static const _routes = <String>[
    AppRoutes.home,
    AppRoutes.watchlist,
    AppRoutes.top5,
    AppRoutes.portfolio,
    AppRoutes.learn,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: AppColors.textMuted,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == currentIndex) return;
        Navigator.of(context).pushReplacementNamed(_routes[index]);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          activeIcon: Icon(Icons.bar_chart_rounded),
          label: 'Stocks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_outline_rounded),
          activeIcon: Icon(Icons.star_rounded),
          label: 'Top 5',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart_outline_rounded),
          activeIcon: Icon(Icons.pie_chart_rounded),
          label: 'Portfolio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined),
          activeIcon: Icon(Icons.menu_book_rounded),
          label: 'Learn',
        ),
      ],
    );
  }
}
