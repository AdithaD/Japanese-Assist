import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:japanese_assist/dictionary/dictionary_entry.dart';

class DictionaryEntryInfoDialog extends StatelessWidget {
  final DictionaryEntry entry;

  const DictionaryEntryInfoDialog({this.entry});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(8.0),
      children: <Widget>[
        _createJapaneseWordDisplayWidget(context),
        SizedBox(
          height: 16.0,
        ),
        _createTranslationsWidget()
      ],
    );
  }

  Widget _createJapaneseWordDisplayWidget(BuildContext context){

    List<Widget> japaneseWordsToDisplay = new List<Widget>();

    if (entry.kanjiWord == null || entry.kanjiWord == "") {
      japaneseWordsToDisplay.add( Align(
          alignment: Alignment.center,
          child: Text(
            entry.hiraganaWord,
            style: Theme.of(context).textTheme.headline,
          )
      ));
    } else {
      japaneseWordsToDisplay.add( Align(
          alignment: Alignment.center,
          child: Text(
            entry.kanjiWord,
            style: Theme.of(context).textTheme.headline,
          )
      ));
      japaneseWordsToDisplay.add(Align(
          alignment: Alignment.center,
          child: Text(
            entry.hiraganaWord,
            style: Theme.of(context).textTheme.subhead,
            textAlign: TextAlign.center,
          )
      ));
    }

    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Column(
        children: japaneseWordsToDisplay
      ),
    );
  }

  Widget _createTranslationsWidget() {
    List<Widget> textWidgets = new List<Widget>();

    for (var i = 0; i < entry.englishTranslations.length; i++) {
      textWidgets.add(Text(
        entry.englishTranslations[i],
        textAlign: TextAlign.center,
      ));

      if (i != entry.englishTranslations.length - 1) {
        textWidgets.add(Divider());
      }
    }

    return Column(
      children: textWidgets,
    );
  }
}
