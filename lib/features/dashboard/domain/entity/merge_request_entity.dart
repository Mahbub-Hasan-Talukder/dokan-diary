class MergeRequestEntity {
  final String intoItemId;
  final double intoItemNewQuantity;
  final double intoItemNewUnitPrice;
  final String mergingItemId;

  MergeRequestEntity({
    required this.intoItemId,
    required this.intoItemNewQuantity,
    required this.intoItemNewUnitPrice,
    required this.mergingItemId,
  });
}
