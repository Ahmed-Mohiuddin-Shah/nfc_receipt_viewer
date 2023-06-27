import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_receipt_viewer/ndef_record.dart';

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

  void parseResult() {
    tech = Ndef.from(widget.tag);
    if (tech is Ndef && tech != null) {
      final cachedMessage = tech!.cachedMessage;
      int recordNum = 0;
      for (var i in Iterable.generate(cachedMessage!.records.length)) {
        final record = cachedMessage.records[i];
        final info = NdefRecordInfo.fromNdef(record);
        if (recordNum == 0) {
          Uint8List bytesImage;
          String imgString = info.subtitle.split(") ")[1];
          bytesImage = const Base64Decoder().convert(imgString);

          Image.memory(bytesImage);
          ndefWidgets.add(
            Center(
              child: Image.memory(bytesImage),
            ),
          );
        } else {
          ndefWidgets.add(
            Text(info.subtitle.split(") ")[1]),
          );
        }
        recordNum++;
      }
    }
  }
}
