import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'logic/demo_toggle/demo_toggle_cubit.dart';

void main() {
  runApp(const SdkInvestApp());
}

class SdkInvestApp extends StatelessWidget {
  const SdkInvestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DemoToggleCubit()),
      ],
      child: MaterialApp(
        title: 'SDK Investing',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        initialRoute: AppRoutes.widgetShowcase,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
