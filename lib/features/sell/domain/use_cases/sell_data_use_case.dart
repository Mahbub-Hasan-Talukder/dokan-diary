import 'package:dartz/dartz.dart';
import 'package:diary/features/sell/domain/entities/fetch_item_entity.dart';
import 'package:diary/features/sell/domain/entities/sell_request_entity.dart';

import '../repository/fetch_sell_data_repo.dart';
import '../entities/sell_data_entity.dart';

class SellDataUseCase {
  SellDataRepo sellDataRepo;

  SellDataUseCase(this.sellDataRepo);

  Future<Either<List<SellDataEntity>, String>> fetchSellData(
      {required String date}) async {
    return await sellDataRepo.fetchSellData(date: date);
  }

  Future<Either<String, String>> addSellData(
      {required SellRequestEntity reqEntity}) async {
    return await sellDataRepo.addSellData(reqEntity: reqEntity);
  }

  Future<Either<List<FetchItemEntity>, String>> fetchItems() async {
    return await sellDataRepo.fetchItems();
  }

  Future<Either<String, String>> undoSell({
    required int saleId,
    required double quantitySold,
    required String itemId,
  }) async {
    return await sellDataRepo.undoSell(
      saleId: saleId,
      quantitySold: quantitySold,
      itemId: itemId,
    );
  }
}
