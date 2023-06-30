import 'package:flutter/material.dart';

class DisplayTagFromDB extends StatelessWidget {
  const DisplayTagFromDB({super.key});

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
          title: const FittedBox(
            child: Text("Sample Receipt from Database"),
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