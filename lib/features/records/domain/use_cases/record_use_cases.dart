import 'package:dartz/dartz.dart';

import '../entities/day_wise_entity.dart';
import '../entities/item_wise_entity.dart';
import '../repository/records_repository.dart';

class RecordsUseCases{
  final RecordsRepository _recordsRepository;
  RecordsUseCases(this._recordsRepository);

  Future<Either<List<DayWiseEntity>,String>> fetchDayWiseData({String? startDate, String? endDate,}) async {
    return await _recordsRepository.fetchDayWiseData();
  }
  Future<Either<List<ItemWiseEntity>,String>> fetchItemWiseData({String? startDate, String? endDate,}) async {
    return await _recordsRepository.fetchItemWiseData();
  }
}