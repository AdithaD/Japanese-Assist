import 'package:flutter/material.dart';
import 'package:japanese_assist/dictionary/dictionary_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  static const String NAME = "Japanese Assist";
  static const String DICTIONARY_FILE_PATH = "assets/xml/JMdict_e.xml";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.red,
        canvasColor: Colors.white,
        cardColor: Colors.white,
      ),
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
