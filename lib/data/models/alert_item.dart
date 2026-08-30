import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'stock.dart';

/// Which segment of the Alerts & Signals filter bar an alert belongs to.
enum AlertCategory { upgrade, downgrade, priceAlert }

/// A single row on the Alerts & Signals screen — a score change, a price
/// zone trigger, or a "still rated X" reminder.
class AlertItem extends Equatable {
  const AlertItem({
    required this.category,
    required this.ticker,
    required this.companyName,
    required this.title,
    required this.reason,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
    this.status,
  });

  final AlertCategory category;
  final String ticker;
  final String companyName;

  /// The bolded headline, e.g. "MU upgraded 82 → 87" or "AAPL entered Buy Zone".
  final String title;
  final String reason;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;

  /// Recommendation pill shown at the trailing edge. Null when the alert
  /// isn't tied to a specific action rating (e.g. a price-zone trigger).
  final StockStatus? status;

  @override
  List<Object?> get props => [
    category,
    ticker,
    companyName,
    title,
    reason,
    timeAgo,
    icon,
    iconColor,
    status,
  ];
}
