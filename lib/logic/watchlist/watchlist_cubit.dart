import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/alert_item.dart';
import '../../data/models/stock.dart';
import '../../data/models/watchlist_item.dart';
import '../../core/theme/app_colors.dart';

enum WatchlistStatus { loading, loaded }

/// Which segment of the Watchlist filter bar is active.
enum WatchlistFilter { all, nearBuy, alerts }

class WatchlistState {
  const WatchlistState({
    this.status = WatchlistStatus.loading,
    this.filter = WatchlistFilter.all,
    this.query = '',
    this.items = const [],
    this.activeAlerts = const [],
  });

  final WatchlistStatus status;
  final WatchlistFilter filter;
  final String query;
  final List<WatchlistItem> items;
  final List<AlertItem> activeAlerts;

  /// Items after applying the filter segment and the search query.
  List<WatchlistItem> get visibleItems {
    var result = items;
    switch (filter) {
      case WatchlistFilter.nearBuy:
        result = result.where((i) => i.indicator == WatchlistIndicator.nearBuyZone).toList();
      case WatchlistFilter.alerts:
        result = result.where((i) => i.indicator == WatchlistIndicator.lowConfidence).toList();
      case WatchlistFilter.all:
        break;
    }
    if (query.trim().isEmpty) return result;
    final q = query.trim().toLowerCase();
    return result.where((i) => i.ticker.toLowerCase().contains(q) || i.name.toLowerCase().contains(q)).toList();
  }

  WatchlistState copyWith({
    WatchlistStatus? status,
    WatchlistFilter? filter,
    String? query,
    List<WatchlistItem>? items,
    List<AlertItem>? activeAlerts,
  }) {
    return WatchlistState(
      status: status ?? this.status,
      filter: filter ?? this.filter,
      query: query ?? this.query,
      items: items ?? this.items,
      activeAlerts: activeAlerts ?? this.activeAlerts,
    );
  }
}

/// Drives the Watchlist screen. Mock/in-memory data only — no backend.
class WatchlistCubit extends Cubit<WatchlistState> {
  WatchlistCubit() : super(const WatchlistState()) {
    _load();
  }

  Future<void> _load() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (isClosed) return;
    emit(state.copyWith(
      status: WatchlistStatus.loaded,
      items: const [
        WatchlistItem(
          ticker: 'AAPL',
          name: 'Apple Inc.',
          price: 192.74,
          change: 2.18,
          changePercent: 1.14,
          sdkScore: 87,
          status: StockStatus.strongBuy,
          indicator: WatchlistIndicator.nearBuyZone,
        ),
        WatchlistItem(
          ticker: 'AMZN',
          name: 'Amazon.com Inc.',
          price: 183.56,
          change: 3.25,
          changePercent: 1.80,
          sdkScore: 82,
          status: StockStatus.buy,
          indicator: WatchlistIndicator.scoreRising,
        ),
        WatchlistItem(
          ticker: 'GOOGL',
          name: 'Alphabet Inc.',
          price: 162.89,
          change: 1.55,
          changePercent: 0.96,
          sdkScore: 79,
          status: StockStatus.buy,
          indicator: WatchlistIndicator.nearBuyZone,
        ),
        WatchlistItem(
          ticker: 'TSM',
          name: 'Taiwan Semicon.',
          price: 176.12,
          change: 2.71,
          changePercent: 1.56,
          sdkScore: 85,
          status: StockStatus.strongBuy,
          indicator: WatchlistIndicator.scoreRising,
        ),
        WatchlistItem(
          ticker: 'LLY',
          name: 'Eli Lilly & Co.',
          price: 752.48,
          change: -4.32,
          changePercent: -0.57,
          sdkScore: 68,
          status: StockStatus.hold,
          indicator: WatchlistIndicator.lowConfidence,
        ),
        WatchlistItem(
          ticker: 'RKLB',
          name: 'Rocket Lab USA',
          price: 6.28,
          change: 0.21,
          changePercent: 3.46,
          sdkScore: 78,
          status: StockStatus.buy,
          indicator: WatchlistIndicator.scoreRising,
        ),
      ],
      activeAlerts: const [
        AlertItem(
          category: AlertCategory.priceAlert,
          ticker: 'AAPL',
          companyName: 'Apple Inc.',
          title: 'AAPL reached Buy zone',
          reason: 'Price: 192.74',
          timeAgo: 'Today, 8:32 AM',
          icon: Icons.adjust_rounded,
          iconColor: AppColors.accentCyan,
        ),
        AlertItem(
          category: AlertCategory.upgrade,
          ticker: 'RKLB',
          companyName: 'Rocket Lab USA, Inc.',
          title: 'RKLB score upgraded to 78',
          reason: 'Score improved from 71',
          timeAgo: 'May 22, 11:14 AM',
          icon: Icons.trending_up_rounded,
          iconColor: AppColors.strongBuy,
          status: StockStatus.buy,
        ),
      ],
    ));
  }

  void setFilter(WatchlistFilter filter) => emit(state.copyWith(filter: filter));

  void setQuery(String query) => emit(state.copyWith(query: query));
}
