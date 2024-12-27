import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/di/di.dart';
import 'dashboard_data_source.dart';

class DashboardDataSourceImp implements DashboardDataSource {
  final firebaseFirestore = FirebaseFirestore.instance;
  final dbHelper = getIt<DatabaseHelper>();
  Database? _db;
  @override
  Future<List<Map<String, dynamic>>> fetchData() async {
    _db ??= await dbHelper.database;
    if (_db != null) return await _db!.query('Items');
    throw Exception('Database instance not created');
  }

  @override
  Future<void> deleteItem(String itemId) async {
    try {
      _db ??= await dbHelper.database;
      if (_db != null) {
        await _db!.rawDelete('''
          DELETE FROM Items WHERE item_id = ?;
        ''', [itemId]);
        await firebaseFirestore.collection('Items').doc(itemId).delete();
        return;
      }
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }

  @override
  Future<bool> doesItemExist({required String itemId}) async {
    _db ??= await dbHelper.database;
    if (_db != null) {
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
  Future<void> updateItem({
    required String itemId,
    required double newQuantity,
    required double newUnitPrice,
  }) async {
    _db ??= await dbHelper.database;

    // Execute the update query
    try {
      await _db!.rawUpdate(
        '''
        UPDATE Items
        SET 
          item_unit_price = ?, 
          item_quantity = ?
        WHERE 
          item_id = ?;
        ''',
        [newUnitPrice, newQuantity, itemId], // Bind the values here
      );

      await firebaseFirestore.collection('Items').doc(itemId).update({
        'item_unit_price': newUnitPrice,
        'item_quantity': newQuantity,
      });
    } catch (e) {
      throw Exception('Failed to update item: ${e.toString()}');
    }
  }
}
