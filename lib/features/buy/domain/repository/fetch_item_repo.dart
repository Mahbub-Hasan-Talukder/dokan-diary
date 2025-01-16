import 'package:dartz/dartz.dart';

import '../entities/add_request_entity.dart';
import '../entities/item_entity.dart';
import '../entities/update_request_entity.dart';

abstract class FetchItemRepo {
  Future<Either<List<ItemEntity>, String>> fetchItems();
  Future<Either<String, String>> addItems({required AddRequestEntity entity});
  Future<Either<String, String>> deleteItem({required String id});
  Future<Either<List<ItemEntity>, String>> updateItem(
      {required UpdateRequestEntity entity});
}
