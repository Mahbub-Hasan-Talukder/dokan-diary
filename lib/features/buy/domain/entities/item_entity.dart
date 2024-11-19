import 'package:diary/core/core_entity/core_product_entity.dart';

class ItemEntity extends CoreItemEntity {
  ItemEntity({
    required super.id,
    required super.itemName,
    required super.quantity,
    required super.unitPrice,
    required super.unitType,
  });
}
