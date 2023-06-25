import 'package:flutter/material.dart';
import 'package:nfc_receipt_viewer/read_tag.dart';
import 'package:nfc_manager/nfc_manager.dart';

ValueNotifier<dynamic> result = ValueNotifier(null);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainPage(),
      theme: ThemeData(
        fontFamily: 'HelloHeadline',
        primarySwatch: Colors.blueGrey,
      ),
      darkTheme: ThemeData(
        canvasColor: Colors.teal.shade700,
        // fontFamily: 'HelloHeadline',
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.blueGrey.shade900,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.teal,
          onPrimary: Colors.white,
          secondary: Colors.teal.shade600,
          onSecondary: Colors.white,
          error: Colors.redAccent.shade700,
          onError: Colors.white,
          background: Colors.blueGrey.shade900,
          onBackground: Colors.white,
          surface: Colors.teal,
          onSurface: Colors.white,
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Afaan'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                builder: (BuildContext context) {
                  _tagRead(context);
                  return const ReadTag();
                }).whenComplete(() {
              NfcManager.instance.stopSession();
            });
          },
          child: const Icon(Icons.nfc_rounded),
        ),
        body: Text(parseResult()));
  }
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

void _tagRead(BuildContext context) {
  NfcManager.instance.startSession(
    onDiscovered: (NfcTag tag) async {
      result.value = tag.data[0];
      NfcManager.instance.stopSession();
      Navigator.pop(context);
    },
    onError: (error) {
      Navigator.pop(context);
      return Future(() => null);
    },
  );
}
