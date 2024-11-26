import 'package:dartz/dartz.dart';
import 'package:diary/features/sell/data/models/FetchItemResponse.dart';
import 'package:diary/features/sell/domain/entities/fetch_item_entity.dart';
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
  Future<Either<String, String>> addSellData(
      {required SellRequestEntity reqEntity}) async {
    try {
      final result = await sellDataSource.addSellData(entity: reqEntity);
      await sellDataSource.updateItemQuantity(
          reqEntity.itemId ?? '', reqEntity.remainingQuantity ?? 0, 'Items');
      return Left(result);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<List<FetchItemEntity>, String>> fetchItems() async {
    try {
      final result = await sellDataSource.fetchItems();
      final x = result.map((json) {
        return FetchItemResponse.fromJson(json).toEntity();
      }).toList();
      return Left(x);
    } catch (e) {
      return Right(e.toString());
    }
  }

  @override
  Future<Either<String, String>> undoSell({
    required int saleId,
    required double quantitySold,
    required String itemId,
  }) async {
    try {
      final items = await sellDataSource.fetchItems();
      FetchItemEntity? entity;
      for (Map<String, dynamic> jsonItem in items) {
        if (jsonItem['item_id'] == itemId) {
          entity = FetchItemResponse.fromJson(jsonItem).toEntity();
          break;
        }
      }
      if (entity != null) {
        await sellDataSource.updateItemQuantity(
          itemId,
          entity.quantity! + quantitySold,
          'Items',
        );
      }
      await sellDataSource.deleteItem(id: saleId);
      return const Left('Successfully returned');
    } catch (e) {
      return Right(e.toString());
    }
  }
}
