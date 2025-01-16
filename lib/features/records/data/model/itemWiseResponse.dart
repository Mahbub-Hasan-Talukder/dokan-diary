import 'package:diary/features/records/domain/entities/day_wise_entity.dart';

import '../../domain/entities/item_wise_entity.dart';

class ItemWiseResponse {
  String? itemName;
  double? totalSell;
  double? purchaseCost;

  ItemWiseResponse({
    required this.totalSell,
    required this.itemName,
    required this.purchaseCost,
  });

  ItemWiseResponse.fromJson({required Map<String, dynamic> json}) {
    itemName = json['item_name'];
    totalSell = json['total_sell_amount'];
    purchaseCost = json['total_purchase_cost'];
  }

  ItemWiseEntity toEntity() {
    return ItemWiseEntity(
      itemName: itemName,
      totalSell: totalSell,
      purchaseCost: purchaseCost,
      percentage: ((totalSell??0)-(purchaseCost??0))/(purchaseCost??1)*100,
    );
  }
}
