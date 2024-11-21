import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper.dart';
import '../../../../core/di/di.dart';
import 'data_source.dart';

class FireStoreImp implements BackupDataSource {
  final dbHelper = getIt<DatabaseHelper>();
  Database? _db;

  @override
  Future<QuerySnapshot<Map<String,dynamic>>> restore(String tableName)async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String,dynamic>> snapshot = await fireStore.collection(tableName).get();
    // print(snapshot);
    return snapshot;
  }

  @override
  Future<void> upload(List<Map<String, dynamic>> items) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    CollectionReference itemsCollection = fireStore.collection("Items");
    for (var item in items) {
      await itemsCollection.doc(item['item_id']).set(item);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchLocalData(String tableName) async {
    _db ??= await dbHelper.database;
    if (_db != null) return await _db!.query(tableName);
    throw Exception('Database instance not created');
  }
}
