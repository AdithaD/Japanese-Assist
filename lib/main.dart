import 'package:flutter/material.dart';
import 'dictionary_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  static const NAME = "Japanese Assist";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
          primarySwatch: Colors.red,
          canvasColor: Colors.white,
          cardColor: Color.fromRGBO(255, 172, 163, 90.0)),
      home: new Scaffold(
        appBar: AppBar(title: new Text(MyApp.NAME)),
        body: new DictionaryPage(),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.book), title: Text("Dictionary")),
            BottomNavigationBarItem(
                icon: Icon(Icons.content_copy), title: Text("Flashcards"))
          ],
        ),
      ),
    );
  }
}
