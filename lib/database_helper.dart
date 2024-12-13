import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  static final _databaseName = "inventory.db";
  static final _databaseVersion = 2;

  static final table = 'items';
  static final columnId = 'id';
  static final columnName = 'name';
  static final columnDescription = 'description';
  static final columnCategory = 'category';
  static final columnPrice = 'price';
  static final coloumnStock = 'quantity';
  static final columnImage = 'imagePath';

  static Database? _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('inventory.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path,
        version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnDescription TEXT,
            $columnCategory TEXT,
            $columnPrice REAL,
            $coloumnStock INTEGER,
            $columnImage TEXT
          )
          ''');

    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id INTEGER,
        transaction_type TEXT,
        quantity INTEGER,
        date TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE items ADD COLUMN imagePath TEXT");
    }
  }

  Future<int> insert(Map<String, dynamic> item) async {
    Database db = await instance.database;
    return await db.insert('items', item);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> insertHistory(Map<String, dynamic> history) async {
    final db = await database;
    return await db.insert('history', history);
  }

  Future<List<Map<String, dynamic>>> getHistory(int itemId) async {
    final db = await database;
    return await db.query(
      'history',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
  }

}
