import 'package:diary/features/sell/domain/entities/sell_request_entity.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper.dart';
import '../../../../core/di/di.dart';
import 'data_source.dart';

class SellDataSourceImp implements SellDataSource {
  final dbHelper = getIt<DatabaseHelper>();
  Database? _db;

  @override
  Future<List<Map<String, dynamic>>> fetchSellData(
      {required String saleDate}) async {
    _db ??= await dbHelper.database;
    if (_db != null) {
      final result = await _db!.rawQuery('''
        SELECT i.item_name, i.item_id, s.sale_date, s.quantity_sold, s.total_price
        FROM Sales s
        JOIN Items i ON s.item_id = i.item_id
        WHERE s.sale_date = ?;
      ''', [saleDate]);
      return result;
    }
    throw Exception('Database instance not created');
  }

  @override
  Future<String> addSellData({required SellRequestEntity entity}) async {
    _db ??= await dbHelper.database;
    if (_db != null) {
      await _db!.rawQuery('''
        INSERT INTO Sales (item_id, quantity_sold, total_price)
        VALUES (?, ?, ?)
      ''', [entity.itemId ?? 'n/a', entity.soldQuantity ?? 0, entity.soldPrice ?? 0]);
      return 'Information added successfully';
    }
    throw Exception('Database instance not created');
  }
}
