import 'package:flutter/material.dart';
import '../../presentation/pages/widget_showcase_page.dart';
import '../../presentation/pages/placeholder_detail_page.dart';
import 'app_routes.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.widgetShowcase:
        return MaterialPageRoute(builder: (_) => const WidgetShowcasePage());
      case AppRoutes.placeholderDetail:
        return MaterialPageRoute(builder: (_) => const PlaceholderDetailPage());
      default:
        return MaterialPageRoute(builder: (_) => const WidgetShowcasePage());
    }
  }
}
