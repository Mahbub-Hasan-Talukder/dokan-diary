import 'package:diary/features/sell/domain/entities/sell_data_entity.dart';

class SellDataModel {
  String? itemName;
  String? itemId;
  String? sellDate;
  double? quantitySold;
  double? totalPrice;
  double? unitPrice;

  SellDataModel({
    this.itemName,
    this.itemId,
    this.sellDate,
    this.quantitySold,
    this.totalPrice,
    this.unitPrice,
  });

  SellDataModel.fromJson(Map<String, dynamic> json) {
    itemName = json['item_name'];
    itemId = json['item_id'];
    sellDate = json['sale_date'];
    quantitySold = json['quantity_sold'];
    totalPrice = json['total_price'];
    unitPrice = json['item_unit_price'];
  }

  SellDataEntity toEntity() {
    double profit = (totalPrice ?? 0) - (quantitySold ?? 0) * (unitPrice ?? 0);
    return SellDataEntity(
      itemName: itemName,
      itemId: itemId,
      sellDate: sellDate,
      quantitySold: quantitySold,
      totalPrice: totalPrice,
      profit: profit,
    );
  }
}
