import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"]),
        backgroundColor: Color(0xFF1b090c),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(_gifData["media"][0]["mediumgif"]["url"]);
            },
          )
        ],
      ),
      backgroundColor: Color(0xFF1b090c),
      body: Center(
        child: Image.network(_gifData["media"][0]["mediumgif"]["url"]),
      ),
    );
  }
}
