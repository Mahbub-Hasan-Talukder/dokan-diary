class UpdateRequestEntity {
  String itemId;
  double unitPrice;
  double quantity;
  String itemName;
  String unitType;

  UpdateRequestEntity({
    required this.itemId,
    required this.unitPrice,
    required this.quantity,
    required this.itemName,
    required this.unitType,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'item_unit_price': unitPrice,
      'item_quantity': quantity,
      'item_name': itemName,
      'item_unit_type': unitType,
    };
  }
}
