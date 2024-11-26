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
        s.sale_date, 
        SUM(s.total_price) AS total_sell_amount, 
        SUM(s.quantity_sold * i.item_unit_price) AS total_purchase_cost
    FROM Sales s
    JOIN Items i ON s.item_id = i.item_id
  ''';

    List<String> whereClauses = [];
    List<dynamic> whereArgs = [];

    // Add date range filter if provided
    if (startDate != null && endDate != null) {
      whereClauses.add('s.sale_date BETWEEN ? AND ?');
      whereArgs.add(startDate);
      whereArgs.add(endDate);
    }

    // Add GROUP BY and ORDER BY
    query +=
        whereClauses.isNotEmpty ? ' WHERE ${whereClauses.join(' AND ')}' : '';
    query += ' GROUP BY s.sale_date ORDER BY s.sale_date';

    // Execute query
    return await _db!.rawQuery(query, whereArgs);
  }
}
