import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DisplayTag extends StatefulWidget {
  var txt = "";
  DisplayTag({Key? myKey, required this.txt}) : super(key: myKey);

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
      body: Text(widget.txt),
    );
  }
}
