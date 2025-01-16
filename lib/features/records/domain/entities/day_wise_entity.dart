class DayWiseEntity {
  String? date;
  double? totalSell;
  double? purchaseCost;
  double? percentage;

  DayWiseEntity({
    required this.totalSell,
    required this.date,
    required this.purchaseCost,
    this.percentage,
  });
}
