import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');
    return await openDatabase(
      path,
      version: 2, // Increment the version to trigger onUpgrade
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Add this for schema migrations
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Items table
    await db.execute('''
      CREATE TABLE Items (
        item_id TEXT PRIMARY KEY NOT NULL,
        item_name TEXT NOT NULL,
        item_unit_type TEXT NOT NULL,
        item_unit_price REAL NOT NULL,
        item_quantity REAL NOT NULL
      )
    ''');

    // Create Sales table
    await db.execute('''
      CREATE TABLE Sales (
        sale_id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id TEXT NOT NULL,
        sale_date TEXT NOT NULL,
        quantity_sold REAL NOT NULL,
        total_price REAL NOT NULL,
        FOREIGN KEY (item_id) REFERENCES Items (item_id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add the Notes table
      await db.execute('''
        CREATE TABLE Notes (
          note_id INTEGER PRIMARY KEY AUTOINCREMENT,
          note_title TEXT NOT NULL,
          note_content TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
    }
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
