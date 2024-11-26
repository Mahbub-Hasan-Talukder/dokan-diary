import 'package:dartz/dartz.dart';

import '../entities/day_wise_entity.dart';

abstract class RecordsRepository {
  Future<Either<List<DayWiseEntity>, String>> fetchDayWiseData({
    String? startDate,
    String? endDate,
  });
}
