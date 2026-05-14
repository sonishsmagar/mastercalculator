import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/number_system_controller.dart';

class NumberSystemConverterPage extends ConsumerWidget {
  const NumberSystemConverterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(numberSystemProvider);
    final controller = ref.read(numberSystemProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Number System Converter'),
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
            // Input Base Selector
            Text(
              'Select Input Base',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildBaseButton(
                  context,
                  'Decimal',
                  state.selectedInputBase == 'decimal',
                  () => controller.setInputBase('decimal'),
                ),
                _buildBaseButton(
                  context,
                  'Binary',
                  state.selectedInputBase == 'binary',
                  () => controller.setInputBase('binary'),
                ),
                _buildBaseButton(
                  context,
                  'Octal',
                  state.selectedInputBase == 'octal',
                  () => controller.setInputBase('octal'),
                ),
                _buildBaseButton(
                  context,
                  'Hexadecimal',
                  state.selectedInputBase == 'hexadecimal',
                  () => controller.setInputBase('hexadecimal'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Input Field
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText:
                    'Input (${state.selectedInputBase[0].toUpperCase()}${state.selectedInputBase.substring(1)})',
                border: const OutlineInputBorder(),
                hintText: '0',
              ),
              controller: TextEditingController(text: state.decimalInput),
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
            // Output Cards
            _buildOutputCard(
              context,
              'Decimal',
              state.decimalInput,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildOutputCard(
              context,
              'Binary',
              state.binaryOutput,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildOutputCard(
              context,
              'Octal',
              state.octalOutput,
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildOutputCard(
              context,
              'Hexadecimal',
              state.hexadecimalOutput,
              Colors.purple,
            ),
            const SizedBox(height: 24),
            // Keypad
            Text(
              'Input Keypad',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildKeypad(context, controller, state.selectedInputBase),
          ],
        ),
      ),
    );
  }

  Widget _buildBaseButton(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutputCard(
      BuildContext context, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
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
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypad(BuildContext context, NumberSystemController controller,
      String selectedBase) {
    final maxDigit = selectedBase == 'binary'
        ? 1
        : selectedBase == 'octal'
            ? 7
            : selectedBase == 'hexadecimal'
                ? 15
                : 9;

    final List<String> digits = [];
    for (int i = 0; i <= maxDigit; i++) {
      if (i <= 9) {
        digits.add(i.toString());
      } else {
        digits.add(String.fromCharCode(65 + (i - 10)));
      }
    }

    return Column(
      children: [
        // Number buttons
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: digits.length,
          itemBuilder: (context, index) {
            return _buildKeyButton(
              context,
              digits[index],
              () => controller.appendInput(digits[index]),
              Colors.blue,
            );
          },
        ),
        const SizedBox(height: 12),
        // Action buttons
        Row(
          children: [
            Expanded(
              child: _buildKeyButton(
                context,
                'Backspace',
                () => controller.backspace(),
                Colors.orange,
                isWide: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildKeyButton(
                context,
                'Clear',
                () => controller.clear(),
                Colors.red,
                isWide: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKeyButton(
    BuildContext context,
    String label,
    VoidCallback onTap,
    Color color, {
    bool isWide = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.8),
                color.withValues(alpha: 0.6)
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
