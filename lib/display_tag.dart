import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:typed_data';

class DisplayTag extends StatefulWidget {
  final NfcTag tag;
  const DisplayTag({Key? myKey, required this.tag}) : super(key: myKey);

  @override
  State<DisplayTag> createState() => _DisplayTagState();
}

class _DisplayTagState extends State<DisplayTag> {
  final ndefWidgets = <Widget>[];
  Ndef? tech;

  @override
  Widget build(BuildContext context) {
    parseResult();
    return Scaffold(
        appBar: AppBar(
          title: const Text('NFC Receipt'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.save_rounded),
        ),
        body: Column(
          children: ndefWidgets,
        ));
  }

  String parseResult() {
    tech = Ndef.from(widget.tag);
    if (tech is Ndef && tech != null) {
      final cachedMessage = tech!.cachedMessage;
      for (var i in Iterable.generate(cachedMessage!.records.length)) {
        String base64String =
            const Utf8Decoder().convert(cachedMessage.records[i].payload);
        ndefWidgets.add(
          Text(base64String),
        );
      }
    }

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
