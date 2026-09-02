import 'package:flutter/material.dart';

import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/top5/top5_page.dart';
import '../../presentation/pages/stock/stock_detail_page.dart';
import '../../presentation/pages/alerts/alerts_page.dart';
import '../../presentation/pages/compare/compare_stocks_page.dart';
import '../../presentation/pages/portfolio/portfolio_page.dart';
import '../../presentation/pages/watchlist/watchlist_page.dart';
import '../../presentation/pages/learn/learn_page.dart';
import '../../presentation/pages/subscription/subscription_page.dart';
import '../../presentation/pages/onboarding/onboarding_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/signup_page.dart';
import '../../presentation/pages/search/search_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
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
      case AppRoutes.learn:
        return MaterialPageRoute(builder: (_) => const LearnPage());
      case AppRoutes.subscription:
        return MaterialPageRoute(
          builder: (_) => const SubscriptionPage(),
          fullscreenDialog: true,
        );
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
