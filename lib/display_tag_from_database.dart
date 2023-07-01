import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_receipt_viewer/receipt_class.dart';

class DisplayTagFromDB extends StatelessWidget {
  final Receipt receipt;

  DisplayTagFromDB({Key? myKey, required this.receipt}) : super(key: myKey);

  final ndefWidgets = <Widget>[];

  @override
  Widget build(BuildContext context) {
    parseResult();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete_rounded),
          )
        ],
        title: FittedBox(
          child: Text(receipt.receiptID),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: ndefWidgets,
        ),
      ),
    );
  }

  void parseResult() {
    late TableRow customerNameRow;
    late TableRow receiptIDRow;

    ndefWidgets.add(const SizedBox(
      height: 20,
    ));

    Uint8List bytesImage;
    bytesImage = const Base64Decoder().convert(receipt.imageBase64);
    ndefWidgets.add(Image.memory(bytesImage));
    ndefWidgets.add(const SizedBox(
      height: 10,
    ));

    ndefWidgets.add(Text(receipt.superMarketName));
    ndefWidgets.add(const SizedBox(
      height: 20,
    ));

    customerNameRow = TableRow(children: <Widget>[
      const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text("Customer Name: "),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(receipt.customerName),
      )
    ]);

    receiptIDRow = TableRow(children: <Widget>[
      const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text("Receipt ID: "),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(receipt.receiptID),
      )
    ]);
    ndefWidgets.add(Table(
        border: TableBorder.all(color: Colors.black, width: 2.0),
        children: <TableRow>[customerNameRow, receiptIDRow]));

    ndefWidgets.add(const SizedBox(
      height: 20,
    ));

    final rowsList = <DataRow>[];

    for (var element in receipt.productEntries.split("#")) {
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
    ndefWidgets.add(FittedBox(
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
    ));
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
    );
  }

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
