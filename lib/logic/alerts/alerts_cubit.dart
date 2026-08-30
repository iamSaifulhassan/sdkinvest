import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/alerts/alert_item.dart';
import '../../data/repositories/alerts/alert_repository.dart';

enum AlertsStatus { loading, loaded }

class AlertsState extends Equatable {
  const AlertsState({
    this.status = AlertsStatus.loading,
    this.filter,
    this.alerts = const [],
  });

  final AlertsStatus status;

  /// Null means "All".
  final AlertCategory? filter;
  final List<AlertItem> alerts;

  /// Alerts after applying the category filter.
  List<AlertItem> get visibleAlerts => filter == null
      ? alerts
      : alerts.where((a) => a.category == filter).toList();

  // `filter` is wrapped in a function so copyWith can tell "not passed" apart
  // from "explicitly set back to null" (plain `filter ?? this.filter` would
  // make it impossible to ever clear the filter back to "All").
  AlertsState copyWith({
    AlertsStatus? status,
    AlertCategory? Function()? filter,
    List<AlertItem>? alerts,
  }) {
    return AlertsState(
      status: status ?? this.status,
      filter: filter != null ? filter() : this.filter,
      alerts: alerts ?? this.alerts,
    );
  }

  @override
  List<Object?> get props => [status, filter, alerts];
}

/// Drives the Alerts & Signals screen. Alert data comes from
/// [AlertRepository] — no backend yet.
class AlertsCubit extends Cubit<AlertsState> {
  AlertsCubit({this.repository = const MockAlertRepository()})
    : super(const AlertsState()) {
    _load();
  }

  final AlertRepository repository;

  Future<void> _load() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (isClosed) return;
    emit(
      state.copyWith(status: AlertsStatus.loaded, alerts: repository.alerts),
    );
  }

  void setFilter(AlertCategory? category) =>
      emit(state.copyWith(filter: () => category));
}
