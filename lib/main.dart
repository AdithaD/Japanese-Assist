import 'package:flutter/material.dart';
import 'home_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  static final NAME = "Japanese Assist";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new Scaffold(
        appBar: AppBar(
            title: new Text(MyApp.NAME)
        ),
        body: new HomePage(),
        bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text("Dictionary")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.content_copy),
              title: Text("Flashcards")
          )
        ]),
      ),
    );
  }
}
