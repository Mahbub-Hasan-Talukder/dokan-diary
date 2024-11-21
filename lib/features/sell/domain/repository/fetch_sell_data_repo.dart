import 'package:dartz/dartz.dart';
import '../entities/fetch_item_entity.dart';
import '../entities/sell_request_entity.dart';
import '../entities/sell_data_entity.dart';

abstract class SellDataRepo{
  Future<Either<List<SellDataEntity>,String>> fetchSellData({required String date});
  Future<Either<String,String>> addSellData({required SellRequestEntity reqEntity});
  Future<Either<List<FetchItemEntity>,String>> fetchItems();
}