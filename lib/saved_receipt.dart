import 'package:flutter/material.dart';

class SavedReceipt extends StatefulWidget {
  const SavedReceipt({super.key});

  @override
  State<SavedReceipt> createState() => _SavedReceiptState();
}

class _SavedReceiptState extends State<SavedReceipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NFC Receipt Viewer"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: AlertDialog(
          icon: const Icon(Icons.check_circle_outline_rounded),
          title: const Text("Successfully Saved!"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            )
          ],
        ),
      ),
    );
  }
}
