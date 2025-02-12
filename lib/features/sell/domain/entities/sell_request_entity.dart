class SellRequestEntity {
  String? itemId;
  String? date;
  double? soldPrice;
  double? soldQuantity;
  double? remainingQuantity;
  double? totalPurchase;
  String? itemName;

  SellRequestEntity({
    required this.itemId,
    required this.itemName,
    required this.soldQuantity,
    required this.soldPrice,
    required this.date,
    required this.remainingQuantity,
    required this.totalPurchase,
  });
}
