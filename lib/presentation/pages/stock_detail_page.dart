import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/factor_score.dart';
import '../../data/models/score_insight.dart';
import '../../data/models/stock.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/factor_analysis_card.dart';
import '../widgets/score_history_card.dart';
import '../widgets/score_insights_card.dart';
import '../widgets/sdk_score_card.dart';
import '../widgets/ticker_avatar.dart';

/// Stock detail screen — SDK Score, 6-factor breakdown, score history chart,
/// and the reasoning (and missing data) behind the score. Currently backed
/// by static demo data matching the NVDA mockup.
class StockDetailPage extends StatelessWidget {
  const StockDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            const TickerAvatar(ticker: 'NVDA', size: 34),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('NVDA', style: AppTextStyles.title.copyWith(fontSize: 16)),
                Text(
                  'NVIDIA Corporation',
                  style: AppTextStyles.caption.copyWith(fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.alerts),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.trim,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            Text(
              '\$1,246.82',
              style: AppTextStyles.displayFigure.copyWith(fontSize: 34),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.arrow_upward_rounded,
                  size: 14,
                  color: AppColors.gain,
                ),
                const SizedBox(width: 2),
                Text(
                  '+\$25.97 (2.14%) Today',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.gain,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const SdkScoreCard(
              score: 90,
              status: StockStatus.strongBuy,
              confidence: StockConfidence.provisional,
              dataCoverageLabel: '68% Data Coverage',
            ),
            const SizedBox(height: AppSpacing.lg),
            const FactorAnalysisCard(
              factors: [
                FactorScore(label: 'Valuation', value: 62),
                FactorScore(label: 'Growth', value: 96),
                FactorScore(label: 'Profitability', value: 94),
                FactorScore(label: 'Momentum', value: 92),
                FactorScore(label: 'Earnings Quality'),
                FactorScore(label: 'Financial Strength', value: 88),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const ScoreHistoryCard(
              rangeLabel: '6M',
              scores: [82, 80, 78, 81, 85, 84, 87, 86, 89, 88, 91, 90],
              monthLabels: [
                'Nov 23',
                'Dec 23',
                'Jan 24',
                'Feb 24',
                'Mar 24',
                'Apr 24',
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            IntrinsicHeight(
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(
                  child: ScoreInsightsCard(
                    title: 'Why this score?',
                    insights: [
                      ScoreInsight(
                        title: 'Strong revenue and EPS growth',
                        detail: 'Consistent double-digit growth across key metrics.',
                      ),
                      ScoreInsight(
                        title: 'Strong momentum',
                        detail: 'Price and relative strength trending up.',
                      ),
                      ScoreInsight(
                        title: 'Healthy profitability',
                        detail: 'High ROE and strong margins vs. sector peers.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Expanded(
                  child: ScoreInsightsCard(
                    title: 'Material Missing Factors',
                    isWarning: true,
                    insights: [
                      ScoreInsight(
                        title: 'Valuation',
                        detail:
                            'Insufficient valuation data limits confidence.',
                        icon: Icons.balance_rounded,
                      ),
                      ScoreInsight(
                        title: 'Earnings Quality',
                        detail:
                            'Not enough quality and accruals data available.',
                        icon: Icons.bar_chart_rounded,
                      ),
                    ],
                  ),
                ),
              ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
