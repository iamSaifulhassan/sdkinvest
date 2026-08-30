import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/alert_item.dart';
import '../../data/models/stock.dart';
import '../../data/models/watchlist_item.dart';
import '../../data/repositories/alert_repository.dart';

enum WatchlistStatus { loading, loaded }

/// Which segment of the Watchlist filter bar is active.
enum WatchlistFilter { all, nearBuy, alerts }

class WatchlistState extends Equatable {
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
        result = result
            .where((i) => i.indicator == WatchlistIndicator.nearBuyZone)
            .toList();
      case WatchlistFilter.alerts:
        final alertTickers = activeAlerts.map((a) => a.ticker).toSet();
        result = result.where((i) => alertTickers.contains(i.ticker)).toList();
      case WatchlistFilter.all:
        break;
    }
    if (query.trim().isEmpty) return result;
    final q = query.trim().toLowerCase();
    return result
        .where(
          (i) =>
              i.ticker.toLowerCase().contains(q) ||
              i.name.toLowerCase().contains(q),
        )
        .toList();
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

  @override
  List<Object?> get props => [status, filter, query, items, activeAlerts];
}

/// Drives the Watchlist screen. Tracked-item data is still mock/in-memory
/// (no backend yet); the "Active Alerts" preview comes from the same
/// [AlertRepository] the full Alerts & Signals screen uses, filtered down to
/// tickers this watchlist actually tracks.
class WatchlistCubit extends Cubit<WatchlistState> {
  WatchlistCubit({this.alertRepository = const MockAlertRepository()})
    : super(const WatchlistState()) {
    _load();
  }

  final AlertRepository alertRepository;

  static const _items = [
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
  ];

  Future<void> _load() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (isClosed) return;
    final trackedTickers = _items.map((i) => i.ticker).toSet();
    emit(
      state.copyWith(
        status: WatchlistStatus.loaded,
        items: _items,
        activeAlerts: alertRepository.alerts
            .where((a) => trackedTickers.contains(a.ticker))
            .toList(),
      ),
    );
  }

  void setFilter(WatchlistFilter filter) =>
      emit(state.copyWith(filter: filter));

  void setQuery(String query) => emit(state.copyWith(query: query));
}
