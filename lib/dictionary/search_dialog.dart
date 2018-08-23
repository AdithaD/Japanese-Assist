import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget{

  final TextEditingController searchTermController= new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              Text("Search dictionary", style: Theme.of(context).textTheme.headline),
              SizedBox(height: 16.0,),
              TextField(decoration: InputDecoration(labelText: "Search term"), controller:  searchTermController),
              SizedBox(height: 8.0,),
              RaisedButton(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.search),
                ],
              ),onPressed: () {
                Navigator.pop(context, searchTermController.text);
              },
              color: Theme.of(context).buttonColor,
              elevation: 8.0,
              shape: OutlineInputBorder(),),
            ],
          ),
        )
      ],
    );
  }
}