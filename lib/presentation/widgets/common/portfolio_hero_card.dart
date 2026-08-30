import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Portfolio value hero card with an intraday chart, shown at the top of Home.
class PortfolioHeroCard extends StatelessWidget {
  const PortfolioHeroCard({
    super.key,
    required this.portfolioValue,
    required this.changeLabel,
    required this.isPositive,
    this.chartPoints = const [],
    this.yAxisLabels = const [],
    this.xAxisLabels = const [],
    this.changeCaption = 'Daily Change',
    this.secondaryCaption,
    this.secondaryValue,
  });

  final String portfolioValue;
  final String changeLabel;
  final bool isPositive;
  final List<double> chartPoints;
  final List<String> yAxisLabels;
  final List<String> xAxisLabels;

  /// Label above [changeLabel] — "Daily Change" on Home, "Day Gain" on
  /// Portfolio (same slot, different mockup wording).
  final String changeCaption;

  /// Optional second stat shown beside the change ("Total Return" on the
  /// Portfolio screen). Null hides the second column entirely.
  final String? secondaryCaption;
  final String? secondaryValue;

  @override
  Widget build(BuildContext context) {
    final lineColor = isPositive ? AppColors.gain : AppColors.loss;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
      ),
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
              Text('Total Portfolio Value', style: AppTextStyles.caption),
              const SizedBox(width: 4),
              Icon(
                Icons.info_outline_rounded,
                size: 12,
                color: AppColors.textMuted,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(portfolioValue, style: AppTextStyles.displayFigure),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(changeCaption, style: AppTextStyles.caption),
                    Text(
                      changeLabel,
                      style: AppTextStyles.body.copyWith(
                        color: lineColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (secondaryCaption != null && secondaryValue != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(secondaryCaption!, style: AppTextStyles.caption),
                      Text(
                        secondaryValue!,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 116,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: CustomPaint(
                    painter: _PortfolioChartPainter(
                      points: chartPoints,
                      lineColor: lineColor,
                    ),
                  ),
                ),
                if (yAxisLabels.isNotEmpty) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final label in yAxisLabels)
                        Text(
                          label,
                          style: AppTextStyles.caption.copyWith(fontSize: 10),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (xAxisLabels.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                for (final label in xAxisLabels)
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(fontSize: 10),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PortfolioChartPainter extends CustomPainter {
  const _PortfolioChartPainter({required this.points, required this.lineColor});

  final List<double> points;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    for (var index = 0; index < 4; index++) {
      final y = size.height * index / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (points.length < 2) return;
    final chartPoints = points.asMap().entries.map((entry) {
      final x = entry.key / (points.length - 1) * size.width;
      return Offset(x, (1 - points[entry.key].clamp(0, 1)) * size.height);
    }).toList();

    final fillPath = Path()..moveTo(chartPoints.first.dx, size.height);
    for (final point in chartPoints) {
      fillPath.lineTo(point.dx, point.dy);
    }
    fillPath.lineTo(chartPoints.last.dx, size.height);
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          colors: [
            lineColor.withValues(alpha: 0.35),
            lineColor.withValues(alpha: 0.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Offset.zero & size),
    );

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final line = Path()..moveTo(chartPoints.first.dx, chartPoints.first.dy);
    for (final point in chartPoints.skip(1)) {
      line.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(line, linePaint);
    canvas.drawCircle(chartPoints.last, 3.5, Paint()..color = lineColor);
  }

  @override
  bool shouldRepaint(covariant _PortfolioChartPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.lineColor != lineColor;
}
