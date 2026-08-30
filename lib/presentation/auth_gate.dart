import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/routing/app_router.dart';
import '../core/routing/app_routes.dart';
import '../logic/auth/auth_cubit.dart';
import 'pages/home/home_page.dart';

/// App root: swaps between the pre-auth flow (Onboarding → Login/Signup)
/// and the main app shell based on [AuthCubit]'s status.
///
/// Pre-auth screens get their own nested [Navigator] rather than living on
/// the app's root route. Without that, Login's `pushReplacementNamed` to
/// Signup would replace THIS widget on the root Navigator and destroy the
/// gate — nesting keeps that back-and-forth contained, while a fresh
/// [ValueKey] per [AuthStatus] discards the nested stack (so a completed
/// Onboarding never lingers underneath Login, and Login/Signup never
/// linger underneath Home after a successful sign-in).
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          return const HomePage();
        }
        final initialRoute = state.status == AuthStatus.onboarding
            ? AppRoutes.onboarding
            : AppRoutes.login;
        return Navigator(
          key: ValueKey(state.status),
          initialRoute: initialRoute,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}
