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
import '../../presentation/pages/legal/legal_document_page.dart';
import '../../data/legal/disclaimer_content.dart';
import '../../data/legal/terms_content.dart';
import '../../data/legal/privacy_policy_content.dart';
import '../../presentation/pages/support/faq_page.dart';
import '../../presentation/pages/support/contact_support_page.dart';
import '../../presentation/pages/checkout/checkout_page.dart';
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
      case AppRoutes.disclaimer:
        return MaterialPageRoute(
          builder: (_) =>
              const LegalDocumentPage(document: kDisclaimerDocument),
        );
      case AppRoutes.terms:
        return MaterialPageRoute(
          builder: (_) => const LegalDocumentPage(document: kTermsDocument),
        );
      case AppRoutes.privacyPolicy:
        return MaterialPageRoute(
          builder: (_) =>
              const LegalDocumentPage(document: kPrivacyPolicyDocument),
        );
      case AppRoutes.faq:
        return MaterialPageRoute(builder: (_) => const FaqPage());
      case AppRoutes.contactSupport:
        return MaterialPageRoute(builder: (_) => const ContactSupportPage());
      case AppRoutes.checkout:
        // The only route taking arguments — the plan and cycle the user
        // picked on the Subscription screen.
        final args = settings.arguments;
        if (args is! CheckoutArgs) {
          return MaterialPageRoute(builder: (_) => const SubscriptionPage());
        }
        return MaterialPageRoute(
          builder: (_) => CheckoutPage(args: args),
          fullscreenDialog: true,
        );
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
