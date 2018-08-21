import 'package:flutter/material.dart';
import 'package:japanese_assist/dictionary/dictionary_widget.dart';
import 'package:japanese_assist/dictionary/search_dialog.dart';
import 'package:japanese_assist/dictionary/search_page.dart';
import 'package:japanese_assist/main.dart';

class DictionaryPage extends StatefulWidget {
  createState() => DictionaryPageState();
}

class DictionaryPageState extends State<DictionaryPage> {

  GlobalKey<DictionaryWidgetState> dictionaryKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(MyApp.NAME),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: _displaySearchDialog),
          IconButton(icon: Icon(Icons.repeat), onPressed: _refreshEntries,)
        ],
      ),
      body: DictionaryWidget(key: dictionaryKey,),
    );
  }

  void _displaySearchDialog() async {
    String result = await showDialog<String>(
        context: context, builder: (context) => SearchDialog());

    if (result.isNotEmpty) {
      _createSearchRoute(result);
    }
  }
  
  void _refreshEntries(){
    dictionaryKey.currentState.setState((){});
  }

  _createSearchRoute(String searchTerm) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => DictionarySearchPage(searchTerm: searchTerm)));
  }
}
