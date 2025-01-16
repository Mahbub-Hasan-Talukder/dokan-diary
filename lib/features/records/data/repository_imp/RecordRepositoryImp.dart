import 'package:dartz/dartz.dart';
import 'package:diary/features/records/data/data_source/data_source.dart';

import 'package:diary/features/records/domain/entities/day_wise_entity.dart';
import 'package:diary/features/records/domain/entities/item_wise_entity.dart';

import '../../domain/repository/records_repository.dart';
import '../model/dayWiseResponse.dart';
import '../model/itemWiseResponse.dart';

class RecordsRepositoryImp implements RecordsRepository {
  RecordsRepositoryImp(this._recordsDataSource);

  final RecordsDataSource _recordsDataSource;

  @override
  Future<Either<List<DayWiseEntity>, String>> fetchDayWiseData(
      {String? startDate, String? endDate}) async {
    try {
      final response = await _recordsDataSource.fetchDayWiseSellInfo(
        startDate: startDate,
        endDate: endDate,
      );
      final result = response.map((itemJson) {
        return DayWiseResponse.fromJson(json: itemJson).toEntity();
      }).toList();
      return Left(result);
    } catch (e) {
      return Right(e.toString());
    }
  }

  @override
  Future<Either<List<ItemWiseEntity>, String>> fetchItemWiseData(
      {String? startDate, String? endDate}) async {
    try {
      final response = await _recordsDataSource.fetchItemWiseSellInfo(
        startDate: startDate,
        endDate: endDate,
      );
      final result = response.map((itemJson) {
        return ItemWiseResponse.fromJson(json: itemJson).toEntity();
      }).toList();
      return Left(result);
    } catch (e) {
      return Right(e.toString());
    }
  }
}
