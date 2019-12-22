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
  final _limitDefault = 20;
  int _offset = 0, _limit = 0;

  Future<Map> _getGifs() async {
    http.Response response;
    _limit = _limitDefault;

    if(_search == null) {
      _limit = _limitDefault;
      response = await http.get('https://api.giphy.com/v1/gifs/trending?api_key=QB7WvjnEE7fNW1UMXDGmLkbftsQlpnMF&$_limit=20&rating=G');
    } else {
      _limit = _limitDefault - 1;
      response = await http.get('https://api.giphy.com/v1/gifs/search?api_key=QB7WvjnEE7fNW1UMXDGmLkbftsQlpnMF&q=$_search&limit=$_limit&offset=$_offset&rating=G&lang=en');
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
              textAlign: TextAlign.center,
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
                      width: 200.0,
                      alignment: Alignment.center,
                      child: LinearProgressIndicator(),
                    );
                  default:
                   if(snapshot.hasError) return Container();
                   else return _createGifTable(context, snapshot);
                }
              },
            ),
          )
        ], 
      )
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _limitDefault,
      itemBuilder: (context, index) {
        if(_search == null) {
          return GestureDetector(
            child: Image.network(
              snapshot.data['data'][index]['images']['fixed_height']['url'],
              height: 300.0,
              fit: BoxFit.cover,
            )
          );
        } else {
          if(index == _limit) {
            return GestureDetector(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 80.0,),
                  Text('Mostrar mais...', style: TextStyle(color: Colors.white),),
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += _limit;
                });
              },
            );
          } else {
            return GestureDetector(
              child: Image.network(
                snapshot.data['data'][index]['images']['fixed_height']['url'],
                height: 300.0,
                fit: BoxFit.cover,
              )
            );
          }
        }
      },
    );
  }
}