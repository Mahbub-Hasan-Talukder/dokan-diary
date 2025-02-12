import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper.dart';
import '../../../../core/di/di.dart';
import 'data_source.dart';

class RecordsDataSourceImp implements RecordsDataSource {
  final dbHelper = getIt<DatabaseHelper>();
  Database? _db;

  @override
  Future<List<Map<String, dynamic>>> fetchDayWiseSellInfo({
    String? startDate,
    String? endDate,
  }) async {
    _db ??= await dbHelper.database;
    if (_db == null) {
      throw Exception('Database instance not created');
    }

    String query = '''
    SELECT 
        sale_date, 
        SUM(total_price) AS total_sell_amount, 
        SUM(total_purchase) AS total_purchase_cost
    FROM Sales
  ''';

    List<String> whereClauses = [];
    List<dynamic> whereArgs = [];

    // Add date range filter if provided
    if (startDate != null && endDate != null) {
      whereClauses.add('sale_date BETWEEN ? AND ?');
      whereArgs.add(startDate);
      whereArgs.add(endDate);
    }

    // Add GROUP BY and ORDER BY
    query +=
        whereClauses.isNotEmpty ? ' WHERE ${whereClauses.join(' AND ')}' : '';
    query += ' GROUP BY sale_date ORDER BY sale_date';

    return await _db!.rawQuery(query, whereArgs);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchItemWiseSellInfo({
    String? startDate,
    String? endDate,
  }) async {
    _db ??= await dbHelper.database;
    if (_db == null) {
      throw Exception('Database instance not created');
    }

    String query = '''
    SELECT 
        item_name, 
        IFNULL(SUM(total_price), 0) AS total_sell_amount, 
        SUM(total_purchase) AS total_purchase_cost
    FROM Sales
  ''';

    List<String> whereClauses = [];
    List<dynamic> whereArgs = [];

    // Add date range filter if provided
    if (startDate != null && endDate != null) {
      whereClauses.add('sale_date BETWEEN ? AND ?');
      whereArgs.add(startDate);
      whereArgs.add(endDate);
    }

    // Add GROUP BY and ORDER BY
    query +=
        whereClauses.isNotEmpty ? ' WHERE ${whereClauses.join(' AND ')}' : '';
    query += ' GROUP BY item_name ORDER BY item_name';

    return await _db!.rawQuery(query, whereArgs);
  }
}
