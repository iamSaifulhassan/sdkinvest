import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// One slide of the first-launch onboarding carousel. Each slide carries
/// its own accent (drawn from the app's real status palette — strongBuy,
/// accentBlue, accentPurple) rather than repeating one color three times,
/// so the carousel reads as three distinct ideas instead of one template.
class OnboardingSlide extends Equatable {
  const OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color accent;

  @override
  List<Object?> get props => [icon, title, description, accent];
}
