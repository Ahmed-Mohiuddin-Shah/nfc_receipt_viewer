import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'HelloHeadline',
        primarySwatch: Colors.blueGrey,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = 0;

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
              backgroundColor: Colors.blueGrey.shade800,
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              builder: (BuildContext context) {
                return const SizedBox(
                  height: 200,
                  child: Center(
                    child: Text('Scanning...'),
                  ),
                );
              }).whenComplete(() {});
        },
        child: const Icon(Icons.nfc_rounded),
      ),
    );
  }
}
