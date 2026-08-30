import 'package:flutter/material.dart';

import '../../models/alerts/alert_item.dart';
import '../../models/stock/stock.dart';
import '../../../core/theme/app_colors.dart';

/// Single source of truth for score-change/price-zone alerts. Both the full
/// Alerts & Signals screen and the Watchlist screen's "Active Alerts"
/// preview read from here, so the same event never gets reworded twice.
abstract class AlertRepository {
  List<AlertItem> get alerts;
}

class MockAlertRepository implements AlertRepository {
  const MockAlertRepository();

  @override
  List<AlertItem> get alerts => const [
    AlertItem(
      category: AlertCategory.upgrade,
      ticker: 'MU',
      companyName: 'Micron Technology',
      title: 'MU upgraded 82 → 87',
      reason: 'Momentum + earnings improved',
      timeAgo: '2hr ago',
      icon: Icons.trending_up_rounded,
      iconColor: AppColors.strongBuy,
      status: StockStatus.strongBuy,
    ),
    AlertItem(
      category: AlertCategory.priceAlert,
      ticker: 'AAPL',
      companyName: 'Apple Inc.',
      title: 'AAPL entered Buy zone',
      reason: 'Price moved into our Buy zone',
      timeAgo: '3hr ago',
      icon: Icons.adjust_rounded,
      iconColor: AppColors.accentCyan,
    ),
    AlertItem(
      category: AlertCategory.downgrade,
      ticker: 'XOM',
      companyName: 'Exxon Mobil Corporation',
      title: 'XOM downgraded 58 → 51',
      reason: 'Revenue and EPS weakened',
      timeAgo: '5hr ago',
      icon: Icons.trending_down_rounded,
      iconColor: AppColors.trim,
      status: StockStatus.trim,
    ),
    AlertItem(
      category: AlertCategory.priceAlert,
      ticker: 'NVDA',
      companyName: 'NVIDIA Corporation',
      title: 'NVDA remains Strong Buy',
      reason: 'Strong momentum and outlook intact',
      timeAgo: '7hr ago',
      icon: Icons.verified_rounded,
      iconColor: AppColors.accentBlue,
      status: StockStatus.strongBuy,
    ),
    AlertItem(
      category: AlertCategory.upgrade,
      ticker: 'RKLB',
      companyName: 'Rocket Lab USA, Inc.',
      title: 'RKLB upgraded to 78',
      reason: 'Launch cadence and backlog growth',
      timeAgo: '9hr ago',
      icon: Icons.trending_up_rounded,
      iconColor: AppColors.strongBuy,
      status: StockStatus.buy,
    ),
  ];
}
