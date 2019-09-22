import 'package:flutter/material.dart';
import 'package:seivom/home.dart';

void main() => runApp(Seivom());

class Seivom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Home(),
    );
  }
}
