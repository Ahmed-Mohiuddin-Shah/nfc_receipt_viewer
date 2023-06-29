import 'dart:async';

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
          "CREATE TABLE receipts(id INTEGER PRIMARY KEY AUTOINCREMENT, receiptID TEXT NOT NULL, shopName TEXT NOT NULL, name TEXT NOT NULL, entries, total TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertReceipts(List<Receipt> receipts) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var receipt in receipts) {
      result = await db.insert('receipts', receipt.toMap());
    }
    return result;
  }

  Future<List<Receipt>> retrieveReceipts() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('receipts');
    return queryResult.map((e) => Receipt.fromMap(e)).toList();
  }

  Future<void> deleteReceipt(int id) async {
    final db = await initializeDB();
    await db.delete(
      'receipts',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> addReceipts() async {
    Receipt firstReceipt = Receipt(
        receiptID: "fsfijwfj",
        superMarketName: "Hello",
        customerName: "Goerge",
        productEntries: "Products",
        receiptTotal: "1000");
    Receipt secondReceipt = Receipt(
        receiptID: "hdhdddf",
        superMarketName: "World",
        customerName: "jeoff",
        productEntries: "Products",
        receiptTotal: "1042100");
    List<Receipt> listOfReceipts = [firstReceipt, secondReceipt];
    return DatabaseHandler().insertReceipts(listOfReceipts);
  }
}
