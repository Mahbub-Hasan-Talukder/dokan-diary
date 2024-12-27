import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper.dart';
import '../../../../core/di/di.dart';
import 'dashboard_data_source.dart';

class DashboardDataSourceImp implements DashboardDataSource {
  final dbHelper = getIt<DatabaseHelper>();
  Database? _db;
  @override
  Future<List<Map<String, dynamic>>> fetchData() async {
    _db ??= await dbHelper.database;
    if (_db != null) return await _db!.query('Items');
    throw Exception('Database instance not created');
  }
}
