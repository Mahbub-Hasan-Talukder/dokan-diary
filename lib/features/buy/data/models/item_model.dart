
import '../../domain/entities/item_entity.dart';

class ItemModel {
  String? id;
  String? itemName;
  String? unitType;
  double? quantity;
  double? unitPrice;

  ItemModel({
    this.id,
    this.itemName,
    this.quantity,
    this.unitType,
    this.unitPrice,
  });

  ItemModel.fromJson(Map<String, dynamic> json) {
    id = json['item_id'];
    itemName = json['item_name'];
    unitType = json['item_unit_type'];
    quantity = json['item_quantity'];
    unitPrice = json['item_unit_price'];
  }

  ItemEntity toEntity() {
    return ItemEntity(
      id: id,
      itemName: itemName,
      quantity: quantity,
      unitType: unitType,
      unitPrice: unitPrice,
    );
  }
}
