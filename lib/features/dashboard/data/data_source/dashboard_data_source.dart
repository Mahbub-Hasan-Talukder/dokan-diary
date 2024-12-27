abstract class DashboardDataSource {
  Future<List<Map<String, dynamic>>> fetchData();
  Future<void> deleteItem(String itemId);
  Future<bool> doesItemExist({required String itemId});
  Future<void> updateItem({
    required String itemId,
    required double newQuantity,
    required double newUnitPrice,
  });
}
