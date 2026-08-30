import 'package:flutter/material.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/alert_item.dart';
import '../../data/models/stock.dart';
import '../widgets/alert_card.dart';
import '../widgets/alert_summary_tile.dart';
import '../widgets/app_bottom_nav.dart';

/// Alerts & Signals screen — score-change/upgrade-downgrade/price-zone
/// notifications, filterable by category. Currently backed by static demo
/// data matching the mockup.
class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  AlertCategory? _filter;

  static const _alerts = [
    AlertItem(
      category: AlertCategory.upgrade,
      ticker: 'MU',
      companyName: 'Micron Technology',
      title: 'MU upgraded 82 → 87',
      reason: 'Momentum + earnings improved',
      timeAgo: '2hr ago',
      icon: Icons.trending_up_rounded,
      iconColor: AppColors.strongBuy,
      status: StockStatus.strongBuy,
    ),
    AlertItem(
      category: AlertCategory.priceAlert,
      ticker: 'AAPL',
      companyName: 'Apple Inc.',
      title: 'AAPL entered Buy zone',
      reason: 'Price moved into our Buy zone',
      timeAgo: '3hr ago',
      icon: Icons.adjust_rounded,
      iconColor: AppColors.accentCyan,
    ),
    AlertItem(
      category: AlertCategory.downgrade,
      ticker: 'XOM',
      companyName: 'Exxon Mobil Corporation',
      title: 'XOM downgraded 58 → 51',
      reason: 'Revenue and EPS weakened',
      timeAgo: '5hr ago',
      icon: Icons.trending_down_rounded,
      iconColor: AppColors.trim,
      status: StockStatus.trim,
    ),
    AlertItem(
      category: AlertCategory.priceAlert,
      ticker: 'NVDA',
      companyName: 'NVIDIA Corporation',
      title: 'NVDA remains Strong Buy',
      reason: 'Strong momentum and outlook intact',
      timeAgo: '7hr ago',
      icon: Icons.verified_rounded,
      iconColor: AppColors.accentBlue,
      status: StockStatus.strongBuy,
    ),
    AlertItem(
      category: AlertCategory.upgrade,
      ticker: 'RKLB',
      companyName: 'Rocket Lab USA, Inc.',
      title: 'RKLB upgraded to 78',
      reason: 'Launch cadence and backlog growth',
      timeAgo: '9hr ago',
      icon: Icons.trending_up_rounded,
      iconColor: AppColors.strongBuy,
      status: StockStatus.buy,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final upgrades = _alerts.where((a) => a.category == AlertCategory.upgrade).length;
    final downgrades = _alerts.where((a) => a.category == AlertCategory.downgrade).length;
    final priceAlerts = _alerts.where((a) => a.category == AlertCategory.priceAlert).length;
    final visibleAlerts = _filter == null ? _alerts : _alerts.where((a) => a.category == _filter).toList();

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
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.subscription),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxl),
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
                        _FilterChip(label: 'All', selected: _filter == null, onTap: () => setState(() => _filter = null)),
                        const SizedBox(width: AppSpacing.sm),
                        _FilterChip(
                          label: 'Upgrades',
                          selected: _filter == AlertCategory.upgrade,
                          onTap: () => setState(() => _filter = AlertCategory.upgrade),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _FilterChip(
                          label: 'Downgrades',
                          selected: _filter == AlertCategory.downgrade,
                          onTap: () => setState(() => _filter = AlertCategory.downgrade),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _FilterChip(
                          label: 'Price Alerts',
                          selected: _filter == AlertCategory.priceAlert,
                          onTap: () => setState(() => _filter = AlertCategory.priceAlert),
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
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.filter_alt_rounded, size: 18, color: AppColors.textMuted),
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
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentBlue : AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? AppColors.accentBlue : AppColors.border),
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
