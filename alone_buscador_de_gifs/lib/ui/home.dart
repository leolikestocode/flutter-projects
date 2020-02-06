import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:alone_buscador_de_gifs/ui/intern.dart';
import 'package:share/share.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _query = "";
  int _limit = 19;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_query == "" || _query.isEmpty) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=7lPICr7kTPeg1baT1SmE0XgzjdteEe0F&limit=$_limit&rating=G");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=7lPICr7kTPeg1baT1SmE0XgzjdteEe0F&q=$_query&limit=$_limit&offset=$_offset&rating=G&lang=en");
    }

    return json.decode(response.body);
  }

  void loadMore() {
    setState(() {
      _offset += 19;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Busque aqui seu GIF ;)',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              onSubmitted: (val) {
                setState(() {
                  _query = val;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          strokeWidth: 5.0,
                          backgroundColor: Colors.white,
                        ),
                      );

                    default:
                      return _createGifTable(context, snapshot);
                  }
                }),
          )
        ],
      ),
    );
  }

  int loadMoreLength(data) {
    if (_query == "" || _query.isEmpty) {
      return data.length;
    }
    return data.length + 1;
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: loadMoreLength(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if (snapshot.data["data"].length == index) {
            return GestureDetector(
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 64.0,
                    ),
                    Text("carregar mais",
                        style: TextStyle(color: Colors.white)),
                  ])),
              onTap: loadMore,
            );
          } else {
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Intern(snapshot.data["data"][index])),
                  );
                },
                onLongPress: () {
                  Share.share(snapshot.data["data"][index]["images"]
                      ["fixed_height"]["url"]);
                },
                child: Image.network(snapshot.data["data"][index]["images"]
                    ["fixed_height"]["url"]));
          }
        });
  }
}
