import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/stock/stock.dart';
import '../../data/repositories/stock/stock_repository.dart';

enum Top5Status { loading, loaded }

/// Which section(s) the segmented control is showing.
enum Top5Filter { all, add, trimSell }

class Top5State extends Equatable {
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

  @override
  List<Object?> get props => [status, filter, topStocks, trimStocks];
}

/// Drives the Top 5 screen's ranked list. Stock data comes from
/// [StockRepository] — no backend yet.
class Top5Cubit extends Cubit<Top5State> {
  Top5Cubit({this._repository = const MockStockRepository()})
    : super(const Top5State()) {
    _load();
  }

  final StockRepository _repository;

  Future<void> _load() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (isClosed) return;
    emit(
      state.copyWith(
        status: Top5Status.loaded,
        topStocks: _repository.topRanked,
        trimStocks: _repository.trimCandidates,
      ),
    );
  }

  void setFilter(Top5Filter filter) => emit(state.copyWith(filter: filter));

  Future<void> refresh() async {
    emit(state.copyWith(status: Top5Status.loading));
    await _load();
  }
}
