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
      // await _db!.rawDelete('DELETE FROM Sales;');
      // await _db!.rawDelete('DELETE FROM Items;');
      final result = await _db!.rawQuery('''
        SELECT *
        FROM Sales s JOIN Items i 
        ON s.item_id = i.item_id
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
        INSERT OR REPLACE INTO Sales (item_id, sale_date, quantity_sold, total_price)
        VALUES (?, ?, ?, ?)
      ''', [
        entity.itemId ?? 'n/a',
        entity.date,
        entity.soldQuantity ?? 0,
        entity.soldPrice ?? 0
      ]);
      return 'Information added successfully';
    }
    throw Exception('Database instance not created');
  }

  @override
  Future<List<Map<String, dynamic>>> fetchItems() async {
    _db ??= await dbHelper.database;
    if (_db != null) return await _db!.query('Items');
    throw Exception('Database instance not created');
  }

  @override
  Future<void> updateItemQuantity(
      String itemId, double newQuantity, String tableName) async {
    _db ??= await dbHelper.database;
    if (_db != null) {
      await _db!.rawUpdate('''
        UPDATE $tableName
        SET item_quantity = ?
        WHERE item_id = ?;
      ''', [newQuantity, itemId]);
    }
  }

  @override
  Future<void> deleteItem({required int id}) async {
    _db ??= await dbHelper.database;
    if (_db != null) {
      await _db!.rawDelete('''
        DELETE FROM Sales WHERE sale_id = ?;
      ''', [id]);
      return;
    }
    throw Exception('Database instance not created');
  }
}
