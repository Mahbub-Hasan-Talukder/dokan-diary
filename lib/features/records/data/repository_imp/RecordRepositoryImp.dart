import 'package:dartz/dartz.dart';
import 'package:diary/features/records/data/data_source/data_source.dart';

import 'package:diary/features/records/domain/entities/day_wise_entity.dart';

import '../../domain/repository/records_repository.dart';
import '../model/dayWiseResponse.dart';

class RecordsRepositoryImp implements RecordsRepository {
  RecordsRepositoryImp(this._recordsDataSource);

  final RecordsDataSource _recordsDataSource;

  @override
  Future<Either<List<DayWiseEntity>, String>> fetchDayWiseData(
      {String? startDate, String? endDate}) async {
    try {
      final response = await _recordsDataSource.fetchDayWiseSellInfo();
      final result = response.map((itemJson){
        return DayWiseResponse.fromJson(json: itemJson).toEntity();
      }).toList();
      return Left(result);
    } catch (e) {
      return Right(e.toString());
    }
  }
}
