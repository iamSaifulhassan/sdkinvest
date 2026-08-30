import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/onboarding/onboarding_slide.dart';
import '../../../logic/auth/auth_cubit.dart';
import '../../../logic/onboarding/onboarding_cubit.dart';
import '../../widgets/common/app_primary_button.dart';
import '../../widgets/onboarding/onboarding_dots.dart';

/// First-launch carousel. [OnboardingCubit] is the source of truth for
/// which page is active; the [PageController] here just animates to
/// whatever index the cubit reports, so the two never disagree about
/// "current page" (see [_OnboardingViewState.build]).
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<OnboardingCubit, OnboardingState>(
          listenWhen: (previous, current) =>
              previous.pageIndex != current.pageIndex,
          listener: (context, state) {
            if (_pageController.hasClients &&
                _pageController.page?.round() != state.pageIndex) {
              _pageController.animateToPage(
                state.pageIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    child: TextButton(
                      onPressed: () =>
                          context.read<AuthCubit>().completeOnboarding(),
                      child: Text(
                        'Skip',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: state.slides.length,
                    onPageChanged: (index) =>
                        context.read<OnboardingCubit>().setPage(index),
                    itemBuilder: (context, index) =>
                        _SlideContent(slide: state.slides[index]),
                  ),
                ),
                OnboardingDots(
                  count: state.slides.length,
                  activeIndex: state.pageIndex,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: AppPrimaryButton(
                    label: state.isLastPage ? 'Get Started' : 'Next',
                    onPressed: () {
                      if (state.isLastPage) {
                        context.read<AuthCubit>().completeOnboarding();
                      } else {
                        context.read<OnboardingCubit>().next();
                      }
                    },
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

class _SlideContent extends StatelessWidget {
  const _SlideContent({required this.slide});

  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 176,
            height: 176,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Soft ambient glow behind the badge, rather than one flat
                // tint circle repeated on every slide.
                Container(
                  width: 176,
                  height: 176,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        slide.accent.withValues(alpha: 0.22),
                        slide.accent.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: slide.accent.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(slide.icon, size: 48, color: slide.accent),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.headline.copyWith(fontSize: 24),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            slide.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
