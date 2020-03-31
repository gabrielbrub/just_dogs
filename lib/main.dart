import 'package:flutter/material.dart';
import 'breeds_list.dart';

void main() => runApp(JustDogs());

class JustDogs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green[700],
        accentColor: Colors.greenAccent[900],
      ),
      home: BreedsList(),
    );
  }
}