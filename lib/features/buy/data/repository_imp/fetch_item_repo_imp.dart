import 'package:dartz/dartz.dart';
import 'package:diary/features/buy/domain/entities/add_request_entity.dart';

import '../../domain/entities/item_entity.dart';
import '../../domain/repository/fetch_item_repo.dart';
import '../data_source/data_source.dart';
import '../models/item_model.dart';

class FetchItemRepoImp implements FetchItemRepo {
  FetchItemDataSource fetchItemDataSource;

  FetchItemRepoImp(this.fetchItemDataSource);

  @override
  Future<Either<List<ItemEntity>, String>> fetchItems() async {
    try {
      final response = await fetchItemDataSource.fetchItems();
      final res = response.map((json) {
        return ItemModel.fromJson(json).toEntity();
      }).toList();
      return Left(res);
    } catch (e) {
      Right(e.toString());
    }
    return const Right('Something went wrong');
  }

  @override
  Future<Either<String, String>> addItems(
      {required AddRequestEntity entity}) async {
    try {
      if (await fetchItemDataSource.doesItemExist(itemId: entity.id ?? '')) {
        final fetchedData =
            await fetchItemDataSource.getItem(itemId: entity.id ?? '');
        final fetchedEntity = ItemModel.fromJson(fetchedData.first).toEntity();
        double inputUnitPrice = entity.unitPrice ?? 0;
        double inputQuantity = entity.quantity ?? 0;
        double fetchedUnitPrice = fetchedEntity.unitPrice ?? 0;
        double fetchedQuantity = fetchedEntity.quantity ?? 0;
        double newQuantity = inputQuantity + fetchedQuantity;
        double newUnitPrice = (inputUnitPrice * inputQuantity +
            fetchedUnitPrice * fetchedQuantity) /
            newQuantity;
        entity.quantity = newQuantity;
        entity.unitPrice = newUnitPrice.floorToDouble();
      }
      fetchItemDataSource.addItems(entity: entity);
      return const Left('Data added successfully');
    } catch (e) {
      return Right(e.toString());
    }
  }

  @override
  Future<Either<String, String>> deleteItem({required String id}) async {
    try {
      if (await fetchItemDataSource.doesItemExist(itemId: id)) {
        await fetchItemDataSource.deleteItem(id: id);
        return const Left('Successfully deleted.');
      }
      return const Right("Item doesn't exists");
    } catch (e) {
      return Right(e.toString());
    }
  }
}
