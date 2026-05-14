import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/currency_controller.dart';
import '../widgets/currency_picker.dart';
import '../widgets/historical_chart.dart';

class CurrencyConverterPage extends ConsumerWidget {
  const CurrencyConverterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currencyConverterProvider);
    final controller = ref.read(currencyConverterProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.convert(),
            tooltip: 'Refresh Rates',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.convert();
          controller.loadHistoricalRates();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Amount Input
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => controller.setAmount('1.0'),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: controller.setAmount,
              ),
              const SizedBox(height: 20),

              // Currency Selection Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('From'),
                        const SizedBox(height: 8),
                        CurrencyPicker(
                          selectedCurrency: state.baseCurrency,
                          onCurrencyChanged: controller.setBaseCurrency,
                          isBaseCurrency: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz),
                    onPressed: controller.swapCurrencies,
                    style: IconButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('To'),
                        const SizedBox(height: 8),
                        CurrencyPicker(
                          selectedCurrency: state.targetCurrency,
                          onCurrencyChanged: controller.setTargetCurrency,
                          isBaseCurrency: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Error Message
              if (state.errorMessage.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.errorMessage,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: controller.clearError,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Conversion Result
              if (state.exchangeRate != null && !state.isLoading) ...[
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          '${state.amount.toStringAsFixed(2)} ${state.baseCurrency}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Icon(
                          Icons.arrow_downward,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${state.exchangeRate!.convertedAmount.toStringAsFixed(2)} ${state.targetCurrency}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '1 ${state.baseCurrency} = ${state.exchangeRate!.rate.toStringAsFixed(4)} ${state.targetCurrency}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                        ),
                        Text(
                          'Last updated: ${_formatTime(state.exchangeRate!.lastUpdated)}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else if (state.isLoading) ...[
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Multi-Currency Comparison Toggle
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Compare Multiple Currencies',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      IconButton(
                        icon: Icon(
                          state.showComparison
                              ? Icons.expand_less
                              : Icons.expand_more,
                        ),
                        onPressed: controller.toggleComparison,
                      ),
                    ],
                  ),
                ),
              ),

              // Multi-Currency Comparison
              if (state.showComparison &&
                  state.multiCurrencyComparison.isNotEmpty) ...[
                const SizedBox(height: 16),
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${state.amount.toStringAsFixed(2)} ${state.baseCurrency} in other currencies:',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        ...state.multiCurrencyComparison.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  entry.value.toStringAsFixed(2),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Historical Chart (Placeholder)
              const SizedBox(
                height: 500,
                child: HistoricalChart(),
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
