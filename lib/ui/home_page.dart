import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gif_lovers/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null) {
      // Response with Giphy
      // response = await http.get('https://api.giphy.com/v1/gifs/trending?api_key=P5HOZKW7deTUOmXOIZORtQerdJpgOeZU&limit=20&rating=G');
      response = await http.get('https://api.tenor.com/v1/trending?limite=20&key=STA64Y4RCFQL&anon_id=3a76e56901d740da9e59ffb22b988242');
    } else {
      // Response with Giphy
      // response = await http.get('https://api.giphy.com/v1/gifs/search?api_key=P5HOZKW7deTUOmXOIZORtQerdJpgOeZU&q=$_search&limit=19&offset=$_offset&rating=G&lang=pt');
      response = await http.get('https://api.tenor.com/v1/search?q=$_search&limit=19&pos=$_offset&key=STA64Y4RCFQL');
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

//    _getGifs().then((data) {
//      //print(data);
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1b090c),
        title: Image.asset('images/logo.png'),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF1b090c),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise aqui",
                labelStyle: TextStyle(
                  color: Color(0xFF970342)
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0xFF970342),
                      width: 2.0
                  ),
                  borderRadius: BorderRadius.circular(15)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF970342),
                    width: 2.0
                  ),
                  borderRadius: BorderRadius.circular(15)
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0
              ),
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch(snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width:  200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF4561bf)),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) return ErrorWidget('Ops!');
                    else return _createGifTable(context, snapshot);
                }
              }
            ),
          )
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return Center(
      child: GridView.builder(
          padding: EdgeInsets.all(20.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: _getCount(snapshot.data["results"]),
          itemBuilder: (context, index) {
            if (_search == null || index < snapshot.data["results"].length) {
              return GestureDetector(
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot.data["results"][index]["media"][0]["mediumgif"]["url"],
                  height: 300.0,
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return GifPage(snapshot.data["results"][index]);
                        }
                      )
                  );
                },
                onLongPress: () {
                  Share.share(snapshot.data["results"][index]["media"][0]["mediumgif"]["url"]);
                },
              );
            } else {
              return Container(
                child: GestureDetector(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: Color(0xFF970342),
                      ),
                      Text("Carregar Mais",
                        style: TextStyle(
                          color: Color(0xFF970342),
                          fontSize: 22.0
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _offset += 19;
                    });
                  },
                ),
              );
            }
          }
      ),
    );
  }
}
