import '../../domain/models/calc_entry.dart';

abstract class CalculatorHistorySource {
  Future<void> saveCalculation(CalcEntry entry);
  Future<List<CalcEntry>> getCalculationHistory();
  Future<void> clearHistory();
}

class CalculatorHistorySourceImpl implements CalculatorHistorySource {
  final List<CalcEntry> _memoryHistory = [];

  @override
  Future<void> saveCalculation(CalcEntry entry) async {
    _memoryHistory.insert(0, entry);

    // Keep only last 50 entries in memory
    if (_memoryHistory.length > 50) {
      _memoryHistory.removeLast();
    }

    // In real implementation, save to SharedPreferences
    // await _saveToStorage();
  }

  @override
  Future<List<CalcEntry>> getCalculationHistory() async {
    return List<CalcEntry>.from(_memoryHistory);
  }

  @override
  Future<void> clearHistory() async {
    _memoryHistory.clear();
    // In real implementation, clear from storage
    // await SharedPrefsService.remove(_historyKey);
  }

  // Future<void> _saveToStorage() async {
  //   final historyJson = _memoryHistory.map((entry) => json.encode({
  //     'expression': entry.expression,
  //     'result': entry.result,
  //     'timestamp': entry.timestamp.toIso8601String(),
  //   })).toList();
  //
  //   await SharedPrefsService.setStringList(_historyKey, historyJson);
  // }
  //
  // Future<void> _loadFromStorage() async {
  //   final historyJson = await SharedPrefsService.getStringList(_historyKey);
  //   if (historyJson != null) {
  //     _memoryHistory.clear();
  //     for (final jsonString in historyJson) {
  //       final data = json.decode(jsonString);
  //       _memoryHistory.add(CalcEntry(
  //         expression: data['expression'],
  //         result: data['result'],
  //         timestamp: DateTime.parse(data['timestamp']),
  //       ));
  //     }
  //   }
  // }
}
