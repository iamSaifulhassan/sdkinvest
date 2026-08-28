import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../logic/top5/top5_cubit.dart';
import '../widgets/app_bar_custom.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_shimmer_list.dart';
import '../widgets/stock_list_card.dart';

class Top5Page extends StatelessWidget {
  const Top5Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Top5Cubit(),
      child: const _Top5View(),
    );
  }
}

class _Top5View extends StatelessWidget {
  const _Top5View();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Top 5'),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: SafeArea(
        child: BlocBuilder<Top5Cubit, Top5State>(
          builder: (context, state) {
            if (state.status == Top5Status.loading) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: AppShimmerList(itemCount: 5),
              );
            }
            if (state.stocks.isEmpty) {
              return Center(
                child: Text('No results yet', style: AppTextStyles.caption),
              );
            }
            return RefreshIndicator(
              onRefresh: context.read<Top5Cubit>().refresh,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    child: StockListCard(
                      stocks: state.stocks,
                      showRank: true,
                      onTapStock: (_) => Navigator.of(context).pushNamed(AppRoutes.placeholderDetail),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
