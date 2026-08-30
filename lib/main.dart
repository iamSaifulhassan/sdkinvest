import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'logic/auth/auth_cubit.dart';
import 'presentation/auth_gate.dart';

void main() {
  runApp(const SdkInvestApp());
}

class SdkInvestApp extends StatelessWidget {
  const SdkInvestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // The one cubit provided above the app shell — session status is
      // genuinely global, unlike every screen-level cubit below it.
      create: (_) => AuthCubit(),
      child: MaterialApp(
        title: 'SDK Investing',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const AuthGate(),
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
