import 'package:flutter/material.dart';
import 'package:japanese_assist/dictionary/dictionary_entry.dart';
import 'package:japanese_assist/dictionary/dictionary_entry_info_dialog.dart';

class DictionaryEntryListTile extends StatelessWidget {
  final DictionaryEntry entry;

  const DictionaryEntryListTile({this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(entry.getJapaneseWord()),
        subtitle: Text(entry.englishTranslations.first),
        onTap: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => DictionaryEntryInfoDialog(
                entry: entry,
              ));
        },
      ),
    );
  }
}