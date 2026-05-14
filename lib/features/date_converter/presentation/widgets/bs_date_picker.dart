import 'package:flutter/material.dart';

class BSDatePicker extends StatefulWidget {
  final Function(String) onDateSelected;
  final String? initialDate;

  const BSDatePicker({
    super.key,
    required this.onDateSelected,
    this.initialDate,
  });

  @override
  State<BSDatePicker> createState() => _BSDatePickerState();
}

class _BSDatePickerState extends State<BSDatePicker> {
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();

  final List<String> _bsMonths = [
    'Baishakh',
    'Jestha',
    'Ashadh',
    'Shrawan',
    'Bhadra',
    'Ashwin',
    'Kartik',
    'Mangsir',
    'Poush',
    'Magh',
    'Falgun',
    'Chaitra'
  ];

  @override
  void initState() {
    super.initState();
    _initializeDate();
  }

  void _initializeDate() {
    if (widget.initialDate != null) {
      final parts = widget.initialDate!.split('/');
      if (parts.length == 3) {
        _yearController.text = parts[0];
        _monthController.text = (int.parse(parts[1])).toString();
        _dayController.text = parts[2];
      }
    } else {
      // Set default to current BS date (approximate)
      final now = DateTime.now();
      final currentYear = now.year - 57; // Approximate conversion
      _yearController.text = currentYear.toString();
      _monthController.text = '1';
      _dayController.text = '1';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bikram Sambat Date',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Year Input
            Expanded(
              child: TextField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: 'Year',
                  hintText: 'e.g., 2080',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _updateSelectedDate(),
              ),
            ),
            const SizedBox(width: 12),

            // Month Dropdown
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: _monthController.text.isEmpty
                    ? 1
                    : int.tryParse(_monthController.text),
                decoration: const InputDecoration(
                  labelText: 'Month',
                  border: OutlineInputBorder(),
                ),
                isExpanded: true,
                isDense: true,
                items: List.generate(12, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text(
                      '${index + 1} - ${_bsMonths[index]}',
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    _monthController.text = value.toString();
                    _updateSelectedDate();
                  }
                },
              ),
            ),
            const SizedBox(width: 12),

            // Day Input
            Expanded(
              child: TextField(
                controller: _dayController,
                decoration: const InputDecoration(
                  labelText: 'Day',
                  hintText: '1-32',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _updateSelectedDate(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Quick Actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.today),
                label: const Text('Today (Approx)'),
                onPressed: _setToToday,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
                onPressed: _clearDate,
              ),
            ),
          ],
        ),

        // Validation Message
        const SizedBox(height: 8),
        _buildValidationMessage(),
      ],
    );
  }

  void _updateSelectedDate() {
    final year = _yearController.text;
    final month = _monthController.text;
    final day = _dayController.text;

    if (year.isNotEmpty && month.isNotEmpty && day.isNotEmpty) {
      final bsDate = '$year/${month.padLeft(2, '0')}/${day.padLeft(2, '0')}';
      widget.onDateSelected(bsDate);
    }
  }

  void _setToToday() {
    final now = DateTime.now();
    final currentYear = now.year - 57; // Approximate conversion
    final currentMonth = now.month;
    final currentDay = now.day;

    setState(() {
      _yearController.text = currentYear.toString();
      _monthController.text = currentMonth.toString();
      _dayController.text = currentDay.toString();
    });

    _updateSelectedDate();
  }

  void _clearDate() {
    setState(() {
      _yearController.clear();
      _monthController.clear();
      _dayController.clear();
    });
    widget.onDateSelected('');
  }

  Widget _buildValidationMessage() {
    final year = _yearController.text;
    final month = _monthController.text;
    final day = _dayController.text;

    if (year.isEmpty || month.isEmpty || day.isEmpty) {
      return const SizedBox();
    }

    final yearInt = int.tryParse(year);
    final monthInt = int.tryParse(month);
    final dayInt = int.tryParse(day);

    if (yearInt == null || monthInt == null || dayInt == null) {
      return Text(
        'Please enter valid numbers',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      );
    }

    if (yearInt < 2000 || yearInt > 2100) {
      return Text(
        'Year should be between 2000 and 2100 BS',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      );
    }

    if (monthInt < 1 || monthInt > 12) {
      return Text(
        'Month should be between 1 and 12',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      );
    }

    if (dayInt < 1 || dayInt > 32) {
      return Text(
        'Day should be between 1 and 32',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      );
    }

    return Text(
      'Selected: $year/${month.padLeft(2, '0')}/${day.padLeft(2, '0')} BS',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }
}
