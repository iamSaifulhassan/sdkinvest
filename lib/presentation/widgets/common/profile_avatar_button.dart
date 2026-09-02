import 'package:flutter/material.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';

/// App-bar avatar icon that opens [ProfilePage]. Shared across every main
/// screen so Profile is reachable the same way everywhere.
class ProfileAvatarButton extends StatelessWidget {
  const ProfileAvatarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Profile',
      icon: Icon(Icons.account_circle_outlined, color: AppColors.textPrimary),
      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.profile),
    );
  }
}
