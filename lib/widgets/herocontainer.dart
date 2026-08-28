import 'package:flutter/material.dart';

class HeroContainer extends StatelessWidget {
	const HeroContainer({
		super.key,
		this.portfolioValue = '--',
		this.changeLabel = '--',
		this.chartPoints = const [],
	});

	final String portfolioValue;
	final String changeLabel;
	final List<double> chartPoints;

	@override
	Widget build(BuildContext context) {
		return Container(
			padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
			decoration: BoxDecoration(
				color: const Color(0xff07182b),
				borderRadius: BorderRadius.circular(18),
				border: Border.all(color: const Color(0xff1b3b56)),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: [
							Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text('Total Portfolio Value', style: TextStyle(color: Color(0xff8496a9), fontSize: 12)),
									SizedBox(height: 4),
									Text(portfolioValue, style: const TextStyle(color: Color(0xfff2f5f7), fontSize: 30, fontWeight: FontWeight.w700)),
									SizedBox(height: 4),
									Text(changeLabel, style: const TextStyle(color: Color(0xff8194a4), fontSize: 12, fontWeight: FontWeight.w600)),
								],
							),
							Container(
								padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
								decoration: BoxDecoration(color: const Color(0xff102a3e), borderRadius: BorderRadius.circular(8)),
								child: const Text('1D', style: TextStyle(color: Color(0xffaec1cf), fontSize: 12, fontWeight: FontWeight.w600)),
							),
						],
					),
					const SizedBox(height: 12),
					SizedBox(height: 116, child: CustomPaint(painter: _PortfolioChartPainter(points: chartPoints))),
					const SizedBox(height: 6),
					const Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: [
							Text('9:30 AM', style: _axisStyle),
							Text('11:00 AM', style: _axisStyle),
							Text('12:30 PM', style: _axisStyle),
							Text('2:00 PM', style: _axisStyle),
							Text('3:30 PM', style: _axisStyle),
						],
					),
				],
			),
		);
	}
}

const _axisStyle = TextStyle(color: Color(0xff64788b), fontSize: 10);

class _PortfolioChartPainter extends CustomPainter {
	const _PortfolioChartPainter({required this.points});
	final List<double> points;

	@override
	void paint(Canvas canvas, Size size) {
		final gridPaint = Paint()..color = const Color(0xff173249)..strokeWidth = 1;
		for (var index = 0; index < 4; index++) {
			final y = size.height * index / 3;
			canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
		}

		if (points.length < 2) return;
		final chartPoints = points.asMap().entries.map((entry) {
			final x = entry.key / (points.length - 1) * size.width;
			return Offset(x, points[entry.key].clamp(0, 1) * size.height);
		}).toList();

		final path = Path()..moveTo(chartPoints.first.dx, size.height);
		for (final point in chartPoints) {
			path.lineTo(point.dx, point.dy);
		}
		path.lineTo(chartPoints.last.dx, size.height);
		path.close();
		canvas.drawPath(path, Paint()..shader = const LinearGradient(colors: [Color(0x5535bd75), Color(0x0035bd75)], begin: Alignment.topCenter, end: Alignment.bottomCenter).createShader(Offset.zero & size));

		final linePaint = Paint()
			..color = const Color(0xff35bd75)
			..strokeWidth = 2.2
			..style = PaintingStyle.stroke
			..strokeCap = StrokeCap.round
			..strokeJoin = StrokeJoin.round;
		final line = Path()..moveTo(chartPoints.first.dx, chartPoints.first.dy);
		for (final point in chartPoints.skip(1)) {
			line.lineTo(point.dx, point.dy);
		}
		canvas.drawPath(line, linePaint);
		canvas.drawCircle(chartPoints.last, 3.5, Paint()..color = const Color(0xff7ce0a3));
	}

	@override
	bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
