class Percentage {
  static calculatePercentageFromTwoValues(double partialValue, double totalValue) {
    return ((partialValue / totalValue) * 100).toStringAsFixed(2);
  }

  static calculateValueFromPercentageAndValue(double totalValue, double percentage) {
    return ((percentage * totalValue) / 100).toStringAsFixed(2);
  }
}
