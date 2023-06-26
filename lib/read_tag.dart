import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_receipt_viewer/display_tag.dart';

ValueNotifier<dynamic> result = ValueNotifier("");

class ReadTag extends StatefulWidget {
  const ReadTag({super.key});

  @override
  State<ReadTag> createState() => _ReadTagState();
}

class _ReadTagState extends State<ReadTag> {
  @override
  Widget build(BuildContext context) {
    _tagRead(context);

    return SizedBox(
      height: 200,
      child: Center(
        child: Text("Scanning...\n${parseResult()}"),
      ),
    );
  }
}

void _tagRead(BuildContext context) {
  NfcManager.instance.startSession(
    onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      NfcManager.instance.stopSession();
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const DisplayTag();
          },
        ),
      );
    },
    onError: (error) {
      Navigator.pop(context);
      return Future(() => null);
    },
  );
}

String parseResult() {
  // List<String> stringList = result
  //     .toString()
  //     .split('payload:')[1]
  //     .split('}')[0]
  //     .split('[')[1]
  //     .split(']')[0]
  //     .split(', ');
  // String string = '';
  // for (var element in stringList) {
  //   string += element;
  // }

  return result.toString();
}
