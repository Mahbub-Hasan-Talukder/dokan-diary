import 'package:dartz/dartz.dart';

import '../entities/add_request_entity.dart';
import '../entities/item_entity.dart';
import '../entities/update_request_entity.dart';
import '../repository/fetch_item_repo.dart';

class FetchItemUseCase {
  FetchItemRepo fetchItemRepo;
  FetchItemUseCase(this.fetchItemRepo);

  Future<Either<List<ItemEntity>, String>> call() async {
    return await fetchItemRepo.fetchItems();
  }

  Future<Either<String, String>> add({required AddRequestEntity entity}) async {
    return await fetchItemRepo.addItems(entity: entity);
  }

  Future<Either<String, String>> delete({required String itemId}) async {
    return await fetchItemRepo.deleteItem(id: itemId);
  }

  Future<Either<List<ItemEntity>, String>> update(
      {required UpdateRequestEntity entity}) async {
    return await fetchItemRepo.updateItem(entity: entity);
  }
}
