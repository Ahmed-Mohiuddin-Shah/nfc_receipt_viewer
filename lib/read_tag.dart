import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_receipt_viewer/display_tag.dart';

class ReadTag extends StatefulWidget {
  const ReadTag({super.key});

  @override
  State<ReadTag> createState() => _ReadTagState();
}

class _ReadTagState extends State<ReadTag> {
  @override
  Widget build(BuildContext context) {
    _tagRead(context);

    return const SizedBox(
      height: 200,
      child: Center(
        child: Text("Scanning..."),
      ),
    );
  }
}

void _tagRead(BuildContext context) {
  NfcManager.instance.startSession(
    onDiscovered: (NfcTag tag) async {
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return DisplayTag(tag: tag);
          },
        ),
      );
      NfcManager.instance.stopSession();
    },
    onError: (error) {
      Navigator.pop(context);
      return Future(() => null);
    },
  );
}
