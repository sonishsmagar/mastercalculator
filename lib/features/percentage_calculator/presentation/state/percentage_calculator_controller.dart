import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/calculation_models.dart';

enum CalculatorTab { percentage, discount, profitLoss, gst }

class PercentageCalculatorState {
  static const Object _discountResultSentinel = Object();
  static const Object _profitLossResultSentinel = Object();
  static const Object _gstResultSentinel = Object();

  final CalculatorTab selectedTab;
  
  // Percentage
  final double percentageBase;
  final double percentageValue;
  
  // Discount
  final double discountPrice;
  final double discountPercent;
  final DiscountCalculation? discountResult;
  
  // Profit/Loss
  final double costPrice;
  final double sellingPrice;
  final ProfitLossCalculation? profitLossResult;
  
  // GST
  final double gstPrice;
  final double gstPercent;
  final bool gstInclusive;
  final GSTCalculation? gstResult;

  const PercentageCalculatorState({
    this.selectedTab = CalculatorTab.percentage,
    this.percentageBase = 0,
    this.percentageValue = 0,
    this.discountPrice = 0,
    this.discountPercent = 0,
    this.discountResult,
    this.costPrice = 0,
    this.sellingPrice = 0,
    this.profitLossResult,
    this.gstPrice = 0,
    this.gstPercent = 18,
    this.gstInclusive = false,
    this.gstResult,
  });

  PercentageCalculatorState copyWith({
    CalculatorTab? selectedTab,
    double? percentageBase,
    double? percentageValue,
    double? discountPrice,
    double? discountPercent,
    Object? discountResult = _discountResultSentinel,
    double? costPrice,
    double? sellingPrice,
    Object? profitLossResult = _profitLossResultSentinel,
    double? gstPrice,
    double? gstPercent,
    bool? gstInclusive,
    Object? gstResult = _gstResultSentinel,
  }) {
    return PercentageCalculatorState(
      selectedTab: selectedTab ?? this.selectedTab,
      percentageBase: percentageBase ?? this.percentageBase,
      percentageValue: percentageValue ?? this.percentageValue,
      discountPrice: discountPrice ?? this.discountPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      discountResult: identical(discountResult, _discountResultSentinel)
          ? this.discountResult
          : discountResult as DiscountCalculation?,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      profitLossResult: identical(profitLossResult, _profitLossResultSentinel)
          ? this.profitLossResult
          : profitLossResult as ProfitLossCalculation?,
      gstPrice: gstPrice ?? this.gstPrice,
      gstPercent: gstPercent ?? this.gstPercent,
      gstInclusive: gstInclusive ?? this.gstInclusive,
      gstResult: identical(gstResult, _gstResultSentinel)
          ? this.gstResult
          : gstResult as GSTCalculation?,
    );
  }
}

class PercentageCalculatorController extends StateNotifier<PercentageCalculatorState> {
  PercentageCalculatorController() : super(const PercentageCalculatorState());

  void selectTab(CalculatorTab tab) {
    state = state.copyWith(selectedTab: tab);
  }

  // Percentage
  void setPercentageBase(double value) {
    state = state.copyWith(percentageBase: value);
  }

  void setPercentageValue(double value) {
    state = state.copyWith(percentageValue: value);
  }

  // Discount
  void setDiscountPrice(double price) {
    state = state.copyWith(discountPrice: price);
    _calculateDiscount();
  }

  void setDiscountPercent(double percent) {
    state = state.copyWith(discountPercent: percent);
    _calculateDiscount();
  }

  void _calculateDiscount() {
    if (state.discountPrice <= 0) {
      state = state.copyWith(discountResult: null);
      return;
    }
    final result = DiscountCalculation.calculate(
      originalPrice: state.discountPrice,
      discountPercent: state.discountPercent,
    );
    state = state.copyWith(discountResult: result);
  }

  // Profit/Loss
  void setCostPrice(double price) {
    state = state.copyWith(costPrice: price);
    _calculateProfitLoss();
  }

  void setSellingPrice(double price) {
    state = state.copyWith(sellingPrice: price);
    _calculateProfitLoss();
  }

  void _calculateProfitLoss() {
    if (state.costPrice <= 0) {
      state = state.copyWith(profitLossResult: null);
      return;
    }
    final result = ProfitLossCalculation.calculate(
      costPrice: state.costPrice,
      sellingPrice: state.sellingPrice,
    );
    state = state.copyWith(profitLossResult: result);
  }

  // GST
  void setGstPrice(double price) {
    state = state.copyWith(gstPrice: price);
    _calculateGST();
  }

  void setGstPercent(double percent) {
    state = state.copyWith(gstPercent: percent);
    _calculateGST();
  }

  void toggleGstInclusive() {
    state = state.copyWith(gstInclusive: !state.gstInclusive);
    _calculateGST();
  }

  void _calculateGST() {
    if (state.gstPrice <= 0) {
      state = state.copyWith(gstResult: null);
      return;
    }
    
    final result = state.gstInclusive
        ? GSTCalculation.reverse(
            totalPrice: state.gstPrice,
            gstPercent: state.gstPercent,
          )
        : GSTCalculation.calculate(
            originalPrice: state.gstPrice,
            gstPercent: state.gstPercent,
          );
    state = state.copyWith(gstResult: result);
  }

  void reset() {
    state = const PercentageCalculatorState();
  }
}

final percentageCalculatorProvider =
    StateNotifierProvider<PercentageCalculatorController, PercentageCalculatorState>(
  (ref) => PercentageCalculatorController(),
);
