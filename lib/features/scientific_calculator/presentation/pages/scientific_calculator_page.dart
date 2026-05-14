import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/scientific_calculator_controller.dart';

class ScientificCalculatorPage extends ConsumerWidget {
  const ScientificCalculatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scientificCalculatorProvider);
    final controller = ref.read(scientificCalculatorProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Header with AppBar styling
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [Colors.blue.shade800, Colors.blue.shade600]
                    : [Colors.blue.shade600, Colors.blue.shade400],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Back',
                    ),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Advanced Scientific',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Calculator',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.toggleAngleMode,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          controller.angleMode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Display Area
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Operation result
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    state.lastFunction.isEmpty ? '' : state.lastFunction,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Main input display
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    state.input.isEmpty ? '0' : state.input,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Result display
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    '= ${state.result}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Buttons Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  // Row 1: Trigonometric Functions
                  Expanded(
                    child: Row(
                      children: [
                        _buildFunctionButton(context, 'sin',
                            () => controller.applySin(), Colors.orange),
                        _buildFunctionButton(context, 'cos',
                            () => controller.applyCos(), Colors.orange),
                        _buildFunctionButton(context, 'tan',
                            () => controller.applyTan(), Colors.orange),
                        _buildFunctionButton(
                            context, 'C', controller.clear, Colors.red),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Row 2: Logarithmic Functions
                  Expanded(
                    child: Row(
                      children: [
                        _buildFunctionButton(context, 'log',
                            () => controller.applyLog(), Colors.deepPurple),
                        _buildFunctionButton(context, 'ln',
                            () => controller.applyLn(), Colors.deepPurple),
                        _buildFunctionButton(context, '√',
                            () => controller.applySqrt(), Colors.deepPurple),
                        _buildFunctionButton(
                            context, 'DEL', controller.backspace, Colors.red),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Row 3: Power & Factorial
                  Expanded(
                    child: Row(
                      children: [
                        _buildFunctionButton(context, 'x²',
                            () => controller.applyPower(2), Colors.teal),
                        _buildFunctionButton(context, 'x³',
                            () => controller.applyPower(3), Colors.teal),
                        _buildFunctionButton(context, 'x!',
                            () => controller.applyFactorial(), Colors.teal),
                        _buildFunctionButton(context, 'xʸ',
                            () => controller.appendInput('^'), Colors.teal),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Row 4: Constants
                  Expanded(
                    child: Row(
                      children: [
                        _buildFunctionButton(context, 'π',
                            () => controller.addConstant('π'), Colors.indigo),
                        _buildFunctionButton(context, 'e',
                            () => controller.addConstant('e'), Colors.indigo),
                        _buildFunctionButton(context, 'φ',
                            () => controller.addConstant('φ'), Colors.indigo),
                        _buildActionButton(
                            context, '=', controller.calculate, Colors.green),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Row 5: Numbers 7-0 (Top row of number pad)
                  Expanded(
                    child: Row(
                      children: [
                        _buildNumberButton(
                            context, '7', () => controller.appendInput('7')),
                        _buildNumberButton(
                            context, '8', () => controller.appendInput('8')),
                        _buildNumberButton(
                            context, '9', () => controller.appendInput('9')),
                        _buildNumberButton(
                            context, '/', () => controller.appendInput('/')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Row 6: Numbers 4-6
                  Expanded(
                    child: Row(
                      children: [
                        _buildNumberButton(
                            context, '4', () => controller.appendInput('4')),
                        _buildNumberButton(
                            context, '5', () => controller.appendInput('5')),
                        _buildNumberButton(
                            context, '6', () => controller.appendInput('6')),
                        _buildNumberButton(
                            context, '*', () => controller.appendInput('*')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Row 7: Numbers 1-3
                  Expanded(
                    child: Row(
                      children: [
                        _buildNumberButton(
                            context, '1', () => controller.appendInput('1')),
                        _buildNumberButton(
                            context, '2', () => controller.appendInput('2')),
                        _buildNumberButton(
                            context, '3', () => controller.appendInput('3')),
                        _buildNumberButton(
                            context, '-', () => controller.appendInput('-')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Row 8: 0, Decimal, Parenthesis
                  Expanded(
                    child: Row(
                      children: [
                        _buildNumberButton(
                            context, '0', () => controller.appendInput('0')),
                        _buildNumberButton(
                            context, '.', () => controller.appendInput('.')),
                        _buildNumberButton(
                            context, '(', () => controller.appendInput('(')),
                        _buildNumberButton(
                            context, ')', () => controller.appendInput(')')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Row 9: Plus and Backspace
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildNumberButton(
                              context, '+', () => controller.appendInput('+')),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildFunctionButton(
                              context, '←', controller.backspace, Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildNumberButton(
    BuildContext context,
    String label,
    VoidCallback onPressed,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(12),
            splashColor: Colors.blue.withValues(alpha: 0.3),
            highlightColor: Colors.blue.withValues(alpha: 0.1),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFunctionButton(
    BuildContext context,
    String label,
    VoidCallback onPressed,
    Color color,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(12),
            splashColor: color.withValues(alpha: 0.4),
            highlightColor: color.withValues(alpha: 0.15),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.9),
                    color.withValues(alpha: 0.7)
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    VoidCallback onPressed,
    Color color,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(12),
            splashColor: color.withValues(alpha: 0.4),
            highlightColor: color.withValues(alpha: 0.15),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
