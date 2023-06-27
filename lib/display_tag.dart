// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_receipt_viewer/invalid_tag.dart';
import 'package:nfc_receipt_viewer/ndef_record.dart';

class DisplayTag extends StatefulWidget {
  final NfcTag tag;
  const DisplayTag({Key? myKey, required this.tag}) : super(key: myKey);

  @override
  State<DisplayTag> createState() => _DisplayTagState();
}

class _DisplayTagState extends State<DisplayTag> {
  bool isValidData = true;

  final ndefWidgets = <Widget>[];
  Ndef? tech;

  var logoImage;
  var receiptInfo;
  late List<String> productEntries;

  @override
  Widget build(BuildContext context) {
    parseResult();
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
          onPressed: () {},
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

          try {
            bytesImage = const Base64Decoder().convert(recordString);
            logoImage = Image.memory(bytesImage);
          } catch (e) {
            isValidData = false;
            return;
          }
          ndefWidgets.add(
            Center(
              child: logoImage,
            ),
          );
        } else if (recordNum == 1) {
          receiptInfo = recordString.split("#");
          ndefWidgets.add(Text(receiptInfo[0]));
          ndefWidgets.add(Text("Customer Name: ${receiptInfo[1]}"));
          ndefWidgets.add(Text("Receipt ID: ${receiptInfo[2]}"));
        } else {
          productEntries = recordString.split("#");
          final rowsList = <DataRow>[];

          for (var element in productEntries) {
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
          );
        }
        recordNum++;
      }
    }
  }

  double getTotalFromProductsInfo(List productInfoList) {
    double total = 0;
    for (var element in productEntries) {
      List<String> productInfo = element.split("/");
      total += (double.tryParse(productInfo[2]) ?? 0) *
          (double.tryParse(productInfo[1]) ?? 0);
    }
    return total;
  }
}
