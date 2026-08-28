import 'package:equatable/equatable.dart';
import '../../data/models/home_action_item.dart';
import '../../data/models/stock.dart';

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
      ];
}
