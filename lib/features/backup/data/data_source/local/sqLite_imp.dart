import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

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
    final fetchedData = _db!.query(tableName);

    if (_db != null) return await fetchedData;
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
    QuerySnapshot<Map<String, dynamic>> salesSnapshots,
    QuerySnapshot<Map<String, dynamic>> itemsSnapshots,
  ) async {
    try {
      _db ??= await dbHelper.database;
      if (_db == null) return;

      // Create a map to quickly find item details using item_id
      Map<String, Map<String, dynamic>> itemsMap = {};

      for (var item in itemsSnapshots.docs) {
        final itemData = item.data();
        final String itemId = itemData['item_id']?.toString() ?? "0";
        final String itemName = itemData['item_name'] ?? 'Unknown';
        final double unitPrice =
            double.tryParse(itemData['item_unit_price'].toString()) ?? 0.0;

        itemsMap[itemId] = {
          'item_name': itemName,
          'unit_price': unitPrice,
        };
      }

      for (var snapshot in salesSnapshots.docs) {
        final data = snapshot.data();
        final String itemId = data['item_id']?.toString() ?? "0";
        final double quantitySold =
            double.tryParse(data['quantity_sold'].toString()) ?? 0;
        final String saleDate = data['sale_date'] ?? '';
        final int saleId = int.tryParse(data['sale_id'].toString()) ?? 0;
        final double totalPrice =
            double.tryParse(data['total_price'].toString()) ?? 0.0;

        // Retrieve item details
        final String itemName =
            itemsMap[itemId]?['item_name'] ?? _getItemName(itemId) ?? 'Unknown';
        final double unitPrice = (itemsMap[itemId]?['unit_price'] ??
            _getItemUnitPrice(itemId) ??
            0.0) as double;

        // Calculate total_purchase
        final double totalPurchase = quantitySold * unitPrice;

        // Insert or replace the data
        await _db!.rawInsert('''
        INSERT OR REPLACE INTO Sales (sale_id, item_id, item_name, sale_date, quantity_sold, total_price, total_purchase)
        VALUES (?, ?, ?, ?, ?, ?, ?)
      ''', [
          saleId,
          itemId,
          itemName,
          saleDate,
          quantitySold,
          totalPrice,
          totalPurchase,
        ]);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> exportTablesToJson() async {
    try {
      _db ??= await dbHelper.database;
      if (_db == null) return;
      // Fetch data from Items table
      final itemsData = await _db!.rawQuery('SELECT * FROM Items');
      final salesData = await _db!.rawQuery('SELECT * FROM Sales');

      // Convert data to JSON
      final itemsJson = jsonEncode(itemsData);
      final salesJson = jsonEncode(salesData);

      // Get directory to save files
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Unable to access external storage');
      }

      // Define file paths
      final itemsFile = File('${directory.path}/items.json');
      final salesFile = File('${directory.path}/sales.json');

      // Write JSON data to files
      await itemsFile.writeAsString(itemsJson);
      await salesFile.writeAsString(salesJson);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void instantDelete() async {
    try {
      _db ??= await dbHelper.database;
      if (_db == null) return;
      await _db!.rawDelete('DELETE FROM Sales;');
      await _db!.rawDelete('DELETE FROM Items;');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  _getItemName(String itemId) {
    return itemId.split('_').first;
  }

  _getItemUnitPrice(String itemId) {
    return double.tryParse(itemId.split('_').last) ?? 0.0;
  }
}
