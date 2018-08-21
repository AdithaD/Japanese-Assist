import 'package:flutter/widgets.dart';
import 'package:japanese_assist/dictionary/dictionary_entry.dart';
import 'package:japanese_assist/dictionary/dictionary_entry_list_tile.dart';

class DictionaryEntryList extends StatelessWidget {
  final List<DictionaryEntry> entries;

  DictionaryEntryList({Key key, this.entries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (context, index) {
          return DictionaryEntryListTile(
            entry: entries[index],
          );
        },
        itemCount: entries.length);
  }
}
