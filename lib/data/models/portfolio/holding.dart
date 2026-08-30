import 'package:equatable/equatable.dart';

import 'stock.dart';

/// One position in the Portfolio screen's holdings table.
class Holding extends Equatable {
  const Holding({
    required this.ticker,
    required this.name,
    required this.positionValue,
    required this.weightPercent,
    required this.sdkScore,
    required this.status,
  });

  final String ticker;
  final String name;

  /// Dollar value of the position, already formatted (e.g. "\$4.87M").
  final String positionValue;

  /// % of the total portfolio this position represents.
  final double weightPercent;

  final int sdkScore;
  final StockStatus status;

  @override
  List<Object?> get props => [
    ticker,
    name,
    positionValue,
    weightPercent,
    sdkScore,
    status,
  ];
}
