import 'package:flutter/material.dart';
import 'package:seivom/ui/home.dart';

void main() => runApp(Seivom());

class Seivom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.black),
      home: Home(),
    );
  }
}
