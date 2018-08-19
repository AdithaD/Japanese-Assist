import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:xml/xml.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

Future<List<DictionaryEntry>> fetchDictionaryEntriesIntoDOM() async{
  final String dictionaryXmlString = await rootBundle.loadString("assets/xml/JMdict_e.xml");



  //return compute(parseDictionaryEntriesFromDOM, prepareXmlString(dictionaryXmlString, 0, 10));
  return parseDictionaryEntriesFromDOM(prepareXmlString(dictionaryXmlString, 20000, 200));
}

String prepareXmlString(String dictionaryXmlString, int startingIndex, int amountOfEntries){
  StringBuffer result = new StringBuffer("<JMDict>");

  int currentIndex = startingIndex;

  int currentEntry = 0;

  while(currentEntry < amountOfEntries){
    int start = dictionaryXmlString.indexOf("<entry>", currentIndex);

    int end = dictionaryXmlString.indexOf("</entry>", currentIndex);

    if(end > start){
      result.write(dictionaryXmlString.substring(start, end + "</entry>".length));
      currentEntry ++;
    }

    currentIndex = end + "</entry>".length;
  }

  result.write("</JMDict>");

  return result.toString();
}

List<DictionaryEntry> parseDictionaryEntriesFromDOM(String dictionaryXmlString){
  final parsedDoc = parse(dictionaryXmlString);
  List<XmlNode> elements = List<XmlNode>();

  for(var element in parsedDoc.findAllElements("entry")){

    elements.add(element);
  }

  return elements.map<DictionaryEntry>((element) => DictionaryEntry.fromXml(element)).toList();
}

class DictionaryPage extends StatefulWidget{
  createState() => new DictionaryPageState();
}

class DictionaryPageState extends State<DictionaryPage>{

  /*final String _test = '''
        <?xml version="1.0"?>
        <JMDict>
          <entry>
<ent_seq>1371780</ent_seq>
<k_ele>
<keb>水素</keb>
<ke_pri>ichi1</ke_pri>
<ke_pri>news1</ke_pri>
<ke_pri>nf11</ke_pri>
</k_ele>
<r_ele>
<reb>すいそ</reb>
<re_pri>ichi1</re_pri>
<re_pri>news1</re_pri>
<re_pri>nf11</re_pri>
</r_ele>
<sense>
<pos>&n;</pos>
<gloss>hydrogen (H)</gloss>
</sense>
</entry>
<entry>
<ent_seq>1371790</ent_seq>
<k_ele>
<keb>水素化物</keb>
</k_ele>
<r_ele>
<reb>すいそかぶつ</reb>
</r_ele>
<sense>
<pos>&n;</pos>
<gloss>hydride</gloss>
</sense>
</entry>
<entry>
<ent_seq>1371800</ent_seq>
<k_ele>
<keb>水槽</keb>
<ke_pri>news1</ke_pri>
<ke_pri>nf13</ke_pri>
</k_ele>
<r_ele>
<reb>すいそう</reb>
<re_pri>news1</re_pri>
<re_pri>nf13</re_pri>
</r_ele>
<sense>
<pos>&n;</pos>
<gloss>water tank</gloss>
<gloss>cistern</gloss>
</sense>
<sense>
<gloss>fish tank</gloss>
<gloss>aquarium</gloss>
</sense>
</entry>
<entry>
<ent_seq>1371810</ent_seq>
<k_ele>
<keb>水増し</keb>
<ke_pri>ichi1</ke_pri>
<ke_pri>news1</ke_pri>
<ke_pri>nf16</ke_pri>
</k_ele>
<r_ele>
<reb>みずまし</reb>
<re_pri>ichi1</re_pri>
<re_pri>news1</re_pri>
<re_pri>nf16</re_pri>
</r_ele>
<sense>
<pos>&n;</pos>
<pos>&vs;</pos>
<pos>&adj-f;</pos>
<gloss>dilution</gloss>
<gloss>watering down</gloss>
</sense>
<sense>
<gloss>inflation (of budget, claim, etc.)</gloss>
<gloss>padding</gloss>
</sense>
</entry>
<entry>
<ent_seq>1371820</ent_seq>
<k_ele>
<keb>水族館</keb>
<ke_pri>ichi1</ke_pri>
<ke_pri>news1</ke_pri>
<ke_pri>nf14</ke_pri>
</k_ele>
<r_ele>
<reb>すいぞくかん</reb>
<re_pri>ichi1</re_pri>
<re_pri>news1</re_pri>
<re_pri>nf14</re_pri>
</r_ele>
<r_ele>
<reb>すいぞっかん</reb>
</r_ele>
<sense>
<pos>&n;</pos>
<s_inf>すいぞっかん is colloquial</s_inf>
<gloss>aquarium</gloss>
</sense>
</entry>
          </JMDict>
        ''';*/

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DictionaryEntry>>(
      future: fetchDictionaryEntriesIntoDOM(),
      builder: (context, snapshot){
        if (snapshot.hasError) print(snapshot.error);

        if(snapshot.hasData){
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
                      Expanded(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(),
                      )),
                      RaisedButton(onPressed: () {

                      },
                      child: Text("Search"),
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,)
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: DictionaryEntryList(entries: snapshot.data),
              ),
            ],
          );

        }else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }


}

class DictionaryEntryList extends StatelessWidget{

  final List<DictionaryEntry> entries;

  DictionaryEntryList({Key key, this.entries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index){
      return Card(
        child: ListTile(
          title: Text(entries[index].japaneseWord),
          subtitle: Text(entries[index].englishTranslation),
        ),
      );
    },
    itemCount: entries.length);
  }
}

class DictionaryEntry{
  final String japaneseWord;
  final String englishTranslation;

  DictionaryEntry({this.japaneseWord, this.englishTranslation});

  factory DictionaryEntry.fromXml(XmlElement element){

    return DictionaryEntry(
      japaneseWord: element.findAllElements("reb").first.text,
      englishTranslation: element.findAllElements("gloss").first.text,
    );
  }
}

class MutableDictionaryEntry{
  String japaneseWord;
  String englishTranslation;
}
