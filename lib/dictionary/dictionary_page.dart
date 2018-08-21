import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:japanese_assist/dictionary/dictionary_entry.dart';
import 'package:japanese_assist/dictionary/dictionary_entry_list.dart';
import 'package:japanese_assist/main.dart';
import 'package:xml/xml.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'package:japanese_assist/dictionary/search_page.dart';

Future<List<DictionaryEntry>> fetchDictionaryEntriesIntoDOM() async {
  final String dictionaryXmlString =
      await rootBundle.loadString(MyApp.DICTIONARY_FILE_PATH);

  return compute(parseDictionaryEntriesFromDOM,
      prepareXmlStringForEntries(dictionaryXmlString, 20000, 200));
  /*return parseDictionaryEntriesFromDOM(
      prepareXmlStringForEntries(dictionaryXmlString, 20000, 200));*/
}

String prepareXmlStringForEntries(
    String dictionaryXmlString, int startingIndex, int amountOfEntries) {
  StringBuffer result = new StringBuffer("<JMDict>");

  int currentIndex = startingIndex;

  int currentEntry = 0;

  while (currentEntry < amountOfEntries) {
    int start = dictionaryXmlString.indexOf("<entry>", currentIndex);

    int end = dictionaryXmlString.indexOf("</entry>", currentIndex);

    if (end > start) {
      result
          .write(dictionaryXmlString.substring(start, end + "</entry>".length));
      currentEntry++;
    }

    currentIndex = end + "</entry>".length;
  }

  result.write("</JMDict>");

  return result.toString();
}

List<DictionaryEntry> parseDictionaryEntriesFromDOM(
    String dictionaryXmlString) {
  final parsedDoc = parse(dictionaryXmlString);
  List<XmlNode> elements = List<XmlNode>();

  for (var element in parsedDoc.findAllElements("entry")) {
    elements.add(element);
  }

  return elements
      .map<DictionaryEntry>((element) => DictionaryEntry.fromXml(element))
      .toList();
}

class DictionaryPage extends StatefulWidget {
  createState() => new DictionaryPageState();
}

class DictionaryPageState extends State<DictionaryPage> {
  TextEditingController searchFieldController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DictionaryEntry>>(
      future: fetchDictionaryEntriesIntoDOM(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              Container(
                color: Theme.of(context).highlightColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.search),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: searchFieldController,
                        ),
                      )),
                      RaisedButton(
                        onPressed: () =>
                            _startSearch(searchFieldController.text),
                        child: Text("Search"),
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: DictionaryEntryList(entries: snapshot.data),
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  _startSearch(String searchTerm) {
    if (searchFieldController.text != "") {
      _createSearchRoute(searchTerm);
    }
  }

  _createSearchRoute(String searchTerm) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => DictionarySearchPage(searchTerm: searchTerm)));
  }
}


