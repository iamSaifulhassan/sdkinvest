import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/course.dart';

/// A single row on the "Featured Courses" list: icon, title/description,
/// Continue/Start button, and lesson-count/duration/progress meta line.
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course, this.onTap});

  final Course course;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: course.iconColor.withValues(alpha: 0.16),
                child: Icon(course.icon, size: 20, color: course.iconColor),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(course.title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(course.description, style: AppTextStyles.caption.copyWith(fontSize: 11.5, height: 1.3)),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(Icons.menu_book_outlined, size: 12, color: AppColors.textMuted),
                        const SizedBox(width: 3),
                        Text('${course.lessonCount} Lessons', style: AppTextStyles.caption.copyWith(fontSize: 10.5)),
                        const SizedBox(width: AppSpacing.sm),
                        Icon(Icons.schedule_rounded, size: 12, color: AppColors.textMuted),
                        const SizedBox(width: 3),
                        Text('${course.durationMinutes} min', style: AppTextStyles.caption.copyWith(fontSize: 10.5)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: onTap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.strongBuy,
                      side: BorderSide(color: AppColors.strongBuy),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      course.isStarted ? 'Continue' : 'Start',
                      style: AppTextStyles.caption.copyWith(color: AppColors.strongBuy, fontWeight: FontWeight.w700, fontSize: 11.5),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('${course.progressPercent}%', style: AppTextStyles.caption.copyWith(fontSize: 10.5)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
