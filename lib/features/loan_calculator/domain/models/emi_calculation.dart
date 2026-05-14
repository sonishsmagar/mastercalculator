class EMICalculation {
  final double monthlyEMI;
  final double totalPayment;
  final double totalInterest;
  final double principal;
  final double annualRate;
  final int months;

  EMICalculation({
    required this.monthlyEMI,
    required this.totalPayment,
    required this.totalInterest,
    required this.principal,
    required this.annualRate,
    required this.months,
  });

  /// EMI = P * r * (1 + r)^n / ((1 + r)^n - 1)
  /// where P = Principal, r = monthly rate, n = number of months
  factory EMICalculation.calculate({
    required double principal,
    required double annualRate,
    required int months,
  }) {
    final monthlyRate = annualRate / 12 / 100;
    
    if (monthlyRate == 0) {
      final monthlyEMI = principal / months;
      return EMICalculation(
        monthlyEMI: monthlyEMI,
        totalPayment: principal,
        totalInterest: 0,
        principal: principal,
        annualRate: annualRate,
        months: months,
      );
    }

    final numerator = monthlyRate * ((1 + monthlyRate).pow(months).toDouble());
    final denominator = ((1 + monthlyRate).pow(months).toDouble() - 1);
    final monthlyEMI = principal * (numerator / denominator);
    final totalPayment = monthlyEMI * months;
    final totalInterest = totalPayment - principal;

    return EMICalculation(
      monthlyEMI: monthlyEMI,
      totalPayment: totalPayment,
      totalInterest: totalInterest,
      principal: principal,
      annualRate: annualRate,
      months: months,
    );
  }
}

extension on num {
  num pow(int exponent) {
    if (exponent == 0) return 1;
    num result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= this;
    }
    return result;
  }
}
