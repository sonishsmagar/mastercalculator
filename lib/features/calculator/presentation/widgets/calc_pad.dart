import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import '../state/calculator_controller.dart';

class CalcPad extends ConsumerWidget {
  const CalcPad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);
    final controller = ref.read(calculatorProvider.notifier);

    return Column(
      children: [
        // Mode Toggle Switch - Optimized
        RepaintBoundary(
          child: _ModeToggle(
            isScientificMode: state.isScientificMode,
            onToggle: controller.toggleScientificMode,
          ),
        ),

        // Calculator Buttons - No Scrolling
        Expanded(
          child: RepaintBoundary(
            child: state.isScientificMode
                ? _ScientificLayout(controller: controller)
                : _BasicLayout(controller: controller),
          ),
        ),
      ],
    );
  }
}

class _ModeToggle extends StatelessWidget {
  final bool isScientificMode;
  final VoidCallback onToggle;

  const _ModeToggle({
    required this.isScientificMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 50,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color:
                (isDark ? Colors.white : Colors.white).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color:
                  (isDark ? Colors.white : Colors.white).withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Animated background indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                left: isScientificMode
                    ? MediaQuery.of(context).size.width * 0.5 - 24
                    : 4,
                top: 4,
                bottom: 4,
                width: MediaQuery.of(context).size.width * 0.5 - 20,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(21),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              // Toggle buttons
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isScientificMode ? onToggle : null,
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(25),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Basic',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: !isScientificMode
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: !isScientificMode ? onToggle : null,
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(25),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Scientific',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isScientificMode
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BasicLayout extends StatelessWidget {
  final CalculatorController controller;

  const _BasicLayout({required this.controller});

  static const _basicButtons = [
    ['C', '(', ')', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['0', '.', '⌫', '='],
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: List.generate(
          _basicButtons.length,
          (rowIndex) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: List.generate(
                  _basicButtons[rowIndex].length,
                  (colIndex) {
                    final button = _basicButtons[rowIndex][colIndex];
                    return Expanded(
                      flex: button == '0' ? 2 : 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _CalcButton(
                          label: button,
                          onPressed: () =>
                              _handleButtonPress(button, controller),
                          isOperator: _isOperator(button),
                          isEquals: button == '=',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleButtonPress(String button, CalculatorController controller) {
    switch (button) {
      case 'C':
        controller.clearExpression();
        break;
      case '⌫':
        controller.deleteLast();
        break;
      case '=':
        controller.calculate();
        break;
      default:
        controller.appendToExpression(button);
    }
  }

  bool _isOperator(String button) {
    return ['÷', '×', '-', '+', '=', 'C', '⌫', '(', ')'].contains(button);
  }
}

class _ScientificLayout extends StatelessWidget {
  final CalculatorController controller;

  const _ScientificLayout({required this.controller});

  static const _scientificButtons = [
    ['sin', 'cos', 'tan', 'log'],
    ['ln', 'sqrt', '^', 'π'],
    ['C', '(', ')', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['0', '.', '⌫', '='],
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: List.generate(
          _scientificButtons.length,
          (rowIndex) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: List.generate(
                  _scientificButtons[rowIndex].length,
                  (colIndex) {
                    final button = _scientificButtons[rowIndex][colIndex];
                    final isScientificBtn = rowIndex < 2;
                    return Expanded(
                      flex: button == '0' ? 2 : 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _CalcButton(
                          label: button,
                          onPressed: () => isScientificBtn
                              ? _handleScientificButtonPress(button, controller)
                              : _handleButtonPress(button, controller),
                          isOperator: _isOperator(button) || isScientificBtn,
                          isEquals: button == '=',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleButtonPress(String button, CalculatorController controller) {
    switch (button) {
      case 'C':
        controller.clearExpression();
        break;
      case '⌫':
        controller.deleteLast();
        break;
      case '=':
        controller.calculate();
        break;
      default:
        controller.appendToExpression(button);
    }
  }

  void _handleScientificButtonPress(
    String button,
    CalculatorController controller,
  ) {
    switch (button) {
      case 'M+':
        controller.memoryAdd();
        break;
      case 'M-':
        controller.memorySubtract();
        break;
      case 'MR':
        controller.memoryRecall();
        break;
      case 'MC':
        controller.memoryClear();
        break;
      default:
        controller.applyScientificFunction(button);
    }
  }

  bool _isOperator(String button) {
    return ['÷', '×', '-', '+', '=', 'C', '⌫', '(', ')'].contains(button);
  }
}

class _CalcButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isOperator;
  final bool isEquals;

  const _CalcButton({
    required this.label,
    required this.onPressed,
    this.isOperator = false,
    this.isEquals = false,
  });

  @override
  Widget build(BuildContext context) {
    Color getButtonColor() {
      if (isEquals) {
        return Theme.of(context).colorScheme.primary;
      } else if (isOperator) {
        return Theme.of(context).colorScheme.secondary;
      } else {
        return Theme.of(context).colorScheme.surface;
      }
    }

    final buttonColor = getButtonColor();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: buttonColor.withValues(
              alpha: isEquals || isOperator ? 0.25 : 0.1),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            splashColor: buttonColor.withValues(alpha: 0.3),
            highlightColor: buttonColor.withValues(alpha: 0.15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: buttonColor.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: buttonColor.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: label.length > 3 ? 14 : 20,
                    fontWeight: FontWeight.w600,
                    color: isEquals || isOperator
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
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
