import 'package:flutter/material.dart';

class DisplayTag extends StatefulWidget {
  const DisplayTag({super.key});

  @override
  State<DisplayTag> createState() => _DisplayTagState();
}

class _DisplayTagState extends State<DisplayTag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Receipt'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.save_rounded),
      ),
    );
  }
}
