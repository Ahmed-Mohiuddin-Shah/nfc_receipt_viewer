// ignore_for_file: prefer_typing_uninitialized_variables

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

  var logoImage;
  var receiptInfo;

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
      ndefWidgets.add(
        const Spacer(
          flex: 1,
        ),
      );
      final cachedMessage = tech!.cachedMessage;
      int recordNum = 0;
      for (var i in Iterable.generate(cachedMessage!.records.length)) {
        final record = cachedMessage.records[i];
        final info = NdefRecordInfo.fromNdef(record);
        String recordString = info.subtitle.split(") ")[1];
        if (recordNum == 0) {
          Uint8List bytesImage;
          bytesImage = const Base64Decoder().convert(recordString);

          logoImage = Image.memory(bytesImage);
          ndefWidgets.add(
            Center(
              child: logoImage,
            ),
          );
        } else if (recordNum == 1) {
          receiptInfo = recordString.split("#");
          ndefWidgets.add(Text(receiptInfo[0]));
          ndefWidgets.add(const Spacer());
          ndefWidgets.add(Text(receiptInfo[1]));
          ndefWidgets.add(Text(receiptInfo[2]));
        }
        recordNum++;
      }
    }
    ndefWidgets.add(const Spacer(
      flex: 1,
    ));
  }
}
