import '../../domain/entities/sell_request_entity.dart';

abstract class SellDataSource{
  Future<List<Map<String,dynamic>>> fetchSellData({required String saleDate});
  Future<String> addSellData({required SellRequestEntity entity});
}