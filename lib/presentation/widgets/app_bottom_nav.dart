import 'package:flutter/material.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import 'app_feedback.dart';

/// Full 5-tab nav matching the design system. Home and Top 5 are wired;
/// Stocks/Portfolio/Learn arrive in later phases, so tapping them surfaces a
/// "coming soon" message instead of silently doing nothing.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  static const _routes = <int, String>{
    0: AppRoutes.home,
    1: AppRoutes.watchlist,
    2: AppRoutes.top5,
    3: AppRoutes.portfolio,
  };
  static const _labels = ['Home', 'Stocks', 'Top 5', 'Portfolio', 'Learn'];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: AppColors.textMuted,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        final route = _routes[index];
        if (route == null) {
          AppFeedback.showSnackBar(context, '${_labels[index]} is coming in a later phase');
          return;
        }
        if (index == currentIndex) return;
        Navigator.of(context).pushReplacementNamed(route);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart_rounded), label: 'Stocks'),
        BottomNavigationBarItem(icon: Icon(Icons.star_outline_rounded), activeIcon: Icon(Icons.star_rounded), label: 'Top 5'),
        BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline_rounded), activeIcon: Icon(Icons.pie_chart_rounded), label: 'Portfolio'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), activeIcon: Icon(Icons.menu_book_rounded), label: 'Learn'),
      ],
    );
  }
}
