import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/percentage_calculator_controller.dart';
import '../../../../core/utils/number_utils.dart';

class PercentageCalculatorPage extends ConsumerWidget {
  const PercentageCalculatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(percentageCalculatorProvider);
    final controller = ref.read(percentageCalculatorProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Percentage & Profit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.reset,
            tooltip: 'Reset',
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Selection
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: CalculatorTab.values.map((tab) {
                  final isSelected = state.selectedTab == tab;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(_getTabLabel(tab)),
                      selected: isSelected,
                      onSelected: (_) => controller.selectTab(tab),
                      selectedColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildTabContent(context, ref, state, controller),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTabContent(
      BuildContext context,
      WidgetRef ref,
      PercentageCalculatorState state,
      PercentageCalculatorController controller) {
    switch (state.selectedTab) {
      case CalculatorTab.percentage:
        return _buildPercentageTab(context, state, controller);
      case CalculatorTab.discount:
        return _buildDiscountTab(context, state, controller);
      case CalculatorTab.profitLoss:
        return _buildProfitLossTab(context, state, controller);
      case CalculatorTab.gst:
        return _buildGSTTab(context, state, controller);
    }
  }

  Widget _buildPercentageTab(
      BuildContext context,
      PercentageCalculatorState state,
      PercentageCalculatorController controller) {
    return Column(
      children: [
        TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Base Amount',
            prefixIcon: Icon(Icons.currency_rupee),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            controller.setPercentageBase(double.tryParse(value) ?? 0);
          },
        ),
        const SizedBox(height: 16),
        TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Percentage (%)',
            suffixIcon: Icon(Icons.percent),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            controller.setPercentageValue(double.tryParse(value) ?? 0);
          },
        ),
        const SizedBox(height: 24),
        if (state.percentageBase > 0) ...[
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _resultRow(context, 'Base Amount',
                      NumberUtils.formatCurrency(state.percentageBase)),
                  const SizedBox(height: 12),
                  _resultRow(context, 'Percentage',
                      '${state.percentageValue.toStringAsFixed(2)}%'),
                  const SizedBox(height: 12),
                  _resultRow(
                      context,
                      'Result',
                      NumberUtils.formatCurrency(
                          state.percentageBase * state.percentageValue / 100)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDiscountTab(
      BuildContext context,
      PercentageCalculatorState state,
      PercentageCalculatorController controller) {
    return Column(
      children: [
        TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Original Price',
            prefixIcon: Icon(Icons.currency_rupee),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            controller.setDiscountPrice(double.tryParse(value) ?? 0);
          },
        ),
        const SizedBox(height: 16),
        TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Discount (%)',
            suffixIcon: Icon(Icons.percent),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            controller.setDiscountPercent(double.tryParse(value) ?? 0);
          },
        ),
        const SizedBox(height: 24),
        if (state.discountResult != null) ...[
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _resultRow(
                      context,
                      'Original Price',
                      NumberUtils.formatCurrency(
                          state.discountResult!.originalPrice)),
                  const SizedBox(height: 12),
                  _resultRow(
                      context,
                      'Discount',
                      NumberUtils.formatCurrency(
                          state.discountResult!.discountAmount),
                      isHighlight: true),
                  const SizedBox(height: 12),
                  _resultRow(
                      context,
                      'Final Price',
                      NumberUtils.formatCurrency(
                          state.discountResult!.finalPrice),
                      isHighlight: true),
                  const SizedBox(height: 12),
                  _resultRow(
                      context,
                      'You Save',
                      NumberUtils.formatCurrency(
                          state.discountResult!.savings)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProfitLossTab(
      BuildContext context,
      PercentageCalculatorState state,
      PercentageCalculatorController controller) {
    return Column(
      children: [
        TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Cost Price',
            prefixIcon: Icon(Icons.currency_rupee),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            controller.setCostPrice(double.tryParse(value) ?? 0);
          },
        ),
        const SizedBox(height: 16),
        TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Selling Price',
            prefixIcon: Icon(Icons.currency_rupee),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            controller.setSellingPrice(double.tryParse(value) ?? 0);
          },
        ),
        const SizedBox(height: 24),
        if (state.profitLossResult != null) ...[
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _resultRow(
                      context,
                      'Cost Price',
                      NumberUtils.formatCurrency(
                          state.profitLossResult!.costPrice)),
                  const SizedBox(height: 12),
                  _resultRow(
                      context,
                      'Selling Price',
                      NumberUtils.formatCurrency(
                          state.profitLossResult!.sellingPrice)),
                  const SizedBox(height: 12),
                  if (state.profitLossResult!.profit > 0) ...[
                    _resultRow(
                        context,
                        'Profit',
                        NumberUtils.formatCurrency(
                            state.profitLossResult!.profit),
                        color: Colors.green),
                    const SizedBox(height: 12),
                    _resultRow(context, 'Profit %',
                        '${state.profitLossResult!.profitPercent.toStringAsFixed(2)}%',
                        color: Colors.green),
                  ] else ...[
                    _resultRow(
                        context,
                        'Loss',
                        NumberUtils.formatCurrency(
                            state.profitLossResult!.loss),
                        color: Colors.red),
                    const SizedBox(height: 12),
                    _resultRow(context, 'Loss %',
                        '${state.profitLossResult!.lossPercent.toStringAsFixed(2)}%',
                        color: Colors.red),
                  ],
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGSTTab(BuildContext context, PercentageCalculatorState state,
      PercentageCalculatorController controller) {
    return Column(
      children: [
        // Toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Price Type',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(label: Text('Exclusive'), value: false),
                    ButtonSegment(label: Text('Inclusive'), value: true),
                  ],
                  selected: {state.gstInclusive},
                  onSelectionChanged: (selected) {
                    controller.toggleGstInclusive();
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: state.gstInclusive
                ? 'Total Price (with GST)'
                : 'Base Price (without GST)',
            prefixIcon: const Icon(Icons.currency_rupee),
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            controller.setGstPrice(double.tryParse(value) ?? 0);
          },
        ),
        const SizedBox(height: 16),
        TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'GST Rate (%)',
            suffixIcon: Icon(Icons.percent),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            controller.setGstPercent(double.tryParse(value) ?? 18);
          },
        ),
        const SizedBox(height: 24),
        if (state.gstResult != null) ...[
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _resultRow(
                      context,
                      'Base Price',
                      NumberUtils.formatCurrency(
                          state.gstResult!.originalPrice)),
                  const SizedBox(height: 12),
                  _resultRow(context, 'GST Amount',
                      NumberUtils.formatCurrency(state.gstResult!.gstAmount),
                      isHighlight: true),
                  const SizedBox(height: 12),
                  _resultRow(context, 'Total Price',
                      NumberUtils.formatCurrency(state.gstResult!.totalPrice),
                      isHighlight: true),
                  const SizedBox(height: 12),
                  _resultRow(context, 'GST Rate',
                      '${state.gstResult!.gstPercent.toStringAsFixed(2)}%'),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _resultRow(BuildContext context, String label, String value,
      {bool isHighlight = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
        ),
      ],
    );
  }

  String _getTabLabel(CalculatorTab tab) {
    switch (tab) {
      case CalculatorTab.percentage:
        return 'Percentage';
      case CalculatorTab.discount:
        return 'Discount';
      case CalculatorTab.profitLoss:
        return 'Profit/Loss';
      case CalculatorTab.gst:
        return 'GST/VAT';
    }
  }
}
