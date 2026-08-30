import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/home_action_item.dart';
import '../../data/models/stock.dart';
import 'home_state.dart';

/// Drives Home screen UI state. Mock/in-memory data only — no backend.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState()) {
    _load();
  }

  Future<void> _load() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (isClosed) return;
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
        top5: const [
          Stock(
            ticker: 'NVDA',
            name: 'NVIDIA Corporation',
            sdkScore: 90,
            status: StockStatus.strongBuy,
            confidence: StockConfidence.provisional,
          ),
          Stock(
            ticker: 'MU',
            name: 'Micron Technology',
            sdkScore: 87,
            status: StockStatus.strongBuy,
            confidence: StockConfidence.provisional,
          ),
          Stock(
            ticker: 'MSFT',
            name: 'Microsoft Corporation',
            sdkScore: 84,
            status: StockStatus.buy,
            confidence: StockConfidence.limited,
          ),
          Stock(
            ticker: 'VRT',
            name: 'Vertiv Holdings Co',
            sdkScore: 82,
            status: StockStatus.buy,
            confidence: StockConfidence.provisional,
          ),
          Stock(
            ticker: 'XOM',
            name: 'Exxon Mobil Corporation',
            sdkScore: 51,
            status: StockStatus.trim,
            confidence: StockConfidence.provisional,
          ),
        ],
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
