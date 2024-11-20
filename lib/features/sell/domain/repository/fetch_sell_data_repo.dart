import 'package:dartz/dartz.dart';
import 'package:diary/features/sell/domain/entities/sell_request_entity.dart';
import '../entities/sell_data_entity.dart';

abstract class SellDataRepo{
  Future<Either<List<SellDataEntity>,String>> fetchSellData({required String date});
  Future<Either<String,String>> addSellData({required SellRequestEntity reqEntity});
}