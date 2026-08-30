import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// A single bullet within the "Why this score?" or "Material Missing
/// Factors" cards — a headline plus a supporting detail line. [icon]
/// overrides the card's default leading icon for this row.
class ScoreInsight extends Equatable {
  const ScoreInsight({required this.title, required this.detail, this.icon});

  final String title;
  final String detail;
  final IconData? icon;

  @override
  List<Object?> get props => [title, detail, icon];
}
