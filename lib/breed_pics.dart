import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:strings/strings.dart';

class BreedPics extends StatelessWidget {
  final String _breed;
  Future<List<String>> images;
  BreedPics(this._breed){
    images = getImages(_breed);
  }

  @override
  Widget build(BuildContext context) {
    int numItems;
    return Scaffold(
      appBar: AppBar(
        title: Text(capitalize(_breed)),
      ),
      body: FutureBuilder(
        future: images,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text('Loading')
                  ],
                ),
              );
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else {
                var images = snapshot.data;
                numItems = images.length;
                return GridView.builder(
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  padding: EdgeInsets.all(4),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.network(images[index], fit: BoxFit.cover),
                    );
                  },
                  itemCount: numItems,
                );
              }
          }
        },
      ),
    );
  }
}

Future<List<String>> getImages(String breed) async {
  List<String> images = List();
  http.Response response = await http.get('https://dog.ceo/api/breed/$breed/images/random/10');
  if (response.statusCode == 200) {
    String data = response.body;
    for(String url in jsonDecode(data)['message']){
      images.add(url);
    }
  } else {
    print(response.statusCode);
  }
  return images;
}
