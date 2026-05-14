import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/temperature_converter_controller.dart';

class TemperatureConverterPage extends ConsumerWidget {
  const TemperatureConverterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(temperatureConverterProvider);
    final controller = ref.read(temperatureConverterProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Section
            Text(
              'Enter Temperature',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Value',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => controller.setInputValue('0'),
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    onChanged: controller.setInputValue,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<String>(
                    value: state.selectedUnit,
                    underline: const SizedBox(),
                    items: [
                      DropdownMenuItem(
                          value: 'celsius',
                          child: Text('°C',
                              style: Theme.of(context).textTheme.labelLarge)),
                      DropdownMenuItem(
                          value: 'fahrenheit',
                          child: Text('°F',
                              style: Theme.of(context).textTheme.labelLarge)),
                      DropdownMenuItem(
                          value: 'kelvin',
                          child: Text('K',
                              style: Theme.of(context).textTheme.labelLarge)),
                    ],
                    onChanged: (value) {
                      if (value != null) controller.setUnit(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Error Message
            if (state.errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade400),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.errorMessage,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            // Temperature Conversion Results
            Text(
              'Conversion Results',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTemperatureCard(
              context,
              'Celsius',
              '°C',
              state.celsiusValue,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildTemperatureCard(
              context,
              'Fahrenheit',
              '°F',
              state.fahrenheitValue,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildTemperatureCard(
              context,
              'Kelvin',
              'K',
              state.kelvinValue,
              Colors.purple,
            ),
            const SizedBox(height: 24),
            // Temperature Reference
            _buildReferenceSection(context),
            const SizedBox(height: 24),
            // Clear Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
                onPressed: controller.clear,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureCard(
    BuildContext context,
    String title,
    String unit,
    double value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reference Points',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _buildReferencePoint('Water Freezes', 0, 32, 273.15),
          const SizedBox(height: 8),
          _buildReferencePoint('Room Temperature', 20, 68, 293.15),
          const SizedBox(height: 8),
          _buildReferencePoint('Water Boils', 100, 212, 373.15),
          const SizedBox(height: 8),
          _buildReferencePoint('Absolute Zero', -273.15, -459.67, 0),
        ],
      ),
    );
  }

  Widget _buildReferencePoint(
      String name, double celsius, double fahrenheit, double kelvin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            Text('${celsius.toStringAsFixed(0)}°C'),
            const SizedBox(width: 16),
            Text('${fahrenheit.toStringAsFixed(0)}°F'),
            const SizedBox(width: 16),
            Text('${kelvin.toStringAsFixed(2)}K'),
          ],
        ),
      ],
    );
  }
}
