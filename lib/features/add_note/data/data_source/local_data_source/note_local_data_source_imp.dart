import 'package:sqflite/sqflite.dart';

import '../../../../../core/database/database_helper.dart';
import '../../../../../core/di/di.dart';
import 'note_local_data_source.dart';

class NoteLocalDataSourceImp implements NoteLocalDataSource {
  final dbHelper = getIt<DatabaseHelper>();
  Database? _db;

  @override
  Future<void> addNote(Map<String, dynamic> note) async {
    try {
      _db ??= await dbHelper.database;
      await _db!.insert('Notes', note);
    } catch (e) {
      throw Exception('Failed to add note');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getNotes() async {
    try {
      _db ??= await dbHelper.database;
      return await _db!.query('Notes');
    } catch (e) {
      throw Exception('Failed to get notes: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteNote(int id) async {
    try {
      _db ??= await dbHelper.database;
      await _db!.delete('Notes', where: 'note_id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to delete note: ${e.toString()}');
    }
  }

  @override
  Future<void> updateNote(int id, Map<String, dynamic> note) async {
    try {
      _db ??= await dbHelper.database;
      await _db!.update('Notes', note, where: 'note_id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to update note: ${e.toString()}');
    }
  }
}
