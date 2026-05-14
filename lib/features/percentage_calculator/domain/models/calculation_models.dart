class PercentageCalculation {
  final double percentage;
  final double value;

  PercentageCalculation({
    required this.percentage,
    required this.value,
  });
}

class DiscountCalculation {
  final double originalPrice;
  final double discountPercent;
  final double discountAmount;
  final double finalPrice;
  final double savings;

  DiscountCalculation({
    required this.originalPrice,
    required this.discountPercent,
    required this.discountAmount,
    required this.finalPrice,
    required this.savings,
  });

  factory DiscountCalculation.calculate({
    required double originalPrice,
    required double discountPercent,
  }) {
    final discountAmount = originalPrice * (discountPercent / 100);
    final finalPrice = originalPrice - discountAmount;
    return DiscountCalculation(
      originalPrice: originalPrice,
      discountPercent: discountPercent,
      discountAmount: discountAmount,
      finalPrice: finalPrice,
      savings: discountAmount,
    );
  }
}

class ProfitLossCalculation {
  final double costPrice;
  final double sellingPrice;
  final double profit;
  final double loss;
  final double profitPercent;
  final double lossPercent;

  ProfitLossCalculation({
    required this.costPrice,
    required this.sellingPrice,
    required this.profit,
    required this.loss,
    required this.profitPercent,
    required this.lossPercent,
  });

  factory ProfitLossCalculation.calculate({
    required double costPrice,
    required double sellingPrice,
  }) {
    final difference = sellingPrice - costPrice;
    final percent = (difference / costPrice) * 100;

    if (difference > 0) {
      return ProfitLossCalculation(
        costPrice: costPrice,
        sellingPrice: sellingPrice,
        profit: difference,
        loss: 0,
        profitPercent: percent,
        lossPercent: 0,
      );
    } else {
      return ProfitLossCalculation(
        costPrice: costPrice,
        sellingPrice: sellingPrice,
        profit: 0,
        loss: -difference,
        profitPercent: 0,
        lossPercent: -percent,
      );
    }
  }
}

class GSTCalculation {
  final double originalPrice;
  final double gstPercent;
  final double gstAmount;
  final double totalPrice;

  GSTCalculation({
    required this.originalPrice,
    required this.gstPercent,
    required this.gstAmount,
    required this.totalPrice,
  });

  factory GSTCalculation.calculate({
    required double originalPrice,
    required double gstPercent,
  }) {
    final gstAmount = originalPrice * (gstPercent / 100);
    final totalPrice = originalPrice + gstAmount;
    return GSTCalculation(
      originalPrice: originalPrice,
      gstPercent: gstPercent,
      gstAmount: gstAmount,
      totalPrice: totalPrice,
    );
  }

  /// Calculate original price from GST included price
  factory GSTCalculation.reverse({
    required double totalPrice,
    required double gstPercent,
  }) {
    final originalPrice = totalPrice / (1 + (gstPercent / 100));
    final gstAmount = totalPrice - originalPrice;
    return GSTCalculation(
      originalPrice: originalPrice,
      gstPercent: gstPercent,
      gstAmount: gstAmount,
      totalPrice: totalPrice,
    );
  }
}
