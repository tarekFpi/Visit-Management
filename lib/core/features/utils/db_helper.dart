import 'package:assignment_asl/core/features/task/model/customer_response.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, v) async {

        await db.execute('''
          CREATE TABLE customers(
            id INTEGER PRIMARY KEY,
            name TEXT,
            phone TEXT,
            email TEXT,
            address TEXT,
            lastVisitDate TEXT,
            visitStatus TEXT,
            notes TEXT,
            syncStatus TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE sync_queue(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            entityType TEXT,
            entityId INTEGER,
            operationType TEXT,
            payload TEXT,
            retryCount INTEGER,
            syncStatus TEXT,
            createdAt TEXT
          )
        ''');
      },
    );
  }

  // INSERT / UPDATE CUSTOMER
  Future<void> insertCustomer(Customer c) async {
    final dbClient = await db;
    await dbClient.insert(
      "customers",
      c.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCustomer(Customer c) async {
    final dbClient = await db;
    await dbClient.update(
      "customers",
      c.toMap(),
      where: "id = ?",
      whereArgs: [c.id],
    );
  }

  Future<List<Customer>> getCustomers() async {
    final dbClient = await db;
    final data = await dbClient.query("customers");
    return data.map((e) => Customer.fromJson(e)).toList();
  }

  // SYNC QUEUE ADD
  Future<void> addSyncQueue(Map<String, dynamic> item) async {
    final dbClient = await db;
    await dbClient.insert("sync_queue", item);
  }

  Future<List<Map<String, dynamic>>> getSyncQueue() async {
    final dbClient = await db;
    return await dbClient.query("sync_queue");
  }

  Future<void> deleteSyncItem(int id) async {
    final dbClient = await db;
    await dbClient.delete(
      "sync_queue",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}