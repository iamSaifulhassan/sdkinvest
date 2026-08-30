import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// One wedge of the Portfolio screen's allocation donut chart.
class AllocationSlice extends Equatable {
  const AllocationSlice({
    required this.label,
    required this.percent,
    required this.color,
  });

  final String label;
  final double percent;
  final Color color;

  @override
  List<Object?> get props => [label, percent, color];
}
