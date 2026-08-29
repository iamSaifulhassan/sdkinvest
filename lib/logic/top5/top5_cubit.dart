import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/stock.dart';

enum Top5Status { loading, loaded }

/// Which section(s) the segmented control is showing.
enum Top5Filter { all, add, trimSell }

class Top5State {
  const Top5State({
    this.status = Top5Status.loading,
    this.filter = Top5Filter.all,
    this.topStocks = const [],
    this.trimStocks = const [],
  });

  final Top5Status status;
  final Top5Filter filter;

  /// The main ranked "buy/strong buy" list.
  final List<Stock> topStocks;

  /// The separate "Stocks to Trim / Avoid" list.
  final List<Stock> trimStocks;

  Top5State copyWith({
    Top5Status? status,
    Top5Filter? filter,
    List<Stock>? topStocks,
    List<Stock>? trimStocks,
  }) {
    return Top5State(
      status: status ?? this.status,
      filter: filter ?? this.filter,
      topStocks: topStocks ?? this.topStocks,
      trimStocks: trimStocks ?? this.trimStocks,
    );
  }
}

/// Drives the Top 5 screen's ranked list. Mock/in-memory data only — no backend.
class Top5Cubit extends Cubit<Top5State> {
  Top5Cubit() : super(const Top5State()) {
    _load();
  }

  Future<void> _load() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (isClosed) return;
    emit(state.copyWith(
      status: Top5Status.loaded,
      topStocks: const [
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
      ],
      trimStocks: const [
        Stock(ticker: 'XOM', name: 'Exxon Mobil Corporation', sdkScore: 51, status: StockStatus.trim, confidence: StockConfidence.provisional),
        Stock(ticker: 'CVX', name: 'Chevron Corporation', sdkScore: 53, status: StockStatus.trim, confidence: StockConfidence.provisional),
      ],
    ));
  }

  void setFilter(Top5Filter filter) => emit(state.copyWith(filter: filter));

  Future<void> refresh() async {
    emit(state.copyWith(status: Top5Status.loading));
    await _load();
  }
}
