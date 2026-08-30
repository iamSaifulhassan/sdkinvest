import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../logic/watchlist/watchlist_cubit.dart';
import '../widgets/alert_card.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_shimmer_list.dart';
import '../widgets/watchlist_row.dart';

/// Watchlist screen — searchable, filterable list of tracked stocks with
/// live price/score/signal, plus a compact "Active Alerts" preview.
class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WatchlistCubit(),
      child: const _WatchlistView(),
    );
  }
}

class _WatchlistView extends StatelessWidget {
  const _WatchlistView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
            Text('Investing', style: AppTextStyles.body.copyWith(color: AppColors.textPrimary)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.textPrimary), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search_rounded, color: AppColors.textPrimary), onPressed: () {}),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: SafeArea(
        child: BlocBuilder<WatchlistCubit, WatchlistState>(
          builder: (context, state) {
            if (state.status == WatchlistStatus.loading) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: AppShimmerList(itemCount: 6),
              );
            }
            final visible = state.visibleItems;
            return ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxl),
              children: [
                Text('Watchlist', style: AppTextStyles.headline.copyWith(fontSize: 22)),
                const SizedBox(height: AppSpacing.md),
                _SearchField(onChanged: context.read<WatchlistCubit>().setQuery),
                const SizedBox(height: AppSpacing.md),
                _FilterBar(selected: state.filter, onChanged: context.read<WatchlistCubit>().setFilter),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: visible.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                          child: Center(
                            child: Text('No matching stocks', style: AppTextStyles.caption),
                          ),
                        )
                      : Column(
                          children: [
                            for (var i = 0; i < visible.length; i++) ...[
                              if (i != 0) Divider(height: 1, color: AppColors.border),
                              WatchlistRow(item: visible[i]),
                            ],
                          ],
                        ),
                ),
                if (state.activeAlerts.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Active Alerts', style: AppTextStyles.title.copyWith(fontSize: 15)),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                        child: Text('View All', style: AppTextStyles.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < state.activeAlerts.length; i++) ...[
                          if (i != 0) const SizedBox(width: AppSpacing.sm),
                          Expanded(child: AlertCard(alert: state.activeAlerts[i])),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: AppTextStyles.body.copyWith(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Search ticker or company',
        hintStyle: AppTextStyles.caption,
        prefixIcon: Icon(Icons.search_rounded, size: 20, color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onChanged});

  final WatchlistFilter selected;
  final ValueChanged<WatchlistFilter> onChanged;

  static const _options = [
    (WatchlistFilter.all, 'All'),
    (WatchlistFilter.nearBuy, 'Near Buy'),
    (WatchlistFilter.alerts, 'Alerts'),
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
                    color: filter == selected ? AppColors.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: filter == selected ? Colors.white : AppColors.textMuted,
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
