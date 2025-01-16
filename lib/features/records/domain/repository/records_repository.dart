import 'package:dartz/dartz.dart';

import '../entities/day_wise_entity.dart';
import '../entities/item_wise_entity.dart';

abstract class RecordsRepository {
  Future<Either<List<DayWiseEntity>, String>> fetchDayWiseData({
    String? startDate,
    String? endDate,
  });
  Future<Either<List<ItemWiseEntity>, String>> fetchItemWiseData({
    String? startDate,
    String? endDate,
  });
}
