import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// A single Action Center tile on Home (score upgrade, watchlist alert, etc).
class HomeActionItem extends Equatable {
  const HomeActionItem({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.detail,
    required this.subtitle,
    required this.timeAgo,
  });

  final IconData icon;
  final Color accentColor;
  final String title;
  final String detail;
  final String subtitle;
  final String timeAgo;

  @override
  List<Object?> get props => [icon, accentColor, title, detail, subtitle, timeAgo];
}
