import 'package:flutter/material.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/top5_page.dart';
import '../../presentation/pages/stock_detail_page.dart';
import '../../presentation/pages/alerts_page.dart';
import '../../presentation/pages/compare_stocks_page.dart';
import '../../presentation/pages/portfolio_page.dart';
import '../../presentation/pages/watchlist_page.dart';
import 'app_routes.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.top5:
        return MaterialPageRoute(builder: (_) => const Top5Page());
      case AppRoutes.stockDetail:
        return MaterialPageRoute(builder: (_) => const StockDetailPage());
      case AppRoutes.alerts:
        return MaterialPageRoute(builder: (_) => const AlertsPage());
      case AppRoutes.compareStocks:
        return MaterialPageRoute(builder: (_) => const CompareStocksPage());
      case AppRoutes.portfolio:
        return MaterialPageRoute(builder: (_) => const PortfolioPage());
      case AppRoutes.watchlist:
        return MaterialPageRoute(builder: (_) => const WatchlistPage());
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
