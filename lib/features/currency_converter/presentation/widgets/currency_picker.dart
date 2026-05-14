import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/currency_controller.dart';

class CurrencyPicker extends ConsumerWidget {
  final String selectedCurrency;
  final Function(String) onCurrencyChanged;
  final bool isBaseCurrency;

  const CurrencyPicker({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
    this.isBaseCurrency = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableCurrencies = ref.watch(
        currencyConverterProvider.select((state) => state.availableCurrencies));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: selectedCurrency,
        onChanged: (String? newValue) {
          if (newValue != null) {
            onCurrencyChanged(newValue);
          }
        },
        items: availableCurrencies.entries.map<DropdownMenuItem<String>>(
          (MapEntry<String, String> entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ).toList(),
        underline: const SizedBox(), // Remove default underline
        isExpanded: true,
        isDense: true,
      ),
    );
  }
}
