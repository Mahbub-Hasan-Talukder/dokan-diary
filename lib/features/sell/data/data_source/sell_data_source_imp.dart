import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/features/sell/domain/entities/sell_request_entity.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper.dart';
import '../../../../core/di/di.dart';
import 'data_source.dart';

// await _db!.rawDelete('DELETE FROM Sales;');
// await _db!.rawDelete('DELETE FROM Items;');
class SellDataSourceImp implements SellDataSource {
  final dbHelper = getIt<DatabaseHelper>();
  Database? _db;

  @override
  Future<List<Map<String, dynamic>>> fetchSellData(
      {required String saleDate}) async {
    _db ??= await dbHelper.database;
    if (_db == null) {
      throw Exception('Database instance not created');
    }

    final result = await _db!.rawQuery('''
    SELECT * FROM Sales WHERE sale_date = ?;
  ''', [saleDate]);

    return result;
  }

  @override
  Future<String> addSellData({required SellRequestEntity entity}) async {
    _db ??= await dbHelper.database;
    if (_db != null) {
      await _db!.rawQuery('''
      INSERT OR REPLACE INTO Sales (item_id, item_name, sale_date, quantity_sold, total_price, total_purchase)
      VALUES (?, ?, ?, ?, ?, ?)
    ''', [
        entity.itemId ?? 'n/a',
        entity.itemName ?? 'Unknown', // Store item name directly
        entity.date,
        entity.soldQuantity ?? 0,
        entity.soldPrice ?? 0,
        entity.totalPurchase ?? 0 // Store purchase price directly
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

  @override
  Future<void> deleteSellFromFirestore(String saleId) async {
    try {
      if (await isSaleExistInFirestore(saleId)) {
        await FirebaseFirestore.instance
            .collection('Sales')
            .doc(saleId.replaceAll('/', '-'))
            .delete();
      }
      return;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> isSaleExistInFirestore(String saleId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Sales')
          .doc(saleId.replaceAll('/', '-'))
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
