import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/stock.dart';
import '../../logic/top5/top5_cubit.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_feedback.dart';
import '../widgets/app_shimmer_list.dart';
import '../widgets/stock_list_card.dart';
import '../widgets/trim_stock_card.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.lg,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Top 5', style: AppTextStyles.headline),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline_rounded, size: 13, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text('Updated today', style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Compare stocks',
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.compareStocks),
              icon: const Icon(Icons.compare_arrows_rounded, color: AppColors.textPrimary),
            ),
            OutlinedButton.icon(
              onPressed: () => AppFeedback.showSnackBar(context, 'Filters are coming in a later phase'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
              ),
              icon: const Icon(Icons.filter_alt_rounded, size: 16),
              label: Text('Filter', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
            ),
          ],
        ),
      ),
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
            final showRanked = state.filter != Top5Filter.trimSell;
            final showTrim = state.filter != Top5Filter.add;
            return RefreshIndicator(
              onRefresh: context.read<Top5Cubit>().refresh,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxl),
                children: [
                  _FilterBar(
                    selected: state.filter,
                    onChanged: context.read<Top5Cubit>().setFilter,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (showRanked)
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      ),
                      child: StockListCard(
                        stocks: state.topStocks,
                        showRank: true,
                        showTagline: true,
                        onTapStock: (_) => Navigator.of(context).pushNamed(AppRoutes.stockDetail),
                      ),
                    ),
                  if (showRanked && showTrim) const SizedBox(height: AppSpacing.xl),
                  if (showTrim) _TrimSection(stocks: state.trimStocks),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onChanged});

  final Top5Filter selected;
  final ValueChanged<Top5Filter> onChanged;

  static const _options = [
    (Top5Filter.all, 'All'),
    (Top5Filter.add, 'Add'),
    (Top5Filter.trimSell, 'Trim / Sell'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          for (final (filter, label) in _options)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: filter == selected ? AppColors.cream : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: filter == selected ? AppColors.ink : AppColors.textMuted,
                      fontWeight: filter == selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TrimSection extends StatelessWidget {
  const _TrimSection({required this.stocks});

  final List<Stock> stocks;

  @override
  Widget build(BuildContext context) {
    if (stocks.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Stocks to Trim / Avoid', style: AppTextStyles.title),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < stocks.length; i++) ...[
              if (i != 0) const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TrimStockCard(
                  stock: stocks[i],
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.stockDetail),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
