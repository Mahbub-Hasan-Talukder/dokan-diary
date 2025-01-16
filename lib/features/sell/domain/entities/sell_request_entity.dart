class SellRequestEntity {
  String? itemId;
  String? date;
  double? soldPrice;
  double? soldQuantity;
  double? remainingQuantity;

  SellRequestEntity({
    required this.itemId,
    required this.soldQuantity,
    required this.soldPrice,
    required this.date,
    required this.remainingQuantity,
  });
}