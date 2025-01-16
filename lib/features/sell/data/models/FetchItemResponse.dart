import 'package:diary/features/sell/domain/entities/fetch_item_entity.dart';

class FetchItemResponse {
  String? itemId;
  String? itemName;
  double? unitPrice;
  double? quantity;

  FetchItemResponse({
    required this.itemId,
    required this.itemName,
    required this.unitPrice,
    required this.quantity,
  });

  FetchItemResponse.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    itemName = json['item_name'];
    unitPrice = json['item_unit_price'];
    quantity = json['item_quantity'];
  }

  FetchItemEntity toEntity() {
    return FetchItemEntity(
      itemId: itemId,
      itemName: itemName,
      unitPrice: unitPrice,
      quantity: quantity,
    );
  }
}
