import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/allocation_slice.dart';
import '../../data/models/holding.dart';
import '../../data/models/stock.dart';

enum PortfolioStatus { loading, loaded }

class PortfolioState {
  const PortfolioState({
    this.status = PortfolioStatus.loading,
    this.portfolioValue = '',
    this.dayGainLabel = '',
    this.totalReturnLabel = '',
    this.isPositive = true,
    this.chartPoints = const [],
    this.yAxisLabels = const [],
    this.xAxisLabels = const [],
    this.holdingsCount = 0,
    this.cashPercentLabel = '',
    this.avgSdkScore = 0,
    this.allocation = const [],
    this.holdings = const [],
    this.rebalancingInsight = '',
  });

  final PortfolioStatus status;
  final String portfolioValue;
  final String dayGainLabel;
  final String totalReturnLabel;
  final bool isPositive;
  final List<double> chartPoints;
  final List<String> yAxisLabels;
  final List<String> xAxisLabels;
  final int holdingsCount;
  final String cashPercentLabel;
  final int avgSdkScore;
  final List<AllocationSlice> allocation;
  final List<Holding> holdings;
  final String rebalancingInsight;

  PortfolioState copyWith({
    PortfolioStatus? status,
    String? portfolioValue,
    String? dayGainLabel,
    String? totalReturnLabel,
    bool? isPositive,
    List<double>? chartPoints,
    List<String>? yAxisLabels,
    List<String>? xAxisLabels,
    int? holdingsCount,
    String? cashPercentLabel,
    int? avgSdkScore,
    List<AllocationSlice>? allocation,
    List<Holding>? holdings,
    String? rebalancingInsight,
  }) {
    return PortfolioState(
      status: status ?? this.status,
      portfolioValue: portfolioValue ?? this.portfolioValue,
      dayGainLabel: dayGainLabel ?? this.dayGainLabel,
      totalReturnLabel: totalReturnLabel ?? this.totalReturnLabel,
      isPositive: isPositive ?? this.isPositive,
      chartPoints: chartPoints ?? this.chartPoints,
      yAxisLabels: yAxisLabels ?? this.yAxisLabels,
      xAxisLabels: xAxisLabels ?? this.xAxisLabels,
      holdingsCount: holdingsCount ?? this.holdingsCount,
      cashPercentLabel: cashPercentLabel ?? this.cashPercentLabel,
      avgSdkScore: avgSdkScore ?? this.avgSdkScore,
      allocation: allocation ?? this.allocation,
      holdings: holdings ?? this.holdings,
      rebalancingInsight: rebalancingInsight ?? this.rebalancingInsight,
    );
  }
}

/// Drives the Portfolio screen. Mock/in-memory data only — no backend.
class PortfolioCubit extends Cubit<PortfolioState> {
  PortfolioCubit() : super(const PortfolioState()) {
    _load();
  }

  Future<void> _load() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (isClosed) return;
    emit(state.copyWith(
      status: PortfolioStatus.loaded,
      portfolioValue: '\$12.84M',
      dayGainLabel: '+\$184,240 (1.46%)',
      totalReturnLabel: '+18.6% YTD',
      isPositive: true,
      chartPoints: const [0.20, 0.28, 0.24, 0.38, 0.34, 0.50, 0.58, 0.52, 0.72, 0.80, 0.90, 1.0],
      yAxisLabels: const ['13.0M', '12.0M', '11.0M', '10.0M'],
      xAxisLabels: const ["'19", "'20", "'21", "'22", "'23"],
      holdingsCount: 18,
      cashPercentLabel: '4.2%',
      avgSdkScore: 78,
      allocation: const [
        AllocationSlice(label: 'Berkshire', percent: 38, color: AppColors.accentBlue),
        AllocationSlice(label: 'Semis', percent: 26, color: AppColors.accentCyan),
        AllocationSlice(label: 'Tech', percent: 20, color: AppColors.strongBuy),
        AllocationSlice(label: 'Energy', percent: 10, color: AppColors.hold),
        AllocationSlice(label: 'Other', percent: 6, color: Color(0xff8b5cf6)),
      ],
      holdings: const [
        Holding(
          ticker: 'BRK.B',
          name: 'Berkshire Hathaway',
          positionValue: '\$4.87M',
          weightPercent: 38.0,
          sdkScore: 85,
          status: StockStatus.hold,
        ),
        Holding(
          ticker: 'NVDA',
          name: 'NVIDIA Corporation',
          positionValue: '\$2.31M',
          weightPercent: 18.0,
          sdkScore: 90,
          status: StockStatus.strongBuy,
        ),
        Holding(
          ticker: 'MU',
          name: 'Micron Technology',
          positionValue: '\$1.67M',
          weightPercent: 13.0,
          sdkScore: 87,
          status: StockStatus.strongBuy,
        ),
        Holding(
          ticker: 'MSFT',
          name: 'Microsoft Corporation',
          positionValue: '\$1.28M',
          weightPercent: 10.0,
          sdkScore: 84,
          status: StockStatus.buy,
        ),
        Holding(
          ticker: 'XOM',
          name: 'Exxon Mobil Corporation',
          positionValue: '\$0.77M',
          weightPercent: 6.0,
          sdkScore: 51,
          status: StockStatus.trim,
        ),
      ],
      rebalancingInsight: 'Consider trimming XOM and adding to MU.',
    ));
  }

  Future<void> refresh() async {
    emit(state.copyWith(status: PortfolioStatus.loading));
    await _load();
  }
}
