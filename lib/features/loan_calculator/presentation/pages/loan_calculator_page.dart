import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/loan_calculator_controller.dart';
import '../../../../core/utils/number_utils.dart';
import '../../../../services/voice/voice_input_service.dart';

class LoanCalculatorPage extends ConsumerWidget {
  const LoanCalculatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loanCalculatorProvider);
    final controller = ref.read(loanCalculatorProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan / EMI Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.reset,
            tooltip: 'Reset',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Principal Amount
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Loan Amount (Principal)',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          NumberUtils.formatCurrency(state.principal),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Slider(
                      value: state.principal,
                      min: 0,
                      max: 10000000,
                      divisions: 1000,
                      label: NumberUtils.formatCurrency(state.principal),
                      onChanged: controller.setPrincipal,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Enter Amount',
                        hintText: '0.00',
                        prefixIcon: const Icon(Icons.currency_rupee),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.mic_none_rounded),
                          tooltip: 'Voice input amount',
                          onPressed: () => _fillPrincipalFromVoice(
                            context,
                            controller,
                          ),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        final sanitized = value.replaceAll(',', '').trim();
                        final amount = double.tryParse(sanitized) ?? 0;
                        controller.setPrincipal(amount);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Interest Rate
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Annual Interest Rate',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          '${state.annualRate.toStringAsFixed(2)}%',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Slider(
                      value: state.annualRate,
                      min: 0,
                      max: 25,
                      divisions: 100,
                      label: '${state.annualRate.toStringAsFixed(2)}%',
                      onChanged: controller.setAnnualRate,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Enter Rate',
                        hintText: '0.00',
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.percent),
                            IconButton(
                              icon: const Icon(Icons.mic_none_rounded),
                              tooltip: 'Voice input rate',
                              onPressed: () => _fillRateFromVoice(
                                context,
                                controller,
                              ),
                            ),
                          ],
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        final sanitized = value.replaceAll(',', '').trim();
                        final rate = double.tryParse(sanitized) ?? 0;
                        controller.setAnnualRate(rate);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tenure
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Loan Tenure',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          '${state.tenure} months (${(state.tenure / 12).toStringAsFixed(1)} years)',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Slider(
                      value: state.tenure.toDouble(),
                      min: 1,
                      max: 480, // 40 years
                      divisions: 479,
                      label: state.tenure.toString(),
                      onChanged: (value) => controller.setTenure(value.toInt()),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Months',
                        hintText: '12',
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_month),
                            IconButton(
                              icon: const Icon(Icons.mic_none_rounded),
                              tooltip: 'Voice input tenure',
                              onPressed: () => _fillTenureFromVoice(
                                context,
                                controller,
                              ),
                            ),
                          ],
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        final months = int.tryParse(value) ?? 12;
                        controller.setTenure(months.clamp(1, 480));
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Results
            if (state.calculation != null) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EMI Calculation Results',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),

                      // Monthly EMI
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Monthly EMI',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              NumberUtils.formatCurrency(
                                  state.calculation!.monthlyEMI),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Total Interest
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Interest',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    NumberUtils.formatCurrency(
                                        state.calculation!.totalInterest),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red.shade400,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Payment',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    NumberUtils.formatCurrency(
                                        state.calculation!.totalPayment),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade400,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSummaryRow(
                              context,
                              'Principal',
                              NumberUtils.formatCurrency(
                                  state.calculation!.principal),
                            ),
                            const SizedBox(height: 8),
                            _buildSummaryRow(
                              context,
                              'Interest Rate',
                              '${state.calculation!.annualRate.toStringAsFixed(2)}% p.a.',
                            ),
                            const SizedBox(height: 8),
                            _buildSummaryRow(
                              context,
                              'Tenure',
                              '${state.calculation!.months} months',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    children: [
                      Icon(
                        Icons.calculate,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Enter values to calculate EMI',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value) {
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
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Future<double?> _listenForNumber() async {
    final voiceText = await VoiceInputService.recognizeSpeech();
    if (voiceText == null || voiceText.trim().isEmpty) return null;

    final expression = VoiceInputService.parseToExpression(voiceText);
    final expressionMatch = RegExp(r'-?\d+(\.\d+)?').firstMatch(expression);
    if (expressionMatch != null) {
      return double.tryParse(expressionMatch.group(0)!);
    }

    final rawMatch = RegExp(r'-?\d+(\.\d+)?')
        .firstMatch(voiceText.replaceAll(',', '').trim());
    if (rawMatch != null) {
      return double.tryParse(rawMatch.group(0)!);
    }

    return null;
  }

  Future<void> _fillPrincipalFromVoice(
    BuildContext context,
    LoanCalculatorController controller,
  ) async {
    final value = await _listenForNumber();
    if (value == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not detect loan amount.')),
        );
      }
      return;
    }
    controller.setPrincipal(value.clamp(0, 10000000).toDouble());
  }

  Future<void> _fillRateFromVoice(
    BuildContext context,
    LoanCalculatorController controller,
  ) async {
    final value = await _listenForNumber();
    if (value == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not detect interest rate.')),
        );
      }
      return;
    }
    controller.setAnnualRate(value.clamp(0, 25).toDouble());
  }

  Future<void> _fillTenureFromVoice(
    BuildContext context,
    LoanCalculatorController controller,
  ) async {
    final value = await _listenForNumber();
    if (value == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not detect tenure months.')),
        );
      }
      return;
    }
    controller.setTenure(value.round().clamp(1, 480));
  }
}
