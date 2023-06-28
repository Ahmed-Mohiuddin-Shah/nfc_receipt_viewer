import 'package:flutter/material.dart';

class SaveReceipt extends StatefulWidget {
  const SaveReceipt({super.key});

  @override
  State<SaveReceipt> createState() => _SaveReceiptState();
}

class _SaveReceiptState extends State<SaveReceipt> {
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
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            )
          ],
        ),
      ),
    );
  }
}
