import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/stock/stock.dart';
import '../../data/repositories/stock/stock_repository.dart';

enum CompareStatus { loading, loaded }

class CompareState extends Equatable {
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

  @override
  List<Object?> get props => [status, available, selected];
}

/// Drives the Compare Stocks screen. Selected tickers are local UI state;
/// the stock/factor/price data itself comes from [StockRepository].
class CompareCubit extends Cubit<CompareState> {
  CompareCubit({this.repository = const MockStockRepository()})
    : super(const CompareState()) {
    _load();
  }

  /// Exposed so the page's read-only lookups (factors/price/coverage/weight
  /// for a given ticker) can go through the same repository instance
  /// without needing to duplicate cubit state for pure display data.
  final StockRepository repository;

  static const int maxSlots = 3;

  Future<void> _load() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (isClosed) return;
    final universe = [...repository.topRanked, ...repository.trimCandidates];
    emit(
      state.copyWith(
        status: CompareStatus.loaded,
        available: universe,
        selected: universe.take(3).toList(),
      ),
    );
  }

  void addStock(Stock stock) {
    if (state.selected.length >= maxSlots) return;
    if (state.selected.any((s) => s.ticker == stock.ticker)) return;
    emit(state.copyWith(selected: [...state.selected, stock]));
  }

  void removeStock(Stock stock) {
    emit(
      state.copyWith(
        selected: state.selected
            .where((s) => s.ticker != stock.ticker)
            .toList(),
      ),
    );
  }
}
