import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search;
  int _offset;

  Future<Map> _getGifs() async {
    http.Response response;

    if(_search == null) {
      response = await http.get('https://api.giphy.com/v1/gifs/trending?api_key=QB7WvjnEE7fNW1UMXDGmLkbftsQlpnMF&limit=20&rating=G');
    } else {
      response = await http.get('https://api.giphy.com/v1/gifs/search?api_key=QB7WvjnEE7fNW1UMXDGmLkbftsQlpnMF&q=$_search&limit=20&offset=$_offset&rating=G&lang=en');
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((gifs) {
      print(gifs);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network('https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Pesquise Aqui!',
                labelStyle: TextStyle(color: Colors.white,),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center
            ),
          ),
        ], 
      )
    );
  }
}