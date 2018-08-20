import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:xml/xml.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'main.dart';
import 'dictionary_page.dart';

Future<List<DictionaryEntry>> fetchSearchEntriesIntoDOM(
    String searchTerm, int amount) async {
  return compute(
      createSearchEntries,
      SearchQuery(
          searchTerm: searchTerm,
          dictionaryXmlString:
              await rootBundle.loadString("assets/xml/JMdict_e.xml"),
          amount: amount));
}

List<DictionaryEntry> createSearchEntries(SearchQuery query) {
  StringBuffer trimmedXmlString = new StringBuffer("<JMDict>");

  int currentIndex = 0;

  int currentEntry = 0;

  List<XmlElement> entries = new List<XmlElement>();

  String regex = r"(?:^|\W)" + query.searchTerm + r"(?:$|\W)";

  while (currentEntry < query.amount) {
    int searchFoundIndex = query.dictionaryXmlString
        .indexOf(RegExp(regex, caseSensitive: false), currentIndex);
    int start =
        query.dictionaryXmlString.lastIndexOf("<entry>", searchFoundIndex);

    int end = query.dictionaryXmlString.indexOf("</entry>", searchFoundIndex);

    if (end > start) {
      String xmlEntry =
          query.dictionaryXmlString.substring(start, end + "</entry>".length);

      XmlElement entryElement = parse(xmlEntry).rootElement;

      bool inJapaneseWord;
      if (entryElement.findAllElements("keb").length == 0) {
        inJapaneseWord = entryElement
            .findAllElements("reb")
            .first
            .text
            .contains(query.searchTerm);
      } else {

        inJapaneseWord = entryElement
            .findAllElements("keb")
            .first
            .text
            .contains(query.searchTerm);
      }
      bool inEnglishTranslation;

      for (var englishTranslation in entryElement.findAllElements("gloss")){
        if (englishTranslation.text.contains(query.searchTerm)) {
          inEnglishTranslation = true;
          break;
        }
      }


      if (inJapaneseWord || inEnglishTranslation) {
        trimmedXmlString.write(query.dictionaryXmlString
            .substring(start, end + "</entry>".length));
        entries.add(entryElement);

        currentEntry++;
      }
    }

    currentIndex = end + "</entry>".length;
  }

  return entries
      .map<DictionaryEntry>((element) => DictionaryEntry.fromXml(element))
      .toList();
}

class DictionarySearchPage extends StatelessWidget {
  final String searchTerm;

  DictionarySearchPage({this.searchTerm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: new Text(MyApp.NAME)),
      body: FutureBuilder<List<DictionaryEntry>>(
          future: fetchSearchEntriesIntoDOM(searchTerm, 10),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            if (snapshot.hasData)
              return DictionaryEntryList(entries: snapshot.data);
            else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class SearchQuery {
  final String searchTerm;
  final String dictionaryXmlString;

  final int amount;

  SearchQuery({this.searchTerm, this.dictionaryXmlString, this.amount});
}
