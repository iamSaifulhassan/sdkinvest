import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/course.dart';

enum LearnStatus { loading, loaded }

class LearnState extends Equatable {
  const LearnState({
    this.status = LearnStatus.loading,
    this.overallProgressPercent = 0,
    this.courses = const [],
    this.quickLessons = const [],
  });

  final LearnStatus status;
  final int overallProgressPercent;
  final List<Course> courses;
  final List<QuickLesson> quickLessons;

  LearnState copyWith({
    LearnStatus? status,
    int? overallProgressPercent,
    List<Course>? courses,
    List<QuickLesson>? quickLessons,
  }) {
    return LearnState(
      status: status ?? this.status,
      overallProgressPercent:
          overallProgressPercent ?? this.overallProgressPercent,
      courses: courses ?? this.courses,
      quickLessons: quickLessons ?? this.quickLessons,
    );
  }

  @override
  List<Object?> get props => [
    status,
    overallProgressPercent,
    courses,
    quickLessons,
  ];
}

/// Drives the SDK Academy screen. Mock/in-memory data only — no backend.
class LearnCubit extends Cubit<LearnState> {
  LearnCubit() : super(const LearnState()) {
    _load();
  }

  Future<void> _load() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (isClosed) return;
    emit(
      state.copyWith(
        status: LearnStatus.loaded,
        overallProgressPercent: 42,
        courses: const [
          Course(
            icon: Icons.account_balance_rounded,
            iconColor: AppColors.strongBuy,
            title: 'SDK Foundations',
            description: 'Build a strong foundation in the SDK System and scoring model.',
            lessonCount: 6,
            durationMinutes: 25,
            progressPercent: 60,
          ),
          Course(
            icon: Icons.filter_6_rounded,
            iconColor: AppColors.strongBuy,
            title: 'Understanding the 6 Factors',
            description:
                'Deep dive into each factor and how they impact stock quality.',
            lessonCount: 8,
            durationMinutes: 32,
            progressPercent: 35,
          ),
          Course(
            icon: Icons.star_rounded,
            iconColor: AppColors.accentBlue,
            title: 'Using Top 5 & Watchlists',
            description:
                'How to find, track, and act on the best opportunities.',
            lessonCount: 5,
            durationMinutes: 18,
            progressPercent: 0,
          ),
          Course(
            icon: Icons.pie_chart_rounded,
            iconColor: AppColors.accentPurple,
            title: 'Portfolio Decision Framework',
            description:
                'Make confident decisions with Buy, Hold, Trim, and Sell.',
            lessonCount: 7,
            durationMinutes: 28,
            progressPercent: 0,
          ),
        ],
        quickLessons: const [
          QuickLesson(
            icon: Icons.help_outline_rounded,
            iconColor: AppColors.strongBuy,
            title: 'What Provisional means',
            durationMinutes: 3,
          ),
          QuickLesson(
            icon: Icons.shield_outlined,
            iconColor: AppColors.strongBuy,
            title: 'How confidence works',
            durationMinutes: 4,
          ),
          QuickLesson(
            icon: Icons.show_chart_rounded,
            iconColor: AppColors.accentBlue,
            title: 'Reading score trends',
            durationMinutes: 3,
          ),
        ],
      ),
    );
  }
}
