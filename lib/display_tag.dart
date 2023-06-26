import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_receipt_viewer/read_tag.dart';

class DisplayTag extends StatefulWidget {
  final NfcTag tag;
  const DisplayTag({Key? myKey, required this.tag}) : super(key: myKey);

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
      body: Text(parseResult()),
    );
  }

  String parseResult() {
    List<String> stringList = widget.tag.data
        .toString()
        .toString()
        .split('payload:')[1]
        .split('}')[0]
        .split('[')[1]
        .split(']')[0]
        .split(', ');
    String string = '';
    for (var element in stringList) {
      string += element;
    }

    return string;
  }
}
