import 'package:flutter/material.dart';

class MagicScreen extends StatefulWidget {
  static final String id = 'magic_screen';

  @override
  _MagicScreenState createState() => _MagicScreenState();
}

class _MagicScreenState extends State<MagicScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Magic'),
      ),
    );
  }
}
