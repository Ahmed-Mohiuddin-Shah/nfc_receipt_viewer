import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_receipt_viewer/data_handler.dart';
import 'package:nfc_receipt_viewer/receipt_class.dart';

/// A widget that displays the details of a receipt from the database.
class DisplayTagFromDB extends StatelessWidget {
  final Receipt receipt; // Receipt to display
  final DatabaseHandler dbHandler; // Instance of DatabaseHandler

  /// Constructs a [DisplayTagFromDB] widget.
  ///
  /// [receipt] represents the receipt to be displayed.
  /// [dbHandler] is an instance of [DatabaseHandler] for performing database operations.
  DisplayTagFromDB({Key? myKey, required this.receipt, required this.dbHandler})
      : super(key: myKey);

  final ndefWidgets = <Widget>[]; // List of widgets to dipay

  @override
  Widget build(BuildContext context) {
    parseResult(); // parsing th data or result
    return Scaffold(
      // retrning scaffold of page
      appBar: AppBar(
        actions: [
          // actions of AppBar
          IconButton(
            // Delete button
            onPressed: () {
              // On pressed action is to create a pop up for confirmation
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text("NFC Receipt Viewer"),
                        automaticallyImplyLeading: false,
                      ),
                      body: AlertDialog(
                        title: const Icon(Icons.dangerous_rounded),
                        content: const FittedBox(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                    'Are you sure you want to delete this item?'),
                                Text('This action is not reversible!')
                              ],
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              dbHandler.deleteReceipt(receipt.id!);

                              Navigator.of(context).pop();
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.delete_rounded),
          )
        ],
        title: FittedBox(
          child: Text(receipt.receiptID), // Displaying Receipt ID in Title bar
        ),
        leading: IconButton(
          // Back button
          onPressed: () {
            // On pressed function pops current context
            Navigator.of(context).pop(false);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: SingleChildScrollView(
        // body displays widgets in Scroll view
        child: Column(
          children: ndefWidgets,
        ),
      ),
    );
  }

  /// Parses the receipt details and generates the corresponding widgets.
  ///
  /// This method is responsible for parsing the receipt details, such as the
  /// customer name, receipt ID, image, product entries, and calculating the total.
  /// It creates and adds the necessary widgets to the [ndefWidgets] list, which
  /// will be displayed in the UI.
  void parseResult() {
    late TableRow customerNameRow;
    late TableRow receiptIDRow;

    ndefWidgets.add(const SizedBox(
      height: 20,
    )); // Add spacer

    Uint8List bytesImage;
    bytesImage = const Base64Decoder().convert(receipt.imageBase64);
    ndefWidgets.add(Image.memory(bytesImage));
    ndefWidgets.add(const SizedBox(
      height: 10,
    )); // Adding logo Image

    ndefWidgets.add(Text(receipt.superMarketName));
    ndefWidgets.add(const SizedBox(
      height: 20,
    )); // Adding super market name

    customerNameRow = TableRow(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("Customer Name: "),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(receipt.customerName),
        )
      ],
    ); // Customer Info Row

    receiptIDRow = TableRow(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("Receipt ID: "),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(receipt.receiptID),
        )
      ],
    ); // Receipt Info Row

    ndefWidgets.add(
      Table(
        border: TableBorder.all(color: Colors.black, width: 2.0),
        children: <TableRow>[customerNameRow, receiptIDRow],
      ),
    ); // Adding customerNameRow andd receiptIDRow as a Table

    ndefWidgets.add(
      const SizedBox(
        height: 20,
      ),
    ); // Adding a Spacer

    final rowsList = <DataRow>[]; // Creating list of DataRows for DataTable

    for (var element in receipt.productEntries.split("#")) {
      // Looping through product entries and adding them to the rowList as a DataRow
      List<String> productInfo = element.split("/");
      rowsList.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text(productInfo[0])),
            DataCell(Text(productInfo[1])),
            DataCell(Text(productInfo[2])),
            DataCell(Text(((
              (double.tryParse(productInfo[2]) ?? 0) *
                  (double.tryParse(productInfo[1]) ?? 0),
            ).toString())))
          ],
        ),
      );
    }

    ndefWidgets.add(
      FittedBox(
        child: DataTable(
            showCheckboxColumn: true,
            border: TableBorder.all(),
            columns: const <DataColumn>[
              DataColumn(label: Text("Product Name")),
              DataColumn(label: Text("Qty")),
              DataColumn(label: Text("Unit Price")),
              DataColumn(label: Text("Total")),
            ],
            rows: rowsList),
      ),
    ); // Adding RowList to the DataTable and adding it to widget list

    ndefWidgets.add(
      Table(
        border: TableBorder.all(color: Colors.black, width: 2.0),
        children: <TableRow>[
          TableRow(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Receipt Total: "),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(getTotalFromProductsInfo(receipt.productEntries)
                    .toString()),
              )
            ],
          ),
        ],
      ),
    );                      // Adding receipt total to DataTable to widget list
  }

  /// Calculates the total amount from the product entries.
  ///
  /// [productEntries] represents the product entries in the receipt.
  /// Returns the total amount as a [double].
  double getTotalFromProductsInfo(String productEntries) {
    double total = 0;
    for (var element in productEntries.split("#")) {
      List<String> productInfo = element.split("/");
      total += (double.tryParse(productInfo[2]) ?? 0) *
          (double.tryParse(productInfo[1]) ?? 0);
    }
    return total;
  }
}
