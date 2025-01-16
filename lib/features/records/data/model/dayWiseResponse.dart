import 'package:diary/features/records/domain/entities/day_wise_entity.dart';

class DayWiseResponse {
  String? date;
  double? totalSell;
  double? purchaseCost;

  DayWiseResponse({
    required this.totalSell,
    required this.date,
    required this.purchaseCost,
  });

  DayWiseResponse.fromJson({required Map<String, dynamic> json}) {
    date = json['sale_date'];
    totalSell = json['total_sell_amount'];
    purchaseCost = json['total_purchase_cost'];
  }

  DayWiseEntity toEntity() {
    return DayWiseEntity(
      date: date,
      totalSell: totalSell,
      purchaseCost: purchaseCost,
      percentage: ((totalSell??0)-(purchaseCost??0))/(purchaseCost??1)*100,
    );
  }
}
