import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/unit_controller.dart';
import '../../domain/models/unit_category.dart';
import '../../domain/usecases/convert_unit.dart';

class UnitConverterPage extends ConsumerWidget {
  const UnitConverterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(unitConverterProvider);
    final controller = ref.read(unitConverterProvider.notifier);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Selection
            Text(
              'Select Category',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: UnitCategory.values.map((category) {
                final isSelected = state.selectedCategory == category;
                return ChoiceChip(
                  label: Text(category.name),
                  selected: isSelected,
                  onSelected: (_) => controller.selectCategory(category),
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Input Value
            TextField(
              decoration: InputDecoration(
                labelText: 'Value',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.calculate),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => controller.setInputValue('1'),
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: controller.setInputValue,
            ),
            const SizedBox(height: 20),

            // From/To Unit Selection
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: state.fromUnit,
                          isExpanded: true,
                          underline: const SizedBox.shrink(),
                          items: state.selectedCategory.units
                              .map((unit) => DropdownMenuItem(
                                    value: unit,
                                    child: Text(
                                      unit,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) controller.setFromUnit(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: controller.swapUnits,
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
                      Text(
                        'To',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: state.toUnit,
                          isExpanded: true,
                          underline: const SizedBox.shrink(),
                          items: state.selectedCategory.units
                              .map((unit) => DropdownMenuItem(
                                    value: unit,
                                    child: Text(
                                      unit,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) controller.setToUnit(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Result Display
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      '${state.inputValue.toStringAsFixed(4)} ${state.fromUnit}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Icon(
                      Icons.arrow_downward,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${state.outputValue.toStringAsFixed(4)} ${state.toUnit}',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick conversion reference
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Common Conversions',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ...state.selectedCategory.units.take(5).map((unit) {
                      final value = UnitConverter.convert(
                        state.selectedCategory.name,
                        state.fromUnit,
                        unit,
                        state.inputValue,
                      );
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              unit,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              value.toStringAsFixed(4),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
        ),
      ),
    );
  }
}
