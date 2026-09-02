import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'logic/auth/auth_cubit.dart';
import 'logic/theme/theme_cubit.dart';
import 'presentation/auth_gate.dart';

void main() {
  runApp(const SdkInvestApp());
}

class SdkInvestApp extends StatefulWidget {
  const SdkInvestApp({super.key});

  @override
  State<SdkInvestApp> createState() => _SdkInvestAppState();
}

class _SdkInvestAppState extends State<SdkInvestApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Nothing here reads ThemeCubit's state (it's ThemeMode.system by
    // default), so when the OS flips light/dark this is the only thing
    // that would otherwise tell the app to rebuild.
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // The two cubits provided above the app shell — session status and
        // theme are genuinely global, unlike every screen-level cubit below.
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          final isDark = switch (mode) {
            ThemeMode.dark => true,
            ThemeMode.light => false,
            ThemeMode.system =>
              WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                  Brightness.dark,
          };
          // AppColors' getters read this flag rather than Theme.of(context),
          // so every screen (which reads AppColors directly) needs it set
          // before build — and the ValueKey forces the whole subtree to
          // rebuild from scratch so those getters are re-evaluated, since
          // a static flag flip alone wouldn't otherwise trigger a rebuild.
          AppColors.isDark = isDark;
          return MaterialApp(
            key: ValueKey(isDark),
            title: 'SDK Investing',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.current,
            home: const AuthGate(),
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
