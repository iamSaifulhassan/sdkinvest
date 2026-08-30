import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/stock.dart';
import '../../logic/compare/compare_cubit.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_feedback.dart';
import '../widgets/app_shimmer_list.dart';
import '../widgets/status_pill.dart';
import '../widgets/ticker_avatar.dart';

/// Side-by-side comparison of up to [CompareCubit.maxSlots] stocks: summary
/// cards (price/score/rating/confidence), a factor radar chart, and a
/// metric-by-metric table. Reuses the status-pill/ticker-avatar visual
/// language already built for Home/Top 5/Stock Detail.
class CompareStocksPage extends StatelessWidget {
  const CompareStocksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CompareCubit(),
      child: const _CompareStocksView(),
    );
  }
}

/// One accent color per comparison slot, matching the mockup's
/// per-stock legend coloring in the factor comparison chart/table.
const _slotColors = [AppColors.strongBuy, AppColors.accentBlue, AppColors.hold];

const _factorLabels = [
  'Valuation',
  'Growth',
  'Profitability',
  'Momentum',
  'Earnings Quality',
  'Financial Strength',
];

class _CompareStocksView extends StatelessWidget {
  const _CompareStocksView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: AppSpacing.lg,
        title: Text('Compare Stocks', style: AppTextStyles.headline.copyWith(fontSize: 22)),
        actions: [
          BlocBuilder<CompareCubit, CompareState>(
            builder: (context, state) {
              final atCapacity = state.selected.length >= CompareCubit.maxSlots;
              return IconButton(
                tooltip: atCapacity ? 'Comparison is full' : 'Add a stock',
                icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.textPrimary),
                onPressed: atCapacity ? null : () => _showAddStockSheet(context),
              );
            },
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: SafeArea(
        child: BlocBuilder<CompareCubit, CompareState>(
          builder: (context, state) {
            if (state.status == CompareStatus.loading) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: AppShimmerList(itemCount: 3),
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxl),
              children: [
                _SelectedChipsRow(selected: state.selected),
                const SizedBox(height: AppSpacing.lg),
                if (state.selected.isEmpty)
                  const _EmptyState()
                else ...[
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < state.selected.length; i++) ...[
                          if (i != 0) const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: _StockSummaryCard(
                              stock: state.selected[i],
                              accent: _slotColors[i % _slotColors.length],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FactorComparisonCard(stocks: state.selected),
                  const SizedBox(height: AppSpacing.lg),
                  _MetricsTable(stocks: state.selected),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showAddStockSheet(BuildContext context) async {
    final cubit = context.read<CompareCubit>();
    final choices = cubit.state.available
        .where((stock) => !cubit.state.selected.any((s) => s.ticker == stock.ticker))
        .toList();
    if (choices.isEmpty) {
      AppFeedback.showSnackBar(context, 'All stocks are already in the comparison');
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add to comparison', style: AppTextStyles.title),
                const SizedBox(height: AppSpacing.sm),
                for (final stock in choices)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: TickerAvatar(ticker: stock.ticker, size: 32),
                    title: Text(stock.ticker, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                    subtitle: Text(stock.name, style: AppTextStyles.caption),
                    trailing: Text('${stock.sdkScore}', style: AppTextStyles.figure),
                    onTap: () {
                      cubit.addStock(stock);
                      Navigator.of(sheetContext).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SelectedChipsRow extends StatelessWidget {
  const _SelectedChipsRow({required this.selected});

  final List<Stock> selected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final stock in selected)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TickerAvatar(ticker: stock.ticker, size: 20),
                const SizedBox(width: 6),
                Text(stock.ticker, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => context.read<CompareCubit>().removeStock(stock),
                  child: Icon(Icons.close_rounded, size: 16, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(Icons.compare_arrows_rounded, size: 32, color: AppColors.textMuted),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Add up to ${CompareCubit.maxSlots} stocks to compare their SDK Scores and factors.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

/// Maps the shared [StockConfidence] enum onto the "High/Moderate/Low
/// Confidence" badge language used specifically on the Compare mockup.
({String label, Color color}) _confidenceTier(StockConfidence confidence) {
  return switch (confidence) {
    StockConfidence.verified => (label: 'High Confidence', color: AppColors.strongBuy),
    StockConfidence.limited => (label: 'Moderate Confidence', color: AppColors.hold),
    StockConfidence.provisional => (label: 'Low Confidence', color: AppColors.hold),
  };
}

class _StockSummaryCard extends StatelessWidget {
  const _StockSummaryCard({required this.stock, required this.accent});

  final Stock stock;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tier = _confidenceTier(stock.confidence);
    final price = CompareCubit.priceFor(stock.ticker);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: accent.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              TickerAvatar(ticker: stock.ticker, size: 26),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(stock.ticker, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13)),
                    Text(
                      stock.name,
                      style: AppTextStyles.caption.copyWith(fontSize: 9.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (price > 0)
            Text('\$${price.toStringAsFixed(2)}', style: AppTextStyles.figure.copyWith(fontSize: 15)),
          const SizedBox(height: 6),
          Text('SDK Score', style: AppTextStyles.caption.copyWith(fontSize: 10)),
          Text('${stock.sdkScore}', style: AppTextStyles.figure.copyWith(fontSize: 22, color: accent)),
          const SizedBox(height: 6),
          StatusPill(status: stock.status),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(color: tier.color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  tier.label,
                  style: AppTextStyles.caption.copyWith(fontSize: 10, color: tier.color, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FactorComparisonCard extends StatelessWidget {
  const _FactorComparisonCard({required this.stocks});

  final List<Stock> stocks;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Factor Comparison', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(width: 4),
              Icon(Icons.info_outline_rounded, size: 13, color: AppColors.textMuted),
              const Spacer(),
              for (var i = 0; i < stocks.length; i++) ...[
                if (i != 0) const SizedBox(width: 10),
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(color: _slotColors[i % _slotColors.length], shape: BoxShape.circle),
                ),
                const SizedBox(width: 4),
                Text(stocks[i].ticker, style: AppTextStyles.caption.copyWith(fontSize: 10)),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _FactorRadarChart(stocks: stocks),
        ],
      ),
    );
  }
}

/// Hexagonal radar/spider chart plotting the 6 SDK factors for up to
/// [CompareCubit.maxSlots] stocks, one colored polygon per stock.
class _FactorRadarChart extends StatelessWidget {
  const _FactorRadarChart({required this.stocks});

  final List<Stock> stocks;

  @override
  Widget build(BuildContext context) {
    final series = [
      for (var i = 0; i < stocks.length; i++)
        (
          color: _slotColors[i % _slotColors.length],
          values: [
            for (final factor in CompareCubit.factorsFor(stocks[i].ticker))
              factor.isMissing ? 0.0 : factor.value! / 100,
          ],
        ),
    ];
    return SizedBox(
      height: 240,
      width: double.infinity,
      child: CustomPaint(
        painter: _RadarPainter(series: series, textColor: AppColors.textMuted, gridColor: AppColors.border),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({required this.series, required this.textColor, required this.gridColor});

  final List<({Color color, List<double> values})> series;
  final Color textColor;
  final Color gridColor;

  static final _axisCount = _factorLabels.length;

  Offset _pointAt(Offset center, double radius, int axisIndex, double fraction) {
    final angle = -math.pi / 2 + axisIndex * (2 * math.pi / _axisCount);
    return Offset(
      center.dx + radius * fraction * math.cos(angle),
      center.dy + radius * fraction * math.sin(angle),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 6);
    final maxRadius = math.min(size.width, size.height) / 2 - 40;

    final gridPaint = Paint()
      ..color = gridColor.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final outerRingPaint = Paint()
      ..color = gridColor.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    for (final ring in [0.25, 0.5, 0.75, 1.0]) {
      final path = Path();
      for (var i = 0; i < _axisCount; i++) {
        final p = _pointAt(center, maxRadius, i, ring);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      canvas.drawPath(path, ring == 1.0 ? outerRingPaint : gridPaint);
    }

    for (var i = 0; i < _axisCount; i++) {
      canvas.drawLine(center, _pointAt(center, maxRadius, i, 1.0), gridPaint);

      final labelPoint = _pointAt(center, maxRadius, i, 1.24);
      final textPainter = TextPainter(
        text: TextSpan(
          text: _factorLabels[i],
          style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w600),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        maxLines: 2,
      )..layout(maxWidth: 70);
      textPainter.paint(canvas, labelPoint - Offset(textPainter.width / 2, textPainter.height / 2));
    }

    for (final s in series) {
      final path = Path();
      for (var i = 0; i < _axisCount; i++) {
        final value = i < s.values.length ? s.values[i] : 0.0;
        final p = _pointAt(center, maxRadius, i, value.clamp(0.0, 1.0));
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();

      canvas.drawPath(path, Paint()..color = s.color.withValues(alpha: 0.26)..style = PaintingStyle.fill);
      canvas.drawPath(
        path,
        Paint()
          ..color = s.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.6
          ..strokeJoin = StrokeJoin.round,
      );

      for (var i = 0; i < _axisCount; i++) {
        final value = i < s.values.length ? s.values[i] : 0.0;
        final p = _pointAt(center, maxRadius, i, value.clamp(0.0, 1.0));
        canvas.drawCircle(p, 4.2, Paint()..color = AppColors.background);
        canvas.drawCircle(p, 3.2, Paint()..color = s.color);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.series != series;
  }
}

class _MetricsTable extends StatelessWidget {
  const _MetricsTable({required this.stocks});

  final List<Stock> stocks;

  static String _ratingLabel(StockStatus status) => switch (status) {
        StockStatus.strongBuy => 'Strong Buy',
        StockStatus.buy => 'Buy',
        StockStatus.hold => 'Hold',
        StockStatus.trim => 'Trim',
      };

  @override
  Widget build(BuildContext context) {
    final gridLine = BorderSide(color: AppColors.border, width: 1);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        columnWidths: {
          0: const FixedColumnWidth(96),
          for (var i = 0; i < stocks.length; i++) i + 1: const FlexColumnWidth(),
        },
        border: TableBorder.symmetric(inside: gridLine),
        children: [
          _metricHeaderRow(stocks, gridLine),
          _metricRow('SDK Score', stocks, gridLine, (i, s) => Text('${s.sdkScore}', style: _valueStyle(i, fontSize: 20))),
          _metricRow('Rating', stocks, gridLine, (i, s) => Text(_ratingLabel(s.status), style: _valueStyle(i, fontSize: 14))),
          _metricRow(
            'Coverage',
            stocks,
            gridLine,
            (i, s) => Text('${CompareCubit.coverageFor(s.ticker)} Analysts', style: _plainValueStyle),
          ),
          _metricRow(
            'Applicable Weight',
            stocks,
            gridLine,
            (i, s) => Text('${CompareCubit.weightFor(s.ticker)}%', style: _plainValueStyle),
          ),
          _metricRow(
            'Thesis (1-line)',
            stocks,
            gridLine,
            (i, s) => Text(s.tagline ?? '—', style: AppTextStyles.caption.copyWith(fontSize: 11.5, height: 1.3)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          ),
        ],
      ),
    );
  }

  TextStyle _valueStyle(int slotIndex, {required double fontSize}) => AppTextStyles.body.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        color: _slotColors[slotIndex % _slotColors.length],
      );

  TextStyle get _plainValueStyle => AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13);

  TableRow _metricHeaderRow(List<Stock> stocks, BorderSide gridLine) {
    return TableRow(
      decoration: BoxDecoration(border: Border(bottom: gridLine)),
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Text('Metric', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
        ),
        for (var i = 0; i < stocks.length; i++)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Text(
              stocks[i].ticker,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: _slotColors[i % _slotColors.length],
              ),
            ),
          ),
      ],
    );
  }

  TableRow _metricRow(
    String label,
    List<Stock> stocks,
    BorderSide gridLine,
    Widget Function(int index, Stock stock) valueBuilder, {
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.sm),
  }) {
    return TableRow(
      children: [
        Padding(
          padding: padding,
          child: Text(label, style: AppTextStyles.caption.copyWith(fontSize: 12)),
        ),
        for (var i = 0; i < stocks.length; i++)
          Padding(
            padding: padding,
            child: Center(child: valueBuilder(i, stocks[i])),
          ),
      ],
    );
  }
}
