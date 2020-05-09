import 'package:flutter/material.dart';
import 'package:TodoCtive/screenui.dart';

void main() => runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "TodoCtive",
      theme: ThemeData.dark().copyWith(
        accentColor: Colors.purple[500],
      ),
      home: Screen(),
    
    );
  }
}
