import 'package:equatable/equatable.dart';

/// SDK Score action recommendation — drives the status-pill color/label.
enum StockStatus { strongBuy, buy, hold, trim }

/// How much data backs the current score — shown as a small trailing tag.
enum StockConfidence { provisional, limited, verified }

extension StockConfidenceLabel on StockConfidence {
  String get label => switch (this) {
        StockConfidence.provisional => 'Provisional',
        StockConfidence.limited => 'Limited',
        StockConfidence.verified => 'Verified',
      };
}

class Stock extends Equatable {
  const Stock({
    required this.ticker,
    required this.name,
    required this.sdkScore,
    required this.status,
    required this.confidence,
    this.tagline,
  });

  final String ticker;
  final String name;

  /// 0-100 SDK Score driving the recommendation.
  final int sdkScore;
  final StockStatus status;
  final StockConfidence confidence;

  /// Short one-line rationale shown under the row on ranked lists (e.g.
  /// "Growth + Momentum leaders"). Null where the layout has no room for it.
  final String? tagline;

  @override
  List<Object?> get props => [ticker, name, sdkScore, status, confidence, tagline];
}
