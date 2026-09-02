import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/stock/stock.dart';
import '../../data/repositories/stock/stock_repository.dart';

class SearchState extends Equatable {
  const SearchState({this.query = '', this.trending = const []});

  final String query;

  /// Trending stocks shown before the user types anything, and the pool
  /// [results] filters down as they search.
  final List<Stock> trending;

  /// Matches against [trending] by ticker or company name. Once a real
  /// backend exists this becomes a server-side search instead.
  List<Stock> get results {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return trending;
    return trending
        .where(
          (s) =>
              s.ticker.toLowerCase().contains(q) ||
              s.name.toLowerCase().contains(q),
        )
        .toList();
  }

  SearchState copyWith({String? query, List<Stock>? trending}) {
    return SearchState(
      query: query ?? this.query,
      trending: trending ?? this.trending,
    );
  }

  @override
  List<Object?> get props => [query, trending];
}

/// Drives the Stock Search screen. The mock universe is the same
/// [StockRepository] every other screen shares, so a ticker searched here
/// scores identically on Stock Detail.
class SearchCubit extends Cubit<SearchState> {
  SearchCubit({this._repository = const MockStockRepository()})
    : super(const SearchState()) {
    final seen = <String>{};
    final universe = [
      ..._repository.topRanked,
      ..._repository.trimCandidates,
    ].where((s) => seen.add(s.ticker)).toList();
    emit(state.copyWith(trending: universe));
  }

  final StockRepository _repository;

  void setQuery(String query) => emit(state.copyWith(query: query));
}
