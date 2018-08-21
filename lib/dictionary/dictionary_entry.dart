import 'package:xml/xml.dart';

class DictionaryEntry {
  final String kanjiWord;
  final String hiraganaWord;

  final List<String> englishTranslations;

  DictionaryEntry(
      {this.kanjiWord, this.hiraganaWord, this.englishTranslations});

  factory DictionaryEntry.fromXml(XmlElement element) {
    String kanjiWord;
    if (element.findAllElements("keb").length != 0) {
      kanjiWord = element.findAllElements("keb").first.text;
    }

    String hiraganaWord;
    if (element.findAllElements("reb").length != 0) {
      hiraganaWord = element.findAllElements("reb").first.text;
    }

    return DictionaryEntry(
      kanjiWord: kanjiWord,
      hiraganaWord: hiraganaWord,
      englishTranslations:
      element.findAllElements("gloss").map<String>((element) {
        return element.text;
      }).toList(),
    );
  }

  String getPreferredJapaneseWord() {
    if (kanjiWord == null || kanjiWord == "") {
      return hiraganaWord;
    } else {
      return kanjiWord;
    }
  }
}