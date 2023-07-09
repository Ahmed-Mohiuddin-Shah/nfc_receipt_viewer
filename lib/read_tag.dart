import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  bool canRead = true;

  @override
  Widget build(BuildContext context) {
    _tagRead(context);
    if (canRead) {
      return SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Container(
            child: Lottie.asset("images/nfc_animation.json",
                fit: BoxFit.scaleDown),
          ),
        ),
      );
    } else {
      return const Center(
        child: SizedBox(
          height: 200,
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: Text("NFC Not Supported"),
          ),
        ),
      );
    }
  }

  void _tagRead(BuildContext context) async {
    canRead = await NfcManager.instance.isAvailable();
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return DisplayTag(
                tag: tag,
                dbHandler: widget.dbHandler,
              );
            },
          ),
        );

        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        NfcManager.instance.stopSession();
      },
      onError: (error) {
        Navigator.pop(context);
        return Future(() => null);
      },
    );
  }
}
