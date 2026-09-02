import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/stock/stock.dart';
import 'stock_row_card.dart';

/// A column of [StockRowCard] rows separated by hairline dividers, meant to
/// sit inside a light cream card.
class StockListCard extends StatelessWidget {
  const StockListCard({
    super.key,
    required this.stocks,
    this.showRank = false,
    this.showTagline = false,
    this.onTapStock,
  });

  final List<Stock> stocks;
  final bool showRank;
  final bool showTagline;
  final ValueChanged<Stock>? onTapStock;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < stocks.length; i++) ...[
          StockRowCard(
            stock: stocks[i],
            rank: showRank ? i + 1 : null,
            showTagline: showTagline,
            onTap: onTapStock == null ? null : () => onTapStock!(stocks[i]),
          ),
          if (i != stocks.length - 1)
            Divider(height: 1, color: AppColors.creamBorder),
        ],
      ],
    );
  }
}
