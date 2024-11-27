import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/features/backup/data/data_source/local/local_data_source.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../core/database/database_helper.dart';
import '../../../../../core/di/di.dart';

class SqLiteImp implements BackupLocalDataSource {
  final dbHelper = getIt<DatabaseHelper>();
  Database? _db;

  @override
  Future<List<Map<String, dynamic>>> fetchLocalData(String tableName) async {
    _db ??= await dbHelper.database;
    if (_db != null) return await _db!.query(tableName);
    throw Exception('Database instance not created');
  }

  @override
  Future<void> restoreItemsTable(
      QuerySnapshot<Map<String, dynamic>> snapshots) async {
    _db ??= await dbHelper.database;

    if (_db == null) return;

    for (var snapshot in snapshots.docs) {
      final data = snapshot.data();

      // Extract values from the snapshot
      final itemId = data['item_id'] ?? '';
      final itemName = data['item_name'] ?? '';
      final itemUnitType = data['item_unit_type'] ?? '';
      final itemUnitPrice = data['item_unit_price'] ?? 0.0;
      final itemQuantity = data['item_quantity'] ?? 0.0;

      // Insert or replace the data
      await _db!.rawInsert('''
        INSERT OR REPLACE INTO Items (item_id, item_name, item_unit_type, item_unit_price, item_quantity)
        VALUES (?, ?, ?, ?, ?)
    ''', [
        itemId,
        itemName,
        itemUnitType,
        itemUnitPrice,
        itemQuantity,
      ]);
    }
  }

  @override
  Future<void> restoreSalesTable(
      QuerySnapshot<Map<String, dynamic>> snapshots) async {
    _db ??= await dbHelper.database;

    if (_db == null) return;

    for (var snapshot in snapshots.docs) {
      final data = snapshot.data();

      // Extract values from the snapshot
      final itemId = data['item_id'] ?? '';
      final quantitySold = data['quantity_sold'] ?? '';
      final saleDate = data['sale_date'] ?? '';
      final saleId = data['sale_id'] ?? 0.0;
      final totalPrice = data['total_price'] ?? 0.0;

      // Insert or replace the data
      await _db!.rawInsert('''
        INSERT OR REPLACE INTO Sales (sale_id, item_id, sale_date, quantity_sold, total_price)
        VALUES (?, ?, ?, ?, ?)
    ''', [
        saleId,
        itemId,
        saleDate,
        quantitySold,
        totalPrice,
      ]);
    }
  }
}
