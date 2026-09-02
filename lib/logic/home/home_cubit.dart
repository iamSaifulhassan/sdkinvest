import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/home/home_action_item.dart';
import '../../data/models/stock/stock.dart';
import '../../data/repositories/stock/stock_repository.dart';

enum HomeStatus { loading, loaded }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.loading,
    this.userName = '',
    this.portfolioValue = '\$0.00',
    this.changeLabel = '--',
    this.isPositive = true,
    this.chartPoints = const [],
    this.yAxisLabels = const [],
    this.xAxisLabels = const [],
    this.watchlistCount = 0,
    this.strongBuyCount = 0,
    this.alertCount = 0,
    this.top5 = const [],
    this.actionItems = const [],
    this.recommendations = const [],
  });

  final HomeStatus status;
  final String userName;
  final String portfolioValue;
  final String changeLabel;
  final bool isPositive;
  final List<double> chartPoints;
  final List<String> yAxisLabels;
  final List<String> xAxisLabels;
  final int watchlistCount;
  final int strongBuyCount;
  final int alertCount;
  final List<Stock> top5;
  final List<HomeActionItem> actionItems;

  /// Stocks the SDK Score model surfaces as worth a look — separate from
  /// [top5], which is strictly rank-ordered.
  final List<Stock> recommendations;

  HomeState copyWith({
    HomeStatus? status,
    String? userName,
    String? portfolioValue,
    String? changeLabel,
    bool? isPositive,
    List<double>? chartPoints,
    List<String>? yAxisLabels,
    List<String>? xAxisLabels,
    int? watchlistCount,
    int? strongBuyCount,
    int? alertCount,
    List<Stock>? top5,
    List<HomeActionItem>? actionItems,
    List<Stock>? recommendations,
  }) {
    return HomeState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      portfolioValue: portfolioValue ?? this.portfolioValue,
      changeLabel: changeLabel ?? this.changeLabel,
      isPositive: isPositive ?? this.isPositive,
      chartPoints: chartPoints ?? this.chartPoints,
      yAxisLabels: yAxisLabels ?? this.yAxisLabels,
      xAxisLabels: xAxisLabels ?? this.xAxisLabels,
      watchlistCount: watchlistCount ?? this.watchlistCount,
      strongBuyCount: strongBuyCount ?? this.strongBuyCount,
      alertCount: alertCount ?? this.alertCount,
      top5: top5 ?? this.top5,
      actionItems: actionItems ?? this.actionItems,
      recommendations: recommendations ?? this.recommendations,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userName,
    portfolioValue,
    changeLabel,
    isPositive,
    chartPoints,
    yAxisLabels,
    xAxisLabels,
    watchlistCount,
    strongBuyCount,
    alertCount,
    top5,
    actionItems,
    recommendations,
  ];
}

/// Drives Home screen UI state. Stock data comes from [StockRepository];
/// everything else (portfolio value, chart, action feed) is still
/// mock/in-memory — no backend yet.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({this._repository = const MockStockRepository()})
    : super(const HomeState()) {
    _load();
  }

  final StockRepository _repository;

  /// Curated separately from [StockRepository.topRanked] — these are
  /// "worth a look" picks distinct from the strictly rank-ordered Top 5
  /// list above, matching the "Recommended For You" mockup section.
  static const _recommendations = [
    Stock(
      ticker: 'AMZN',
      name: 'Amazon.com Inc.',
      sdkScore: 81,
      status: StockStatus.buy,
      confidence: StockConfidence.limited,
      tagline: 'Cloud + retail margin expansion',
    ),
    Stock(
      ticker: 'TSM',
      name: 'Taiwan Semiconductor',
      sdkScore: 85,
      status: StockStatus.strongBuy,
      confidence: StockConfidence.limited,
      tagline: 'Leading foundry for AI chips',
    ),
    Stock(
      ticker: 'GOOGL',
      name: 'Alphabet Inc.',
      sdkScore: 79,
      status: StockStatus.buy,
      confidence: StockConfidence.provisional,
      tagline: 'AI search moat, cheap on FCF',
    ),
  ];

  Future<void> _load() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (isClosed) return;
    // Home's preview mixes the top 4 ranked stocks with the first trim
    // candidate, matching the mockup's 5-row "Today's Top 5" list.
    final top5 = [
      ..._repository.topRanked.take(4),
      _repository.trimCandidates.first,
    ];
    emit(
      state.copyWith(
        status: HomeStatus.loaded,
        userName: 'Dr. Khan',
        portfolioValue: '\$12.84M',
        changeLabel: '+\$184,240 (1.46%)',
        isPositive: true,
        chartPoints: const [
          0.30,
          0.42,
          0.38,
          0.55,
          0.50,
          0.68,
          0.72,
          0.64,
          0.80,
          0.86,
        ],
        yAxisLabels: const ['13.0M', '12.5M', '12.0M', '11.5M'],
        xAxisLabels: const ['May 19', 'May 20', 'May 21', 'May 22', 'May 23'],
        watchlistCount: 24,
        strongBuyCount: 7,
        alertCount: 3,
        top5: top5,
        recommendations: _recommendations,
        actionItems: const [
          HomeActionItem(
            icon: Icons.trending_up_rounded,
            accentColor: Color.fromARGB(255, 1, 112, 55),
            title: 'Score Upgrade',
            detail: 'MU 82 → 87',
            subtitle: 'Micron Technology',
            timeAgo: '2h ago',
          ),
          HomeActionItem(
            icon: Icons.notifications_active_outlined,
            accentColor: Color.fromARGB(255, 255, 157, 0),
            title: 'Watchlist Alert',
            detail: 'AAPL near Buy zone',
            subtitle: 'Apple Inc.',
            timeAgo: '3h ago',
          ),
        ],
      ),
    );
  }
}
