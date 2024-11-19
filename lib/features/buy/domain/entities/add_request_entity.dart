import 'package:diary/core/core_entity/core_product_entity.dart';

class AddRequestEntity extends CoreItemEntity{
  AddRequestEntity({
    required super.id,
    required super.itemName,
    required super.quantity,
    required super.unitPrice,
    required super.unitType,
  });
}