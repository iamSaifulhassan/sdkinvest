import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../logic/portfolio/portfolio_cubit.dart';
import '../widgets/allocation_donut_card.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_shimmer_list.dart';
import '../widgets/holdings_table.dart';
import '../widgets/portfolio_hero_card.dart';
import '../widgets/rebalancing_insight_card.dart';
import '../widgets/stat_tile.dart';

/// Portfolio screen — total value + return, allocation breakdown, full
/// holdings table, and a rebalancing suggestion.
class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PortfolioCubit(),
      child: const _PortfolioView(),
    );
  }
}

class _PortfolioView extends StatelessWidget {
  const _PortfolioView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: AppSpacing.lg,
        title: Text('Portfolio', style: AppTextStyles.headline.copyWith(fontSize: 22)),
        actions: [
          IconButton(icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.textPrimary), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary), onPressed: () {}),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: SafeArea(
        child: BlocBuilder<PortfolioCubit, PortfolioState>(
          builder: (context, state) {
            if (state.status == PortfolioStatus.loading) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: AppShimmerList(itemCount: 4),
              );
            }
            return RefreshIndicator(
              onRefresh: context.read<PortfolioCubit>().refresh,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxl),
                children: [
                  PortfolioHeroCard(
                    portfolioValue: state.portfolioValue,
                    changeLabel: state.dayGainLabel,
                    isPositive: state.isPositive,
                    chartPoints: state.chartPoints,
                    yAxisLabels: state.yAxisLabels,
                    xAxisLabels: state.xAxisLabels,
                    changeCaption: 'Day Gain',
                    secondaryCaption: 'Total Return',
                    secondaryValue: state.totalReturnLabel,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: StatTile(
                          icon: Icons.work_outline_rounded,
                          label: 'Holdings',
                          value: '${state.holdingsCount}',
                          accentColor: AppColors.accentBlue,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: StatTile(
                          icon: Icons.attach_money_rounded,
                          label: 'Cash',
                          value: state.cashPercentLabel,
                          accentColor: AppColors.strongBuy,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: StatTile(
                          icon: Icons.star_outline_rounded,
                          label: 'Avg SDK Score',
                          value: '${state.avgSdkScore}',
                          accentColor: AppColors.accentPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AllocationDonutCard(slices: state.allocation),
                  const SizedBox(height: AppSpacing.lg),
                  HoldingsTable(holdings: state.holdings),
                  const SizedBox(height: AppSpacing.lg),
                  RebalancingInsightCard(insight: state.rebalancingInsight),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
