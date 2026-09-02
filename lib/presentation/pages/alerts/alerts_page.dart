import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/alerts/alert_item.dart';
import '../../../logic/alerts/alerts_cubit.dart';
import '../../widgets/alerts/alert_card.dart';
import '../../widgets/alerts/alert_summary_tile.dart';
import '../../widgets/common/app_bottom_nav.dart';
import '../../widgets/common/app_brand_logo.dart';
import '../../widgets/common/app_shimmer_list.dart';
import '../../widgets/common/theme_toggle_button.dart';

/// Alerts & Signals screen — score-change/upgrade-downgrade/price-zone
/// notifications, filterable by category. Alert data comes from
/// [AlertsCubit] (backed by the shared mock [AlertRepository]).
class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlertsCubit(),
      child: const _AlertsView(),
    );
  }
}

class _AlertsView extends StatelessWidget {
  const _AlertsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: AppSpacing.lg,
        title: const AppBrandLogo(),
        actions: [
          // No bell icon here — this already is the notifications screen.
          const ThemeToggleButton(),
          IconButton(
            icon: Icon(
              Icons.account_circle_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.profile),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: SafeArea(
        child: BlocBuilder<AlertsCubit, AlertsState>(
          builder: (context, state) {
            if (state.status == AlertsStatus.loading) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: AppShimmerList(itemCount: 5),
              );
            }

            final alerts = state.alerts;
            final upgrades = alerts
                .where((a) => a.category == AlertCategory.upgrade)
                .length;
            final downgrades = alerts
                .where((a) => a.category == AlertCategory.downgrade)
                .length;
            final priceAlerts = alerts
                .where((a) => a.category == AlertCategory.priceAlert)
                .length;
            final visibleAlerts = state.visibleAlerts;
            final setFilter = context.read<AlertsCubit>().setFilter;

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xxl,
              ),
              children: [
                Text('Alerts & Signals', style: AppTextStyles.headline),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _FilterChip(
                              label: 'All',
                              selected: state.filter == null,
                              onTap: () => setFilter(null),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _FilterChip(
                              label: 'Upgrades',
                              selected: state.filter == AlertCategory.upgrade,
                              onTap: () => setFilter(AlertCategory.upgrade),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _FilterChip(
                              label: 'Downgrades',
                              selected: state.filter == AlertCategory.downgrade,
                              onTap: () => setFilter(AlertCategory.downgrade),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _FilterChip(
                              label: 'Price Alerts',
                              selected:
                                  state.filter == AlertCategory.priceAlert,
                              onTap: () => setFilter(AlertCategory.priceAlert),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Icon(
                        Icons.filter_alt_rounded,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: AlertSummaryTile(
                        icon: Icons.trending_up_rounded,
                        count: upgrades,
                        label: 'Upgrades',
                        accentColor: AppColors.strongBuy,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AlertSummaryTile(
                        icon: Icons.trending_down_rounded,
                        count: downgrades,
                        label: 'Downgrades',
                        accentColor: AppColors.trim,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AlertSummaryTile(
                        icon: Icons.notifications_none_rounded,
                        count: priceAlerts,
                        label: 'Price Alerts',
                        accentColor: AppColors.hold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                for (var i = 0; i < visibleAlerts.length; i++) ...[
                  if (i != 0) const SizedBox(height: AppSpacing.sm),
                  AlertCard(alert: visibleAlerts[i]),
                ],
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: Text(
                    "You're all caught up!\nWe'll notify you as new alerts and signals arrive.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentBlue : AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.accentBlue : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontSize: 12.5,
            color: selected ? Colors.white : AppColors.textMuted,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
