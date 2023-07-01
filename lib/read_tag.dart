import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_receipt_viewer/display_tag.dart';
import 'data_handler.dart';

class ReadTag extends StatefulWidget {
  final DatabaseHandler dbHandler;
  const ReadTag({Key? myKey, required this.dbHandler}) : super(key: myKey);

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

  void _tagRead(BuildContext context) {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return DisplayTag(
                tag: tag,
                dbHandler: widget.dbHandler,
              );
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
}
