import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../logic/learn/learn_cubit.dart';
import '../widgets/learn/academy_hero_card.dart';
import '../widgets/common/app_bottom_nav.dart';
import '../widgets/common/app_shimmer_list.dart';
import '../widgets/learn/course_card.dart';
import '../widgets/learn/quick_lesson_tile.dart';

/// SDK Academy screen — learning progress, featured courses, and quick tips.
class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => LearnCubit(), child: const _LearnView());
  }
}

class _LearnView extends StatelessWidget {
  const _LearnView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: AppSpacing.lg,
        title: Text(
          'SDK Academy',
          style: AppTextStyles.headline.copyWith(fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.bookmark_border_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
      body: SafeArea(
        child: BlocBuilder<LearnCubit, LearnState>(
          builder: (context, state) {
            if (state.status == LearnStatus.loading) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: AppShimmerList(itemCount: 4),
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xxl,
              ),
              children: [
                AcademyHeroCard(progressPercent: state.overallProgressPercent),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Featured Courses',
                  style: AppTextStyles.title.copyWith(fontSize: 16),
                ),
                const SizedBox(height: AppSpacing.sm),
                for (var i = 0; i < state.courses.length; i++) ...[
                  if (i != 0) const SizedBox(height: AppSpacing.sm),
                  CourseCard(course: state.courses[i]),
                ],
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quick Lessons',
                      style: AppTextStyles.title.copyWith(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                      child: Text(
                        'View All',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < state.quickLessons.length; i++) ...[
                        if (i != 0) const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: QuickLessonTile(lesson: state.quickLessons[i]),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
