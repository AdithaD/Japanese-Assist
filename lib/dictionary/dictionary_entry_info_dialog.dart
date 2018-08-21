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
        Align(
            alignment: Alignment.center,
            child: Text(
              entry.getJapaneseWord(),
              style: Theme.of(context).textTheme.headline,
            )),
        SizedBox(
          height: 16.0,
        ),
        _getTranslationsWidget()
      ],
    );
  }

  Widget _getTranslationsWidget() {
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