import 'package:dartz/dartz.dart';
import 'package:diary/features/sell/domain/entities/sell_request_entity.dart';

import '../models/sell_data_model.dart';
import '../../domain/entities/sell_data_entity.dart';
import '../../domain/repository/fetch_sell_data_repo.dart';
import '../data_source/data_source.dart';

class SellDataRepoImp implements SellDataRepo {
  SellDataSource sellDataSource;

  SellDataRepoImp(this.sellDataSource);

  @override
  Future<Either<List<SellDataEntity>, String>> fetchSellData(
      {required String date}) async {
    try {
      final result = await sellDataSource.fetchSellData(saleDate: date);
      return Left(result.map((json) {
        return SellDataModel.fromJson(json).toEntity();
      }).toList());
    } catch (e) {
      return Right(e.toString());
    }
  }

  @override
  Future<Either<String, String>> addSellData({required SellRequestEntity reqEntity})async {
    try{
      final result = await sellDataSource.addSellData(entity: reqEntity);
      return Left(result);
    }catch(e){
      return right(e.toString());
    }
  }
}
