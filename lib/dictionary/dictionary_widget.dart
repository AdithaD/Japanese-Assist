import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:japanese_assist/dictionary/dictionary_entry.dart';
import 'package:japanese_assist/dictionary/dictionary_entry_list.dart';
import 'package:japanese_assist/main.dart';
import 'package:xml/xml.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:math';

Future<List<DictionaryEntry>> fetchDictionaryEntriesIntoDOM() async {
  final String dictionaryXmlString =
      await rootBundle.loadString(MyApp.DICTIONARY_FILE_PATH);

  return compute(parseDictionaryEntriesFromDOM,
      prepareXmlStringForRandomEntries(dictionaryXmlString, 50));
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

String prepareXmlStringForRandomEntries(String dictionaryXmlString, int amountOfEntries){
  StringBuffer result = new StringBuffer("<JMDict>");
  Random rng = new Random();

  int currentEntry = 0;
  while (currentEntry < amountOfEntries) {
    int currentIndex =  rng.nextInt(dictionaryXmlString.length);

    int start = dictionaryXmlString.lastIndexOf("<entry>", currentIndex);
    int end = dictionaryXmlString.indexOf("</entry>", currentIndex);

    if (start != -1 && end != - 1) {
      if (end > start) {
        result
            .write(dictionaryXmlString.substring(start, end + "</entry>".length));
        currentEntry++;
      }
    }
  }

  result.write("</JMDict>");

  return result.toString();
}

List<DictionaryEntry> parseDictionaryEntriesFromDOM(
    String dictionaryXmlString) {
  final parsedDoc = parse(dictionaryXmlString);
  List<XmlElement> elements = List<XmlElement>();

  for (var element in parsedDoc.findAllElements("entry")) {
    elements.add(element);
  }

  return elements
      .map<DictionaryEntry>((element) => DictionaryEntry.fromXml(element))
      .toList();
}

class DictionaryWidget extends StatefulWidget {

  const DictionaryWidget({Key key}):super(key: key);

  createState() => new DictionaryWidgetState();
}

class DictionaryWidgetState extends State<DictionaryWidget> {

  List<DictionaryEntry> entries;

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<DictionaryEntry>>(
      future: fetchDictionaryEntriesIntoDOM().then((onValue) {
        entries = onValue;
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done){
          return DictionaryEntryList(entries: entries,);
        }else{
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
}


