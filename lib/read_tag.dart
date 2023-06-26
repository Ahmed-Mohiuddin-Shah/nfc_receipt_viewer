import 'package:flutter/material.dart';

class ReadTag extends StatefulWidget {
  const ReadTag({super.key});

  @override
  State<ReadTag> createState() => _ReadTagState();
}

class _ReadTagState extends State<ReadTag> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      child: Center(
        child: Text('Scanning...'),
      ),
    );
  }
}
