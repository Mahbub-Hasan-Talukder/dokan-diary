import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:diary/features/buy/domain/entities/add_request_entity.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper.dart';
import '../../../../core/di/di.dart';
import '../../domain/entities/update_request_entity.dart';
import 'data_source.dart';

class FetchItemDataSourceImpl implements FetchItemDataSource {
  final dbHelper = getIt<DatabaseHelper>();
  Database? _db;

  @override
  Future<List<Map<String, dynamic>>> fetchItems() async {
    _db ??= await dbHelper.database;
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
  Future<List<Map<String, Object?>>> getItem({required String itemId}) async {
    _db ??= await dbHelper.database;
    if (_db != null) {
      final result = await _db!.query(
        'Items',
        where: 'item_id = ?',
        whereArgs: [itemId],
      );
      return result;
    }
    throw Exception('Database instance not created');
  }

  Future<void> updateItem({
    required String itemId,
    required double unitPrice,
    required double quantity,
  }) async {
    try {
      await updateToFirestore(
        itemId: itemId,
        unitPrice: unitPrice,
        quantity: quantity,
      );

      _db ??= await dbHelper.database;

      // Execute the update query
      await _db!.rawUpdate(
        '''
    UPDATE Items
    SET 
      item_unit_price = ?, 
      item_quantity = ?
    WHERE 
      item_id = ?;
    ''',
        [unitPrice, quantity, itemId], // Bind the values here
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteFromFirestore({required String itemId}) async {
    try {
      if (await isItemExistInFirestore(itemId: itemId)) {
        await FirebaseFirestore.instance
            .collection('Items')
            .doc(itemId.replaceAll('/', '-'))
            .delete();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateToFirestore({
    required String itemId,
    required double unitPrice,
    required double quantity,
  }) async {
    try {
      if (await isItemExistInFirestore(itemId: itemId)) {
        await FirebaseFirestore.instance
            .collection('Items')
            .doc(itemId.replaceAll('/', '-'))
            .update(
          {'item_unit_price': unitPrice, 'item_quantity': quantity},
        );
      }
      return;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> isItemExistInFirestore({required String itemId}) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Items')
          .doc(itemId.replaceAll('/', '-'))
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> updateItemNew(
      {required UpdateRequestEntity entity}) async {
    try {
      if (await isItemExistInFirestore(itemId: entity.itemOldId)) {
        await FirebaseFirestore.instance
            .collection('Items')
            .doc(entity.itemOldId.replaceAll('/', '-'))
            .delete();
      }
      _db ??= await dbHelper.database;
      if (_db != null) {
        await _db!.delete('Items',
            where: 'item_id = ?', whereArgs: [entity.itemOldId]);
        await _db!.insert('Items', entity.toJson());
      }
      return await fetchItems();
    } catch (e) {
      throw Exception('Failed to update item: ${e.toString()}');
    }
  }
}
