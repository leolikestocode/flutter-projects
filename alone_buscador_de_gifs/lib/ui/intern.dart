import 'package:flutter/material.dart';
import 'package:share/share.dart';

class Intern extends StatelessWidget {
  final Map _gifIntern;

  Intern(this._gifIntern);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifIntern["title"]),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(_gifIntern["images"]["fixed_height"]["url"]);
              }),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: Image.network(_gifIntern["images"]["fixed_height"]["url"])),
    );
  }
}
