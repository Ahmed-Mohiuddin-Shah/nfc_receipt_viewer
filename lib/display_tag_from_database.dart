import 'package:flutter/material.dart';
import 'package:nfc_receipt_viewer/receipt_class.dart';

class DisplayTagFromDB extends StatelessWidget {
  final Receipt receipt;

  const DisplayTagFromDB({Key? myKey, required this.receipt})
      : super(key: myKey);

  @override
  Widget build(BuildContext context) {
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
        body: const Text("Receipt"));
  }
}
