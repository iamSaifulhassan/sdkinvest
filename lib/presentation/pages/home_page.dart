import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../logic/home/home_cubit.dart';
import '../../logic/home/home_state.dart';
import '../widgets/action_item_tile.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_loading_indicator.dart';
import '../widgets/cream_section_card.dart';
import '../widgets/portfolio_hero_card.dart';
import '../widgets/stat_tile.dart';
import '../widgets/stock_list_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: AppSpacing.lg,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('SDK', style: AppTextStyles.wordmark),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'Investing',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary), onPressed: () {}),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.trim, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          IconButton(icon: const Icon(Icons.account_circle_outlined, color: AppColors.textPrimary), onPressed: () {}),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const Center(child: AppLoadingIndicator());
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good morning, ${state.userName}', style: AppTextStyles.title),
                  const SizedBox(height: AppSpacing.lg),
                  PortfolioHeroCard(
                    portfolioValue: state.portfolioValue,
                    changeLabel: state.changeLabel,
                    isPositive: state.isPositive,
                    chartPoints: state.chartPoints,
                    yAxisLabels: state.yAxisLabels,
                    xAxisLabels: state.xAxisLabels,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: StatTile(
                          icon: Icons.visibility_outlined,
                          label: 'Watchlist',
                          value: '${state.watchlistCount}',
                          accentColor: AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: StatTile(
                          icon: Icons.trending_up_rounded,
                          label: 'Strong Buy',
                          value: '${state.strongBuyCount}',
                          accentColor: AppColors.strongBuy,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: StatTile(
                          icon: Icons.notifications_none_rounded,
                          label: 'Alerts',
                          value: '${state.alertCount}',
                          accentColor: AppColors.trim,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CreamSectionCard(
                    title: "Today's Top 5",
                    onViewAll: () => Navigator.of(context).pushNamed(AppRoutes.top5),
                    child: StockListCard(
                      stocks: state.top5,
                      onTapStock: (_) => Navigator.of(context).pushNamed(AppRoutes.placeholderDetail),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CreamSectionCard(
                    title: 'Action Center',
                    onViewAll: () {},
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0; i < state.actionItems.length; i++) ...[
                          if (i != 0) const SizedBox(width: AppSpacing.sm),
                          Expanded(child: ActionItemTile(item: state.actionItems[i])),
                        ],
                      ],
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
