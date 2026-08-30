import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// One course card on the SDK Academy screen.
class Course extends Equatable {
  const Course({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.lessonCount,
    required this.durationMinutes,
    required this.progressPercent,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final int lessonCount;
  final int durationMinutes;

  /// 0-100. 0 means "not started" (button reads "Start" instead of "Continue").
  final int progressPercent;

  bool get isStarted => progressPercent > 0;

  @override
  List<Object?> get props => [icon, iconColor, title, description, lessonCount, durationMinutes, progressPercent];
}

/// A short standalone tip on the SDK Academy screen ("Quick Lessons" row).
class QuickLesson extends Equatable {
  const QuickLesson({required this.icon, required this.iconColor, required this.title, required this.durationMinutes});

  final IconData icon;
  final Color iconColor;
  final String title;
  final int durationMinutes;

  @override
  List<Object?> get props => [icon, iconColor, title, durationMinutes];
}
