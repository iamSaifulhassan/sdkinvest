import 'package:equatable/equatable.dart';

/// One of the 6 factors behind a stock's SDK Score. [value] is null when
/// the factor couldn't be scored (shown as "Missing" instead of a number).
class FactorScore extends Equatable {
  const FactorScore({required this.label, this.value});

  final String label;
  final int? value;

  bool get isMissing => value == null;

  @override
  List<Object?> get props => [label, value];
}
