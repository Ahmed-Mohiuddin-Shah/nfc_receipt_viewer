import 'package:flutter/material.dart';

class InvalidTag extends StatelessWidget {
  const InvalidTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NFC Receipt Viewer"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: AlertDialog(
          icon: const Icon(Icons.error_outline_rounded),
          title: const Text("Invalid Tag Format!\nPlease Cormat Correctly!"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded))
          ],
        ),
      ),
    );
  }
}
