import '../../domain/entity/dashboard_entity.dart';

class DashboardModel {
  String? id;
  String? itemName;
  double? quantity;
  double? unitPrice;
  DashboardModel({
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
  });
  DashboardModel.fromJson(Map<String, dynamic> json) {
    id = json['item_id'];
    itemName = json['item_name'];
    quantity = json['item_quantity'];
    unitPrice = json['item_unit_price'];
  }
  DashboardEntity toEntity() {
    return DashboardEntity(
      id: id,
      itemName: itemName,
      quantity: quantity,
      unitPrice: unitPrice,
    );
  }
}
