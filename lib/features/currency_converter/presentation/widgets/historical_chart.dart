import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepali_utils/nepali_utils.dart';
import '../state/currency_controller.dart';

class HistoricalChart extends ConsumerWidget {
  const HistoricalChart({super.key});

  String _formatDate(DateTime date) {
    final nepaliDate = date.toNepaliDateTime();
    final bsMonth =
        NepaliDateFormat('MMMM', Language.nepali).format(nepaliDate);
    final bsDay = NepaliDateFormat('dd', Language.nepali).format(nepaliDate);

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final adMonth = months[date.month - 1];
    final adDay = date.day;

    return '$bsDay $bsMonth\n$adDay $adMonth';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currencyConverterProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historical Rates (Last 7 Days)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: state.isLoadingHistory
                  ? const Center(child: CircularProgressIndicator())
                  : state.historicalRates.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bar_chart,
                                size: 64,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Loading historical data...',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            // Mini chart visualization
                            Expanded(
                              child: _buildSimpleChart(
                                  context, state.historicalRates),
                            ),
                            const SizedBox(height: 16),
                            // Data list
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                itemCount: state.historicalRates.length,
                                itemBuilder: (context, index) {
                                  final data = state.historicalRates[index];
                                  final date = data['date'] as DateTime;
                                  final rate = data['rate'] as double;
                                  final formattedDate = _formatDate(date);

                                  return ListTile(
                                    dense: true,
                                    leading: Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    title: Text(
                                      formattedDate,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    trailing: Text(
                                      rate.toStringAsFixed(4),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                    ),
                                  );
                                },
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

  Widget _buildSimpleChart(
      BuildContext context, List<Map<String, dynamic>> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    final rates = data.map((d) => d['rate'] as double).toList();
    final maxRate = rates.reduce((a, b) => a > b ? a : b);
    final minRate = rates.reduce((a, b) => a < b ? a : b);
    final range = maxRate - minRate;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return CustomPaint(
          size: Size(width, height),
          painter: _ChartPainter(
            data: rates,
            minRate: minRate,
            maxRate: maxRate,
            range: range,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<double> data;
  final double minRate;
  final double maxRate;
  final double range;
  final Color color;

  _ChartPainter({
    required this.data,
    required this.minRate,
    required this.maxRate,
    required this.range,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || data.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();
    final spacing = size.width / (data.length - 1);

    // Start fill path from bottom
    fillPath.moveTo(0, size.height);

    for (int i = 0; i < data.length; i++) {
      final x = i * spacing;
      final normalizedValue = range > 0 ? (data[i] - minRate) / range : 0.5;
      final y = size.height -
          (normalizedValue * size.height * 0.8) -
          (size.height * 0.1);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // Draw point
      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
    }

    // Complete fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw fill and line
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
