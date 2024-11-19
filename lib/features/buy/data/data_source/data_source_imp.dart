import 'package:dartz/dartz.dart';
import 'package:diary/features/buy/domain/entities/add_request_entity.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper.dart';
import '../../../../core/di/di.dart';
import 'data_source.dart';

class FetchItemDataSourceImpl implements FetchItemDataSource {
  final dbHelper = getIt<DatabaseHelper>();
  Database? _db;

  @override
  Future<List<Map<String, dynamic>>> fetchItems() async {
    _db ??= await dbHelper.database;
    _db = await dbHelper.database;
    if (_db != null) return await _db!.query('Items');
    throw Exception('Database instance not created');
  }

  @override
  Future<void> addItems({required AddRequestEntity entity}) async {
    _db ??= await dbHelper.database;
    if (_db != null) {
      await _db!.rawInsert('''
  INSERT OR REPLACE INTO Items (item_id, item_name, item_unit_type, item_unit_price, item_quantity)
  VALUES (?, ?, ?, ?, ?)
''', [
        entity.id,
        entity.itemName,
        entity.unitType,
        entity.unitPrice,
        entity.quantity,
      ]);
      return;
    }
    throw Exception('Database instance not created');
  }

  @override
  Future<void> deleteItem({required String id}) async {
    _db ??= await dbHelper.database;
    if (_db != null) {
      await _db!.rawDelete('''
        DELETE FROM Items WHERE item_id = ?;
      ''', [id]);
      return;
    }
    throw Exception('Database instance not created');
  }

  @override
  Future<bool>doesItemExist({required String itemId})async {
    _db ??= await dbHelper.database;
    if(_db!=null){
      final result = await _db!.query(
        'Items',
        where: 'item_id = ?',
        whereArgs: [itemId],
      );
      return result.isNotEmpty;
    }
    throw Exception('Database instance not created');
  }

  @override
  Future<List<Map<String, Object?>>> getItem({required String itemId}) async{
    _db ??= await dbHelper.database;
    if(_db!=null){
      final result = await _db!.query(
        'Items',
        where: 'item_id = ?',
        whereArgs: [itemId],
      );
      return result;
    }
    throw Exception('Database instance not created');
  }


}
