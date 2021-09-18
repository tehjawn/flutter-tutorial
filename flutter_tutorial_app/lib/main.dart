import 'package:flutter/material.dart';
import 'package:flutter_tutorial_app/random_words.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  // Constructor
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
}
