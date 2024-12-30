import '../../domain/entities/add_request_entity.dart';

abstract class FetchItemDataSource {
  Future<List<Map<String, dynamic>>> fetchItems();
  Future<void> addItems({required AddRequestEntity entity});
  Future<void> deleteItem({required String id});
  Future<bool> doesItemExist({required String itemId});
  Future<List<Map<String, Object?>>> getItem({required String itemId});
  Future<void> deleteFromFirestore({required String itemId});
  Future<void> updateToFirestore({
    required String itemId,
    required double unitPrice,
    required double quantity,
  });
}
