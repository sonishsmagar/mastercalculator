class AgeResult {
  final int years;
  final int months;
  final int days;

  AgeResult({required this.years, required this.months, required this.days});

  @override
  String toString() => '$years years, $months months, $days days';
}
