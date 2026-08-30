import 'package:equatable/equatable.dart';

import '../stock/stock.dart';

/// Which trailing signal a Watchlist row highlights.
enum WatchlistIndicator { nearBuyZone, scoreRising, lowConfidence }

extension WatchlistIndicatorLabel on WatchlistIndicator {
  String get label => switch (this) {
    WatchlistIndicator.nearBuyZone => 'Near Buy zone',
    WatchlistIndicator.scoreRising => 'Score rising',
    WatchlistIndicator.lowConfidence => 'Low confidence',
  };
}

/// One row on the Watchlist screen — a tracked stock plus live price and
/// the trailing signal ("Near Buy zone", "Score rising", "Low confidence").
class WatchlistItem extends Equatable {
  const WatchlistItem({
    required this.ticker,
    required this.name,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.sdkScore,
    required this.status,
    required this.indicator,
  });

  final String ticker;
  final String name;
  final double price;
  final double change;
  final double changePercent;
  final int sdkScore;
  final StockStatus status;
  final WatchlistIndicator indicator;

  bool get isPositive => change >= 0;

  @override
  List<Object?> get props => [
    ticker,
    name,
    price,
    change,
    changePercent,
    sdkScore,
    status,
    indicator,
  ];
}
