import 'package:flutter/material.dart';
import 'package:flutter_note/ui/home_note.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteHomePage(),
    );
  }
}
