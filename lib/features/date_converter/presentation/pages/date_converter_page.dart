import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/date_converter_controller.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/bs_date_picker.dart';
import '../widgets/difference_display.dart';

enum DateToolTab { conversion, age, math, utilities }

class DateConverterPage extends ConsumerStatefulWidget {
  const DateConverterPage({super.key});

  @override
  ConsumerState<DateConverterPage> createState() => _DateConverterPageState();
}

class _DateConverterPageState extends ConsumerState<DateConverterPage> {
  DateToolTab _selectedTab = DateToolTab.conversion;
  double _addDaysValue = 0;
  double _subtractDaysValue = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dateConverterProvider);
    final controller = ref.read(dateConverterProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTabTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: controller.clearAll,
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Selection
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  _buildTabButton(
                      context, DateToolTab.conversion, '📅 Convert'),
                  _buildTabButton(context, DateToolTab.age, '👤 Age'),
                  _buildTabButton(context, DateToolTab.math, '➕ Math'),
                  _buildTabButton(
                      context, DateToolTab.utilities, '⚙️ Utilities'),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildTabContent(context, state, controller),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, DateToolTab tab, String label) {
    final isSelected = _selectedTab == tab;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() => _selectedTab = tab);
        },
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }

  String _getTabTitle() {
    switch (_selectedTab) {
      case DateToolTab.conversion:
        return 'AD ↔ BS Conversion';
      case DateToolTab.age:
        return 'Age Calculator';
      case DateToolTab.math:
        return 'Date Math';
      case DateToolTab.utilities:
        return 'Date Utilities';
    }
  }

  Widget _buildTabContent(
      BuildContext context, dynamic state, dynamic controller) {
    switch (_selectedTab) {
      case DateToolTab.conversion:
        return _buildConversionTab(context, state, controller);
      case DateToolTab.age:
        return _buildAgeTab(context, state, controller);
      case DateToolTab.math:
        return _buildMathTab(context, state, controller);
      case DateToolTab.utilities:
        return _buildUtilitiesTab(context, state, controller);
    }
  }

  Widget _buildConversionTab(
      BuildContext context, dynamic state, dynamic controller) {
    return Column(
      children: [
        // Conversion Direction Indicator
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'AD',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: state.isConvertingToBs
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.5),
                      ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.compare_arrows,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: controller.toggleConversionDirection,
                ),
                const SizedBox(width: 16),
                Text(
                  'BS',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: !state.isConvertingToBs
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.5),
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Input Section
        if (state.isConvertingToBs) ...[
          DatePickerField(
            label: 'Gregorian Date (AD)',
            selectedDate: state.selectedGregorianDate,
            onDateSelected: controller.setGregorianDate,
          ),
        ] else ...[
          BSDatePicker(
            onDateSelected: controller.setBsDate,
            initialDate: state.bsDateInput.isEmpty ? null : state.bsDateInput,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.convertBsToAd,
              child: const Text('Convert to AD'),
            ),
          ),
        ],
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
                Icon(Icons.error_outline,
                    color: Theme.of(context).colorScheme.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.errorMessage,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Result Section
        if (state.convertedDate != null) ...[
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Converted Date',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateResult(
                          context,
                          'Gregorian (AD)',
                          _formatGregorianDate(
                              state.convertedDate!.gregorianDate),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDateResult(
                          context,
                          'Bikram Sambat (BS)',
                          state.convertedDate!.bsDate,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Day: ${state.convertedDate!.dayOfWeek}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  DifferenceDisplay(
                      difference: state.convertedDate!.difference),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAgeTab(BuildContext context, dynamic state, dynamic controller) {
    return Column(
      children: [
        Text(
          'Birth Date',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        DatePickerField(
          label: 'Select Birth Date',
          selectedDate: state.selectedGregorianDate,
          onDateSelected: (date) {
            controller.setGregorianDate(date);
            controller.calculateAge();
          },
        ),
        const SizedBox(height: 20),

        // Reference date
        Text(
          'Calculate Age As Of',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        DatePickerField(
          label: 'Reference Date (Leave empty for today)',
          selectedDate: state.secondDate,
          onDateSelected: (date) {
            controller.setSecondDate(date);
            if (state.selectedGregorianDate != null) {
              controller.calculateAge();
            }
          },
        ),
        const SizedBox(height: 20),

        // Age Result
        if (state.ageResult != null) ...[
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Your Exact Age',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildAgeCard(
                        context,
                        '${state.ageResult!.years}',
                        'Years',
                      ),
                      _buildAgeCard(
                        context,
                        '${state.ageResult!.months}',
                        'Months',
                      ),
                      _buildAgeCard(
                        context,
                        '${state.ageResult!.days}',
                        'Days',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMathTab(
      BuildContext context, dynamic state, dynamic controller) {
    return Column(
      children: [
        if (state.selectedGregorianDate != null) ...[
          Text(
            'Selected Date: ${_formatGregorianDate(state.selectedGregorianDate)}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
        ],

        // Add Days
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add Days',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Slider(
                  value: _addDaysValue,
                  min: 0,
                  max: 365,
                  divisions: 365,
                  label: 'Days to add: ${_addDaysValue.toInt()}',
                  onChanged: (value) {
                    setState(() => _addDaysValue = value);
                    if (state.selectedGregorianDate != null) {
                      controller.addDays(value.toInt());
                    }
                  },
                ),
                if (state.addedDate != null)
                  Text(
                    'Result: ${_formatGregorianDate(state.addedDate)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Subtract Days
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Subtract Days',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Slider(
                  value: _subtractDaysValue,
                  min: 0,
                  max: 365,
                  divisions: 365,
                  label: 'Days to subtract: ${_subtractDaysValue.toInt()}',
                  onChanged: (value) {
                    setState(() => _subtractDaysValue = value);
                    if (state.selectedGregorianDate != null) {
                      controller.subtractDays(value.toInt());
                    }
                  },
                ),
                if (state.subtractedDate != null)
                  Text(
                    'Result: ${_formatGregorianDate(state.subtractedDate)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUtilitiesTab(
      BuildContext context, dynamic state, dynamic controller) {
    return Column(
      children: [
        // Week Number
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Week Number',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (state.selectedGregorianDate != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Selected Date:'),
                      Text(
                        _formatGregorianDate(state.selectedGregorianDate),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: state.selectedGregorianDate != null
                      ? () => controller.calculateWeekNumber()
                      : null,
                  child: const Text('Calculate Week Number'),
                ),
                if (state.weekNumber != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Week of Year:'),
                        Text(
                          'Week ${state.weekNumber}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Days Between
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Days Between',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('First Date:',
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                DatePickerField(
                  label: 'Date 1',
                  selectedDate: state.selectedGregorianDate,
                  onDateSelected: controller.setGregorianDate,
                ),
                const SizedBox(height: 12),
                Text('Second Date:',
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                DatePickerField(
                  label: 'Date 2',
                  selectedDate: state.secondDate,
                  onDateSelected: (date) {
                    controller.setSecondDate(date);
                    if (state.selectedGregorianDate != null) {
                      controller.calculateDaysBetween();
                    }
                  },
                ),
                if (state.daysBetween != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Days Between:'),
                        Text(
                          '${state.daysBetween} days',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeCard(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
        ),
      ],
    );
  }

  Widget _buildDateResult(BuildContext context, String label, String date) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _formatGregorianDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
