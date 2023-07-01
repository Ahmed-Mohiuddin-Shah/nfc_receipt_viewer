// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_receipt_viewer/data_handler.dart';
import 'package:nfc_receipt_viewer/invalid_tag.dart';
import 'package:nfc_receipt_viewer/ndef_record.dart';
import 'package:nfc_receipt_viewer/save_receipt.dart';

class DisplayTag extends StatefulWidget {
  final NfcTag tag;
  final DatabaseHandler dbHandler;
  const DisplayTag({Key? myKey, required this.tag, required this.dbHandler})
      : super(key: myKey);

  @override
  State<DisplayTag> createState() => _DisplayTagState();
}

class _DisplayTagState extends State<DisplayTag> {
  bool isValidData = true;

  final ndefWidgets = <Widget>[];
  Ndef? tech;

  var logoImage;
  var receiptInfo;
  late String productEntries;

  @override
  Widget build(BuildContext context) {
    try {
      parseResult();
    } catch (e) {
      isValidData = false;
    }

    if (isValidData) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('NFC Receipt'),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_rounded),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const SaveReceipt();
                },
              ),
            );
          },
          child: const Icon(Icons.save_rounded),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: ndefWidgets,
          ),
        ),
      );
    } else {
      return const InvalidTag();
    }
  }

  void parseResult() {
    late TableRow customerNameRow;
    late TableRow receiptIDRow;

    ndefWidgets.add(const SizedBox(
      height: 20,
    ));

    tech = Ndef.from(widget.tag);
    if (tech is Ndef && tech != null) {
      final cachedMessage = tech!.cachedMessage;
      int recordNum = 0;
      for (var i in Iterable.generate(cachedMessage!.records.length)) {
        final record = cachedMessage.records[i];
        final info = NdefRecordInfo.fromNdef(record);
        String recordString = info.subtitle.split(") ")[1];
        if (recordNum == 0) {
          Uint8List bytesImage;
          bytesImage = const Base64Decoder().convert(recordString);
          logoImage = Image.memory(bytesImage);
          ndefWidgets.add(logoImage);
          ndefWidgets.add(const SizedBox(
            height: 10,
          ));
        } else if (recordNum == 1) {
          receiptInfo = recordString.split("#");

          ndefWidgets.add(Text(receiptInfo[0]));
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
              child: Text(receiptInfo[1]),
            )
          ]);

          receiptIDRow = TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Receipt ID: "),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(receiptInfo[2]),
            )
          ]);
          ndefWidgets.add(Table(
              border: TableBorder.all(color: Colors.black, width: 2.0),
              children: <TableRow>[customerNameRow, receiptIDRow]));

          ndefWidgets.add(const SizedBox(
            height: 20,
          ));
        } else {
          productEntries = recordString;
          final rowsList = <DataRow>[];

          for (var element in productEntries.split("#")) {
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
        }
        recordNum++;
      }
    }
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
                child:
                    Text(getTotalFromProductsInfo(productEntries).toString()),
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
