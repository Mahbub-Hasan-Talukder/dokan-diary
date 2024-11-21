import '../../domain/entities/sell_request_entity.dart';

abstract class SellDataSource{
  Future<List<Map<String,dynamic>>> fetchSellData({required String saleDate});
  Future<String> addSellData({required SellRequestEntity entity});
  Future<List<Map<String,dynamic>>> fetchItems();
  Future<void> updateItemQuantity(String itemId, double newQuantity);
}