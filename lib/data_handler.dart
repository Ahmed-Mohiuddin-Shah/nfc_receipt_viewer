import 'dart:async';

import 'package:nfc_receipt_viewer/receipt_class.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// A class that handles the database operations for managing receipts.
class DatabaseHandler {

  /// Initializes the database.
  ///
  /// Returns a [Future] that completes with the initialized [Database] instance.
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();               // get path of database in native OS
    return openDatabase(
      join(path, 'receipts.db'),                          // joining path with name of Database
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE receipts(id INTEGER PRIMARY KEY AUTOINCREMENT, receiptID TEXT NOT NULL, image TEXT NOT NULL, shopName TEXT NOT NULL, name TEXT NOT NULL, entries TEXT NOT NULL)",
        );                                                // Executing SQL query to create necassery table
      },
      version: 1,                                         // database version
    );
  }

  /// Inserts a list of [Receipt] objects into the database.
  ///
  /// Takes a list of [Receipt] objects as a parameter.
  /// Returns the number of rows inserted as an [int].
  Future<int> insertReceipts(List<Receipt> receipts) async {
    int result = 0;                                       // result of insert operation
    final Database db = await initializeDB();             // Getting Database Object
    for (var receipt in receipts) {                       // Looping through list of receipts
      result = await db.insert('receipts', receipt.toMap());  // Inserting the Map representation of Receipt in Database
    }
    return result;                                        // returns the index of last inserted Receipt
  }

  /// Inserts a list of [Receipt] objects into the database.
  ///
  /// Takes a list of [Receipt] objects as a parameter.
  /// Returns the number of rows inserted as an [int].
  Future<List<Receipt>> retrieveReceipts() async {
    final Database db = await initializeDB();              // Getting Database Object
    final List<Map<String, Object?>> queryResult = await db.query('receipts');  // Querying the Receipts table to return the List of Maps of Receipt
    return queryResult.map((e) => Receipt.fromMap(e)).toList(); //Converting List of Maps to List of Receipts
  }

  /// Deletes a receipt from the database by its ID.
  ///
  /// Takes the ID of the receipt as a parameter.
  /// Returns [void].
  Future<void> deleteReceipt(int id) async {
    final db = await initializeDB();                       // Getting Database Object
    await db.delete(
      'receipts',
      where: "id = ?",
      whereArgs: [id],
    );                                                    // Deleting the Receipt from the table with th given [id]
  }

  /// Adds example receipts to the database.
  ///
  /// Returns the number of rows inserted as an [int].
  Future<int> addReceipts() async {
    Receipt firstReceipt = Receipt(
        receiptID: "fsfijwfj",
        imageBase64:
            "Qk2mAAAAAAAAAD4AAAAoAAAAIAAAABoAAAABAAEAAAAAAAAAAADEDgAAxA4AAAIAAAACAAAAAAAA/////////////////8AAAAOAAAADgAAAA4AAAAPAAAAH4A/gB+Af8A/wH/AP+A/wH/gP4D/8B+B//gPAf/4DgP//AAH//4AB//+AA///wAf//+AH///gD///8B////gf///4P////H///////w==",
        superMarketName: "Hello",
        customerName: "Goerge",
        productEntries: "haier/12/14323");              //  Example Receipt
    Receipt secondReceipt = Receipt(
        receiptID: "hdhdddf",
        imageBase64:
            "Qk2mAAAAAAAAAD4AAAAoAAAAIAAAABoAAAABAAEAAAAAAAAAAADEDgAAxA4AAAIAAAACAAAAAAAA/////////////////8AAAAOAAAADgAAAA4AAAAPAAAAH4A/gB+Af8A/wH/AP+A/wH/gP4D/8B+B//gPAf/4DgP//AAH//4AB//+AA///wAf//+AH///gD///8B////gf///4P////H///////w==",
        superMarketName: "World",
        customerName: "jeoff",
        productEntries: "Logitech/3/123");              //  Example Receipt
    List<Receipt> listOfReceipts = [firstReceipt, secondReceipt]; // Making a List of Receipts
    return DatabaseHandler().insertReceipts(listOfReceipts);  // Inserting list ofexample Receipts in Database and returning the last index as result
  }
}
