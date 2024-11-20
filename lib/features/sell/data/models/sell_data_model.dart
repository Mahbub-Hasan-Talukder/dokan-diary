import 'package:diary/features/sell/domain/entities/sell_data_entity.dart';

class SellDataModel {
  String? itemName;
  String? itemId;
  String? sellDate;
  double? quantitySold;
  double? totalPrice;

  SellDataModel({
    this.itemName,
    this.itemId,
    this.sellDate,
    this.quantitySold,
    this.totalPrice,
  });

  SellDataModel.fromJson(Map<String,dynamic> json){
    itemName = json['item_name'];
    itemId = json['item_id'];
    sellDate = json['sale_date'];
    quantitySold = json['quantity_sold'];
    totalPrice = json['total_price'];
  }

  SellDataEntity toEntity(){
    return SellDataEntity(
      itemName: itemName,
      itemId: itemId,
      sellDate: sellDate,
      quantitySold: quantitySold,
      totalPrice: totalPrice,
    );
  }
}
