import 'package:diary/features/sell/domain/entities/sell_data_entity.dart';

class SellDataModel {
  String? itemName;
  String? itemId;
  int? saleId;
  String? sellDate;
  double? quantitySold;
  double? totalPrice;
  double? totalPurchase;

  SellDataModel({
    this.itemName,
    this.itemId,
    this.sellDate,
    this.quantitySold,
    this.totalPrice,
    this.totalPurchase,
    this.saleId,
  });

  SellDataModel.fromJson(Map<String, dynamic> json) {
    itemName = json['item_name'];
    itemId = json['item_id'];
    sellDate = json['sale_date'];
    quantitySold = json['quantity_sold'];
    totalPrice = json['total_price'];
    totalPurchase = json['total_purchase'];
    saleId = json['sale_id'];
  }

  SellDataEntity toEntity() {
    double profit = (totalPrice ?? 0) - (totalPurchase ?? 0);
    return SellDataEntity(
      itemName: itemName,
      itemId: itemId,
      sellDate: sellDate,
      quantitySold: quantitySold,
      totalPrice: totalPrice,
      profit: profit,
      saleId: saleId,
    );
  }
}
