class ItemWiseEntity {
  String? itemName;
  double? totalSell;
  double? purchaseCost;
  double? percentage;

  ItemWiseEntity({
    required this.totalSell,
    required this.itemName,
    required this.purchaseCost,
    this.percentage,
  });
}
