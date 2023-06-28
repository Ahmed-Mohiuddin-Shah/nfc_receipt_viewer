import 'package:nfc_receipt_viewer/receipt_class.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'example.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,age INTEGER NOT NULL, country TEXT NOT NULL, email TEXT)",
        );
      },
    );
  }

  Future<int> insertUser(List<Receipt> receipts) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var receipt in receipts) {
      result = await db.insert('users', receipt.toMap());
    }
    return result;
  }

    Future<List<Receipt>> retrieveUsers() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('users');
    return queryResult.map((e) => Receipt.fromMap(e)).toList();
  }
  
  Future<void> deleteUser(int id) async {
    final db = await initializeDB();
    await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
