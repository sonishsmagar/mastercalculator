import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/emi_calculation.dart';

class LoanCalculatorState {
  static const Object _calculationSentinel = Object();

  final double principal;
  final double annualRate;
  final int tenure; // in months
  final EMICalculation? calculation;

  const LoanCalculatorState({
    this.principal = 0,
    this.annualRate = 0,
    this.tenure = 12,
    this.calculation,
  });

  LoanCalculatorState copyWith({
    double? principal,
    double? annualRate,
    int? tenure,
    Object? calculation = _calculationSentinel,
  }) {
    return LoanCalculatorState(
      principal: principal ?? this.principal,
      annualRate: annualRate ?? this.annualRate,
      tenure: tenure ?? this.tenure,
      calculation: identical(calculation, _calculationSentinel)
          ? this.calculation
          : calculation as EMICalculation?,
    );
  }
}

class LoanCalculatorController extends StateNotifier<LoanCalculatorState> {
  static const double _minPrincipal = 0;
  static const double _maxPrincipal = 10000000;
  static const double _minAnnualRate = 0;
  static const double _maxAnnualRate = 25;
  static const int _minTenure = 1;
  static const int _maxTenure = 480;

  LoanCalculatorController() : super(const LoanCalculatorState());

  void setPrincipal(double amount) {
    final normalized = _normalizeDouble(amount, _minPrincipal, _maxPrincipal);
    state = state.copyWith(principal: normalized);
    _calculateEMI();
  }

  void setAnnualRate(double rate) {
    final normalized = _normalizeDouble(rate, _minAnnualRate, _maxAnnualRate);
    state = state.copyWith(annualRate: normalized);
    _calculateEMI();
  }

  void setTenure(int months) {
    final normalized = months.clamp(_minTenure, _maxTenure);
    state = state.copyWith(tenure: normalized);
    _calculateEMI();
  }

  void _calculateEMI() {
    if (state.principal <= 0 || state.tenure <= 0) {
      state = state.copyWith(calculation: null);
      return;
    }

    try {
      final calculation = EMICalculation.calculate(
        principal: state.principal,
        annualRate: state.annualRate,
        months: state.tenure,
      );
      state = state.copyWith(calculation: calculation);
    } catch (e) {
      state = state.copyWith(calculation: null);
    }
  }

  void reset() {
    state = const LoanCalculatorState();
  }

  double _normalizeDouble(double value, double min, double max) {
    if (value.isNaN || value.isInfinite) return min;
    return value.clamp(min, max).toDouble();
  }
}

final loanCalculatorProvider =
    StateNotifierProvider<LoanCalculatorController, LoanCalculatorState>(
  (ref) => LoanCalculatorController(),
);
