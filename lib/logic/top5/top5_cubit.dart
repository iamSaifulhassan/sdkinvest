import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/stock.dart';

enum Top5Status { loading, loaded }

class Top5State {
  const Top5State({this.status = Top5Status.loading, this.stocks = const []});

  final Top5Status status;
  final List<Stock> stocks;

  Top5State copyWith({Top5Status? status, List<Stock>? stocks}) {
    return Top5State(status: status ?? this.status, stocks: stocks ?? this.stocks);
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
      stocks: const [
        Stock(ticker: 'NVDA', name: 'NVIDIA Corporation', sdkScore: 90, status: StockStatus.strongBuy, confidence: StockConfidence.provisional),
        Stock(ticker: 'MU', name: 'Micron Technology', sdkScore: 87, status: StockStatus.strongBuy, confidence: StockConfidence.provisional),
        Stock(ticker: 'MSFT', name: 'Microsoft Corporation', sdkScore: 84, status: StockStatus.buy, confidence: StockConfidence.limited),
        Stock(ticker: 'VRT', name: 'Vertiv Holdings Co', sdkScore: 82, status: StockStatus.buy, confidence: StockConfidence.provisional),
        Stock(ticker: 'XOM', name: 'Exxon Mobil Corporation', sdkScore: 51, status: StockStatus.trim, confidence: StockConfidence.provisional),
      ],
    ));
  }

  Future<void> refresh() async {
    emit(state.copyWith(status: Top5Status.loading));
    await _load();
  }
}
