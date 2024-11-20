class SellRequestEntity {
  String? itemId;
  String? date;
  double? soldPrice;
  double? soldQuantity;

  SellRequestEntity({
    required this.itemId,
    required this.soldQuantity,
    required this.soldPrice,
    required this.date,
  });
}