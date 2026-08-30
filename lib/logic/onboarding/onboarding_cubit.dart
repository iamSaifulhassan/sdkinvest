import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/onboarding/onboarding_slide.dart';

class OnboardingState extends Equatable {
  const OnboardingState({this.pageIndex = 0, this.slides = const []});

  final int pageIndex;
  final List<OnboardingSlide> slides;

  bool get isLastPage => pageIndex >= slides.length - 1;

  OnboardingState copyWith({int? pageIndex, List<OnboardingSlide>? slides}) {
    return OnboardingState(
      pageIndex: pageIndex ?? this.pageIndex,
      slides: slides ?? this.slides,
    );
  }

  @override
  List<Object?> get props => [pageIndex, slides];
}

/// Drives the onboarding carousel's current page. Slide copy is static
/// (not user data), so it's seeded directly rather than pulled through a
/// repository — same reasoning as [SubscriptionCubit]'s plan list.
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit()
    : super(
        const OnboardingState(
          slides: [
            OnboardingSlide(
              icon: Icons.insights_rounded,
              title: 'Know exactly when to act',
              description: 'The SDK Score distills growth, momentum, valuation, and more into one clear Buy, Hold, Trim, or Sell call.',
              accent: AppColors.strongBuy,
            ),
            OnboardingSlide(
              icon: Icons.pie_chart_rounded,
              title: 'Your whole portfolio, one view',
              description: 'Track holdings, allocation, and performance alongside a watchlist that flags opportunities as they emerge.',
              accent: AppColors.accentBlue,
            ),
            OnboardingSlide(
              icon: Icons.notifications_active_rounded,
              title: 'Never miss a score change',
              description: 'Get notified the moment a stock upgrades, downgrades, or enters your buy zone.',
              accent: AppColors.accentPurple,
            ),
          ],
        ),
      );

  void setPage(int index) => emit(state.copyWith(pageIndex: index));

  void next() {
    if (state.isLastPage) return;
    emit(state.copyWith(pageIndex: state.pageIndex + 1));
  }
}
