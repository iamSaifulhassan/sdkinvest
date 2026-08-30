import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/factor_score.dart';
import '../../data/models/stock.dart';

enum CompareStatus { loading, loaded }

class CompareState {
  const CompareState({
    this.status = CompareStatus.loading,
    this.available = const [],
    this.selected = const [],
  });

  final CompareStatus status;

  /// Every stock the user can add to the comparison.
  final List<Stock> available;

  /// The stocks currently placed in a comparison slot (max [CompareCubit.maxSlots]).
  final List<Stock> selected;

  CompareState copyWith({
    CompareStatus? status,
    List<Stock>? available,
    List<Stock>? selected,
  }) {
    return CompareState(
      status: status ?? this.status,
      available: available ?? this.available,
      selected: selected ?? this.selected,
    );
  }
}

/// Drives the Compare Stocks screen. Selected tickers are local UI state
/// only — mock/in-memory data, no backend.
class CompareCubit extends Cubit<CompareState> {
  CompareCubit() : super(const CompareState()) {
    _load();
  }

  static const int maxSlots = 3;

  static const _stocks = [
    Stock(
      ticker: 'NVDA',
      name: 'NVIDIA Corporation',
      sdkScore: 90,
      status: StockStatus.strongBuy,
      confidence: StockConfidence.provisional,
      tagline: 'Growth + Momentum leaders',
    ),
    Stock(
      ticker: 'MU',
      name: 'Micron Technology',
      sdkScore: 87,
      status: StockStatus.strongBuy,
      confidence: StockConfidence.provisional,
      tagline: 'Improving earnings power',
    ),
    Stock(
      ticker: 'MSFT',
      name: 'Microsoft Corporation',
      sdkScore: 84,
      status: StockStatus.buy,
      confidence: StockConfidence.limited,
      tagline: 'Quality + cloud durability',
    ),
    Stock(
      ticker: 'VRT',
      name: 'Vertiv Holdings Co',
      sdkScore: 82,
      status: StockStatus.buy,
      confidence: StockConfidence.provisional,
      tagline: 'AI infrastructure demand',
    ),
    Stock(
      ticker: 'AAPL',
      name: 'Apple Inc.',
      sdkScore: 76,
      status: StockStatus.buy,
      confidence: StockConfidence.limited,
      tagline: 'Strong cash generation',
    ),
    Stock(
      ticker: 'XOM',
      name: 'Exxon Mobil Corporation',
      sdkScore: 51,
      status: StockStatus.trim,
      confidence: StockConfidence.provisional,
    ),
    Stock(
      ticker: 'CVX',
      name: 'Chevron Corporation',
      sdkScore: 53,
      status: StockStatus.trim,
      confidence: StockConfidence.provisional,
    ),
  ];

  /// 6-factor breakdown per ticker, matching the Stock Detail screen's
  /// factors for NVDA and extrapolated for the rest of the mock universe.
  static const Map<String, List<FactorScore>> _factorsByTicker = {
    'NVDA': [
      FactorScore(label: 'Valuation', value: 62),
      FactorScore(label: 'Growth', value: 96),
      FactorScore(label: 'Profitability', value: 94),
      FactorScore(label: 'Momentum', value: 92),
      FactorScore(label: 'Earnings Quality'),
      FactorScore(label: 'Financial Strength', value: 88),
    ],
    'MU': [
      FactorScore(label: 'Valuation', value: 70),
      FactorScore(label: 'Growth', value: 88),
      FactorScore(label: 'Profitability', value: 75),
      FactorScore(label: 'Momentum', value: 84),
      FactorScore(label: 'Earnings Quality', value: 65),
      FactorScore(label: 'Financial Strength', value: 80),
    ],
    'MSFT': [
      FactorScore(label: 'Valuation', value: 58),
      FactorScore(label: 'Growth', value: 79),
      FactorScore(label: 'Profitability', value: 92),
      FactorScore(label: 'Momentum', value: 74),
      FactorScore(label: 'Earnings Quality', value: 90),
      FactorScore(label: 'Financial Strength', value: 95),
    ],
    'VRT': [
      FactorScore(label: 'Valuation', value: 66),
      FactorScore(label: 'Growth', value: 91),
      FactorScore(label: 'Profitability', value: 78),
      FactorScore(label: 'Momentum', value: 88),
      FactorScore(label: 'Earnings Quality'),
      FactorScore(label: 'Financial Strength', value: 72),
    ],
    'AAPL': [
      FactorScore(label: 'Valuation', value: 60),
      FactorScore(label: 'Growth', value: 68),
      FactorScore(label: 'Profitability', value: 89),
      FactorScore(label: 'Momentum', value: 62),
      FactorScore(label: 'Earnings Quality', value: 84),
      FactorScore(label: 'Financial Strength', value: 93),
    ],
    'XOM': [
      FactorScore(label: 'Valuation', value: 82),
      FactorScore(label: 'Growth', value: 40),
      FactorScore(label: 'Profitability', value: 55),
      FactorScore(label: 'Momentum', value: 38),
      FactorScore(label: 'Earnings Quality', value: 60),
      FactorScore(label: 'Financial Strength', value: 70),
    ],
    'CVX': [
      FactorScore(label: 'Valuation', value: 79),
      FactorScore(label: 'Growth', value: 42),
      FactorScore(label: 'Profitability', value: 58),
      FactorScore(label: 'Momentum', value: 41),
      FactorScore(label: 'Earnings Quality', value: 62),
      FactorScore(label: 'Financial Strength', value: 74),
    ],
  };

  static List<FactorScore> factorsFor(String ticker) => _factorsByTicker[ticker] ?? const [];

  /// Last trade price per ticker, matching the Compare Stocks mockup for
  /// NVDA/MU/MSFT and extrapolated for the rest of the mock universe.
  static const Map<String, double> _priceByTicker = {
    'NVDA': 878.96,
    'MU': 128.54,
    'MSFT': 415.12,
    'VRT': 118.40,
    'AAPL': 192.74,
    'XOM': 108.50,
    'CVX': 152.30,
  };

  /// Analyst coverage count per ticker, shown in the comparison table.
  static const Map<String, int> _coverageByTicker = {
    'NVDA': 28,
    'MU': 24,
    'MSFT': 38,
    'VRT': 16,
    'AAPL': 42,
    'XOM': 20,
    'CVX': 19,
  };

  /// % of the SDK Score model's applicable weight covered by available data.
  static const Map<String, int> _weightByTicker = {
    'NVDA': 95,
    'MU': 85,
    'MSFT': 90,
    'VRT': 78,
    'AAPL': 88,
    'XOM': 60,
    'CVX': 58,
  };

  static double priceFor(String ticker) => _priceByTicker[ticker] ?? 0;
  static int coverageFor(String ticker) => _coverageByTicker[ticker] ?? 0;
  static int weightFor(String ticker) => _weightByTicker[ticker] ?? 0;

  Future<void> _load() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (isClosed) return;
    emit(state.copyWith(
      status: CompareStatus.loaded,
      available: _stocks,
      selected: _stocks.take(3).toList(),
    ));
  }

  void addStock(Stock stock) {
    if (state.selected.length >= maxSlots) return;
    if (state.selected.any((s) => s.ticker == stock.ticker)) return;
    emit(state.copyWith(selected: [...state.selected, stock]));
  }

  void removeStock(Stock stock) {
    emit(state.copyWith(
      selected: state.selected.where((s) => s.ticker != stock.ticker).toList(),
    ));
  }
}
