import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nfc_receipt_viewer/display_tag_from_database.dart';
import 'package:nfc_receipt_viewer/read_tag.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_receipt_viewer/receipt_class.dart';

import 'data_handler.dart';

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
        fontFamily: 'HelloHeadline',
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
  late DatabaseHandler dbHandler;

  @override
  void initState() {
    super.initState();
    dbHandler = DatabaseHandler();
    dbHandler.initializeDB().whenComplete(() async {
      await dbHandler.addReceipts();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Receipt Viewer'),
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
                return const ReadTag();
              }).whenComplete(() {
            NfcManager.instance.stopSession();
          });
        },
        child: const Icon(Icons.nfc_rounded),
      ),
      body: FutureBuilder(
        future: dbHandler.retrieveReceipts(),
        builder: (BuildContext context, AsyncSnapshot<List<Receipt>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      bool confirm = await showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Icon(Icons.dangerous_rounded),
                          content: const FittedBox(
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                      'Are you sure you want to delete this item?'),
                                  Text('This action is not reversible!')
                                ],
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            ElevatedButton(
                              child: const Text('Delete'),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        ),
                      );

                      return confirm;
                    }

                    return true;
                  },
                  direction: DismissDirection.endToStart,
                  background: Card(
                    color: Colors.red,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: const Alignment(1, 0),
                      child: const Icon(Icons.delete_rounded),
                    ),
                  ),
                  key: ValueKey<int>(snapshot.data![index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await dbHandler.deleteReceipt(snapshot.data![index].id!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child: Card(
                    child: ListTile(
                      key: ValueKey<int>(snapshot.data![index].id!),
                      contentPadding: const EdgeInsets.all(8.0),
                      title: Text(
                          "${snapshot.data![index].id}. ${snapshot.data![index].receiptID}"),
                      subtitle: Text(snapshot.data![index].superMarketName),
                      leading: Image.memory(
                        base64Decode(
                          snapshot.data![index].imageBase64,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return DisplayTagFromDB(receipt: snapshot.data![index]);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
