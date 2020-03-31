import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:strings/strings.dart';
import 'dart:convert';
import 'breed_pics.dart';
import 'dart:async';


class BreedsList extends StatefulWidget {
  @override
  _BreedsListState createState() => _BreedsListState();
}

class _BreedsListState extends State<BreedsList> {
  List<String> _breedsList = [];
  List<String> _fullBreedsList = [];
  int _currentIndex = 0, _limit = 15;
  Future<List<String>> _future;
  ScrollController _controller = ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  int _length=0;


  @override
  void initState() {
    super.initState();
    getData();
    _controller.addListener(() {
      var isEnd = _controller.offset == _controller.position.maxScrollExtent;
      if (isEnd)
        setState(() {
          _future = loadData();
        });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breeds'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: Future.delayed(Duration(milliseconds: 500)).then((value) => _future), //_future
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else if(snapshot.hasData) {
              _length = _breedsList.length<_fullBreedsList.length ? _breedsList.length + 1 : _breedsList.length;
              return ListView.builder(
                controller: _controller,
                itemCount: _length,
                itemBuilder: (context, index) {
                  if(index == _breedsList.length)
                    return Center(child: CircularProgressIndicator());
                  return Card(
                      key: Key(_breedsList.elementAt(index)),
                      child: InkWell(
                        child: ListTile(
                          title: Text(capitalize(_breedsList.elementAt(index))),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BreedPics(_breedsList.elementAt(index))),
                            );
                          },
                        ),
                      ));
                },
              );
            }
            return LinearProgressIndicator();
          }
      ),
    );
  }

  Future<List<String>> loadData() async {
    for (var i = _currentIndex; i < _currentIndex + _limit; i++) {
      if(i<_fullBreedsList.length)
        _breedsList.add(_fullBreedsList.elementAt(i));
    }
    _currentIndex += _limit;
    return _breedsList;
  }

  Future<void> getData() async {
    http.Response response = await http.get(
        'https://dog.ceo/api/breeds/list/all');
    if (response.statusCode == 200) {
      String data = response.body;
      for(String breed in jsonDecode(data)['message'].keys){
        _fullBreedsList.add(breed);
      }
    } else {
      print(response.statusCode);
    }
    setState(() {
      _future = loadData();
    });
  }
}


